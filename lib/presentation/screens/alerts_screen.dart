import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as language_provider;

import '../../core/theme.dart';
import '../providers/language_provider.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  // ================================================================
  // LANGUAGE TRANSLATIONS
  // ================================================================

  String _text(LanguageProvider language, String key) {
    final Map<String, Map<String, String>> translations = {
      // ============================================================
      // ENGLISH
      // ============================================================
      'English': {
        'alertsTreatments': 'Alerts & Treatments',
        'activeWarnings': 'Active Warnings',

        'waterNotSafe': 'Water is NOT SAFE for Drinking',

        'multipleParameters': 'Multiple parameters exceed BIS limits.',

        'aiTreatmentSuggestions': 'AI Treatment Suggestions',

        'highTdsDetected': 'High TDS Detected (> 500 ppm)',

        'highTdsDescription':
            'Use Reverse Osmosis (RO) filter to remove excess dissolved minerals.',

        'highTurbidityDetected': 'High Turbidity Detected (> 5 NTU)',

        'highTurbidityDescription':
            'Use Sedimentation, Sand Filtration, or Alum to clear physical impurities.',

        'phImbalanceDetected': 'pH Imbalance Detected',

        'phImbalanceDescription':
            'Use pH correction drops (alkaline or acidic neutralizers).',
      },

      // ============================================================
      // KANNADA
      // ============================================================
      'ಕನ್ನಡ': {
        'alertsTreatments': 'ಎಚ್ಚರಿಕೆಗಳು ಮತ್ತು ಚಿಕಿತ್ಸೆಗಳು',

        'activeWarnings': 'ಸಕ್ರಿಯ ಎಚ್ಚರಿಕೆಗಳು',

        'waterNotSafe': 'ನೀರು ಕುಡಿಯಲು ಸುರಕ್ಷಿತವಲ್ಲ',

        'multipleParameters': 'ಹಲವು ನಿಯತಾಂಕಗಳು BIS ಮಿತಿಗಳನ್ನು ಮೀರಿವೆ.',

        'aiTreatmentSuggestions': 'AI ಚಿಕಿತ್ಸೆಯ ಸಲಹೆಗಳು',

        'highTdsDetected': 'ಹೆಚ್ಚಿನ TDS ಪತ್ತೆಯಾಗಿದೆ (> 500 ppm)',

        'highTdsDescription':
            'ಹೆಚ್ಚುವರಿ ಕರಗಿದ ಖನಿಜಗಳನ್ನು ತೆಗೆದುಹಾಕಲು ರಿವರ್ಸ್ ಆಸ್ಮೋಸಿಸ್ (RO) ಫಿಲ್ಟರ್ ಬಳಸಿ.',

        'highTurbidityDetected': 'ಹೆಚ್ಚಿನ ಮಸುಕು ಪತ್ತೆಯಾಗಿದೆ (> 5 NTU)',

        'highTurbidityDescription':
            'ಭೌತಿಕ ಕಲ್ಮಶಗಳನ್ನು ತೆಗೆದುಹಾಕಲು ಸೆಡಿಮೆಂಟೇಶನ್, ಸ್ಯಾಂಡ್ ಫಿಲ್ಟರೇಶನ್ ಅಥವಾ ಅಲಮ್ ಬಳಸಿ.',

        'phImbalanceDetected': 'pH ಅಸಮತೋಲನ ಪತ್ತೆಯಾಗಿದೆ',

        'phImbalanceDescription':
            'pH ಸರಿಪಡಿಸಲು ಕ್ಷಾರೀಯ ಅಥವಾ ಆಮ್ಲೀಯ ನ್ಯೂಟ್ರಲೈಸರ್ ಹನಿಗಳನ್ನು ಬಳಸಿ.',
      },

      // ============================================================
      // HINDI
      // ============================================================
      'हिन्दी': {
        'alertsTreatments': 'अलर्ट और उपचार',

        'activeWarnings': 'सक्रिय चेतावनियाँ',

        'waterNotSafe': 'पानी पीने के लिए सुरक्षित नहीं है',

        'multipleParameters': 'कई पैरामीटर BIS की सीमाओं से अधिक हैं।',

        'aiTreatmentSuggestions': 'AI उपचार सुझाव',

        'highTdsDetected': 'उच्च TDS पाया गया (> 500 ppm)',

        'highTdsDescription':
            'अतिरिक्त घुले हुए खनिजों को हटाने के लिए रिवर्स ऑस्मोसिस (RO) फिल्टर का उपयोग करें।',

        'highTurbidityDetected': 'उच्च गंदलापन पाया गया (> 5 NTU)',

        'highTurbidityDescription':
            'भौतिक अशुद्धियों को हटाने के लिए सेडिमेंटेशन, सैंड फिल्ट्रेशन या फिटकरी का उपयोग करें।',

        'phImbalanceDetected': 'pH असंतुलन पाया गया',

        'phImbalanceDescription':
            'pH को सही करने के लिए क्षारीय या अम्लीय न्यूट्रलाइज़र ड्रॉप्स का उपयोग करें।',
      },
    };

    return translations[language.language]?[key] ?? key;
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final language = language_provider.Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _text(language, 'alertsTreatments'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ======================================================
            // ACTIVE WARNINGS
            // ======================================================
            Text(
              _text(language, 'activeWarnings'),

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: JalRakshakTheme.textDark,
              ),
            ),

            const SizedBox(height: 15),

            _buildWarningCard(
              title: _text(language, 'waterNotSafe'),

              subtitle: _text(language, 'multipleParameters'),

              icon: Icons.warning_amber_rounded,

              color: JalRakshakTheme.dangerRed,
            ),

            const SizedBox(height: 30),

            // ======================================================
            // AI TREATMENT SUGGESTIONS
            // ======================================================
            Text(
              _text(language, 'aiTreatmentSuggestions'),

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: JalRakshakTheme.textDark,
              ),
            ),

            const SizedBox(height: 15),

            // ======================================================
            // HIGH TDS
            // ======================================================
            _buildTreatmentCard(
              title: _text(language, 'highTdsDetected'),

              description: _text(language, 'highTdsDescription'),

              icon: Icons.filter_alt_outlined,
            ),

            const SizedBox(height: 15),

            // ======================================================
            // HIGH TURBIDITY
            // ======================================================
            _buildTreatmentCard(
              title: _text(language, 'highTurbidityDetected'),

              description: _text(language, 'highTurbidityDescription'),

              icon: Icons.water_drop_outlined,
            ),

            const SizedBox(height: 15),

            // ======================================================
            // pH IMBALANCE
            // ======================================================
            _buildTreatmentCard(
              title: _text(language, 'phImbalanceDetected'),

              description: _text(language, 'phImbalanceDescription'),

              icon: Icons.science_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // TOP WARNING BANNER
  // ================================================================

  Widget _buildWarningCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: color.withOpacity(0.5)),
      ),

      child: Row(
        children: [
          Icon(icon, color: color, size: 30),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,

                  style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // AI PRESCRIPTION / TREATMENT CARDS
  // ================================================================

  Widget _buildTreatmentCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: JalRakshakTheme.primaryBlue.withOpacity(0.1),

              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: JalRakshakTheme.primaryBlue),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,

                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
