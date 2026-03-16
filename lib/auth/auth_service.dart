import 'package:daytask_app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  User? get currentUser => SupabaseService.isConfigured
      ? SupabaseService.client.auth.currentUser
      : null;

  Stream<AuthState> authStateChanges() {
    if (!SupabaseService.isConfigured) {
      return const Stream.empty();
    }
    return SupabaseService.client.auth.onAuthStateChange;
  }

  Future<void> signIn({required String email, required String password}) async {
    _ensureConfigured();
    await SupabaseService.client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    _ensureConfigured();
    await SupabaseService.client.auth.signUp(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    _ensureConfigured();
    await SupabaseService.client.auth.signOut();
  }

  void _ensureConfigured() {
    if (!SupabaseService.isConfigured) {
      throw const AuthException('Missing Supabase setup.');
    }
  }
}
