import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
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
              const SizedBox(height: 45),

              // ------------------------------------------------
              // JALRAKSHAK LOGO
              // ------------------------------------------------
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  size: 52,
                  color: Color(0xFF1768E5),
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // TITLE
              // ------------------------------------------------
              Text(
                languageProvider.text('welcome'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // ------------------------------------------------
              // SUBTITLE
              // ------------------------------------------------
              Text(
                languageProvider.text('loginSubtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 40),

              // ------------------------------------------------
              // EMAIL
              // ------------------------------------------------
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
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
                    borderSide: const BorderSide(
                      color: Color(0xFF1768E5),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // PASSWORD
              // ------------------------------------------------
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,

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
                    borderSide: const BorderSide(
                      color: Color(0xFF1768E5),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ------------------------------------------------
              // FORGOT PASSWORD
              // ------------------------------------------------
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Forgot password functionality
                    // can be added later.
                  },

                  child: Text(
                    languageProvider.text('forgotPassword'),
                    style: const TextStyle(color: Color(0xFF1768E5)),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // LOGIN BUTTON
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: login,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1768E5),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: Text(
                    languageProvider.text('login'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // REGISTER
              // ------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    languageProvider.text('noAccount'),
                    style: const TextStyle(color: Colors.grey),
                  ),

                  TextButton(
                    onPressed: () {
                      // Registration functionality
                      // can be added later.
                    },

                    child: Text(
                      languageProvider.text('register'),
                      style: const TextStyle(
                        color: Color(0xFF1768E5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
