import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'presentation/providers/language_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(child: LanguageProviderWrapper(child: JalRakshakApp())),
  );
}

// ============================================================
// LANGUAGE PROVIDER WRAPPER
// ============================================================

class LanguageProviderWrapper extends StatelessWidget {
  final Widget child;

  const LanguageProviderWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: child,
    );
  }
}

// ============================================================
// JALRAKSHAK APP
// ============================================================

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
