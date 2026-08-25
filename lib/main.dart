import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'core/theme.dart';

import 'presentation/providers/language_provider.dart';
import 'presentation/providers/theme_provider.dart';

import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: JalRakshakAppWrapper(),
    ),
  );
}

// ============================================================
// APP PROVIDER WRAPPER
// ============================================================

class JalRakshakAppWrapper extends StatelessWidget {
  const JalRakshakAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        // LANGUAGE PROVIDER
        provider.ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),

        // THEME PROVIDER
        provider.ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const JalRakshakApp(),
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
    final themeProvider =
        provider.Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'JalRakshak',

      debugShowCheckedModeBanner: false,

      // ========================================================
      // LIGHT THEME
      // ========================================================

      theme: JalRakshakTheme.lightTheme,

      // ========================================================
      // DARK THEME
      // ========================================================
      // We are using Flutter's built-in dark theme for now.
      // This avoids requiring darkTheme inside core/theme.dart.

      darkTheme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor:
            const Color(0xFF101418),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4D9AFF),
          secondary: Color(0xFF4D9AFF),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101418),
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          color: Color(0xFF1A2027),
          elevation: 0,
        ),

        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A2027),
          selectedItemColor: Color(0xFF4D9AFF),
          unselectedItemColor: Colors.grey,
        ),
      ),

      // ========================================================
      // CURRENT THEME MODE
      // ========================================================

      themeMode: themeProvider.themeMode,

      // ========================================================
      // START SCREEN
      // ========================================================

      home: const SplashScreen(),
    );
  }
}