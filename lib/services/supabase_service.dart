import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _configured = false;

  static bool get isConfigured => _configured;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initializeFromEnvironment() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    if (url.isEmpty || anonKey.isEmpty) {
      _configured = false;
      return;
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
    _configured = true;
  }
}
