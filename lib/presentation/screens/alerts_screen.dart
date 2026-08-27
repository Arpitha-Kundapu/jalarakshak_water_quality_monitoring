import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as language_provider;

import '../../core/theme.dart';
import '../providers/language_provider.dart';
import '../services/sensor_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  // ================================================================
  // SENSOR SERVICE
  // ================================================================

  final SensorService _sensorService = SensorService();

  // ================================================================
  // TEMPORARY pH
  // ================================================================

  // pH sensor is not currently connected.
  // Therefore we keep 7.0 temporarily.
  static const double temporaryPh = 7.0;

  // ================================================================
  // DATA
  // ================================================================

  double tds = 0.0;
  double turbidity = 0.0;
  double ph = temporaryPh;

  String classification = 'Waiting for prediction';

  Map<String, dynamic> probabilities = {};

  bool loading = true;
  String? error;

  // ================================================================
  // INIT
  // ================================================================

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  // ================================================================
  // LOAD FIREBASE DATA
  // ================================================================

  Future<void> _loadData() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

      final result = await _sensorService.getWaterQuality();

      // ------------------------------------------------------------
      // SENSOR DATA
      // ------------------------------------------------------------

      final Map<String, dynamic> sensorData =
          result['sensor_data'] is Map
              ? Map<String, dynamic>.from(
                  result['sensor_data'],
                )
              : {};

      // ------------------------------------------------------------
      // PREDICTION DATA
      // ------------------------------------------------------------

      final Map<String, dynamic> predictionData =
          result['prediction'] is Map
              ? Map<String, dynamic>.from(
                  result['prediction'],
                )
              : {};

      // ------------------------------------------------------------
      // TDS
      // ------------------------------------------------------------

      final double newTds = _toDouble(
        sensorData['tds_mg_L'],
        0.0,
      );

      // ------------------------------------------------------------
      // TURBIDITY
      // ------------------------------------------------------------

      final double newTurbidity = _toDouble(
        sensorData['turbidity_NTU'],
        0.0,
      );

      // ------------------------------------------------------------
      // CLASSIFICATION
      // ------------------------------------------------------------

      final String newClassification =
          predictionData['classification']?.toString() ??
              'Waiting for prediction';

      // ------------------------------------------------------------
      // PROBABILITIES
      // ------------------------------------------------------------

      final Map<String, dynamic> newProbabilities =
          predictionData['probabilities'] is Map
              ? Map<String, dynamic>.from(
                  predictionData['probabilities'],
                )
              : {};

      // ------------------------------------------------------------
      // UPDATE UI
      // ------------------------------------------------------------

      if (!mounted) return;

      setState(() {
        tds = newTds;
        turbidity = newTurbidity;
        ph = temporaryPh;

        classification = newClassification;

        probabilities = newProbabilities;

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  // ================================================================
  // SAFE DOUBLE CONVERSION
  // ================================================================

  double _toDouble(
    dynamic value,
    double fallback,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        fallback;
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final language =
        language_provider.Provider.of<LanguageProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _text(
            language,
            'alertsTreatments',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: _loadData,
          ),
        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadData,

              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // =================================================
                    // ERROR
                    // =================================================

                    if (error != null)
                      _buildErrorCard(
                        error!,
                      ),

                    // =================================================
                    // CURRENT WATER STATUS
                    // =================================================

                    Text(
                      _text(
                        language,
                        'currentStatus',
                      ),

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            JalRakshakTheme.textDark,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    _buildStatusCard(
                      language,
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // =================================================
                    // SENSOR VALUES
                    // =================================================

                    Text(
                      _text(
                        language,
                        'currentReadings',
                      ),

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            JalRakshakTheme.textDark,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child:
                              _buildReadingCard(
                            title: 'TDS',
                            value:
                                '${tds.toStringAsFixed(1)} mg/L',
                            icon:
                                Icons.water_drop_outlined,
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child:
                              _buildReadingCard(
                            title:
                                'Turbidity',
                            value:
                                '${turbidity.toStringAsFixed(2)} NTU',
                            icon:
                                Icons.opacity,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    _buildReadingCard(
                      title: 'pH',
                      value:
                          '${ph.toStringAsFixed(1)}',
                      icon:
                          Icons.science_outlined,
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // =================================================
                    // ACTIVE WARNINGS
                    // =================================================

                    Text(
                      _text(
                        language,
                        'activeWarnings',
                      ),

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            JalRakshakTheme.textDark,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    ..._buildWarnings(
                      language,
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // =================================================
                    // TREATMENT SUGGESTIONS
                    // =================================================

                    Text(
                      _text(
                        language,
                        'aiTreatmentSuggestions',
                      ),

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            JalRakshakTheme.textDark,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    ..._buildTreatments(
                      language,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // =================================================
                    // ML PROBABILITIES
                    // =================================================

                    _buildProbabilityCard(
                      language,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ================================================================
  // STATUS CARD
  // ================================================================

  Widget _buildStatusCard(
    LanguageProvider language,
  ) {
    Color statusColor;

    IconData statusIcon;

    String statusText;

    switch (classification) {
      case 'Drinking':
        statusColor =
            JalRakshakTheme.primaryBlue;
        statusIcon =
            Icons.check_circle_outline;
        statusText =
            _text(language, 'safeDrinking');

        break;

      case 'Irrigation/Garden':
        statusColor = Colors.green;
        statusIcon =
            Icons.grass_outlined;
        statusText =
            _text(language, 'irrigationWater');

        break;

      case 'Washing/Cleaning':
        statusColor = Colors.orange;
        statusIcon =
            Icons.cleaning_services_outlined;
        statusText =
            _text(language, 'washingWater');

        break;

      case 'Unsafe':
        statusColor =
            JalRakshakTheme.dangerRed;
        statusIcon =
            Icons.warning_amber_rounded;
        statusText =
            _text(language, 'unsafeWater');

        break;

      default:
        statusColor = Colors.grey;
        statusIcon =
            Icons.help_outline;
        statusText = classification;
    }

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
            statusColor.withOpacity(0.1),

        borderRadius:
            BorderRadius.circular(15),

        border: Border.all(
          color:
              statusColor.withOpacity(0.5),
        ),
      ),

      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 35,
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  classification,

                  style: TextStyle(
                    color: statusColor,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  statusText,

                  style: TextStyle(
                    color:
                        statusColor.withOpacity(
                      0.8,
                    ),
                    fontSize: 13,
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
  // BUILD WARNINGS
  // ================================================================

  List<Widget> _buildWarnings(
    LanguageProvider language,
  ) {
    final List<Widget> warnings = [];

    // --------------------------------------------------------------
    // UNSAFE CLASSIFICATION
    // --------------------------------------------------------------

    if (classification == 'Unsafe') {
      warnings.add(
        _buildWarningCard(
          title:
              _text(
                language,
                'waterNotSafe',
              ),
          subtitle:
              _text(
                language,
                'unsafeClassification',
              ),
          icon:
              Icons.warning_amber_rounded,
          color:
              JalRakshakTheme.dangerRed,
        ),
      );

      warnings.add(
        const SizedBox(
          height: 12,
        ),
      );
    }

    // --------------------------------------------------------------
    // HIGH TDS
    // --------------------------------------------------------------

    if (tds > 500) {
      warnings.add(
        _buildWarningCard(
          title:
              _text(
                language,
                'highTdsDetected',
              ),
          subtitle:
              'Current TDS: ${tds.toStringAsFixed(1)} mg/L',
          icon:
              Icons.water_drop,
          color:
              Colors.orange,
        ),
      );

      warnings.add(
        const SizedBox(
          height: 12,
        ),
      );
    }

    // --------------------------------------------------------------
    // HIGH TURBIDITY
    // --------------------------------------------------------------

    if (turbidity > 5) {
      warnings.add(
        _buildWarningCard(
          title:
              _text(
                language,
                'highTurbidityDetected',
              ),
          subtitle:
              'Current turbidity: ${turbidity.toStringAsFixed(2)} NTU',
          icon:
              Icons.opacity,
          color:
              Colors.orange,
        ),
      );

      warnings.add(
        const SizedBox(
          height: 12,
        ),
      );
    }

    // --------------------------------------------------------------
    // PH
    // --------------------------------------------------------------

    if (ph < 6.5 || ph > 8.5) {
      warnings.add(
        _buildWarningCard(
          title:
              _text(
                language,
                'phImbalanceDetected',
              ),
          subtitle:
              'Current pH: ${ph.toStringAsFixed(1)}',
          icon:
              Icons.science,
          color:
              JalRakshakTheme.dangerRed,
        ),
      );

      warnings.add(
        const SizedBox(
          height: 12,
        ),
      );
    }

    // --------------------------------------------------------------
    // NO WARNINGS
    // --------------------------------------------------------------

    if (warnings.isEmpty) {
      warnings.add(
        _buildWarningCard(
          title:
              _text(
                language,
                'noActiveWarnings',
              ),
          subtitle:
              _text(
                language,
                'waterParametersNormal',
              ),
          icon:
              Icons.check_circle_outline,
          color:
              Colors.green,
        ),
      );
    }

    return warnings;
  }

  // ================================================================
  // BUILD TREATMENTS
  // ================================================================

  List<Widget> _buildTreatments(
    LanguageProvider language,
  ) {
    final List<Widget> treatments = [];

    // --------------------------------------------------------------
    // HIGH TDS
    // --------------------------------------------------------------

    if (tds > 500) {
      treatments.add(
        _buildTreatmentCard(
          title:
              _text(
                language,
                'highTdsDetected',
              ),
          description:
              _text(
                language,
                'highTdsDescription',
              ),
          icon:
              Icons.filter_alt_outlined,
        ),
      );

      treatments.add(
        const SizedBox(
          height: 15,
        ),
      );
    }

    // --------------------------------------------------------------
    // HIGH TURBIDITY
    // --------------------------------------------------------------

    if (turbidity > 5) {
      treatments.add(
        _buildTreatmentCard(
          title:
              _text(
                language,
                'highTurbidityDetected',
              ),
          description:
              _text(
                language,
                'highTurbidityDescription',
              ),
          icon:
              Icons.water_drop_outlined,
        ),
      );

      treatments.add(
        const SizedBox(
          height: 15,
        ),
      );
    }

    // --------------------------------------------------------------
    // PH
    // --------------------------------------------------------------

    if (ph < 6.5 || ph > 8.5) {
      treatments.add(
        _buildTreatmentCard(
          title:
              _text(
                language,
                'phImbalanceDetected',
              ),
          description:
              _text(
                language,
                'phImbalanceDescription',
              ),
          icon:
              Icons.science_outlined,
        ),
      );

      treatments.add(
        const SizedBox(
          height: 15,
        ),
      );
    }

    // --------------------------------------------------------------
    // NO TREATMENT REQUIRED
    // --------------------------------------------------------------

    if (treatments.isEmpty) {
      treatments.add(
        _buildTreatmentCard(
          title:
              _text(
                language,
                'noTreatmentRequired',
              ),
          description:
              _text(
                language,
                'waterParametersNormal',
              ),
          icon:
              Icons.check_circle_outline,
        ),
      );
    }

    return treatments;
  }

  // ================================================================
  // READING CARD
  // ================================================================

  Widget _buildReadingCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color:
                JalRakshakTheme.primaryBlue,
            size: 28,
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
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
  // WARNING CARD
  // ================================================================

  Widget _buildWarningCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color:
            color.withOpacity(0.1),

        borderRadius:
            BorderRadius.circular(15),

        border: Border.all(
          color:
              color.withOpacity(0.4),
        ),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    color: color,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  subtitle,

                  style: TextStyle(
                    color:
                        color.withOpacity(
                      0.8,
                    ),
                    fontSize: 12,
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
  // TREATMENT CARD
  // ================================================================

  Widget _buildTreatmentCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            padding:
                const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color:
                  JalRakshakTheme.primaryBlue
                      .withOpacity(0.1),
              shape:
                  BoxShape.circle,
            ),

            child: Icon(
              icon,
              color:
                  JalRakshakTheme.primaryBlue,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  description,

                  style:
                      const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
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
  // PROBABILITY CARD
  // ================================================================

  Widget _buildProbabilityCard(
    LanguageProvider language,
  ) {
    if (probabilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            _text(
              language,
              'mlConfidence',
            ),

            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          ...probabilities.entries.map(
            (entry) {
              final value =
                  _toDouble(
                entry.value,
                0,
              );

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 10,
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key
                            .replaceAll(
                              '_',
                              '/',
                            ),
                        style:
                            const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),

                    Text(
                      '${value.toStringAsFixed(1)}%',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ERROR CARD
  // ================================================================

  Widget _buildErrorCard(
    String message,
  ) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 20,
      ),

      padding:
          const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color:
            JalRakshakTheme.dangerRed
                .withOpacity(0.1),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Text(
        'Firebase Error:\n$message',

        style: TextStyle(
          color:
              JalRakshakTheme.dangerRed,
          fontSize: 12,
        ),
      ),
    );
  }

  // ================================================================
  // TRANSLATIONS
  // ================================================================

  String _text(
    LanguageProvider language,
    String key,
  ) {
    final Map<String, Map<String, String>>
        translations = {
      'English': {
        'alertsTreatments':
            'Alerts & Treatments',

        'currentStatus':
            'Current Water Status',

        'currentReadings':
            'Current Readings',

        'activeWarnings':
            'Active Warnings',

        'aiTreatmentSuggestions':
            'AI Treatment Suggestions',

        'safeDrinking':
            'Water is suitable for drinking.',

        'irrigationWater':
            'Water is recommended for irrigation or garden use.',

        'washingWater':
            'Water is recommended for washing and cleaning.',

        'unsafeWater':
            'Water should not be used for drinking.',

        'waterNotSafe':
            'Water is NOT SAFE for Drinking',

        'unsafeClassification':
            'The ML model classified this water as unsafe.',

        'highTdsDetected':
            'High TDS Detected (> 500 ppm)',

        'highTdsDescription':
            'Use Reverse Osmosis (RO) filtration to reduce dissolved minerals.',

        'highTurbidityDetected':
            'High Turbidity Detected (> 5 NTU)',

        'highTurbidityDescription':
            'Use sedimentation, sand filtration, or suitable filtration to reduce physical impurities.',

        'phImbalanceDetected':
            'pH Imbalance Detected',

        'phImbalanceDescription':
            'pH correction may be required to bring the water within the desired range.',

        'noActiveWarnings':
            'No Active Warnings',

        'waterParametersNormal':
            'Current monitored parameters are within the configured limits.',

        'noTreatmentRequired':
            'No Immediate Treatment Required',

        'mlConfidence':
            'ML Prediction Confidence',
      },

      'ಕನ್ನಡ': {
        'alertsTreatments':
            'ಎಚ್ಚರಿಕೆಗಳು ಮತ್ತು ಚಿಕಿತ್ಸೆಗಳು',

        'currentStatus':
            'ಪ್ರಸ್ತುತ ನೀರಿನ ಸ್ಥಿತಿ',

        'currentReadings':
            'ಪ್ರಸ್ತುತ ಮಾಪನಗಳು',

        'activeWarnings':
            'ಸಕ್ರಿಯ ಎಚ್ಚರಿಕೆಗಳು',

        'aiTreatmentSuggestions':
            'AI ಚಿಕಿತ್ಸೆಯ ಸಲಹೆಗಳು',

        'safeDrinking':
            'ನೀರು ಕುಡಿಯಲು ಸೂಕ್ತವಾಗಿದೆ.',

        'irrigationWater':
            'ನೀರು ನೀರಾವರಿ ಅಥವಾ ತೋಟಕ್ಕೆ ಸೂಕ್ತವಾಗಿದೆ.',

        'washingWater':
            'ನೀರು ತೊಳೆಯಲು ಮತ್ತು ಸ್ವಚ್ಛಗೊಳಿಸಲು ಸೂಕ್ತವಾಗಿದೆ.',

        'unsafeWater':
            'ನೀರನ್ನು ಕುಡಿಯಲು ಬಳಸಬಾರದು.',

        'waterNotSafe':
            'ನೀರು ಕುಡಿಯಲು ಸುರಕ್ಷಿತವಲ್ಲ',

        'unsafeClassification':
            'ML ಮಾದರಿಯು ಈ ನೀರನ್ನು ಸುರಕ್ಷಿತವಲ್ಲ ಎಂದು ವರ್ಗೀಕರಿಸಿದೆ.',

        'highTdsDetected':
            'ಹೆಚ್ಚಿನ TDS ಪತ್ತೆಯಾಗಿದೆ (> 500 ppm)',

        'highTdsDescription':
            'ಕರಗಿದ ಖನಿಜಗಳನ್ನು ಕಡಿಮೆ ಮಾಡಲು RO ಫಿಲ್ಟರೇಶನ್ ಬಳಸಿ.',

        'highTurbidityDetected':
            'ಹೆಚ್ಚಿನ ಮಸುಕು ಪತ್ತೆಯಾಗಿದೆ (> 5 NTU)',

        'highTurbidityDescription':
            'ಭೌತಿಕ ಕಲ್ಮಶಗಳನ್ನು ಕಡಿಮೆ ಮಾಡಲು ಸೆಡಿಮೆಂಟೇಶನ್ ಅಥವಾ ಸ್ಯಾಂಡ್ ಫಿಲ್ಟರೇಶನ್ ಬಳಸಿ.',

        'phImbalanceDetected':
            'pH ಅಸಮತೋಲನ ಪತ್ತೆಯಾಗಿದೆ',

        'phImbalanceDescription':
            'ನೀರಿನ pH ಅನ್ನು ಅಗತ್ಯವಿರುವ ವ್ಯಾಪ್ತಿಗೆ ತರಲು pH ತಿದ್ದುಪಡಿ ಅಗತ್ಯವಾಗಬಹುದು.',

        'noActiveWarnings':
            'ಯಾವುದೇ ಸಕ್ರಿಯ ಎಚ್ಚರಿಕೆಗಳಿಲ್ಲ',

        'waterParametersNormal':
            'ಪ್ರಸ್ತುತ ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಲಾದ ನಿಯತಾಂಕಗಳು ನಿಗದಿತ ಮಿತಿಗಳಲ್ಲಿವೆ.',

        'noTreatmentRequired':
            'ತಕ್ಷಣದ ಚಿಕಿತ್ಸೆ ಅಗತ್ಯವಿಲ್ಲ',

        'mlConfidence':
            'ML ಮುನ್ಸೂಚನೆಯ ವಿಶ್ವಾಸಾರ್ಹತೆ',
      },

      'हिन्दी': {
        'alertsTreatments':
            'अलर्ट और उपचार',

        'currentStatus':
            'वर्तमान जल स्थिति',

        'currentReadings':
            'वर्तमान रीडिंग',

        'activeWarnings':
            'सक्रिय चेतावनियाँ',

        'aiTreatmentSuggestions':
            'AI उपचार सुझाव',

        'safeDrinking':
            'पानी पीने के लिए उपयुक्त है।',

        'irrigationWater':
            'पानी सिंचाई या बगीचे के लिए उपयुक्त है।',

        'washingWater':
            'पानी धोने और सफाई के लिए उपयुक्त है।',

        'unsafeWater':
            'पानी को पीने के लिए उपयोग नहीं करना चाहिए।',

        'waterNotSafe':
            'पानी पीने के लिए सुरक्षित नहीं है',

        'unsafeClassification':
            'ML मॉडल ने इस पानी को असुरक्षित वर्गीकृत किया है।',

        'highTdsDetected':
            'उच्च TDS पाया गया (> 500 ppm)',

        'highTdsDescription':
            'घुले हुए खनिजों को कम करने के लिए RO फिल्ट्रेशन का उपयोग करें।',

        'highTurbidityDetected':
            'उच्च गंदलापन पाया गया (> 5 NTU)',

        'highTurbidityDescription':
            'भौतिक अशुद्धियों को कम करने के लिए सेडिमेंटेशन या सैंड फिल्ट्रेशन का उपयोग करें।',

        'phImbalanceDetected':
            'pH असंतुलन पाया गया',

        'phImbalanceDescription':
            'पानी के pH को उचित सीमा में लाने के लिए pH सुधार की आवश्यकता हो सकती है।',

        'noActiveWarnings':
            'कोई सक्रिय चेतावनी नहीं',

        'waterParametersNormal':
            'वर्तमान निगरानी किए गए पैरामीटर निर्धारित सीमाओं के भीतर हैं।',

        'noTreatmentRequired':
            'तत्काल उपचार की आवश्यकता नहीं',

        'mlConfidence':
            'ML भविष्यवाणी विश्वास',
      },
    };

    return translations[
            language.language]?[key] ??
        key;
  }
}