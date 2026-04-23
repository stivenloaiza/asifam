import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reminder_provider.dart';

class TalkingFaceView extends StatefulWidget {
  const TalkingFaceView({super.key});

  @override
  State<TalkingFaceView> createState() => _TalkingFaceViewState();
}

class _TalkingFaceViewState extends State<TalkingFaceView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReminderProvider>(context);
    final reminder = provider.activeReminder;

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  height: 300 + (_controller.value * 20),
                  width: 300 + (_controller.value * 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1 + (_controller.value * 0.1)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2 + (_controller.value * 0.2)),
                      width: 2 + (_controller.value * 2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2 * _controller.value),
                        blurRadius: 20 * _controller.value,
                        spreadRadius: 10 * _controller.value,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.keyboard_voice,
                      size: 150,
                      color: Colors.white.withOpacity(0.5 + (_controller.value * 0.5)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            if (reminder != null) ...[
              Text(
                'Recordatorio Activo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  reminder.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                // Podríamos detener el TTS manualmente aquí si quisiéramos
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('ENTENDIDO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
