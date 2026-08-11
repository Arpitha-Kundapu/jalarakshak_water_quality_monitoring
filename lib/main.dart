import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: JalRakshakApp(),
    ),
  );
}

class JalRakshakApp extends StatelessWidget {
  const JalRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JalRakshak',
      debugShowCheckedModeBanner: false,
      theme: JalRakshakTheme.lightTheme,

      // Splash → Language → Login → MainScreen
      home: const SplashScreen(),
    );
  }
}