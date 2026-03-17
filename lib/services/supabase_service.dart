import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _configured = false;
  static String? _initError;
  static List<String> _missingKeys = <String>[];

  static bool get isConfigured => _configured;
  static String? get initError => _initError;
  static List<String> get missingKeys => List.unmodifiable(_missingKeys);

  static SupabaseClient get client => Supabase.instance.client;

  static String _readFirstDefined(List<String> keys) {
    for (final key in keys) {
      final value = switch (key) {
        'SUPABASE_URL' => const String.fromEnvironment('SUPABASE_URL'),
        // Common misspelling fallback.
        'SUPASE_URL' => const String.fromEnvironment('SUPASE_URL'),
        'SUPABSE_URL' => const String.fromEnvironment('SUPABSE_URL'),
        'SUPABASE_ANON_KEY' => const String.fromEnvironment(
          'SUPABASE_ANON_KEY',
        ),
        // Common variant fallback.
        'SUPABASE_ANONKEY' => const String.fromEnvironment('SUPABASE_ANONKEY'),
        'SUPABASE_KEY' => const String.fromEnvironment('SUPABASE_KEY'),
        _ => '',
      };

      final cleaned = value.trim().replaceAll('"', '');
      if (cleaned.isNotEmpty) {
        return cleaned;
      }
    }

    return '';
  }

  static Future<void> initializeFromEnvironment() async {
    _initError = null;
    _missingKeys = <String>[];

    final url = _readFirstDefined(const [
      'SUPABASE_URL',
      'SUPASE_URL',
      'SUPABSE_URL',
    ]);
    final anonKey = _readFirstDefined(const [
      'SUPABASE_ANON_KEY',
      'SUPABASE_ANONKEY',
      'SUPABASE_KEY',
    ]);

    if (url.isEmpty || anonKey.isEmpty) {
      if (url.isEmpty) {
        _missingKeys.add('SUPABASE_URL');
      }
      if (anonKey.isEmpty) {
        _missingKeys.add('SUPABASE_ANON_KEY');
      }
      _configured = false;
      return;
    }

    try {
      await Supabase.initialize(url: url, anonKey: anonKey);
      _configured = true;
    } catch (error) {
      _configured = false;
      _initError = error.toString();
    }
  }
}
