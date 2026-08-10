import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'presentation/screens/main_screen.dart';

void main() {
  // ProviderScope is required for Riverpod state management
  runApp(const ProviderScope(child: JalRakshakApp()));
}

class JalRakshakApp extends StatelessWidget {
  const JalRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JalRakshak',
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: JalRakshakTheme.lightTheme, // Applies your custom Poppins theme
      home: const MainScreen(),
    );
  }
}