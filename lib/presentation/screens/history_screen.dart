import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart' as language_provider;

import '../../core/theme.dart';
import '../../core/file_helper.dart';
import '../providers/language_provider.dart';
import '../services/sensor_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // ================================================================
  // VARIABLES
  // ================================================================

  String selectedPeriod = 'Week';

  final List<String> periods = [
    'Day',
    'Week',
    'Month',
    'Year',
  ];

  final SensorService sensorService = SensorService();

  late Future<List<Map<String, dynamic>>> historyFuture;

  // ================================================================
  // INIT
  // ================================================================

  @override
  void initState() {
    super.initState();

    historyFuture = sensorService.getHistory();
  }

  // ================================================================
  // REFRESH HISTORY
  // ================================================================

  void _refreshHistory() {
    setState(() {
      historyFuture = sensorService.getHistory();
    });
  }

  // ================================================================
  // LANGUAGE
  // ================================================================

  String _text(
    LanguageProvider language,
    String key,
  ) {
    final Map<String, Map<String, String>> translations = {
      'English': {
        'historyTrends': 'History & Trends',
        'day': 'Day',
        'week': 'Week',
        'month': 'Month',
        'year': 'Year',
        'waterQualityScore': 'Water Quality Score',
        'averageScore': 'Average Score',
        'readings': 'Readings',
        'tds': 'TDS',
        'turbidity': 'Turbidity',
        'noData': 'No history data available',
        'loading': 'Loading history...',
        'error': 'Unable to load history',
        'refresh': 'Refresh',
        'downloadReport': 'Download Report',
        'reportSoon': 'Report generation will be available soon.',
        'reportGenerating': 'Generating report...',
        'reportSavedSuccess': 'Report saved/shared successfully!',
        'reportError': 'Failed to generate report.',
        'latestReadings': 'Latest Readings',
        'mgL': 'mg/L',
        'ntu': 'NTU',
      },

      'ಕನ್ನಡ': {
        'historyTrends': 'ಇತಿಹಾಸ ಮತ್ತು ಪ್ರವೃತ್ತಿಗಳು',
        'day': 'ದಿನ',
        'week': 'ವಾರ',
        'month': 'ತಿಂಗಳು',
        'year': 'ವರ್ಷ',
        'waterQualityScore': 'ನೀರಿನ ಗುಣಮಟ್ಟದ ಸ್ಕೋರ್',
        'averageScore': 'ಸರಾಸರಿ ಸ್ಕೋರ್',
        'readings': 'ಓದುಗಳು',
        'tds': 'TDS',
        'turbidity': 'ಮಬ್ಬುತನ',
        'noData': 'ಇತಿಹಾಸದ ಡೇಟಾ ಲಭ್ಯವಿಲ್ಲ',
        'loading': 'ಇತಿಹಾಸ ಲೋಡ್ ಆಗುತ್ತಿದೆ...',
        'error': 'ಇತಿಹಾಸ ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ',
        'refresh': 'ರಿಫ್ರೆಶ್',
        'downloadReport': 'ವರದಿಯನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ',
        'reportSoon': 'ವರದಿ ರಚಿಸುವ ಸೌಲಭ್ಯ ಶೀಘ್ರದಲ್ಲೇ ಲಭ್ಯವಾಗಲಿದೆ.',
        'reportGenerating': 'ವರದಿ ಸಿದ್ಧಪಡಿಸಲಾಗುತ್ತಿದೆ...',
        'reportSavedSuccess': 'ವರದಿಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ/ಹಂಚಿಕೊಳ್ಳಲಾಗಿದೆ.',
        'reportError': 'ವರದಿ ಸಿದ್ಧಪಡಿಸಲು ವಿಫಲವಾಗಿದೆ.',
        'latestReadings': 'ಇತ್ತೀಚಿನ ಓದುಗಳು',
        'mgL': 'mg/L',
        'ntu': 'NTU',
      },

      'हिन्दी': {
        'historyTrends': 'इतिहास और रुझान',
        'day': 'दिन',
        'week': 'सप्ताह',
        'month': 'महीना',
        'year': 'वर्ष',
        'waterQualityScore': 'पानी की गुणवत्ता का स्कोर',
        'averageScore': 'औसत स्कोर',
        'readings': 'रीडिंग',
        'tds': 'TDS',
        'turbidity': 'टर्बिडिटी',
        'noData': 'इतिहास डेटा उपलब्ध नहीं है',
        'loading': 'इतिहास लोड हो रहा है...',
        'error': 'इतिहास लोड नहीं हो सका',
        'refresh': 'रिफ्रेश',
        'downloadReport': 'रिपोर्ट डाउनलोड करें',
        'reportSoon': 'रिपोर्ट बनाने की सुविधा जल्द उपलब्ध होगी।',
        'reportGenerating': 'रिपोर्ट तैयार की जा रही है...',
        'reportSavedSuccess': 'रिपोर्ट सफलतापूर्वक सहेज ली गई/साझा कर दी गई।',
        'reportError': 'रिपोर्ट तैयार करने में विफल।',
        'latestReadings': 'नवीनतम रीडिंग',
        'mgL': 'mg/L',
        'ntu': 'NTU',
      },
    };

    return translations[language.language]?[key] ?? key;
  }

  String _periodText(
    LanguageProvider language,
    String period,
  ) {
    switch (period) {
      case 'Day':
        return _text(language, 'day');

      case 'Week':
        return _text(language, 'week');

      case 'Month':
        return _text(language, 'month');

      case 'Year':
        return _text(language, 'year');

      default:
        return period;
    }
  }

  // ================================================================
  // SAFE DOUBLE
  // ================================================================

  double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // ================================================================
  // CALCULATE WQI
  // ================================================================

  double _calculateWqi({
    required double tds,
    required double turbidity,
  }) {
    double score = 100;

    // TDS
    if (tds > 1000) {
      score -= 40;
    } else if (tds > 500) {
      score -= 25;
    } else if (tds > 300) {
      score -= 10;
    }

    // Turbidity
    if (turbidity > 5) {
      score -= 30;
    } else if (turbidity > 3) {
      score -= 15;
    } else if (turbidity > 1) {
      score -= 5;
    }

    return score.clamp(0, 100).toDouble();
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
      backgroundColor:
          JalRakshakTheme.backgroundLight,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,

        title: Text(
          _text(language, 'historyTrends'),

          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: JalRakshakTheme.textDark,
          ),
        ),

        actions: [
          IconButton(
            onPressed: _refreshHistory,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: historyFuture,

          builder: (
            context,
            snapshot,
          ) {
            // ======================================================
            // LOADING
            // ======================================================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),

                    const SizedBox(height: 12),

                    Text(
                      _text(
                        language,
                        'loading',
                      ),
                    ),
                  ],
                ),
              );
            }

            // ======================================================
            // ERROR
            // ======================================================

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.redAccent,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        _text(
                          language,
                          'error',
                        ),
                      ),

                      const SizedBox(height: 12),

                      ElevatedButton.icon(
                        onPressed: _refreshHistory,

                        icon: const Icon(
                          Icons.refresh,
                        ),

                        label: Text(
                          _text(
                            language,
                            'refresh',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final history =
                snapshot.data ?? [];

            // ======================================================
            // NO DATA
            // ======================================================

            if (history.isEmpty) {
              return Center(
                child: Text(
                  _text(
                    language,
                    'noData',
                  ),
                ),
              );
            }

            // ======================================================
            // SELECT RECORDS
            // ======================================================

            final records =
                _getRecordsForPeriod(
              history,
            );

            // ======================================================
            // BUILD SCREEN
            // ======================================================

            return RefreshIndicator(
              onRefresh: () async {
                _refreshHistory();
                await historyFuture;
              },

              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  4,
                  20,
                  24,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,

                  children: [
                    // =================================================
                    // PERIOD SELECTOR
                    // =================================================

                    _buildPeriodSelector(
                      language,
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // CHART
                    // =================================================

                    _buildChartCard(
                      language,
                      records,
                    ),

                    const SizedBox(height: 18),

                    // =================================================
                    // SUMMARY
                    // =================================================

                    _buildSummary(
                      language,
                      records,
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // READINGS
                    // =================================================

                    _buildReadings(
                      language,
                      records,
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // DOWNLOAD
                    // =================================================

                    _buildDownloadButton(
                      language,
                      records,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ================================================================
  // PERIOD SELECTOR
  // ================================================================

  Widget _buildPeriodSelector(
    LanguageProvider language,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(25),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: periods.map(
          (period) {
            final bool isSelected =
                selectedPeriod == period;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPeriod = period;
                  });
                },

                child: AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 200,
                  ),

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 9,
                  ),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? JalRakshakTheme.primaryBlue
                        : Colors.transparent,

                    borderRadius:
                        BorderRadius.circular(22),
                  ),

                  child: Text(
                    _periodText(
                      language,
                      period,
                    ),

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      fontSize: 11,

                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,

                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  // ================================================================
  // GET RECORDS FOR PERIOD
  // ================================================================

  List<Map<String, dynamic>>
      _getRecordsForPeriod(
    List<Map<String, dynamic>> history,
  ) {
    int count;

    switch (selectedPeriod) {
      case 'Day':
        count = 10;
        break;

      case 'Week':
        count = 30;
        break;

      case 'Month':
        count = 60;
        break;

      case 'Year':
        count = 100;
        break;

      default:
        count = 30;
    }

    return history.take(count).toList();
  }

  // ================================================================
  // CHART
  // ================================================================

  Widget _buildChartCard(
    LanguageProvider language,
    List<Map<String, dynamic>> records,
  ) {
    // We show the latest 7 readings on the graph.
    final chartRecords =
        records.take(7).toList().reversed.toList();

    final List<FlSpot> spots = [];

    for (int i = 0;
        i < chartRecords.length;
        i++) {
      final double tds =
          _toDouble(
        chartRecords[i]['tds_mg_L'],
      );

      final double turbidity =
          _toDouble(
        chartRecords[i]['turbidity_NTU'],
      );

      final double wqi =
          _calculateWqi(
        tds: tds,
        turbidity: turbidity,
      );

      spots.add(
        FlSpot(
          i.toDouble(),
          wqi,
        ),
      );
    }

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),

            blurRadius: 12,

            offset:
                const Offset(0, 4),
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
              'waterQualityScore',
            ),

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: JalRakshakTheme.textDark,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 190,

            child: LineChart(
              LineChartData(
                minX: 0,

                maxX: chartRecords.length <= 1
                    ? 1
                    : chartRecords.length - 1.0,

                minY: 0,

                maxY: 100,

                gridData: FlGridData(
                  show: true,

                  drawVerticalLine: false,

                  horizontalInterval: 25,

                  getDrawingHorizontalLine:
                      (value) {
                    return FlLine(
                      color:
                          Colors.grey.shade200,

                      strokeWidth: 1,
                    );
                  },
                ),

                borderData:
                    FlBorderData(
                  show: false,
                ),

                titlesData:
                    FlTitlesData(
                  topTitles:
                      const AxisTitles(
                    sideTitles:
                        SideTitles(
                      showTitles: false,
                    ),
                  ),

                  rightTitles:
                      const AxisTitles(
                    sideTitles:
                        SideTitles(
                      showTitles: false,
                    ),
                  ),

                  leftTitles:
                      AxisTitles(
                    sideTitles:
                        SideTitles(
                      showTitles: true,

                      reservedSize: 28,

                      interval: 25,

                      getTitlesWidget:
                          (value, meta) {
                        return Text(
                          value
                              .toInt()
                              .toString(),

                          style:
                              const TextStyle(
                            fontSize: 8,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles:
                      AxisTitles(
                    sideTitles:
                        SideTitles(
                      showTitles: true,

                      reservedSize: 20,

                      interval: 1,

                      getTitlesWidget:
                          (value, meta) {
                        return Text(
                          '#${value.toInt() + 1}',

                          style:
                              const TextStyle(
                            fontSize: 8,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: spots,

                    isCurved: true,

                    curveSmoothness:
                        0.25,

                    color:
                        JalRakshakTheme.primaryBlue,

                    barWidth: 2.5,

                    isStrokeCapRound: true,

                    dotData: FlDotData(
                      show: true,

                      getDotPainter:
                          (
                        spot,
                        percent,
                        bar,
                        index,
                      ) {
                        return FlDotCirclePainter(
                          radius: 2.5,

                          color:
                              JalRakshakTheme.primaryBlue,

                          strokeWidth: 0,
                        );
                      },
                    ),

                    belowBarData:
                        BarAreaData(
                      show: true,

                      color:
                          JalRakshakTheme.primaryBlue
                              .withOpacity(
                        0.08,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SUMMARY
  // ================================================================

  Widget _buildSummary(
    LanguageProvider language,
    List<Map<String, dynamic>> records,
  ) {
    if (records.isEmpty) {
      return const SizedBox.shrink();
    }

    double total = 0;

    for (final record in records) {
      final double tds =
          _toDouble(
        record['tds_mg_L'],
      );

      final double turbidity =
          _toDouble(
        record['turbidity_NTU'],
      );

      total += _calculateWqi(
        tds: tds,
        turbidity: turbidity,
      );
    }

    final double average =
        total / records.length;

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                _text(
                  language,
                  'averageScore',
                ),

                style:
                    const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                '${average.toStringAsFixed(0)}/100',

                style:
                    const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      JalRakshakTheme.textDark,
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [
              Text(
                _text(
                  language,
                  'readings',
                ),

                style:
                    const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                '${records.length}',

                style:
                    const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      JalRakshakTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // READINGS LIST
  // ================================================================

  Widget _buildReadings(
    LanguageProvider language,
    List<Map<String, dynamic>> records,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          _text(
            language,
            'latestReadings',
          ),

          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: JalRakshakTheme.textDark,
          ),
        ),

        const SizedBox(height: 10),

        ...records.take(10).map(
          (record) {
            final double tds =
                _toDouble(
              record['tds_mg_L'],
            );

            final double turbidity =
                _toDouble(
              record['turbidity_NTU'],
            );

            final double wqi =
                _calculateWqi(
              tds: tds,
              turbidity: turbidity,
            );

            return Container(
              margin:
                  const EdgeInsets.only(
                bottom: 8,
              ),

              padding:
                  const EdgeInsets.all(
                14,
              ),

              decoration:
                  BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,

                    decoration:
                        BoxDecoration(
                      color:
                          JalRakshakTheme
                              .primaryBlue
                              .withOpacity(
                        0.10,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),

                    child: const Icon(
                      Icons.water_drop_outlined,

                      color:
                          JalRakshakTheme
                              .primaryBlue,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          '${_text(language, 'tds')}: ${tds.toStringAsFixed(1)} ${_text(language, 'mgL')}',
                          style:
                              const TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          '${_text(language, 'turbidity')}: ${turbidity.toStringAsFixed(2)} ${_text(language, 'ntu')}',
                          style:
                              const TextStyle(
                            fontSize: 11,
                            color:
                                Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,

                    children: [
                      const Text(
                        'WQI',

                        style:
                            TextStyle(
                          fontSize: 9,
                          color:
                              Colors.grey,
                        ),
                      ),

                      Text(
                        wqi
                            .toStringAsFixed(
                          0,
                        ),

                        style:
                            const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              JalRakshakTheme
                                  .textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  // DOWNLOAD REPORT
  // ================================================================

  Widget _buildDownloadButton(
    LanguageProvider language,
    List<Map<String, dynamic>> records,
  ) {
    return SizedBox(
      width: 170,
      height: 38,

      child: ElevatedButton.icon(
        onPressed: () {
          _downloadReport(
            language,
            records,
          );
        },

        icon: const Icon(
          Icons.download_rounded,
          size: 15,
          color: Colors.white,
        ),

        label: Text(
          _text(
            language,
            'downloadReport',
          ),

          style:
              const TextStyle(
            fontSize: 11,
            fontWeight:
                FontWeight.bold,
            color: Colors.white,
          ),
        ),

        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              JalRakshakTheme.primaryBlue,

          foregroundColor:
              Colors.white,

          elevation: 0,

          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              8,
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // GENERATE AND SHARE REPORT (CSV)
  // ================================================================

  Future<void> _downloadReport(
    LanguageProvider language,
    List<Map<String, dynamic>> records,
  ) async {
    // Show a loading snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(_text(language, 'reportGenerating')),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      final StringBuffer csvBuffer = StringBuffer();
      
      // Headers
      csvBuffer.writeln('Push ID,Timestamp (Unix),Date & Time,TDS (mg/L),Turbidity (NTU),WQI');
      
      for (final record in records) {
        final double tds = _toDouble(record['tds_mg_L']);
        final double turbidity = _toDouble(record['turbidity_NTU']);
        final double wqi = _calculateWqi(tds: tds, turbidity: turbidity);
        final dynamic rawTimestamp = record['timestamp'];
        
        String formattedDate = '';
        if (rawTimestamp != null) {
          final int timestamp = int.tryParse(rawTimestamp.toString()) ?? 0;
          if (timestamp > 0) {
            final DateTime dt = timestamp > 100000000000
                ? DateTime.fromMillisecondsSinceEpoch(timestamp)
                : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            formattedDate = dt.toLocal().toString();
          }
        }
        
        csvBuffer.writeln(
          '${record['_id'] ?? ""},'
          '${rawTimestamp ?? ""},'
          '"$formattedDate",'
          '${tds.toStringAsFixed(1)},'
          '${turbidity.toStringAsFixed(2)},'
          '${wqi.toStringAsFixed(0)}'
        );
      }

      // Download and share report cross-platform
      await downloadAndShareReport(
        csvContent: csvBuffer.toString(),
        fileName: 'JalRakshak_Water_Quality_Report.csv',
        shareSubject: 'JalRakshak Water Quality Report',
        shareText: 'Here is the water quality report generated by JalRakshak.',
      );

      if (!mounted) return;

      // Hide the loading snackbar and show success
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_text(language, 'reportSavedSuccess')),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_text(language, 'reportError')}: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}