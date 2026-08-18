import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = 'English';

  String get language => _language;

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  String text(String key) {
    final Map<String, Map<String, String>> translations = {
      // ==========================================================
      // ENGLISH
      // ==========================================================
      'English': {
        // --------------------------------------------------------
        // LANGUAGE SCREEN
        // --------------------------------------------------------
        'chooseLanguage': 'Choose Your Language',
        'selectLanguage': 'Select your preferred language',
        'continue': 'Continue',

        // --------------------------------------------------------
        // LOGIN SCREEN
        // --------------------------------------------------------
        'welcome': 'Welcome to JalRakshak',
        'loginSubtitle': 'Login to monitor your water quality',
        'email': 'Email',
        'enterEmail': 'Enter your email',
        'password': 'Password',
        'enterPassword': 'Enter your password',
        'forgotPassword': 'Forgot Password?',
        'login': 'Login',
        'noAccount': "Don't have an account?",
        'register': 'Register',

        // --------------------------------------------------------
        // MAIN SCREEN / BOTTOM NAVIGATION
        // --------------------------------------------------------
        'dashboard': 'Dashboard',
        'home': 'Home',
        'live': 'Live',
        'history': 'History',
        'alerts': 'Alerts',
        'profile': 'Profile',

        // --------------------------------------------------------
        // DASHBOARD - GENERAL
        // --------------------------------------------------------
        'liveWaterStatus': 'Live Water Status',
        'unableSensorData': 'Unable to receive sensor data',
        'sensorUpdates': 'Sensor data updates every 3 seconds',
        'esp32Connected': 'ESP32 Sensor Connected',
        'liveStatus': 'LIVE',

        // --------------------------------------------------------
        // WATER QUALITY SCORE
        // --------------------------------------------------------
        'waterQualityScore': 'WATER QUALITY SCORE',
        'good': 'GOOD',
        'unsafe': 'UNSAFE',
        'check': 'CHECK',

        // --------------------------------------------------------
        // WATER PARAMETERS
        // --------------------------------------------------------
        'waterParameters': 'Water Parameters',
        'phLevel': 'pH Level',
        'tds': 'TDS',
        'turbidity': 'Turbidity',
        'monitoring': 'Monitoring',

        // --------------------------------------------------------
        // WATER USAGE CLASSIFICATION
        // --------------------------------------------------------
        'waterUsage': 'Water Usage Classification',
        'drinking': 'Drinking',
        'cooking': 'Cooking',
        'bathing': 'Bathing',
        'washingClothes': 'Washing Clothes',
        'cleaning': 'Cleaning',
        'irrigation': 'Irrigation',
        'industrialUse': 'Industrial Use',

        'safe': 'Safe',
        'notSafe': 'Not Safe',
        'moderate': 'Moderate',

        // --------------------------------------------------------
        // HEALTH RISKS
        // --------------------------------------------------------
        'healthRisks': 'Health Risks',
        'healthConcernsDetected': 'Health concerns detected',
        'waterLooksSafe': 'Water looks safe',

        'waterNotSafe': 'Water is NOT SAFE',
        'noMajorHealthRisk': 'No Major Health Risk',

        'avoidDrinking': 'Avoid direct drinking until treated.',
        'safeRange': 'Current readings are within the safe range.',

        'healthRiskDetected':
            'Some water parameters are outside the recommended range. Please check the risks below.',

        'noHealthConcern':
            'Your current water readings do not indicate a major health concern.',

        // --------------------------------------------------------
        // POSSIBLE HEALTH ISSUES
        // --------------------------------------------------------
        'possibleHealthIssues': 'Possible Health Issues',

        'highTds': 'High TDS',
        'highTdsDescription':
            'High dissolved solids may indicate excess minerals or dissolved substances.',

        'highTurbidity': 'High Turbidity',
        'highTurbidityDescription':
            'Suspended particles may indicate contamination and reduce water clarity.',

        'imbalancedPh': 'Imbalanced pH',
        'imbalancedPhDescription':
            'Water outside the recommended pH range may cause irritation or other concerns.',

        'poorOverallQuality': 'Poor Overall Quality',
        'poorOverallQualityDescription':
            'The overall water quality score is currently low and requires attention.',

        'noMajorHealthRiskDetected':
            'No major health risk detected from current readings.',

        // --------------------------------------------------------
        // RECOMMENDATION
        // --------------------------------------------------------
        'recommendation': 'Recommendation',
        'avoidDrinkingTreatment':
            'Avoid drinking this water until suitable treatment or purification is completed.',

        // --------------------------------------------------------
        // TREATMENT / PRECAUTIONS
        // --------------------------------------------------------
        'treatmentSuggestions': 'Treatment Suggestions',
        'precautions': 'Precautions',

        // --------------------------------------------------------
        // WATER QUALITY STATUS
        // --------------------------------------------------------
        'waterQuality': 'Water Quality',
        'safeForDrinking': 'Safe for Drinking',
        'notSafeForDrinking': 'Not Safe for Drinking',

        // --------------------------------------------------------
        // LIVE SCREEN
        // --------------------------------------------------------
        'liveMonitoring': 'Live Monitoring',
        'realTimeSensorReadings': 'Real-time sensor readings',
        'connected': 'Connected',
        'updatingEvery3Seconds': 'Updating every 3 seconds',
        'normal': 'Normal',
        'excellent': 'Excellent',
      },

      // ==========================================================
      // KANNADA
      // ==========================================================
      'ಕನ್ನಡ': {
        // --------------------------------------------------------
        // LANGUAGE SCREEN
        // --------------------------------------------------------
        'chooseLanguage': 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
        'selectLanguage': 'ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
        'continue': 'ಮುಂದುವರಿಸಿ',

        // --------------------------------------------------------
        // LOGIN SCREEN
        // --------------------------------------------------------
        'welcome': 'JalRakshak ಗೆ ಸ್ವಾಗತ',
        'loginSubtitle':
            'ನಿಮ್ಮ ನೀರಿನ ಗುಣಮಟ್ಟವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಲು ಲಾಗಿನ್ ಮಾಡಿ',
        'email': 'ಇಮೇಲ್',
        'enterEmail': 'ನಿಮ್ಮ ಇಮೇಲ್ ನಮೂದಿಸಿ',
        'password': 'ಪಾಸ್‌ವರ್ಡ್',
        'enterPassword': 'ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ',
        'forgotPassword': 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿರುವಿರಾ?',
        'login': 'ಲಾಗಿನ್',
        'noAccount': 'ಖಾತೆ ಇಲ್ಲವೇ?',
        'register': 'ನೋಂದಣಿ',

        // --------------------------------------------------------
        // MAIN SCREEN / BOTTOM NAVIGATION
        // --------------------------------------------------------
        'dashboard': 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್',
        'home': 'ಮುಖಪುಟ',
        'live': 'ಲೈವ್',
        'history': 'ಇತಿಹಾಸ',
        'alerts': 'ಎಚ್ಚರಿಕೆಗಳು',
        'profile': 'ಪ್ರೊಫೈಲ್',

        // --------------------------------------------------------
        // DASHBOARD - GENERAL
        // --------------------------------------------------------
        'liveWaterStatus': 'ನೀರಿನ ಲೈವ್ ಸ್ಥಿತಿ',
        'unableSensorData': 'ಸೆನ್ಸರ್ ಡೇಟಾವನ್ನು ಪಡೆಯಲು ಸಾಧ್ಯವಾಗುತ್ತಿಲ್ಲ',
        'sensorUpdates': 'ಸೆನ್ಸರ್ ಡೇಟಾ ಪ್ರತಿ 3 ಸೆಕೆಂಡಿಗೆ ನವೀಕರಿಸಲಾಗುತ್ತದೆ',
        'esp32Connected': 'ESP32 ಸೆನ್ಸರ್ ಸಂಪರ್ಕಗೊಂಡಿದೆ',
        'liveStatus': 'ಲೈವ್',

        // --------------------------------------------------------
        // WATER QUALITY SCORE
        // --------------------------------------------------------
        'waterQualityScore': 'ನೀರಿನ ಗುಣಮಟ್ಟದ ಸ್ಕೋರ್',
        'good': 'ಉತ್ತಮ',
        'unsafe': 'ಸುರಕ್ಷಿತವಲ್ಲ',
        'check': 'ಪರಿಶೀಲಿಸಿ',

        // --------------------------------------------------------
        // WATER PARAMETERS
        // --------------------------------------------------------
        'waterParameters': 'ನೀರಿನ ನಿಯತಾಂಕಗಳು',
        'phLevel': 'pH ಮಟ್ಟ',
        'tds': 'TDS',
        'turbidity': 'ಮಂದತೆ',
        'monitoring': 'ಮೇಲ್ವಿಚಾರಣೆ',

        // --------------------------------------------------------
        // WATER USAGE CLASSIFICATION
        // --------------------------------------------------------
        'waterUsage': 'ನೀರಿನ ಬಳಕೆಯ ವರ್ಗೀಕರಣ',
        'drinking': 'ಕುಡಿಯಲು',
        'cooking': 'ಅಡುಗೆಗೆ',
        'bathing': 'ಸ್ನಾನಕ್ಕೆ',
        'washingClothes': 'ಬಟ್ಟೆ ತೊಳೆಯಲು',
        'cleaning': 'ಸ್ವಚ್ಛಗೊಳಿಸಲು',
        'irrigation': 'ನೀರಾವರಿ',
        'industrialUse': 'ಕೈಗಾರಿಕಾ ಬಳಕೆ',

        'safe': 'ಸುರಕ್ಷಿತ',
        'notSafe': 'ಸುರಕ್ಷಿತವಲ್ಲ',
        'moderate': 'ಮಧ್ಯಮ',

        // --------------------------------------------------------
        // HEALTH RISKS
        // --------------------------------------------------------
        'healthRisks': 'ಆರೋಗ್ಯದ ಅಪಾಯಗಳು',
        'healthConcernsDetected': 'ಆರೋಗ್ಯದ ಸಮಸ್ಯೆಗಳು ಕಂಡುಬಂದಿವೆ',
        'waterLooksSafe': 'ನೀರು ಸುರಕ್ಷಿತವಾಗಿ ಕಾಣುತ್ತದೆ',

        'waterNotSafe': 'ನೀರು ಸುರಕ್ಷಿತವಲ್ಲ',
        'noMajorHealthRisk': 'ಯಾವುದೇ ಪ್ರಮುಖ ಆರೋಗ್ಯದ ಅಪಾಯವಿಲ್ಲ',

        'avoidDrinking':
            'ಶುದ್ಧೀಕರಿಸುವವರೆಗೆ ಈ ನೀರನ್ನು ನೇರವಾಗಿ ಕುಡಿಯುವುದನ್ನು ತಪ್ಪಿಸಿ.',
        'safeRange': 'ಪ್ರಸ್ತುತ ಮೌಲ್ಯಗಳು ಸುರಕ್ಷಿತ ವ್ಯಾಪ್ತಿಯಲ್ಲಿವೆ.',

        'healthRiskDetected':
            'ಕೆಲವು ನೀರಿನ ನಿಯತಾಂಕಗಳು ಶಿಫಾರಸು ಮಾಡಿದ ವ್ಯಾಪ್ತಿಯಿಂದ ಹೊರಗಿವೆ. ಕೆಳಗಿನ ಅಪಾಯಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.',

        'noHealthConcern':
            'ಪ್ರಸ್ತುತ ನೀರಿನ ಮೌಲ್ಯಗಳು ಯಾವುದೇ ಪ್ರಮುಖ ಆರೋಗ್ಯದ ಅಪಾಯವನ್ನು ಸೂಚಿಸುವುದಿಲ್ಲ.',

        // --------------------------------------------------------
        // POSSIBLE HEALTH ISSUES
        // --------------------------------------------------------
        'possibleHealthIssues': 'ಸಂಭವನೀಯ ಆರೋಗ್ಯ ಸಮಸ್ಯೆಗಳು',

        'highTds': 'ಹೆಚ್ಚಿನ TDS',
        'highTdsDescription':
            'ಹೆಚ್ಚಿನ ಕರಗಿದ ಘನವಸ್ತುಗಳು ಹೆಚ್ಚುವರಿ ಖನಿಜಗಳು ಅಥವಾ ಕರಗಿದ ಪದಾರ್ಥಗಳಿರುವುದನ್ನು ಸೂಚಿಸಬಹುದು.',

        'highTurbidity': 'ಹೆಚ್ಚಿನ ಮಂದತೆ',
        'highTurbidityDescription':
            'ನೀರಿನಲ್ಲಿರುವ ಕಣಗಳು ಮಾಲಿನ್ಯವನ್ನು ಸೂಚಿಸಬಹುದು ಮತ್ತು ನೀರಿನ ಪಾರದರ್ಶಕತೆಯನ್ನು ಕಡಿಮೆ ಮಾಡಬಹುದು.',

        'imbalancedPh': 'ಅಸಮತೋಲನ pH',
        'imbalancedPhDescription':
            'ಶಿಫಾರಸು ಮಾಡಿದ pH ವ್ಯಾಪ್ತಿಯ ಹೊರಗಿನ ನೀರು ಚರ್ಮ ಅಥವಾ ದೇಹಕ್ಕೆ ತೊಂದರೆ ಉಂಟುಮಾಡಬಹುದು.',

        'poorOverallQuality': 'ಕಡಿಮೆ ಒಟ್ಟಾರೆ ಗುಣಮಟ್ಟ',
        'poorOverallQualityDescription':
            'ಪ್ರಸ್ತುತ ನೀರಿನ ಒಟ್ಟಾರೆ ಗುಣಮಟ್ಟದ ಸ್ಕೋರ್ ಕಡಿಮೆಯಾಗಿದೆ ಮತ್ತು ಗಮನ ಅಗತ್ಯವಿದೆ.',

        'noMajorHealthRiskDetected':
            'ಪ್ರಸ್ತುತ ಮೌಲ್ಯಗಳಿಂದ ಯಾವುದೇ ಪ್ರಮುಖ ಆರೋಗ್ಯದ ಅಪಾಯ ಕಂಡುಬಂದಿಲ್ಲ.',

        // --------------------------------------------------------
        // RECOMMENDATION
        // --------------------------------------------------------
        'recommendation': 'ಶಿಫಾರಸು',
        'avoidDrinkingTreatment':
            'ಸೂಕ್ತವಾದ ಶುದ್ಧೀಕರಣ ಪೂರ್ಣಗೊಳ್ಳುವವರೆಗೆ ಈ ನೀರನ್ನು ಕುಡಿಯುವುದನ್ನು ತಪ್ಪಿಸಿ.',

        // --------------------------------------------------------
        // TREATMENT / PRECAUTIONS
        // --------------------------------------------------------
        'treatmentSuggestions': 'ಚಿಕಿತ್ಸೆಯ ಸಲಹೆಗಳು',
        'precautions': 'ಮುನ್ನೆಚ್ಚರಿಕೆಗಳು',

        // --------------------------------------------------------
        // WATER QUALITY
        // --------------------------------------------------------
        'waterQuality': 'ನೀರಿನ ಗುಣಮಟ್ಟ',
        'safeForDrinking': 'ಕುಡಿಯಲು ಸುರಕ್ಷಿತ',
        'notSafeForDrinking': 'ಕುಡಿಯಲು ಸುರಕ್ಷಿತವಲ್ಲ',

        // --------------------------------------------------------
        // LIVE SCREEN
        // --------------------------------------------------------
        'liveMonitoring': 'ನೇರ ಮೇಲ್ವಿಚಾರಣೆ',
        'realTimeSensorReadings': 'ನೈಜ-ಸಮಯ ಸೆನ್ಸರ್ ವಾಚನಗಳು',
        'connected': 'ಸಂಪರ್ಕಿಸಲಾಗಿದೆ',
        'updatingEvery3Seconds': 'ಪ್ರತಿ 3 ಸೆಕೆಂಡಿಗೆ ನವೀಕರಿಸಲಾಗುತ್ತಿದೆ',
        'normal': 'ಸಾಮಾನ್ಯ',
        'excellent': 'ಅತ್ಯುತ್ತಮ',
      },

      // ==========================================================
      // HINDI
      // ==========================================================
      'हिन्दी': {
        // --------------------------------------------------------
        // LANGUAGE SCREEN
        // --------------------------------------------------------
        'chooseLanguage': 'अपनी भाषा चुनें',
        'selectLanguage': 'अपनी पसंदीदा भाषा चुनें',
        'continue': 'जारी रखें',

        // --------------------------------------------------------
        // LOGIN SCREEN
        // --------------------------------------------------------
        'welcome': 'JalRakshak में आपका स्वागत है',
        'loginSubtitle':
            'अपने पानी की गुणवत्ता की निगरानी करने के लिए लॉगिन करें',
        'email': 'ईमेल',
        'enterEmail': 'अपना ईमेल दर्ज करें',
        'password': 'पासवर्ड',
        'enterPassword': 'अपना पासवर्ड दर्ज करें',
        'forgotPassword': 'पासवर्ड भूल गए?',
        'login': 'लॉगिन',
        'noAccount': 'खाता नहीं है?',
        'register': 'रजिस्टर करें',

        // --------------------------------------------------------
        // MAIN SCREEN / BOTTOM NAVIGATION
        // --------------------------------------------------------
        'dashboard': 'डैशबोर्ड',
        'home': 'होम',
        'live': 'लाइव',
        'history': 'इतिहास',
        'alerts': 'अलर्ट',
        'profile': 'प्रोफ़ाइल',

        // --------------------------------------------------------
        // DASHBOARD - GENERAL
        // --------------------------------------------------------
        'liveWaterStatus': 'पानी की लाइव स्थिति',
        'unableSensorData': 'सेंसर डेटा प्राप्त नहीं हो सका',
        'sensorUpdates': 'सेंसर डेटा हर 3 सेकंड में अपडेट होता है',
        'esp32Connected': 'ESP32 सेंसर कनेक्ट है',
        'liveStatus': 'लाइव',

        // --------------------------------------------------------
        // WATER QUALITY SCORE
        // --------------------------------------------------------
        'waterQualityScore': 'पानी की गुणवत्ता का स्कोर',
        'good': 'अच्छा',
        'unsafe': 'असुरक्षित',
        'check': 'जाँच करें',

        // --------------------------------------------------------
        // WATER PARAMETERS
        // --------------------------------------------------------
        'waterParameters': 'पानी के पैरामीटर',
        'phLevel': 'pH स्तर',
        'tds': 'TDS',
        'turbidity': 'मटमैलेपन',
        'monitoring': 'निगरानी',

        // --------------------------------------------------------
        // WATER USAGE CLASSIFICATION
        // --------------------------------------------------------
        'waterUsage': 'पानी के उपयोग का वर्गीकरण',
        'drinking': 'पीने के लिए',
        'cooking': 'खाना पकाने के लिए',
        'bathing': 'नहाने के लिए',
        'washingClothes': 'कपड़े धोने के लिए',
        'cleaning': 'सफाई के लिए',
        'irrigation': 'सिंचाई के लिए',
        'industrialUse': 'औद्योगिक उपयोग',

        'safe': 'सुरक्षित',
        'notSafe': 'सुरक्षित नहीं',
        'moderate': 'मध्यम',

        // --------------------------------------------------------
        // HEALTH RISKS
        // --------------------------------------------------------
        'healthRisks': 'स्वास्थ्य जोखिम',
        'healthConcernsDetected': 'स्वास्थ्य संबंधी चिंताएँ पाई गईं',
        'waterLooksSafe': 'पानी सुरक्षित दिखाई देता है',

        'waterNotSafe': 'पानी सुरक्षित नहीं है',
        'noMajorHealthRisk': 'कोई बड़ा स्वास्थ्य जोखिम नहीं',

        'avoidDrinking': 'उपचार होने तक इस पानी को सीधे पीने से बचें।',
        'safeRange': 'वर्तमान रीडिंग सुरक्षित सीमा में हैं।',

        'healthRiskDetected':
            'कुछ पानी के पैरामीटर अनुशंसित सीमा से बाहर हैं। नीचे दिए गए जोखिमों की जाँच करें।',

        'noHealthConcern':
            'वर्तमान पानी की रीडिंग किसी बड़े स्वास्थ्य जोखिम का संकेत नहीं देती हैं।',

        // --------------------------------------------------------
        // POSSIBLE HEALTH ISSUES
        // --------------------------------------------------------
        'possibleHealthIssues': 'संभावित स्वास्थ्य समस्याएँ',

        'highTds': 'उच्च TDS',
        'highTdsDescription':
            'अधिक घुले हुए ठोस पदार्थ अतिरिक्त खनिजों या घुले हुए पदार्थों की उपस्थिति का संकेत दे सकते हैं।',

        'highTurbidity': 'अधिक मटमैलेपन',
        'highTurbidityDescription':
            'पानी में मौजूद कण प्रदूषण का संकेत दे सकते हैं और पानी की स्पष्टता कम कर सकते हैं।',

        'imbalancedPh': 'असंतुलित pH',
        'imbalancedPhDescription':
            'अनुशंसित pH सीमा से बाहर का पानी जलन या अन्य समस्याएँ पैदा कर सकता है।',

        'poorOverallQuality': 'खराब समग्र गुणवत्ता',
        'poorOverallQualityDescription':
            'वर्तमान पानी की समग्र गुणवत्ता का स्कोर कम है और ध्यान देने की आवश्यकता है।',

        'noMajorHealthRiskDetected':
            'वर्तमान रीडिंग से कोई बड़ा स्वास्थ्य जोखिम नहीं पाया गया।',

        // --------------------------------------------------------
        // RECOMMENDATION
        // --------------------------------------------------------
        'recommendation': 'सुझाव',
        'avoidDrinkingTreatment':
            'उचित उपचार या शुद्धिकरण पूरा होने तक इस पानी को पीने से बचें।',

        // --------------------------------------------------------
        // TREATMENT / PRECAUTIONS
        // --------------------------------------------------------
        'treatmentSuggestions': 'उपचार सुझाव',
        'precautions': 'सावधानियाँ',

        // --------------------------------------------------------
        // WATER QUALITY
        // --------------------------------------------------------
        'waterQuality': 'पानी की गुणवत्ता',
        'safeForDrinking': 'पीने के लिए सुरक्षित',
        'notSafeForDrinking': 'पीने के लिए सुरक्षित नहीं',

        // --------------------------------------------------------
        // LIVE SCREEN
        // --------------------------------------------------------
        'liveMonitoring': 'लाइव मॉनिटरिंग',
        'realTimeSensorReadings': 'रीयल-टाइम सेंसर रीडिंग',
        'connected': 'कनेक्टेड',
        'updatingEvery3Seconds': 'हर 3 सेकंड में अपडेट हो रहा है',
        'normal': 'सामान्य',
        'excellent': 'उत्कृष्ट',
      },
    };

    return translations[_language]?[key] ?? key;
  }
}
