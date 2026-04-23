import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reminder.dart';
import '../../providers/reminder_provider.dart';

class ReminderList extends StatelessWidget {
  const ReminderList({super.key});

  @override
  Widget build(BuildContext context) {
    final reminders = Provider.of<ReminderProvider>(context).reminders;

    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 80, color: Colors.white10),
            const SizedBox(height: 20),
            const Text(
              'No hay recordatorios programados',
              style: TextStyle(color: Colors.white38, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: reminders.length,
      padding: const EdgeInsets.only(right: 10),
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return _ReminderCard(reminder: reminder);
      },
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final Reminder reminder;
  const _ReminderCard({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReminderProvider>(context);
    final time = TimeOfDay(hour: reminder.hour, minute: reminder.minute);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: provider.editingReminder?.id == reminder.id 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5) 
              : Colors.white.withOpacity(0.05),
          width: provider.editingReminder?.id == reminder.id ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.all(24),
            onTap: () {
              provider.testReminder(reminder);
            },
            leading: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: reminder.isEnabled 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.white10,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.notifications_active, 
                color: reminder.isEnabled ? Theme.of(context).colorScheme.primary : Colors.white24,
                size: 28,
              ),
            ),
            title: Text(
              reminder.title,
              style: TextStyle(
                color: reminder.isEnabled ? Colors.white : Colors.white38,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                decoration: reminder.isEnabled ? null : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 8),
                      Text(
                        time.format(context),
                        style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getFrequencyText(reminder),
                          style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _FulfillmentButton(
                      icon: Icons.sentiment_very_satisfied,
                      isSelected: reminder.fulfillmentStatus == FulfillmentStatus.happy,
                      activeColor: Colors.greenAccent,
                      onTap: () => provider.updateFulfillmentStatus(reminder, FulfillmentStatus.happy),
                    ),
                    const SizedBox(width: 12),
                    _FulfillmentButton(
                      icon: Icons.sentiment_neutral,
                      isSelected: reminder.fulfillmentStatus == FulfillmentStatus.neutral,
                      activeColor: Colors.amberAccent,
                      onTap: () => provider.updateFulfillmentStatus(reminder, FulfillmentStatus.neutral),
                    ),
                    const SizedBox(width: 12),
                    _FulfillmentButton(
                      icon: Icons.sentiment_very_dissatisfied,
                      isSelected: reminder.fulfillmentStatus == FulfillmentStatus.sad,
                      activeColor: Colors.redAccent,
                      onTap: () => provider.updateFulfillmentStatus(reminder, FulfillmentStatus.sad),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined, 
                    color: provider.editingReminder?.id == reminder.id 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.white24, 
                    size: 24
                  ),
                  onPressed: () {
                    provider.setEditingReminder(reminder);
                  },
                ),
                Switch(
                  value: reminder.isEnabled,
                  onChanged: (val) {
                    provider.toggleReminder(reminder);
                  },
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 24),
                  onPressed: () {
                    provider.deleteReminder(reminder.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getFrequencyText(Reminder reminder) {
    switch (reminder.frequency) {
      case ReminderFrequency.once:
        return "UNA VEZ";
      case ReminderFrequency.daily:
        return "DIARIO";
      case ReminderFrequency.weekly:
        return "SEMANAL";
      case ReminderFrequency.custom:
        if (reminder.repeatDays == null || reminder.repeatDays!.isEmpty) return "PERSONALIZADO";
        final labels = ["L", "M", "M", "J", "V", "S", "D"];
        final sortedDays = List<int>.from(reminder.repeatDays!)..sort();
        return sortedDays.map((d) => labels[d - 1]).join("");
    }
  }
}

class _FulfillmentButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _FulfillmentButton({
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected ? activeColor : Colors.white24,
          size: 24,
        ),
      ),
    );
  }
}
