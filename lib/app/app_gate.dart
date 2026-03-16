import 'package:daytask_app/auth/auth_controller.dart';
import 'package:daytask_app/auth/login_screen.dart';
import 'package:daytask_app/dashboard/dashboard_screen.dart';
import 'package:daytask_app/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppGate extends ConsumerWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!SupabaseService.isConfigured) {
      return const _ConfigMissingScreen();
    }

    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('Auth error: $error'))),
      data: (state) {
        final session = state.session;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: session == null
              ? const LoginScreen(key: ValueKey('login'))
              : const DashboardScreen(key: ValueKey('dashboard')),
        );
      },
    );
  }
}

class _ConfigMissingScreen extends StatelessWidget {
  const _ConfigMissingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: const Text(
              'Supabase is not configured. Run with --dart-define SUPABASE_URL and SUPABASE_ANON_KEY. See README for setup.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
