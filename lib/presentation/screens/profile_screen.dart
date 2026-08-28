import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/core/theme.dart';
import '/presentation/providers/language_provider.dart';
import '/presentation/providers/theme_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final bool isDark = themeProvider.themeMode == ThemeMode.dark;

    final backgroundColor = isDark
        ? const Color(0xFF101418)
        : JalRakshakTheme.backgroundLight;

    final cardColor = isDark
        ? const Color(0xFF1A2027)
        : Colors.white;

    final textColor = isDark
        ? Colors.white
        : JalRakshakTheme.textDark;

    final secondaryTextColor = isDark
        ? Colors.grey.shade400
        : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,

        title: Text(
          _text(language, 'profileSettings'),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

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

              // ======================================================
              // PROFILE HEADER
              // ======================================================

              _buildProfileHeader(
                cardColor: cardColor,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),

              const SizedBox(height: 20),

              // ======================================================
              // SETTINGS
              // ======================================================

              _buildSettingsCard(
                language,
                cardColor: cardColor,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDark: isDark,
              ),

              const SizedBox(height: 18),

              // ======================================================
              // LOGOUT
              // ======================================================

              _buildLogoutButton(
                language,
                cardColor: cardColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // LANGUAGE TEXT
  // ================================================================

  String _text(
    LanguageProvider language,
    String key,
  ) {
    final Map<String, Map<String, String>> translations = {

      // ============================================================
      // ENGLISH
      // ============================================================

      'English': {
        'profileSettings': 'Profile & Settings',
        'userName': 'User Name',
        'language': 'Language',
        'notifications': 'Notifications',
        'theme': 'Theme',
        'darkMode': 'Dark Mode',
        'lightMode': 'Light Mode',
        'privacyPolicy': 'Privacy Policy',
        'aboutJalRakshak': 'About JalRakshak',
        'logout': 'Logout',
        'selectLanguage': 'Select Language',
        'selectTheme': 'Select Theme',
        'privacySoon': 'Privacy Policy will be available soon.',
        'aboutText':
            'JalRakshak is a smart water quality monitoring '
            'and AI prescriptive system designed to monitor '
            'water quality and provide intelligent treatment '
            'recommendations.',
        'logoutConfirm':
            'Are you sure you want to logout?',
        'cancel': 'Cancel',
        'loggedOut': 'Logged out successfully.',
      },

      // ============================================================
      // KANNADA
      // ============================================================

      'ಕನ್ನಡ': {
        'profileSettings':
            'ಪ್ರೊಫೈಲ್ ಮತ್ತು ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
        'userName':
            'ಬಳಕೆದಾರರ ಹೆಸರು',
        'language':
            'ಭಾಷೆ',
        'notifications':
            'ಅಧಿಸೂಚನೆಗಳು',
        'theme':
            'ಥೀಮ್',
        'darkMode':
            'ಡಾರ್ಕ್ ಮೋಡ್',
        'lightMode':
            'ಲೈಟ್ ಮೋಡ್',
        'privacyPolicy':
            'ಗೌಪ್ಯತಾ ನೀತಿ',
        'aboutJalRakshak':
            'JalRakshak ಬಗ್ಗೆ',
        'logout':
            'ಲಾಗ್‌ಔಟ್',
        'selectLanguage':
            'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
        'selectTheme':
            'ಥೀಮ್ ಆಯ್ಕೆಮಾಡಿ',
        'privacySoon':
            'ಗೌಪ್ಯತಾ ನೀತಿ ಶೀಘ್ರದಲ್ಲೇ ಲಭ್ಯವಾಗಲಿದೆ.',
        'aboutText':
            'JalRakshak ನೀರಿನ ಗುಣಮಟ್ಟವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಲು '
            'ಮತ್ತು ಬುದ್ಧಿವಂತ ಚಿಕಿತ್ಸಾ ಶಿಫಾರಸುಗಳನ್ನು ನೀಡಲು '
            'ವಿನ್ಯಾಸಗೊಳಿಸಲಾದ ಸ್ಮಾರ್ಟ್ ನೀರಿನ ಗುಣಮಟ್ಟ ಮೇಲ್ವಿಚಾರಣಾ '
            'ಮತ್ತು AI ಆಧಾರಿತ ವ್ಯವಸ್ಥೆಯಾಗಿದೆ.',
        'logoutConfirm':
            'ನೀವು ಲಾಗ್‌ಔಟ್ ಮಾಡಲು ಖಚಿತವಾಗಿ ಬಯಸುವಿರಾ?',
        'cancel':
            'ರದ್ದುಮಾಡಿ',
        'loggedOut':
            'ಯಶಸ್ವಿಯಾಗಿ ಲಾಗ್‌ಔಟ್ ಆಗಿದೆ.',
      },

      // ============================================================
      // HINDI
      // ============================================================

      'हिन्दी': {
        'profileSettings':
            'प्रोफ़ाइल और सेटिंग्स',
        'userName':
            'उपयोगकर्ता का नाम',
        'language':
            'भाषा',
        'notifications':
            'सूचनाएँ',
        'theme':
            'थीम',
        'darkMode':
            'डार्क मोड',
        'lightMode':
            'लाइट मोड',
        'privacyPolicy':
            'गोपनीयता नीति',
        'aboutJalRakshak':
            'JalRakshak के बारे में',
        'logout':
            'लॉगआउट',
        'selectLanguage':
            'भाषा चुनें',
        'selectTheme':
            'थीम चुनें',
        'privacySoon':
            'गोपनीयता नीति जल्द उपलब्ध होगी।',
        'aboutText':
            'JalRakshak एक स्मार्ट जल गुणवत्ता निगरानी '
            'और AI आधारित प्रणाली है जिसे पानी की गुणवत्ता '
            'की निगरानी करने और बुद्धिमान उपचार सुझाव '
            'देने के लिए बनाया गया है।',
        'logoutConfirm':
            'क्या आप वाकई लॉगआउट करना चाहते हैं?',
        'cancel':
            'रद्द करें',
        'loggedOut':
            'सफलतापूर्वक लॉगआउट हो गया।',
      },
    };

    return translations[language.language]?[key] ?? key;
  }

  // ================================================================
  // PROFILE HEADER
  // ================================================================

  Widget _buildProfileHeader({
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,
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

          // ========================================================
          // AVATAR
          // ========================================================

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

          // ========================================================
          // USER DETAILS
          // ========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  'User Name',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'user@example.com',

                  style: TextStyle(
                    fontSize: 11,
                    color: secondaryTextColor,
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

  Widget _buildSettingsCard(
    LanguageProvider language, {
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: cardColor,
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

          // ========================================================
          // LANGUAGE
          // ========================================================

          _buildSettingTile(
            icon: Icons.language,

            title: _text(
              language,
              'language',
            ),

            trailingText:
                language.language,

            textColor: textColor,
            secondaryTextColor:
                secondaryTextColor,

            onTap: () {
              _showLanguageDialog(
                language,
              );
            },
          ),

          _buildDivider(isDark),

          // ========================================================
          // NOTIFICATIONS
          // ========================================================

          _buildSettingTile(
            icon: Icons.notifications_none,

            title: _text(
              language,
              'notifications',
            ),

            trailing: Switch(
              value: notificationsEnabled,

              activeColor:
                  JalRakshakTheme.primaryBlue,

              onChanged: (value) {
                setState(() {
                  notificationsEnabled =
                      value;
                });
              },
            ),

            textColor: textColor,
            secondaryTextColor:
                secondaryTextColor,

            onTap: () {
              setState(() {
                notificationsEnabled =
                    !notificationsEnabled;
              });
            },
          ),

          _buildDivider(isDark),

          // ========================================================
          // THEME
          // ========================================================

          _buildSettingTile(
            icon: Icons.brightness_6_outlined,

            title: _text(
              language,
              'theme',
            ),

            trailingText: isDark
                ? _text(
                    language,
                    'darkMode',
                  )
                : _text(
                    language,
                    'lightMode',
                  ),

            textColor: textColor,
            secondaryTextColor:
                secondaryTextColor,

            onTap: () {
              _showThemeDialog(
                language,
              );
            },
          ),

          _buildDivider(isDark),

          // ========================================================
          // PRIVACY POLICY
          // ========================================================

          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,

            title: _text(
              language,
              'privacyPolicy',
            ),

            showArrow: true,

            textColor: textColor,
            secondaryTextColor:
                secondaryTextColor,

            onTap: () {
              _showComingSoon(
                language,
                _text(
                  language,
                  'privacyPolicy',
                ),
              );
            },
          ),

          _buildDivider(isDark),

          // ========================================================
          // ABOUT
          // ========================================================

          _buildSettingTile(
            icon: Icons.info_outline,

            title: _text(
              language,
              'aboutJalRakshak',
            ),

            showArrow: true,

            textColor: textColor,
            secondaryTextColor:
                secondaryTextColor,

            onTap: () {
              _showAboutDialog(
                language,
              );
            },
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
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(18),

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),

        child: SizedBox(
          height: 54,

          child: Row(
            children: [

              // ====================================================
              // ICON
              // ====================================================

              SizedBox(
                width: 32,

                child: Icon(
                  icon,
                  size: 18,
                  color: secondaryTextColor,
                ),
              ),

              const SizedBox(width: 8),

              // ====================================================
              // TITLE
              // ====================================================

              Expanded(
                child: Text(
                  title,

                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),

              // ====================================================
              // TRAILING TEXT
              // ====================================================

              if (trailingText != null)
                Text(
                  trailingText,

                  style: TextStyle(
                    fontSize: 10,
                    color: secondaryTextColor,
                  ),
                ),

              // ====================================================
              // TRAILING WIDGET
              // ====================================================

              if (trailing != null)
                trailing,

              // ====================================================
              // ARROW
              // ====================================================

              if (showArrow)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    left: 5,
                  ),

                  child: Icon(
                    Icons.chevron_right,
                    size: 17,
                    color: secondaryTextColor,
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

  Widget _buildDivider(
    bool isDark,
  ) {
    return Divider(
      height: 1,
      thickness: 0.6,
      indent: 55,
      endIndent: 12,

      color: isDark
          ? Colors.grey.shade800
          : Colors.grey.shade200,
    );
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  Widget _buildLogoutButton(
    LanguageProvider language, {
    required Color cardColor,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),

      child: InkWell(
        onTap: () {
          _showLogoutDialog(
            language,
          );
        },

        borderRadius:
            BorderRadius.circular(14),

        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),

          child: Row(
            children: [

              const Icon(
                Icons.logout,
                size: 18,
                color: JalRakshakTheme.dangerRed,
              ),

              const SizedBox(width: 10),

              Text(
                _text(
                  language,
                  'logout',
                ),

                style: const TextStyle(
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

  void _showLanguageDialog(
    LanguageProvider language,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            _text(
              language,
              'selectLanguage',
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              _languageOption(
                language,
                'English',
                dialogContext,
              ),

              _languageOption(
                language,
                'ಕನ್ನಡ',
                dialogContext,
              ),

              _languageOption(
                language,
                'हिन्दी',
                dialogContext,
              ),
            ],
          ),
        );
      },
    );
  }

  // ================================================================
  // LANGUAGE OPTION
  // ================================================================

  Widget _languageOption(
    LanguageProvider language,
    String selectedLanguage,
    BuildContext dialogContext,
  ) {
    return ListTile(
      title: Text(
        selectedLanguage,
      ),

      trailing:
          language.language ==
                  selectedLanguage
              ? const Icon(
                  Icons.check,
                  color:
                      JalRakshakTheme
                          .primaryBlue,
                )
              : null,

      onTap: () {
        language.setLanguage(
          selectedLanguage,
        );

        Navigator.pop(
          dialogContext,
        );
      },
    );
  }

  // ================================================================
  // THEME DIALOG
  // ================================================================

  void _showThemeDialog(
    LanguageProvider language,
  ) {
    final themeProvider =
        Provider.of<ThemeProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            _text(
              language,
              'selectTheme',
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              // ====================================================
              // LIGHT MODE
              // ====================================================

              RadioListTile<ThemeMode>(
                value: ThemeMode.light,

                groupValue:
                    themeProvider.themeMode,

                title: Text(
                  _text(
                    language,
                    'lightMode',
                  ),
                ),

                onChanged:
                    (ThemeMode? value) {
                  if (value == null) {
                    return;
                  }

                  themeProvider
                      .setThemeMode(
                    ThemeMode.light,
                  );

                  Navigator.pop(
                    dialogContext,
                  );
                },
              ),

              // ====================================================
              // DARK MODE
              // ====================================================

              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,

                groupValue:
                    themeProvider.themeMode,

                title: Text(
                  _text(
                    language,
                    'darkMode',
                  ),
                ),

                onChanged:
                    (ThemeMode? value) {
                  if (value == null) {
                    return;
                  }

                  themeProvider
                      .setThemeMode(
                    ThemeMode.dark,
                  );

                  Navigator.pop(
                    dialogContext,
                  );
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

  void _showAboutDialog(
    LanguageProvider language,
  ) {
    showAboutDialog(
      context: context,

      applicationName:
          'JalRakshak',

      applicationVersion:
          '1.0.0',

      applicationIcon:
          const Icon(
        Icons.water_drop,
        color:
            JalRakshakTheme
                .primaryBlue,
        size: 40,
      ),

      children: [
        Text(
          _text(
            language,
            'aboutText',
          ),
        ),
      ],
    );
  }

  // ================================================================
  // COMING SOON
  // ================================================================

  void _showComingSoon(
    LanguageProvider language,
    String title,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          '$title ${_text(language, 'privacySoon')}',
        ),

        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ================================================================
  // LOGOUT DIALOG
  // ================================================================

  void _showLogoutDialog(
    LanguageProvider language,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            _text(
              language,
              'logout',
            ),
          ),

          content: Text(
            _text(
              language,
              'logoutConfirm',
            ),
          ),

          actions: [

            // ======================================================
            // CANCEL
            // ======================================================

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child: Text(
                _text(
                  language,
                  'cancel',
                ),
              ),
            ),

            // ======================================================
            // LOGOUT
            // ======================================================

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(
                  dialogContext,
                );

                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('is_logged_in', false);

                if (!mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      _text(
                        language,
                        'loggedOut',
                      ),
                    ),
                  ),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    JalRakshakTheme
                        .dangerRed,

                foregroundColor:
                    Colors.white,
              ),

              child: Text(
                _text(
                  language,
                  'logout',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}