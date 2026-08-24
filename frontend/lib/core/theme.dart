import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JalRakshakTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1D80E5);
  static const Color safeGreen = Color(0xFF43A047);
  static const Color warningOrange = Color(0xFFFFB300);
  static const Color dangerRed = Color(0xFFE53935);
  static const Color backgroundLight = Color(0xFFF5F7FA);
  
  // FIX: Corrected the hex code to a solid, highly visible dark navy/black
  static const Color textDark = Color(0xFF1E293B); 

  // Global App Theme
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: primaryBlue,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      // FIX: Force the AppBar to use dark text and icons
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        foregroundColor: textDark, 
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}