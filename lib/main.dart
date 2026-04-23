import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'providers/reminder_provider.dart';
import 'ui/views/dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await WakelockPlus.enable();
  } catch (e) {
    debugPrint("Wakelock could not be enabled: $e");
  }

  runApp(const AsifamApp());
}

class AsifamApp extends StatelessWidget {
  const AsifamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: MaterialApp(
        title: 'Asifam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B5CF6),
            brightness: Brightness.dark,
          ).copyWith(
            surface: const Color(0xFF1E293B),
            primary: const Color(0xFF8B5CF6),
            secondary: const Color(0xFF38BDF8),
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          scaffoldBackgroundColor: const Color(0xFF020617),
          cardTheme: const CardThemeData(
            color: Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            elevation: 0,
          ),
        ),
        home: const DashboardView(),
      ),
    );
  }
}
