import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedPeriod = 'Week';

  final List<String> periods = [
    'Day',
    'Week',
    'Month',
    'Year',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JalRakshakTheme.backgroundLight,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'History & Trends',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: JalRakshakTheme.textDark,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            4,
            20,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // =====================================================
              // TIME PERIOD SELECTOR
              // =====================================================

              _buildPeriodSelector(),

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

              _buildChartCard(),

              const SizedBox(height: 18),

              // =====================================================
              // SUMMARY
              // =====================================================

              _buildSummary(),

              const SizedBox(height: 20),

              // =====================================================
              // DOWNLOAD REPORT
              // =====================================================

              _buildDownloadButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // PERIOD SELECTOR
  // ================================================================

  Widget _buildPeriodSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? JalRakshakTheme.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
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
        }).toList(),
      ),
    );
  }

  // ================================================================
  // CHART CARD
  // ================================================================

  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        18,
        16,
        14,
      ),
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
          const Text(
            'Water Quality Score',
            style: TextStyle(
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
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),

                // --------------------------------------------------
                // BORDER
                // --------------------------------------------------

                borderData: FlBorderData(
                  show: false,
                ),

                // --------------------------------------------------
                // TITLES
                // --------------------------------------------------

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
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
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];

                        final index = value.toInt();

                        if (index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 6,
                          ),
                          child: Text(
                            days[index],
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
                      getDotPainter: (
                        spot,
                        percent,
                        bar,
                        index,
                      ) {
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
                      color: JalRakshakTheme.primaryBlue
                          .withOpacity(0.08),
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

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --------------------------------------------------------
          // AVERAGE SCORE
          // --------------------------------------------------------

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Average Score',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 3),

              Text(
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
            children: const [
              Text(
                'Trend',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 3),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_upward_rounded,
                    size: 14,
                    color: JalRakshakTheme.safeGreen,
                  ),

                  SizedBox(width: 3),

                  Text(
                    'Improving',
                    style: TextStyle(
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

  Widget _buildDownloadButton() {
    return SizedBox(
      width: 170,
      height: 38,
      child: ElevatedButton.icon(
        onPressed: () {
          _showReportMessage();
        },

        icon: const Icon(
          Icons.download_rounded,
          size: 15,
          color: Colors.white,
        ),

        label: const Text(
          'Download Report',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor:
              JalRakshakTheme.primaryBlue,

          foregroundColor: Colors.white,

          elevation: 0,

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // DOWNLOAD MESSAGE
  // ================================================================

  void _showReportMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Report generation will be available soon.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}