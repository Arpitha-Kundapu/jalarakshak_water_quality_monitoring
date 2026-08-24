import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart' as language_provider;

import '../../core/theme.dart';
import '../providers/language_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedPeriod = 'Week';

  final List<String> periods = ['Day', 'Week', 'Month', 'Year'];

  // ================================================================
  // LANGUAGE
  // ================================================================

  String _text(LanguageProvider language, String key) {
    final Map<String, Map<String, String>> translations = {
      'English': {
        'historyTrends': 'History & Trends',
        'day': 'Day',
        'week': 'Week',
        'month': 'Month',
        'year': 'Year',
        'waterQualityScore': 'Water Quality Score',
        'mon': 'Mon',
        'tue': 'Tue',
        'wed': 'Wed',
        'thu': 'Thu',
        'fri': 'Fri',
        'sat': 'Sat',
        'sun': 'Sun',
        'averageScore': 'Average Score',
        'trend': 'Trend',
        'improving': 'Improving',
        'downloadReport': 'Download Report',
        'reportSoon': 'Report generation will be available soon.',
      },

      'ಕನ್ನಡ': {
        'historyTrends': 'ಇತಿಹಾಸ ಮತ್ತು ಪ್ರವೃತ್ತಿಗಳು',
        'day': 'ದಿನ',
        'week': 'ವಾರ',
        'month': 'ತಿಂಗಳು',
        'year': 'ವರ್ಷ',
        'waterQualityScore': 'ನೀರಿನ ಗುಣಮಟ್ಟದ ಸ್ಕೋರ್',
        'mon': 'ಸೋಮ',
        'tue': 'ಮಂಗಳ',
        'wed': 'ಬುಧ',
        'thu': 'ಗುರು',
        'fri': 'ಶುಕ್ರ',
        'sat': 'ಶನಿ',
        'sun': 'ಭಾನು',
        'averageScore': 'ಸರಾಸರಿ ಸ್ಕೋರ್',
        'trend': 'ಪ್ರವೃತ್ತಿ',
        'improving': 'ಸುಧಾರಿಸುತ್ತಿದೆ',
        'downloadReport': 'ವರದಿಯನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ',
        'reportSoon': 'ವರದಿ ರಚಿಸುವ ಸೌಲಭ್ಯ ಶೀಘ್ರದಲ್ಲೇ ಲಭ್ಯವಾಗಲಿದೆ.',
      },

      'हिन्दी': {
        'historyTrends': 'इतिहास और रुझान',
        'day': 'दिन',
        'week': 'सप्ताह',
        'month': 'महीना',
        'year': 'वर्ष',
        'waterQualityScore': 'पानी की गुणवत्ता का स्कोर',
        'mon': 'सोम',
        'tue': 'मंगल',
        'wed': 'बुध',
        'thu': 'गुरु',
        'fri': 'शुक्र',
        'sat': 'शनि',
        'sun': 'रवि',
        'averageScore': 'औसत स्कोर',
        'trend': 'रुझान',
        'improving': 'सुधार हो रहा है',
        'downloadReport': 'रिपोर्ट डाउनलोड करें',
        'reportSoon': 'रिपोर्ट बनाने की सुविधा जल्द उपलब्ध होगी।',
      },
    };

    return translations[language.language]?[key] ?? key;
  }

  String _periodText(LanguageProvider language, String period) {
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

  String _dayText(LanguageProvider language, int index) {
    final List<String> keys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

    return _text(language, keys[index]);
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final language = language_provider.Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: JalRakshakTheme.backgroundLight,

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
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // =====================================================
              // TIME PERIOD SELECTOR
              // =====================================================
              _buildPeriodSelector(language),

              const SizedBox(height: 14),

              // =====================================================
              // DATE RANGE
              // =====================================================
              const Text(
                '12 May - 18 May 2024',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // =====================================================
              // CHART CARD
              // =====================================================
              _buildChartCard(language),

              const SizedBox(height: 18),

              // =====================================================
              // SUMMARY
              // =====================================================
              _buildSummary(language),

              const SizedBox(height: 20),

              // =====================================================
              // DOWNLOAD REPORT
              // =====================================================
              _buildDownloadButton(language),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // PERIOD SELECTOR
  // ================================================================

  Widget _buildPeriodSelector(LanguageProvider language) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),

        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Row(
        children: periods.map((period) {
          final bool isSelected = selectedPeriod == period;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPeriod = period;
                });
              },

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                padding: const EdgeInsets.symmetric(vertical: 9),

                decoration: BoxDecoration(
                  color: isSelected
                      ? JalRakshakTheme.primaryBlue
                      : Colors.transparent,

                  borderRadius: BorderRadius.circular(22),
                ),

                child: Text(
                  _periodText(language, period),

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 11,

                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,

                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================================================================
  // CHART CARD
  // ================================================================

  Widget _buildChartCard(LanguageProvider language) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            _text(language, 'waterQualityScore'),

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
                maxX: 6,
                minY: 0,
                maxY: 100,

                // --------------------------------------------------
                // GRID
                // --------------------------------------------------
                gridData: FlGridData(
                  show: true,

                  drawVerticalLine: false,

                  horizontalInterval: 25,

                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),

                // --------------------------------------------------
                // BORDER
                // --------------------------------------------------
                borderData: FlBorderData(show: false),

                // --------------------------------------------------
                // TITLES
                // --------------------------------------------------
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      reservedSize: 28,

                      interval: 25,

                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),

                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      reservedSize: 24,

                      interval: 1,

                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index < 0 || index >= 7) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 6),

                          child: Text(
                            _dayText(language, index),

                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // --------------------------------------------------
                // LINE
                // --------------------------------------------------
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 60),
                      FlSpot(1, 75),
                      FlSpot(2, 70),
                      FlSpot(3, 76),
                      FlSpot(4, 72),
                      FlSpot(5, 88),
                      FlSpot(6, 84),
                    ],

                    isCurved: true,

                    curveSmoothness: 0.25,

                    color: JalRakshakTheme.primaryBlue,

                    barWidth: 2.5,

                    isStrokeCapRound: true,

                    // ------------------------------------------------
                    // POINTS
                    // ------------------------------------------------
                    dotData: FlDotData(
                      show: true,

                      getDotPainter: (spot, percent, bar, index) {
                        return FlDotCirclePainter(
                          radius: 2.5,

                          color: JalRakshakTheme.primaryBlue,

                          strokeWidth: 0,
                        );
                      },
                    ),

                    // ------------------------------------------------
                    // AREA BELOW GRAPH
                    // ------------------------------------------------
                    belowBarData: BarAreaData(
                      show: true,

                      color: JalRakshakTheme.primaryBlue.withOpacity(0.08),
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

  Widget _buildSummary(LanguageProvider language) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          // --------------------------------------------------------
          // AVERAGE SCORE
          // --------------------------------------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                _text(language, 'averageScore'),

                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),

              const SizedBox(height: 3),

              const Text(
                '84/100',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: JalRakshakTheme.textDark,
                ),
              ),
            ],
          ),

          // --------------------------------------------------------
          // TREND
          // --------------------------------------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Text(
                _text(language, 'trend'),

                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),

              const SizedBox(height: 3),

              Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Icon(
                    Icons.arrow_upward_rounded,
                    size: 14,
                    color: JalRakshakTheme.safeGreen,
                  ),

                  const SizedBox(width: 3),

                  Text(
                    _text(language, 'improving'),

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: JalRakshakTheme.safeGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================================
  // DOWNLOAD REPORT BUTTON
  // ================================================================

  Widget _buildDownloadButton(LanguageProvider language) {
    return SizedBox(
      width: 170,
      height: 38,

      child: ElevatedButton.icon(
        onPressed: () {
          _showReportMessage(language);
        },

        icon: const Icon(Icons.download_rounded, size: 15, color: Colors.white),

        label: Text(
          _text(language, 'downloadReport'),

          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: JalRakshakTheme.primaryBlue,

          foregroundColor: Colors.white,

          elevation: 0,

          padding: const EdgeInsets.symmetric(horizontal: 18),

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // ================================================================
  // DOWNLOAD MESSAGE
  // ================================================================

  void _showReportMessage(LanguageProvider language) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_text(language, 'reportSoon')),

        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
