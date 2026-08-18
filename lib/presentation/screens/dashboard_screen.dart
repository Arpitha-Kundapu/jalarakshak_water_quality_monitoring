import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as language_provider;

import '../../core/theme.dart';
import '../../domain/entities/sensor_data.dart';
import '../providers/sensor_provider.dart';
import '../providers/language_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _usageExpanded = false;
  bool _healthExpanded = false;
  bool _treatmentExpanded = true;
  bool _precautionsExpanded = false;

  LanguageProvider get _language =>
      language_provider.Provider.of<LanguageProvider>(context);

  // ================================================================
  // TREATMENT & PRECAUTION TEXT
  // These texts are kept inside the dashboard so no changes are
  // required in language_provider.dart.
  // ================================================================
  String _dashboardText(String english) {
    switch (_language.language) {
      case 'ಕನ್ನಡ':
        const kannada = {
          'Follow these precautions to stay safe':
              'ಸುರಕ್ಷಿತವಾಗಿರಲು ಈ ಮುನ್ನೆಚ್ಚರಿಕೆಗಳನ್ನು ಅನುಸರಿಸಿ',
          'Do not drink untreated water.': 'ಶುದ್ಧೀಕರಿಸದ ನೀರನ್ನು ಕುಡಿಯಬೇಡಿ.',
          'Always store water in clean containers.':
              'ನೀರನ್ನು ಯಾವಾಗಲೂ ಸ್ವಚ್ಛವಾದ ಪಾತ್ರೆಗಳಲ್ಲಿ ಸಂಗ್ರಹಿಸಿ.',
          'Clean your storage tanks regularly.':
              'ನೀರಿನ ಸಂಗ್ರಹ ಟ್ಯಾಂಕ್‌ಗಳನ್ನು ನಿಯಮಿತವಾಗಿ ಸ್ವಚ್ಛಗೊಳಿಸಿ.',
          'Boil water if unsure about quality.':
              'ನೀರಿನ ಗುಣಮಟ್ಟದ ಬಗ್ಗೆ ಅನುಮಾನವಿದ್ದರೆ ನೀರನ್ನು ಕುದಿಸಿ.',
          'Use proper filters and replace them on time.':
              'ಸರಿಯಾದ ಫಿಲ್ಟರ್‌ಗಳನ್ನು ಬಳಸಿ ಮತ್ತು ಅವುಗಳನ್ನು ಸಮಯಕ್ಕೆ ಬದಲಾಯಿಸಿ.',
          'Simple steps based on the current water condition':
              'ಪ್ರಸ್ತುತ ನೀರಿನ ಸ್ಥಿತಿಗೆ ಅನುಗುಣವಾದ ಸರಳ ಕ್ರಮಗಳು',
          'Use properly filtered water for drinking.':
              'ಕುಡಿಯಲು ಸರಿಯಾಗಿ ಫಿಲ್ಟರ್ ಮಾಡಿದ ನೀರನ್ನು ಬಳಸಿ.',
          'High TDS means the water contains a high amount of dissolved substances. Avoid drinking it directly and use properly filtered drinking water.':
              'ಹೆಚ್ಚಿನ TDS ಎಂದರೆ ನೀರಿನಲ್ಲಿ ಹೆಚ್ಚಿನ ಪ್ರಮಾಣದ ಕರಗಿದ ಪದಾರ್ಥಗಳಿವೆ. ಈ ನೀರನ್ನು ನೇರವಾಗಿ ಕುಡಿಯಬೇಡಿ ಮತ್ತು ಸರಿಯಾಗಿ ಫಿಲ್ಟರ್ ಮಾಡಿದ ಕುಡಿಯುವ ನೀರನ್ನು ಬಳಸಿ.',
          'Let it settle, filter it and boil before drinking.':
              'ಕಣಗಳು ಕೆಳಗೆ ಕುಳಿತುಕೊಳ್ಳಲು ಬಿಡಿ, ಫಿಲ್ಟರ್ ಮಾಡಿ ಮತ್ತು ಕುಡಿಯುವ ಮೊದಲು ಕುದಿಸಿ.',
          'If the water looks cloudy, keep it undisturbed so particles can settle. Filter the water and boil it before drinking.':
              'ನೀರು ಮಸುಕಾಗಿ ಕಾಣಿಸಿದರೆ ಅದನ್ನು ಅಲುಗಾಡಿಸದೆ ಇಡಿ, ಕಣಗಳು ಕೆಳಗೆ ಕುಳಿತುಕೊಳ್ಳಲು ಬಿಡಿ. ನಂತರ ನೀರನ್ನು ಫಿಲ್ಟರ್ ಮಾಡಿ ಮತ್ತು ಕುಡಿಯುವ ಮೊದಲು ಕುದಿಸಿ.',
          'Unbalanced pH': 'ಅಸಮತೋಲಿತ pH',
          'Avoid drinking this water directly.': 'ಈ ನೀರನ್ನು ನೇರವಾಗಿ ಕುಡಿಯಬೇಡಿ.',
          'The measured pH is outside the preferred range. Do not drink this water directly. Use another safe drinking-water source until the water condition is checked and corrected.':
              'ಅಳತೆ ಮಾಡಿದ pH ಶಿಫಾರಸು ಮಾಡಿದ ವ್ಯಾಪ್ತಿಯ ಹೊರಗಿದೆ. ಈ ನೀರನ್ನು ನೇರವಾಗಿ ಕುಡಿಯಬೇಡಿ. ನೀರಿನ ಸ್ಥಿತಿಯನ್ನು ಪರಿಶೀಲಿಸಿ ಸರಿಪಡಿಸುವವರೆಗೆ ಸುರಕ್ಷಿತ ಕುಡಿಯುವ ನೀರಿನ ಮೂಲವನ್ನು ಬಳಸಿ.',
          'Unsafe Water': 'ಸುರಕ್ಷಿತವಲ್ಲದ ನೀರು',
          'Do not drink this water directly.': 'ಈ ನೀರನ್ನು ನೇರವಾಗಿ ಕುಡಿಯಬೇಡಿ.',
          'The current readings indicate that the water may not be suitable for drinking. Avoid direct consumption and use a safe drinking-water source.':
              'ಪ್ರಸ್ತುತ ಮೌಲ್ಯಗಳು ಈ ನೀರು ಕುಡಿಯಲು ಸೂಕ್ತವಲ್ಲದಿರಬಹುದು ಎಂದು ಸೂಚಿಸುತ್ತವೆ. ನೇರವಾಗಿ ಕುಡಿಯುವುದನ್ನು ತಪ್ಪಿಸಿ ಮತ್ತು ಸುರಕ್ಷಿತ ಕುಡಿಯುವ ನೀರನ್ನು ಬಳಸಿ.',
          'Water is currently within the monitored safe range.':
              'ನೀರು ಪ್ರಸ್ತುತ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡುತ್ತಿರುವ ಸುರಕ್ಷಿತ ವ್ಯಾಪ್ತಿಯಲ್ಲಿದೆ.',
          'These are basic safety suggestions. The app does not directly treat the water.':
              'ಇವು ಮೂಲಭೂತ ಸುರಕ್ಷತಾ ಸಲಹೆಗಳು. ಆಪ್ ನೀರನ್ನು ನೇರವಾಗಿ ಶುದ್ಧೀಕರಿಸುವುದಿಲ್ಲ.',
        };
        return kannada[english] ?? english;

      case 'हिन्दी':
        const hindi = {
          'Follow these precautions to stay safe':
              'सुरक्षित रहने के लिए इन सावधानियों का पालन करें',
          'Do not drink untreated water.': 'बिना उपचार किया हुआ पानी न पिएँ।',
          'Always store water in clean containers.':
              'पानी को हमेशा साफ बर्तनों में रखें।',
          'Clean your storage tanks regularly.':
              'पानी की टंकियों को नियमित रूप से साफ करें।',
          'Boil water if unsure about quality.':
              'पानी की गुणवत्ता पर संदेह हो तो पानी उबालें।',
          'Use proper filters and replace them on time.':
              'उचित फिल्टर का उपयोग करें और उन्हें समय पर बदलें।',
          'Simple steps based on the current water condition':
              'वर्तमान पानी की स्थिति के अनुसार सरल उपाय',
          'Use properly filtered water for drinking.':
              'पीने के लिए अच्छी तरह फिल्टर किया हुआ पानी उपयोग करें।',
          'High TDS means the water contains a high amount of dissolved substances. Avoid drinking it directly and use properly filtered drinking water.':
              'उच्च TDS का मतलब है कि पानी में घुले हुए पदार्थ अधिक मात्रा में हैं। इसे सीधे न पिएँ और अच्छी तरह फिल्टर किया हुआ पीने का पानी उपयोग करें।',
          'Let it settle, filter it and boil before drinking.':
              'पानी को कुछ समय स्थिर रखें, फिल्टर करें और पीने से पहले उबालें।',
          'If the water looks cloudy, keep it undisturbed so particles can settle. Filter the water and boil it before drinking.':
              'यदि पानी मटमैला दिखाई देता है, तो उसे बिना हिलाए रखें ताकि कण नीचे बैठ जाएँ। फिर पानी को फिल्टर करें और पीने से पहले उबालें।',
          'Unbalanced pH': 'असंतुलित pH',
          'Avoid drinking this water directly.': 'इस पानी को सीधे न पिएँ।',
          'The measured pH is outside the preferred range. Do not drink this water directly. Use another safe drinking-water source until the water condition is checked and corrected.':
              'मापा गया pH पसंदीदा सीमा से बाहर है। इस पानी को सीधे न पिएँ। पानी की स्थिति की जाँच और सुधार होने तक सुरक्षित पीने के पानी का उपयोग करें।',
          'Unsafe Water': 'असुरक्षित पानी',
          'Do not drink this water directly.': 'इस पानी को सीधे न पिएँ।',
          'The current readings indicate that the water may not be suitable for drinking. Avoid direct consumption and use a safe drinking-water source.':
              'वर्तमान रीडिंग बताती हैं कि पानी पीने के लिए उपयुक्त नहीं हो सकता है। इसे सीधे पीने से बचें और सुरक्षित पीने के पानी का उपयोग करें।',
          'Water is currently within the monitored safe range.':
              'पानी वर्तमान में निगरानी की गई सुरक्षित सीमा में है।',
          'These are basic safety suggestions. The app does not directly treat the water.':
              'ये बुनियादी सुरक्षा सुझाव हैं। ऐप पानी को सीधे उपचारित नहीं करता है।',
        };
        return hindi[english] ?? english;

      default:
        return english;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sensorStream = ref.watch(liveSensorProvider);

    return Scaffold(
      backgroundColor: JalRakshakTheme.backgroundLight,

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,

        title: Center(
          child: Text(
            _language.text('liveWaterStatus'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: JalRakshakTheme.textDark,
            ),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: JalRakshakTheme.textDark,
                ),
              ),
            ),
          ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: sensorStream.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: JalRakshakTheme.primaryBlue,
            ),
          );
        },

        error: (error, stack) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 55,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _language.text('unableSensorData'),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },

        data: (data) {
          return RefreshIndicator(
            color: JalRakshakTheme.primaryBlue,

            onRefresh: () async {
              ref.invalidate(liveSensorProvider);
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 5, 20, 25),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // LIVE STATUS
                  // ==================================================
                  _buildLiveStatus(),

                  const SizedBox(height: 18),

                  // ==================================================
                  // WATER QUALITY SCORE
                  // ==================================================
                  _buildWqiCard(data.wqi, data.status),

                  const SizedBox(height: 22),

                  // ==================================================
                  // WATER PARAMETERS
                  // ==================================================
                  Text(
                    _language.text('waterParameters'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: JalRakshakTheme.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildSensorGrid(data.ph, data.tds, data.turbidity),

                  const SizedBox(height: 22),

                  // ==================================================
                  // WATER USAGE CLASSIFICATION
                  // ==================================================
                  _buildUsageClassification(data),

                  const SizedBox(height: 18),

                  // ==================================================
                  // HEALTH RISKS
                  // ==================================================
                  _buildHealthRisks(data),

                  const SizedBox(height: 18),

                  // ==================================================
                  // TREATMENT SUGGESTIONS
                  // ==================================================
                  _buildTreatmentSuggestions(data),

                  const SizedBox(height: 18),

                  // ==================================================
                  // PRECAUTIONS
                  // ==================================================
                  _buildPrecautions(),

                  const SizedBox(height: 22),

                  // ==================================================
                  // UPDATE MESSAGE
                  // ==================================================
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sync_rounded, size: 14, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          _language.text('sensorUpdates'),
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================================================================
  // LIVE STATUS
  // ================================================================

  Widget _buildLiveStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: JalRakshakTheme.safeGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: JalRakshakTheme.safeGreen.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: JalRakshakTheme.safeGreen,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              _language.text('esp32Connected'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: JalRakshakTheme.textDark,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: JalRakshakTheme.safeGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _language.text('liveStatus'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // WATER QUALITY SCORE
  // ================================================================

  Widget _buildWqiCard(double wqi, String status) {
    final String upperStatus = status.toUpperCase();

    final bool isSafe = upperStatus.startsWith('SAFE');
    final bool isUnsafe = upperStatus.startsWith('UNSAFE');

    final Color statusColor;

    if (isSafe) {
      statusColor = JalRakshakTheme.safeGreen;
    } else if (isUnsafe) {
      statusColor = JalRakshakTheme.dangerRed;
    } else {
      statusColor = JalRakshakTheme.warningOrange;
    }

    final IconData statusIcon;

    if (isSafe) {
      statusIcon = Icons.check_circle_rounded;
    } else if (isUnsafe) {
      statusIcon = Icons.cancel_rounded;
    } else {
      statusIcon = Icons.warning_rounded;
    }

    final String scoreLabel;

    if (isSafe) {
      scoreLabel = _language.text('good');
    } else if (isUnsafe) {
      scoreLabel = _language.text('unsafe');
    } else {
      scoreLabel = _language.text('check');
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _language.text('waterQualityScore'),
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    wqi.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: JalRakshakTheme.textDark,
                    ),
                  ),

                  const Text(
                    '/100',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),

              SizedBox(
                height: 105,
                width: 105,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 105,
                      width: 105,
                      child: CircularProgressIndicator(
                        value: (wqi / 100).clamp(0.0, 1.0),
                        strokeWidth: 11,
                        backgroundColor: Colors.grey.shade200,
                        color: statusColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 25),

                        const SizedBox(height: 3),

                        Text(
                          scoreLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(height: 1, color: Colors.grey.shade200),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon, size: 21, color: statusColor),

              const SizedBox(width: 8),

              Flexible(
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SENSOR GRID
  // ================================================================

  Widget _buildSensorGrid(double ph, double tds, double turbidity) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSensorCard(
                title: _language.text('phLevel'),
                value: ph.toStringAsFixed(1),
                unit: 'pH',
                icon: Icons.science_outlined,
                color: JalRakshakTheme.primaryBlue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildSensorCard(
                title: 'TDS',
                value: tds.toStringAsFixed(0),
                unit: 'ppm',
                icon: Icons.water_drop_outlined,
                color: JalRakshakTheme.primaryBlue,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildSensorCard(
                title: _language.text('turbidity'),
                value: turbidity.toStringAsFixed(1),
                unit: 'NTU',
                icon: Icons.opacity_outlined,
                color: JalRakshakTheme.primaryBlue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildSensorCard(
                title: _language.text('monitoring'),
                value: _language.text('liveStatus'),
                unit: '',
                icon: Icons.sensors_rounded,
                color: JalRakshakTheme.safeGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================================================================
  // SENSOR CARD
  // ================================================================

  Widget _buildSensorCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 21, color: color),
              ),

              const Spacer(),

              const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: JalRakshakTheme.textDark,
                ),
              ),

              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),

                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    unit,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // WATER USAGE CLASSIFICATION
  // ================================================================

  Widget _buildUsageClassification(SensorData data) {
    final bool drinkingSafe = _isDrinkingSafe(data);

    final bool cookingSafe = _isCookingSafe(data);

    final bool bathingSafe = _isBathingSafe(data);

    final bool washingSafe = _isWashingSafe(data);

    final bool cleaningSafe = _isCleaningSafe(data);

    final bool irrigationSafe = _isIrrigationSafe(data);

    final bool industrialModerate = data.wqi >= 50;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: JalRakshakTheme.primaryBlue.withOpacity(0.15),
        ),
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
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              setState(() {
                _usageExpanded = !_usageExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: JalRakshakTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.water_drop_outlined,
                      color: JalRakshakTheme.primaryBlue,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      _language.text('waterUsage'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: JalRakshakTheme.textDark,
                      ),
                    ),
                  ),

                  Icon(
                    _usageExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                    size: 27,
                  ),
                ],
              ),
            ),
          ),

          if (_usageExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),

            _buildUsageOption(
              icon: Icons.local_drink_rounded,
              title: _language.text('drinking'),
              status: drinkingSafe ? 'Safe' : 'Not Safe',
              color: drinkingSafe
                  ? JalRakshakTheme.safeGreen
                  : JalRakshakTheme.dangerRed,
            ),

            _buildUsageOption(
              icon: Icons.restaurant_rounded,
              title: _language.text('cooking'),
              status: cookingSafe ? 'Safe' : 'Not Safe',
              color: cookingSafe
                  ? JalRakshakTheme.safeGreen
                  : JalRakshakTheme.dangerRed,
            ),

            _buildUsageOption(
              icon: Icons.shower_rounded,
              title: _language.text('bathing'),
              status: bathingSafe ? 'Safe' : 'Not Safe',
              color: bathingSafe
                  ? JalRakshakTheme.safeGreen
                  : JalRakshakTheme.dangerRed,
            ),

            _buildUsageOption(
              icon: Icons.checkroom_rounded,
              title: _language.text('washingClothes'),
              status: washingSafe ? 'Safe' : 'Not Safe',
              color: washingSafe
                  ? JalRakshakTheme.safeGreen
                  : JalRakshakTheme.dangerRed,
            ),

            _buildUsageOption(
              icon: Icons.cleaning_services_rounded,
              title: _language.text('cleaning'),
              status: cleaningSafe ? 'Safe' : 'Not Safe',
              color: cleaningSafe
                  ? JalRakshakTheme.safeGreen
                  : JalRakshakTheme.dangerRed,
            ),

            _buildUsageOption(
              icon: Icons.eco_rounded,
              title: _language.text('irrigation'),
              status: irrigationSafe ? 'Safe' : 'Not Safe',
              color: irrigationSafe
                  ? JalRakshakTheme.safeGreen
                  : JalRakshakTheme.dangerRed,
            ),

            _buildUsageOption(
              icon: Icons.factory_rounded,
              title: _language.text('industrialUse'),
              status: industrialModerate ? 'Moderate' : 'Not Safe',
              color: industrialModerate
                  ? JalRakshakTheme.warningOrange
                  : JalRakshakTheme.dangerRed,
              last: true,
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // USAGE RULES
  // ================================================================

  bool _isDrinkingSafe(SensorData data) {
    return data.wqi >= 80 &&
        data.ph >= 6.5 &&
        data.ph <= 8.5 &&
        data.tds <= 500 &&
        data.turbidity <= 5;
  }

  bool _isCookingSafe(SensorData data) {
    return data.wqi >= 75 &&
        data.ph >= 6.5 &&
        data.ph <= 8.5 &&
        data.tds <= 600 &&
        data.turbidity <= 5;
  }

  bool _isBathingSafe(SensorData data) {
    return data.ph >= 6.0 && data.ph <= 9.0 && data.turbidity <= 10;
  }

  bool _isWashingSafe(SensorData data) {
    return data.turbidity <= 12 && data.tds <= 1000;
  }

  bool _isCleaningSafe(SensorData data) {
    return data.turbidity <= 15 && data.tds <= 1500;
  }

  bool _isIrrigationSafe(SensorData data) {
    return data.tds <= 1200 && data.ph >= 6.0 && data.ph <= 9.0;
  }

  // ================================================================
  // USAGE OPTION
  // ================================================================

  Widget _buildUsageOption({
    required IconData icon,
    required String title,
    required String status,
    required Color color,
    bool last = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 6, 12, last ? 12 : 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: JalRakshakTheme.textDark,
                ),
              ),
            ),

            Text(
              status == 'Safe'
                  ? _language.text('safe')
                  : status == 'Moderate'
                  ? _language.text('moderate')
                  : _language.text('notSafe'),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              status == 'Safe'
                  ? Icons.check_circle_outline_rounded
                  : status == 'Moderate'
                  ? Icons.info_outline_rounded
                  : Icons.cancel_outlined,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // HEALTH RISKS
  // ================================================================

  Widget _buildHealthRisks(SensorData data) {
    final bool highTds = data.tds > 500;

    final bool highTurbidity = data.turbidity > 5;

    final bool phAbnormal = data.ph < 6.5 || data.ph > 8.5;

    final bool critical = data.wqi < 60;

    final bool unsafe = critical || highTds || highTurbidity || phAbnormal;

    final Color healthColor = unsafe
        ? JalRakshakTheme.dangerRed
        : JalRakshakTheme.safeGreen;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: unsafe
              ? JalRakshakTheme.dangerRed.withOpacity(0.18)
              : JalRakshakTheme.safeGreen.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ==========================================================
          // HEADER
          // ==========================================================
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              setState(() {
                _healthExpanded = !_healthExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  _buildDoctorIllustration(healthColor),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _language.text('healthRisks'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: JalRakshakTheme.textDark,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          unsafe
                              ? _language.text('healthConcernsDetected')
                              : _language.text('waterLooksSafe'),
                          style: TextStyle(
                            fontSize: 12,
                            color: healthColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _healthExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey.shade700,
                      size: 23,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==========================================================
          // EXPANDED SECTION
          // ==========================================================
          if (_healthExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // MAIN HEALTH STATUS
                  // ==================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: unsafe
                            ? [
                                JalRakshakTheme.dangerRed.withOpacity(0.12),
                                JalRakshakTheme.dangerRed.withOpacity(0.04),
                              ]
                            : [
                                JalRakshakTheme.safeGreen.withOpacity(0.12),
                                JalRakshakTheme.safeGreen.withOpacity(0.04),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: healthColor.withOpacity(0.20)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: healthColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            unsafe
                                ? Icons.warning_rounded
                                : Icons.check_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                unsafe
                                    ? _language.text('waterNotSafe')
                                    : _language.text('waterLooksSafe'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: healthColor,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                unsafe
                                    ? _language.text('avoidDrinking')
                                    : _language.text('safeRange'),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // DOCTOR + MESSAGE
                  // ==================================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDoctorIllustration(healthColor, large: true),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                            ),
                          ),
                          child: Text(
                            unsafe
                                ? _language.text('healthRiskDetected')
                                : _language.text('noHealthConcern'),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // POSSIBLE HEALTH ISSUES
                  // ==================================================
                  Text(
                    _language.text('possibleHealthIssues'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: JalRakshakTheme.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (highTds)
                    _buildHealthRiskItem(
                      icon: Icons.water_drop_outlined,
                      title: _language.text('highTds'),
                      description: _language.text('highTdsDescription'),
                      color: JalRakshakTheme.dangerRed,
                    ),

                  if (highTurbidity)
                    _buildHealthRiskItem(
                      icon: Icons.opacity_rounded,
                      title: _language.text('highTurbidity'),
                      description: _language.text('highTurbidityDescription'),
                      color: JalRakshakTheme.warningOrange,
                    ),

                  if (phAbnormal)
                    _buildHealthRiskItem(
                      icon: Icons.science_outlined,
                      title: _language.text('imbalancedPh'),
                      description: _language.text('imbalancedPhDescription'),
                      color: JalRakshakTheme.warningOrange,
                    ),

                  if (critical)
                    _buildHealthRiskItem(
                      icon: Icons.warning_amber_rounded,
                      title: _language.text('poorOverallQuality'),
                      description: _language.text(
                        'poorOverallQualityDescription',
                      ),
                      color: JalRakshakTheme.dangerRed,
                    ),

                  if (!highTds && !highTurbidity && !phAbnormal && !critical)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: JalRakshakTheme.safeGreen.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: JalRakshakTheme.safeGreen.withOpacity(0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: JalRakshakTheme.safeGreen,
                            size: 22,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              _language.text('noMajorHealthRiskDetected'),
                              style: TextStyle(
                                fontSize: 12,
                                color: JalRakshakTheme.safeGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // DOCTOR ILLUSTRATION
  // ================================================================

  Widget _buildDoctorIllustration(Color color, {bool large = false}) {
    final double size = large ? 72 : 58;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),

          Positioned(
            bottom: large ? 5 : 4,
            child: Container(
              width: large ? 48 : 39,
              height: large ? 34 : 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(large ? 18 : 14),
                  topRight: Radius.circular(large ? 18 : 14),
                  bottomLeft: Radius.circular(large ? 8 : 6),
                  bottomRight: Radius.circular(large ? 8 : 6),
                ),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(
                Icons.medical_services_rounded,
                size: large ? 23 : 19,
                color: color,
              ),
            ),
          ),

          Positioned(
            top: large ? 8 : 7,
            child: Container(
              width: large ? 28 : 23,
              height: large ? 28 : 23,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD7B5),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.person_rounded,
                size: large ? 22 : 18,
                color: Colors.white,
              ),
            ),
          ),

          Positioned(
            right: 0,
            bottom: large ? 2 : 1,
            child: Container(
              width: large ? 22 : 18,
              height: large ? 22 : 18,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: large ? 14 : 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // HEALTH RISK ITEM
  // ================================================================

  Widget _buildHealthRiskItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 21),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // PRECAUTIONS
  // ================================================================

  Widget _buildPrecautions() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: JalRakshakTheme.primaryBlue.withOpacity(0.12),
        ),
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
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              setState(() {
                _precautionsExpanded = !_precautionsExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: JalRakshakTheme.primaryBlue.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.health_and_safety_outlined,
                      color: JalRakshakTheme.primaryBlue,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _language.text('precautions'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: JalRakshakTheme.textDark,
                      ),
                    ),
                  ),
                  Icon(
                    _precautionsExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                    size: 27,
                  ),
                ],
              ),
            ),
          ),

          if (_precautionsExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _dashboardText('Follow these precautions to stay safe'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: JalRakshakTheme.textDark,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                children: [
                  _buildPrecautionItem(
                    icon: Icons.no_drinks_outlined,
                    title: _dashboardText('Do not drink untreated water.'),
                    color: JalRakshakTheme.dangerRed,
                  ),
                  _buildPrecautionItem(
                    icon: Icons.water_drop_outlined,
                    title: _dashboardText(
                      'Always store water in clean containers.',
                    ),
                    color: JalRakshakTheme.primaryBlue,
                  ),
                  _buildPrecautionItem(
                    icon: Icons.cleaning_services_outlined,
                    title: _dashboardText(
                      'Clean your storage tanks regularly.',
                    ),
                    color: JalRakshakTheme.primaryBlue,
                  ),
                  _buildPrecautionItem(
                    icon: Icons.local_drink_outlined,
                    title: _dashboardText(
                      'Boil water if unsure about quality.',
                    ),
                    color: JalRakshakTheme.primaryBlue,
                  ),
                  _buildPrecautionItem(
                    icon: Icons.water_damage_outlined,
                    title: _dashboardText(
                      'Use proper filters and replace them on time.',
                    ),
                    color: JalRakshakTheme.primaryBlue,
                    last: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // PRECAUTION ITEM
  // ================================================================

  Widget _buildPrecautionItem({
    required IconData icon,
    required String title,
    required Color color,
    bool last = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: JalRakshakTheme.textDark,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // TREATMENT SUGGESTIONS
  // ================================================================

  Widget _buildTreatmentSuggestions(SensorData data) {
    final bool highTds = data.tds > 500;

    final bool highTurbidity = data.turbidity > 5;

    final bool phAbnormal = data.ph < 6.5 || data.ph > 8.5;

    final bool unsafe = data.wqi < 60 || highTds || highTurbidity || phAbnormal;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: JalRakshakTheme.primaryBlue.withOpacity(0.12),
        ),
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
          // ==========================================================
          // HEADER
          // ==========================================================
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              setState(() {
                _treatmentExpanded = !_treatmentExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: JalRakshakTheme.primaryBlue.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.medical_services_outlined,
                      color: JalRakshakTheme.primaryBlue,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      _language.text('treatmentSuggestions'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: JalRakshakTheme.textDark,
                      ),
                    ),
                  ),

                  Icon(
                    _treatmentExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                    size: 27,
                  ),
                ],
              ),
            ),
          ),

          if (_treatmentExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dashboardText(
                      'Simple steps based on the current water condition',
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: JalRakshakTheme.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // HIGH TDS
                  if (highTds)
                    _buildTreatmentItem(
                      icon: Icons.water_drop_outlined,
                      title: _language.text('highTds'),
                      subtitle: _dashboardText(
                        'Use properly filtered water for drinking.',
                      ),
                      detail: _dashboardText(
                        'High TDS means the water contains a high amount of dissolved substances. Avoid drinking it directly and use properly filtered drinking water.',
                      ),
                      color: JalRakshakTheme.primaryBlue,
                    ),

                  // HIGH TURBIDITY
                  if (highTurbidity)
                    _buildTreatmentItem(
                      icon: Icons.opacity_rounded,
                      title: _language.text('highTurbidity'),
                      subtitle: _dashboardText(
                        'Let it settle, filter it and boil before drinking.',
                      ),
                      detail: _dashboardText(
                        'If the water looks cloudy, keep it undisturbed so particles can settle. Filter the water and boil it before drinking.',
                      ),
                      color: JalRakshakTheme.primaryBlue,
                    ),

                  // UNBALANCED PH
                  if (phAbnormal)
                    _buildTreatmentItem(
                      icon: Icons.science_outlined,
                      title: _dashboardText('Unbalanced pH'),
                      subtitle: _dashboardText(
                        'Avoid drinking this water directly.',
                      ),
                      detail: _dashboardText(
                        'The measured pH is outside the preferred range. Do not drink this water directly. Use another safe drinking-water source until the water condition is checked and corrected.',
                      ),
                      color: JalRakshakTheme.primaryBlue,
                    ),

                  // UNSAFE WATER
                  if (unsafe)
                    _buildTreatmentItem(
                      icon: Icons.warning_amber_rounded,
                      title: _dashboardText('Unsafe Water'),
                      subtitle: _dashboardText(
                        'Do not drink this water directly.',
                      ),
                      detail: _dashboardText(
                        'The current readings indicate that the water may not be suitable for drinking. Avoid direct consumption and use a safe drinking-water source.',
                      ),
                      color: JalRakshakTheme.dangerRed,
                    ),

                  // SAFE CONDITION
                  if (!highTds && !highTurbidity && !phAbnormal && !unsafe)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: JalRakshakTheme.safeGreen.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: JalRakshakTheme.safeGreen.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: JalRakshakTheme.safeGreen,
                            size: 22,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              _dashboardText(
                                'Water is currently within the monitored safe range.',
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color: JalRakshakTheme.safeGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // SIMPLE INFORMATION BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: JalRakshakTheme.primaryBlue.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: JalRakshakTheme.primaryBlue,
                          size: 20,
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            _dashboardText(
                              'These are basic safety suggestions. The app does not directly treat the water.',
                            ),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================================================================
  // TREATMENT ITEM
  // ================================================================

  Widget _buildTreatmentItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String detail,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          childrenPadding: const EdgeInsets.fromLTRB(58, 0, 16, 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 21),
          ),

          title: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                height: 1.3,
              ),
            ),
          ),

          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),

          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                detail,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
