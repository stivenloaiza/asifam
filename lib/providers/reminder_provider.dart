import 'dart:async';
import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../services/isar_service.dart';
import '../services/tts_service.dart';

enum AssistantState { idle, listening, speaking }

class ReminderProvider extends ChangeNotifier {
  final IsarService _isarService = IsarService();
  final TtsService _ttsService = TtsService();

  List<Reminder> _reminders = [];
  List<Reminder> get reminders => _reminders;

  AssistantState _assistantState = AssistantState.idle;
  AssistantState get assistantState => _assistantState;

  Reminder? _activeReminder;
  Reminder? get activeReminder => _activeReminder;

  Reminder? _editingReminder;
  Reminder? get editingReminder => _editingReminder;

  Timer? _schedulerTimer;

  ReminderProvider() {
    _init();
  }

  void _init() {
    _isarService.listenToReminders().listen((event) {
      _reminders = event;
      // Ordenar por hora y minuto
      _reminders.sort((a, b) {
        if (a.hour != b.hour) return a.hour.compareTo(b.hour);
        return a.minute.compareTo(b.minute);
      });
      notifyListeners();
    });

    _ttsService.setStartHandler(() {
      _assistantState = AssistantState.speaking;
      notifyListeners();
    });

    _ttsService.setCompletionHandler(() {
      _assistantState = AssistantState.idle;
      _activeReminder = null;
      notifyListeners();
    });

    _startScheduler();
  }

  void _startScheduler() {
    _schedulerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkReminders();
    });
  }

  void _checkReminders() {
    final now = DateTime.now();
    for (var reminder in _reminders) {
      if (!reminder.isEnabled) continue;

      if (reminder.hour == now.hour && reminder.minute == now.minute) {
        // Verificar si debe sonar hoy según la frecuencia
        bool matchesDay = false;

        switch (reminder.frequency) {
          case ReminderFrequency.once:
          case ReminderFrequency.daily:
            matchesDay = true;
            break;
          case ReminderFrequency.weekly:
            // Si es semanal, solo suena el mismo día de la semana
            // Como no guardamos el día de creación, asumimos el día que se ejecutó por última vez
            // o si nunca se ejecutó, permitimos que suene el primer día que coincida hora/minuto.
            // Para ser más precisos, si nunca se ejecutó, guardamos el día al crearlo o simplemente
            // dejamos que suene hoy y a partir de ahí cada 7 días.
            if (reminder.lastExecuted == null) {
              matchesDay = true;
            } else {
              // Si ya han pasado al menos 6 días (para evitar problemas de precisión) y es el mismo weekday
              matchesDay = now.weekday == reminder.lastExecuted!.weekday &&
                  now.difference(reminder.lastExecuted!).inDays >= 6;
            }
            break;
          case ReminderFrequency.custom:
            matchesDay = reminder.repeatDays?.contains(now.weekday) ?? false;
            break;
        }

        if (!matchesDay) continue;

        // Evitar repetir en el mismo minuto
        if (reminder.lastExecuted != null &&
            reminder.lastExecuted!.year == now.year &&
            reminder.lastExecuted!.month == now.month &&
            reminder.lastExecuted!.day == now.day &&
            reminder.lastExecuted!.hour == now.hour &&
            reminder.lastExecuted!.minute == now.minute) {
          continue;
        }

        _triggerReminder(reminder);
        break;
      }
    }
  }

  Future<void> _triggerReminder(Reminder reminder) async {
    _activeReminder = reminder;
    reminder.lastExecuted = DateTime.now();
    
    if (reminder.frequency == ReminderFrequency.once) {
      reminder.isEnabled = false;
    }
    
    await _isarService.saveReminder(reminder);
    await _ttsService.speak("Recordatorio: ${reminder.title}");
  }

  Future<void> addReminder(Reminder reminder) async {
    await _isarService.saveReminder(reminder);
    if (_editingReminder?.id == reminder.id) {
      _editingReminder = null;
      notifyListeners();
    }
  }

  void setEditingReminder(Reminder? reminder) {
    _editingReminder = reminder;
    notifyListeners();
  }

  Future<void> testReminder(Reminder reminder) async {
    _activeReminder = reminder;
    _assistantState = AssistantState.speaking;
    notifyListeners();
    await _ttsService.speak("Validando recordatorio: ${reminder.title}");
  }

  Future<void> deleteReminder(int id) async {
    await _isarService.deleteReminder(id);
  }

  Future<void> resetApp() async {
    await _isarService.clearDatabase();
    _editingReminder = null;
    notifyListeners();
  }

  Future<void> toggleReminder(Reminder reminder) async {
    reminder.isEnabled = !reminder.isEnabled;
    await _isarService.saveReminder(reminder);
  }

  Future<void> updateFulfillmentStatus(Reminder reminder, FulfillmentStatus status) async {
    reminder.fulfillmentStatus = status;
    await _isarService.saveReminder(reminder);
    notifyListeners();
  }

  @override
  void dispose() {
    _schedulerTimer?.cancel();
    super.dispose();
  }
}
