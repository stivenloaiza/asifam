import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reminder.dart';
import '../../providers/reminder_provider.dart';

class ReminderHistory extends StatelessWidget {
  const ReminderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final reminders = Provider.of<ReminderProvider>(context).reminders;

    if (reminders.isEmpty) {
      return const Center(
        child: Text(
          'No hay historial disponible',
          style: TextStyle(color: Colors.white38, fontSize: 18),
        ),
      );
    }

    // Calcular estadísticas
    final total = reminders.length;
    final happy = reminders.where((r) => r.fulfillmentStatus == FulfillmentStatus.happy).length;
    final neutral = reminders.where((r) => r.fulfillmentStatus == FulfillmentStatus.neutral).length;
    final sad = reminders.where((r) => r.fulfillmentStatus == FulfillmentStatus.sad).length;

    return Column(
      children: [
        // Gráficas simples
        Row(
          children: [
            _StatCard(label: 'Cumplido', count: happy, color: Colors.greenAccent, total: total),
            const SizedBox(width: 12),
            _StatCard(label: 'Neutro', count: neutral, color: Colors.amberAccent, total: total),
            const SizedBox(width: 12),
            _StatCard(label: 'Incumplido', count: sad, color: Colors.redAccent, total: total),
          ],
        ),
        const SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: reminders.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              final time = TimeOfDay(hour: reminder.hour, minute: reminder.minute);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  leading: Icon(
                    _getStatusIcon(reminder.fulfillmentStatus),
                    color: _getStatusColor(reminder.fulfillmentStatus),
                  ),
                  title: Text(
                    reminder.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    time.format(context),
                    style: const TextStyle(color: Colors.white38),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(FulfillmentStatus status) {
    switch (status) {
      case FulfillmentStatus.happy: return Icons.check_circle;
      case FulfillmentStatus.neutral: return Icons.remove_circle;
      case FulfillmentStatus.sad: return Icons.cancel;
    }
  }

  Color _getStatusColor(FulfillmentStatus status) {
    switch (status) {
      case FulfillmentStatus.happy: return Colors.greenAccent;
      case FulfillmentStatus.neutral: return Colors.amberAccent;
      case FulfillmentStatus.sad: return Colors.redAccent;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final int total;

  const _StatCard({required this.label, required this.count, required this.color, required this.total});

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(0) : "0";
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$count', style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('$percentage%', style: const TextStyle(color: Colors.white24, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
