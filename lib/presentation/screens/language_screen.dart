import 'package:flutter/material.dart';

import 'login_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  final List<String> languages = [
    'English',
    'ಕನ್ನಡ',
    'हिन्दी',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 55),

              // LANGUAGE ICON
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.language,
                  size: 48,
                  color: Color(0xFF1768E5),
                ),
              ),

              const SizedBox(height: 25),

              // TITLE
              const Text(
                'Choose Your Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Select your preferred language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // LANGUAGE OPTIONS
              ...languages.map(
                (language) {
                  final bool isSelected =
                      selectedLanguage == language;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLanguage = language;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEAF4FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1768E5)
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.language,
                              color: isSelected
                                  ? const Color(0xFF1768E5)
                                  : Colors.grey,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Text(
                              language,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF1768E5),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1768E5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}