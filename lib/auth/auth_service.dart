import 'package:daytask_app/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static const String _mobileAuthRedirectUri =
      'io.supabase.daytask://login-callback/';

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

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    _ensureConfigured();
    return SupabaseService.client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        if (fullName != null && fullName.trim().isNotEmpty)
          'full_name': fullName.trim(),
      },
    );
  }

  Future<void> signInWithGoogle() async {
    _ensureConfigured();
    await SupabaseService.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : _mobileAuthRedirectUri,
    );
  }

  Future<void> resendSignupVerificationEmail({required String email}) async {
    _ensureConfigured();
    await SupabaseService.client.auth.resend(
      type: OtpType.signup,
      email: email.trim(),
    );
  }

  Future<void> resetPassword({required String email}) async {
    _ensureConfigured();
    await SupabaseService.client.auth.resetPasswordForEmail(email.trim());
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
