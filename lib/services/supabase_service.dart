import 'package:supabase_flutter/supabase_flutter.dart';

/// Holds the project-specific Supabase configuration.
class SupabaseService {
  SupabaseService._();

  static const supabaseUrl = 'https://neoowknkoiargrzoijhx.supabase.co';
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5lb293a25rb2lhcmdyem9pamh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgyODU4MzUsImV4cCI6MjA4Mzg2MTgzNX0.p46owLzREWBjs-8p3vtceTrcW0uPGrzFS_lUNr0_H-c';

  static SupabaseClient get client => Supabase.instance.client;
}
