import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

import 'dashboard_screen.dart';
import 'live_screen.dart';
import 'history_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // ================================================================
  // APP SCREENS
  // ================================================================

  final List<Widget> _screens = const [
    DashboardScreen(),
    LiveScreen(),
    HistoryScreen(),
    AlertsScreen(),
    ProfileScreen(),
  ];

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    // Get currently selected language
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // ------------------------------------------------------------
      // CURRENT SCREEN
      // ------------------------------------------------------------
      body: IndexedStack(index: _currentIndex, children: _screens),

      // ------------------------------------------------------------
      // BOTTOM NAVIGATION
      // ------------------------------------------------------------
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,

            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },

            type: BottomNavigationBarType.fixed,

            backgroundColor: Colors.white,

            elevation: 0,

            selectedItemColor: const Color(0xFF1D80E5),

            unselectedItemColor: Colors.grey.shade500,

            selectedFontSize: 12,

            unselectedFontSize: 12,

            showUnselectedLabels: true,

            // ------------------------------------------------------
            // NAVIGATION ITEMS
            // ------------------------------------------------------
            items: [
              // ====================================================
              // HOME
              // ====================================================
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: languageProvider.text('home'),
              ),

              // ====================================================
              // LIVE
              // ====================================================
              BottomNavigationBarItem(
                icon: const Icon(Icons.water_drop_outlined),
                activeIcon: const Icon(Icons.water_drop),
                label: languageProvider.text('live'),
              ),

              // ====================================================
              // HISTORY
              // ====================================================
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_outlined),
                activeIcon: const Icon(Icons.bar_chart),
                label: languageProvider.text('history'),
              ),

              // ====================================================
              // ALERTS
              // ====================================================
              BottomNavigationBarItem(
                icon: const Icon(Icons.notifications_none),
                activeIcon: const Icon(Icons.notifications),
                label: languageProvider.text('alerts'),
              ),

              // ====================================================
              // PROFILE
              // ====================================================
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: languageProvider.text('profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
