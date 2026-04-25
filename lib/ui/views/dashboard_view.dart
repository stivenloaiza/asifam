import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/reminder_provider.dart';
import '../widgets/reminder_form.dart';
import '../widgets/reminder_list.dart';
import '../widgets/reminder_history.dart';
import 'talking_face_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        endDrawer: Drawer(
          backgroundColor: const Color(0xFF0F172A),
          child: Column(
            children: [
              DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 48),
                    const SizedBox(height: 10),
                    const Text(
                      'Asifam',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white70),
              title: const Text('Acerca de', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    title: Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 32),
                        const SizedBox(width: 12),
                        const Text('Asifam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Versión 1.0.0',
                            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Desarrollador: loacod@codificando.xyz',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Este es un proyecto personal open source y gratuito desarrollado y asistido con IA para la función familiar.',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Colors.white10),
                          const SizedBox(height: 16),
                          const Text(
                            'LICENCIA REVOLUCIONARIA: THE UNLICENSE',
                            style: TextStyle(
                              color: Color(0xFF8B5CF6), 
                              fontWeight: FontWeight.bold, 
                              fontSize: 12,
                              letterSpacing: 1.2
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Este software es libre de forma absoluta. Se entrega al dominio público sin restricciones, sin condiciones y sin burocracia. '
                            'Eres libre de usarlo, copiarlo, modificarlo o venderlo como desees. La libertad es total.',
                            style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () => launchUrl(Uri.parse('https://github.com/stivenloaiza/asifam')),
                            child: const Text(
                              'https://github.com/stivenloaiza/asifam',
                              style: TextStyle(
                                color: Color(0xFF8B5CF6),
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'ENTENDIDO', 
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(color: Colors.white10),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
              title: const Text('Resetear App', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _showResetConfirmation(context);
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'v1.0.0',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          // Si el asistente está hablando, mostrar la vista de pantalla completa
          if (provider.assistantState == AssistantState.speaking) {
            return const TalkingFaceView();
          }

          return Row(
            children: [
              // Lado izquierdo: Formulario y Estado del asistente (40%)
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(40),
                  color: const Color(0xFF0F172A),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 32),
                          const SizedBox(width: 12),
                          Text(
                            'Asifam',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Asistente Familiar Inteligente',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Programar Nuevo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Configura tu próximo aviso familiar',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white38,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const ReminderForm(),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              // Lado derecho: Pestañas (60%)
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              isScrollable: true,
                              indicatorColor: Theme.of(context).colorScheme.primary,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.white38,
                              dividerColor: Colors.transparent,
                              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              tabs: const [
                                Tab(text: 'Agenda Diaria'),
                                Tab(text: 'Historial'),
                              ],
                            ),
                          ),
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white70, size: 28),
                              onPressed: () => Scaffold.of(context).openEndDrawer(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: ReminderList(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: ReminderHistory(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('¿Resetear aplicación?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Esto borrará todos los recordatorios permanentemente. Esta acción no se puede deshacer.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ReminderProvider>(context, listen: false).resetApp();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('La aplicación ha sido reseteada correctamente')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('BORRAR TODO', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
