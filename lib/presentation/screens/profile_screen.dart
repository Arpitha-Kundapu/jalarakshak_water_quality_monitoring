import 'package:flutter/material.dart';

import '../../core/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedLanguage = 'English';
  bool notificationsEnabled = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JalRakshakTheme.backgroundLight,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Profile & Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: JalRakshakTheme.textDark,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            5,
            20,
            25,
          ),
          child: Column(
            children: [
              // ====================================================
              // PROFILE HEADER
              // ====================================================

              _buildProfileHeader(),

              const SizedBox(height: 20),

              // ====================================================
              // SETTINGS
              // ====================================================

              _buildSettingsCard(),

              const SizedBox(height: 18),

              // ====================================================
              // LOGOUT
              // ====================================================

              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // PROFILE HEADER
  // ================================================================

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // --------------------------------------------------------
          // AVATAR
          // --------------------------------------------------------

          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FF),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD8E9FF),
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 34,
              color: JalRakshakTheme.primaryBlue,
            ),
          ),

          const SizedBox(width: 15),

          // --------------------------------------------------------
          // USER DETAILS
          // --------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: JalRakshakTheme.textDark,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'user@example.com',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SETTINGS CARD
  // ================================================================

  Widget _buildSettingsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // --------------------------------------------------------
          // LANGUAGE
          // --------------------------------------------------------

          _buildSettingTile(
            icon: Icons.language,
            title: 'Language',
            trailingText: selectedLanguage,
            onTap: _showLanguageDialog,
          ),

          _buildDivider(),

          // --------------------------------------------------------
          // NOTIFICATIONS
          // --------------------------------------------------------

          _buildSettingTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            trailing: Switch(
              value: notificationsEnabled,
              activeColor: JalRakshakTheme.primaryBlue,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                notificationsEnabled =
                    !notificationsEnabled;
              });
            },
          ),

          _buildDivider(),

          // --------------------------------------------------------
          // THEME
          // --------------------------------------------------------

          _buildSettingTile(
            icon: Icons.brightness_6_outlined,
            title: 'Theme',
            trailingText: darkMode
                ? 'Dark Mode'
                : 'Light Mode',
            onTap: _showThemeDialog,
          ),

          _buildDivider(),

          // --------------------------------------------------------
          // PRIVACY POLICY
          // --------------------------------------------------------

          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            showArrow: true,
            onTap: () {
              _showComingSoon(
                'Privacy Policy',
              );
            },
          ),

          _buildDivider(),

          // --------------------------------------------------------
          // ABOUT JALRAKSHAK
          // --------------------------------------------------------

          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'About JalRakshak',
            showArrow: true,
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SETTING TILE
  // ================================================================

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailing,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        child: SizedBox(
          height: 54,
          child: Row(
            children: [
              // ----------------------------------------------------
              // ICON
              // ----------------------------------------------------

              SizedBox(
                width: 32,
                child: Icon(
                  icon,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(width: 8),

              // ----------------------------------------------------
              // TITLE
              // ----------------------------------------------------

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: JalRakshakTheme.textDark,
                  ),
                ),
              ),

              // ----------------------------------------------------
              // TRAILING TEXT
              // ----------------------------------------------------

              if (trailingText != null)
                Text(
                  trailingText,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),

              // ----------------------------------------------------
              // TRAILING WIDGET
              // ----------------------------------------------------

              if (trailing != null) trailing,

              // ----------------------------------------------------
              // ARROW
              // ----------------------------------------------------

              if (showArrow)
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.chevron_right,
                    size: 17,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // DIVIDER
  // ================================================================

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.6,
      indent: 55,
      endIndent: 12,
      color: Colors.grey.shade200,
    );
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: _showLogoutDialog,
        borderRadius: BorderRadius.circular(14),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          child: Row(
            children: [
              Icon(
                Icons.logout,
                size: 18,
                color: JalRakshakTheme.dangerRed,
              ),

              SizedBox(width: 10),

              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: JalRakshakTheme.dangerRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // LANGUAGE DIALOG
  // ================================================================

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Select Language',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageOption('English'),
              _languageOption('ಕನ್ನಡ'),
              _languageOption('हिन्दी'),
            ],
          ),
        );
      },
    );
  }

  Widget _languageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: selectedLanguage == language
          ? const Icon(
              Icons.check,
              color: JalRakshakTheme.primaryBlue,
            )
          : null,
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });

        Navigator.pop(context);
      },
    );
  }

  // ================================================================
  // THEME DIALOG
  // ================================================================

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Select Theme',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<bool>(
                value: false,
                groupValue: darkMode,
                title: const Text('Light Mode'),
                onChanged: (value) {
                  setState(() {
                    darkMode = false;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<bool>(
                value: true,
                groupValue: darkMode,
                title: const Text('Dark Mode'),
                onChanged: (value) {
                  setState(() {
                    darkMode = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================================================================
  // ABOUT DIALOG
  // ================================================================

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'JalRakshak',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.water_drop,
        color: JalRakshakTheme.primaryBlue,
        size: 40,
      ),
      children: const [
        Text(
          'JalRakshak is a smart water quality monitoring '
          'and AI prescriptive system designed to monitor '
          'water quality and provide intelligent treatment '
          'recommendations.',
        ),
      ],
    );
  }

  // ================================================================
  // COMING SOON
  // ================================================================

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title will be available soon.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ================================================================
  // LOGOUT DIALOG
  // ================================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Logout',
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(this.context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Logged out successfully.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    JalRakshakTheme.dangerRed,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );
  }
}