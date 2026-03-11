import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nila/core/theme/app_theme.dart';
import 'package:nila/features/auth/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zuilkmtgxvynuqbhbjtw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1aWxrbXRneHZ5bnVxYmhianR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNTQ4MDcsImV4cCI6MjA4ODgzMDgwN30.qfMPR3OA6CWCAjSjFbgYG9JJWeNXGv_jYZZOMNSLmwQ',
  );
  runApp(const NilaApp());
}

class NilaApp extends StatelessWidget {
  const NilaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nila',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
