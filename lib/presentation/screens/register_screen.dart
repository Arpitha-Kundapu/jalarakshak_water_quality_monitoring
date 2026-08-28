import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOCAL TRANSLATIONS
  // ============================================================

  String _text(
    LanguageProvider language,
    String key,
  ) {
    final Map<String, Map<String, String>> translations = {
      'English': {
        'createAccount': 'Create Account',
        'registerSubtitle': 'Sign up to start monitoring water quality',
        'fullName': 'Full Name',
        'enterName': 'Enter your full name',
        'confirmPassword': 'Confirm Password',
        'enterConfirmPassword': 'Re-enter your password',
        'alreadyHaveAccount': 'Already have an account?',
        'loginNow': 'Login Now',
        'passwordsDoNotMatch': 'Passwords do not match',
        'nameEmpty': 'Please enter your name',
        'signingUp': 'Creating account...',
      },
      'ಕನ್ನಡ': {
        'createAccount': 'ಖಾತೆಯನ್ನು ರಚಿಸಿ',
        'registerSubtitle': 'ನೀರಿನ ಗುಣಮಟ್ಟವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಲು ಸೈನ್ ಅಪ್ ಮಾಡಿ',
        'fullName': 'ಪೂರ್ಣ ಹೆಸರು',
        'enterName': 'ನಿಮ್ಮ ಪೂರ್ಣ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
        'confirmPassword': 'ಪಾಸ್ವರ್ಡ್ ದೃಢೀಕರಿಸಿ',
        'enterConfirmPassword': 'ನಿಮ್ಮ ಪಾಸ್ವರ್ಡ್ ಅನ್ನು ಮರು-ನಮೂದಿಸಿ',
        'alreadyHaveAccount': 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ?',
        'loginNow': 'ಈಗ ಲಾಗಿನ್ ಮಾಡಿ',
        'passwordsDoNotMatch': 'ಪಾಸ್‌ವರ್ಡ್‌ಗಳು ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ',
        'nameEmpty': 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
        'signingUp': 'ಖಾತೆಯನ್ನು ರಚಿಸಲಾಗುತ್ತಿದೆ...',
      },
      'हिन्दी': {
        'createAccount': 'खाता बनाएं',
        'registerSubtitle': 'पानी की गुणवत्ता की निगरानी के लिए साइन अप करें',
        'fullName': 'पूरा नाम',
        'enterName': 'अपना पूरा नाम दर्ज करें',
        'confirmPassword': 'पासवर्ड की पुष्टि करें',
        'enterConfirmPassword': 'अपना पासवर्ड पुनः दर्ज करें',
        'alreadyHaveAccount': 'क्या आपके पास पहले से एक खाता है?',
        'loginNow': 'अभी लॉगिन करें',
        'passwordsDoNotMatch': 'पासवर्ड मेल नहीं खाते',
        'nameEmpty': 'कृपया अपना नाम दर्ज करें',
        'signingUp': 'खाता बनाया जा रहा है...',
      },
    };

    return translations[language.language]?[key] ?? key;
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<void> register() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Validation
    if (name.isEmpty) {
      _showMessage(_text(languageProvider, 'nameEmpty'));
      return;
    }

    if (email.isEmpty) {
      _showMessage('Please enter your email');
      return;
    }

    final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      _showMessage('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Please enter your password');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must contain at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showMessage(_text(languageProvider, 'passwordsDoNotMatch'));
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Call dynamic registration API
    final result = await AuthService.register(
      name: name,
      email: email,
      password: password,
    );

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      // Save login session state
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);

      if (!mounted) return;

      _showMessage(result['message'] ?? 'Registration successful');

      // Go to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      _showMessage(result['message'] ?? 'Registration failed');
    }
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 25),

              // ==================================================
              // LOGO
              // ==================================================
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  size: 46,
                  color: Color(0xFF1768E5),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // TITLE
              // ==================================================
              Text(
                _text(languageProvider, 'createAccount'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // SUBTITLE
              // ==================================================
              Text(
                _text(languageProvider, 'registerSubtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // FULL NAME
              // ==================================================
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: _text(languageProvider, 'fullName'),
                  hintText: _text(languageProvider, 'enterName'),
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1768E5), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // EMAIL
              // ==================================================
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: languageProvider.text('email'),
                  hintText: languageProvider.text('enterEmail'),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1768E5), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // PASSWORD
              // ==================================================
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: languageProvider.text('password'),
                  hintText: languageProvider.text('enterPassword'),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1768E5), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // CONFIRM PASSWORD
              // ==================================================
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => register(),
                decoration: InputDecoration(
                  labelText: _text(languageProvider, 'confirmPassword'),
                  hintText: _text(languageProvider, 'enterConfirmPassword'),
                  prefixIcon: const Icon(Icons.lock_clock_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1768E5), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // REGISTER BUTTON
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1768E5),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF1768E5).withOpacity(0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _text(languageProvider, 'createAccount'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // BACK TO LOGIN LINK
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _text(languageProvider, 'alreadyHaveAccount'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      _text(languageProvider, 'loginNow'),
                      style: const TextStyle(
                        color: Color(0xFF1768E5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
