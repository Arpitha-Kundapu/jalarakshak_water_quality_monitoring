import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const bool showRegisterAndForgot = true;

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    final String email =
        emailController.text.trim();

    final String password =
        passwordController.text;

    // ----------------------------------------------------------
    // CHECK EMAIL
    // ----------------------------------------------------------

    if (email.isEmpty) {
      _showMessage('Please enter your email');
      return;
    }

    // ----------------------------------------------------------
    // CHECK EMAIL FORMAT
    // ----------------------------------------------------------

    final RegExp emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      _showMessage(
        'Please enter a valid email address',
      );
      return;
    }

    // ----------------------------------------------------------
    // CHECK PASSWORD
    // ----------------------------------------------------------

    if (password.isEmpty) {
      _showMessage('Please enter your password');
      return;
    }

    // ----------------------------------------------------------
    // CHECK PASSWORD LENGTH
    // ----------------------------------------------------------

    if (password.length < 6) {
      _showMessage(
        'Password must contain at least 6 characters',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // ----------------------------------------------------------
    // DYNAMIC AUTHENTICATION
    // ----------------------------------------------------------

    final result = await AuthService.login(
      email: email,
      password: password,
    );

    setState(() {
      isLoading = false;
    });

    if (result['success']) {
      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const MainScreen(),
        ),
      );
    } else {
      _showMessage(result['message'] ?? 'Invalid email or password');
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
          behavior:
              SnackBarBehavior.floating,
          duration:
              const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(
            children: [

              const SizedBox(height: 45),

              // ==================================================
              // LOGO
              // ==================================================

              Container(
                width: 95,
                height: 95,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFEAF4FF),
                  borderRadius:
                      BorderRadius.circular(
                    28,
                  ),
                ),

                child: const Icon(
                  Icons.water_drop_outlined,
                  size: 52,
                  color:
                      Color(0xFF1768E5),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // TITLE
              // ==================================================

              Text(
                languageProvider.text(
                  'welcome',
                ),

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  fontSize: 25,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // SUBTITLE
              // ==================================================

              Text(
                languageProvider.text(
                  'loginSubtitle',
                ),

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 40),

              // ==================================================
              // EMAIL
              // ==================================================

              TextField(
                controller:
                    emailController,

                keyboardType:
                    TextInputType
                        .emailAddress,

                textInputAction:
                    TextInputAction.next,

                decoration:
                    InputDecoration(
                  labelText:
                      languageProvider
                          .text('email'),

                  hintText:
                      languageProvider
                          .text(
                    'enterEmail',
                  ),

                  prefixIcon:
                      const Icon(
                    Icons
                        .email_outlined,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),

                    borderSide:
                        BorderSide(
                      color:
                          Colors.grey.shade300,
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),

                    borderSide:
                        const BorderSide(
                      color:
                          Color(0xFF1768E5),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // PASSWORD
              // ==================================================

              TextField(
                controller:
                    passwordController,

                obscureText:
                    obscurePassword,

                textInputAction:
                    TextInputAction.done,

                onSubmitted: (_) {
                  login();
                },

                decoration:
                    InputDecoration(
                  labelText:
                      languageProvider
                          .text(
                    'password',
                  ),

                  hintText:
                      languageProvider
                          .text(
                    'enterPassword',
                  ),

                  prefixIcon:
                      const Icon(
                    Icons.lock_outline,
                  ),

                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },

                    icon: Icon(
                      obscurePassword
                          ? Icons
                              .visibility_off
                          : Icons.visibility,
                    ),
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),

                    borderSide:
                        BorderSide(
                      color:
                          Colors.grey.shade300,
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),

                    borderSide:
                        const BorderSide(
                      color:
                          Color(0xFF1768E5),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // FORGOT PASSWORD
              // ==================================================

              Visibility(
                visible: showRegisterAndForgot,
                child: Align(
                  alignment:
                      Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      _showMessage(
                        'Forgot password feature will be added later',
                      );
                    },

                    child: Text(
                      languageProvider
                          .text(
                        'forgotPassword',
                      ),

                      style:
                          const TextStyle(
                        color:
                            Color(0xFF1768E5),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // LOGIN BUTTON
              // ==================================================

              SizedBox(
                width:
                    double.infinity,

                height: 55,

                child:
                    ElevatedButton(
                  onPressed: isLoading ? null : login,

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF1768E5,
                    ),

                    foregroundColor:
                        Colors.white,

                    disabledBackgroundColor:
                        const Color(0xFF1768E5).withOpacity(0.6),

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
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
                          languageProvider
                              .text(
                            'login',
                          ),

                          style:
                              const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // REGISTER
              // ==================================================

              Visibility(
                visible: showRegisterAndForgot,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Text(
                      languageProvider
                          .text(
                        'noAccount',
                      ),

                      style:
                          const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },

                      child: Text(
                        languageProvider
                            .text(
                          'register',
                        ),

                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFF1768E5,
                          ),

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}