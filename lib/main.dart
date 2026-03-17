import 'package:daytask_app/app/app_gate.dart';
import 'package:daytask_app/app/splash_screen.dart';
import 'package:daytask_app/app/theme.dart';
import 'package:daytask_app/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initializeFromEnvironment();

  runApp(const ProviderScope(child: DayTaskApp()));
}

class DayTaskApp extends StatefulWidget {
  const DayTaskApp({super.key});

  @override
  State<DayTaskApp> createState() => _DayTaskAppState();
}

class _DayTaskAppState extends State<DayTaskApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayTask',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _showSplash
            ? SplashScreen(
                key: const ValueKey('splash-screen'),
                onContinue: () => setState(() => _showSplash = false),
              )
            : const AppGate(key: ValueKey('app-gate')),
      ),
    );
  }
}
