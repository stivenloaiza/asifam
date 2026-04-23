import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reminder.dart';
import '../../providers/reminder_provider.dart';

class ReminderForm extends StatefulWidget {
  const ReminderForm({super.key});

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _titleController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  ReminderFrequency _frequency = ReminderFrequency.daily;
  List<int> _selectedDays = []; // 1 = Lunes, 7 = Domingo
  int? _editingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final editingReminder = Provider.of<ReminderProvider>(context).editingReminder;
    if (editingReminder != null) {
      if (editingReminder.id != _editingId) {
        _editingId = editingReminder.id;
        _titleController.text = editingReminder.title;
        _selectedTime = TimeOfDay(hour: editingReminder.hour, minute: editingReminder.minute);
        _frequency = editingReminder.frequency;
        _selectedDays = List<int>.from(editingReminder.repeatDays ?? []);
      }
    } else if (_editingId != null) {
      _clearForm();
    }
  }

  void _clearForm() {
    setState(() {
      _editingId = null;
      _titleController.clear();
      _selectedTime = TimeOfDay.now();
      _frequency = ReminderFrequency.daily;
      _selectedDays = [];
    });
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: '¿Qué debo recordar?',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.add_task, color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) {
                    setState(() => _selectedTime = time);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_filled, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 15),
                      Text(
                        _selectedTime.format(context),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        const Text(
          'Repetir',
          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ReminderFrequency.values.map((f) {
            final isSelected = _frequency == f;
            String label = "";
            switch (f) {
              case ReminderFrequency.once:
                label = "Una vez";
                break;
              case ReminderFrequency.daily:
                label = "Diario";
                break;
              case ReminderFrequency.weekly:
                label = "Semanal";
                break;
              case ReminderFrequency.custom:
                label = "Personalizar";
                break;
            }
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (val) {
                if (val) setState(() => _frequency = f);
              },
              backgroundColor: Colors.white.withOpacity(0.05),
              selectedColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(color: isSelected ? Colors.transparent : Colors.white10),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            );
          }).toList(),
        ),
        if (_frequency == ReminderFrequency.custom) ...[
          const SizedBox(height: 25),
          const Text(
            'Días de la semana',
            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final day = index + 1;
              final isSelected = _selectedDays.contains(day);
              final labels = ["L", "M", "M", "J", "V", "S", "D"];
              return InkWell(
                onTap: () => _toggleDay(day),
                borderRadius: BorderRadius.circular(25),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white.withOpacity(0.05),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4))
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
        const SizedBox(height: 40),
        if (_editingId != null) ...[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Provider.of<ReminderProvider>(context, listen: false).setEditingReminder(null);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('CANCELAR EDICIÓN', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: () {
              if (_titleController.text.isEmpty) return;
              if (_frequency == ReminderFrequency.custom && _selectedDays.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selecciona al menos un día para la frecuencia personalizada')),
                );
                return;
              }

              final provider = Provider.of<ReminderProvider>(context, listen: false);
              final reminder = (_editingId != null) 
                  ? (provider.reminders.firstWhere((r) => r.id == _editingId))
                  : Reminder();
              
              reminder.title = _titleController.text;
              reminder.hour = _selectedTime.hour;
              reminder.minute = _selectedTime.minute;
              reminder.frequency = _frequency;
              reminder.repeatDays = _frequency == ReminderFrequency.custom ? _selectedDays : null;

              provider.addReminder(reminder);
              
              if (_editingId == null) {
                _clearForm();
              }
              
              FocusScope.of(context).unfocus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_editingId != null ? Icons.save_outlined : Icons.check_circle_outline),
                const SizedBox(width: 10),
                Text(
                  _editingId != null ? 'ACTUALIZAR RECORDATORIO' : 'CREAR RECORDATORIO', 
                  style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
