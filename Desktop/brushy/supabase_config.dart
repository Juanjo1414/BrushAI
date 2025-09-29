import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://rlmesiiljhdzqulkrpgl.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJsbWVzaWlsamhkenF1bGtycGdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkwOTEzNTQsImV4cCI6MjA3NDY2NzM1NH0.0Zxyvf1y0nZpMpqjaRX9c1luwA2G9HWpq7EGSH1OBPg';

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
