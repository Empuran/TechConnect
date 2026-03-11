import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techconnect/core/theme/app_theme.dart';
import 'package:techconnect/features/auth/presentation/login_screen.dart';
import 'package:techconnect/features/discovery/presentation/swipe_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://zuilkmtgxvynuqbhbjtw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1aWxrbXRneHZ5bnVxYmhianR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNTQ4MDcsImV4cCI6MjA4ODgzMDgwN30.qfMPR3OA6CWCAjSjFbgYG9JJWeNXGv_jYZZOMNSLmwQ',
  );

  runApp(const TechConnectApp());
}

class TechConnectApp extends StatelessWidget {
  const TechConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechConnect',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic session handling using StreamBuilder
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data!.session;
          if (session != null) {
            return const SwipeScreen(); // Logged in
          }
        }
        return const LoginScreen(); // Not logged in
      },
    );
  }
}
