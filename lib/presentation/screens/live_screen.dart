import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as language_provider;

import '../../core/theme.dart';
import '../providers/sensor_provider.dart';
import '../providers/language_provider.dart';

class LiveScreen extends ConsumerWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorStream = ref.watch(liveSensorProvider);

    final language = language_provider.Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),

        elevation: 0,

        automaticallyImplyLeading: false,

        centerTitle: true,

        title: Column(
          children: [
            Text(
              language.text('liveMonitoring'),

              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: JalRakshakTheme.textDark,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              language.text('realTimeSensorReadings'),

              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: sensorStream.when(
        // ----------------------------------------------------------
        // LOADING
        // ----------------------------------------------------------
        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: JalRakshakTheme.primaryBlue,
            ),
          );
        },

        // ----------------------------------------------------------
        // ERROR
        // ----------------------------------------------------------
        error: (error, stack) {
          return Center(
            child: Text(
              language.text('unableSensorData'),

              style: const TextStyle(
                color: JalRakshakTheme.dangerRed,

                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },

        // ----------------------------------------------------------
        // DATA
        // ----------------------------------------------------------
        data: (data) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(16, 2, 16, 22),

            child: Column(
              children: [
                // ==================================================
                // LIVE STATUS BAR
                // ==================================================
                _buildLiveStatus(language),

                const SizedBox(height: 14),

                // ==================================================
                // pH CARD
                // ==================================================
                _buildSensorCard(
                  title: 'pH',

                  value: data.ph.toStringAsFixed(1),

                  unit: '',

                  minY: 6.2,

                  maxY: 8.8,

                  graphMinLabel: '6.2',

                  graphMaxLabel: '8.8',

                  spots: _phSpots(data.ph),

                  lineColor: const Color(0xFF2E7DD7),

                  statusColor: _getPhColor(data.ph),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // TDS CARD
                // ==================================================
                _buildSensorCard(
                  title: 'TDS',

                  value: data.tds.toStringAsFixed(0),

                  unit: 'ppm',

                  minY: 0,

                  maxY: 900,

                  graphMinLabel: '0',

                  graphMaxLabel: '900',

                  spots: _tdsSpots(data.tds),

                  lineColor: const Color(0xFF39A95A),

                  statusColor: _getTdsColor(data.tds),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // TURBIDITY CARD
                // ==================================================
                _buildSensorCard(
                  title: language.text('turbidity'),

                  value: data.turbidity.toStringAsFixed(1),

                  unit: 'NTU',

                  minY: 0,

                  maxY: 12,

                  graphMinLabel: '0',

                  graphMaxLabel: '12',

                  spots: _turbiditySpots(data.turbidity),

                  lineColor: const Color(0xFFFF8C00),

                  statusColor: _getTurbidityColor(data.turbidity),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // UPDATE MESSAGE
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      size: 15,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      language.text('updatingEvery3Seconds'),

                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================================================================
  // LIVE STATUS
  // ================================================================

  Widget _buildLiveStatus(LanguageProvider language) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: const Color(0xFFE5EAF0)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),

            blurRadius: 10,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Text(
            language.text('liveStatus'),

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: JalRakshakTheme.textDark,
            ),
          ),

          const Spacer(),

          Container(
            width: 8,
            height: 8,

            decoration: const BoxDecoration(
              color: JalRakshakTheme.safeGreen,

              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            language.text('connected'),

            style: const TextStyle(
              fontSize: 12,
              color: JalRakshakTheme.safeGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SENSOR CARD
  // ================================================================

  Widget _buildSensorCard({
    required String title,
    required String value,
    required String unit,
    required double minY,
    required double maxY,
    required String graphMinLabel,
    required String graphMaxLabel,
    required List<FlSpot> spots,
    required Color lineColor,
    required Color statusColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFE7EBF0)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ========================================================
          // LEFT VALUE SECTION
          // ========================================================
          SizedBox(
            width: 82,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: JalRakshakTheme.textDark,
                        ),
                      ),
                    ),

                    if (unit.isNotEmpty)
                      Text(
                        ' ($unit)',

                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 30,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    color: JalRakshakTheme.textDark,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: 7,
                  height: 7,

                  decoration: BoxDecoration(
                    color: statusColor,

                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // ========================================================
          // GRAPH
          // ========================================================
          Expanded(
            child: SizedBox(
              height: 118,

              child: Column(
                children: [
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 7,

                        minY: minY,
                        maxY: maxY,

                        // ------------------------------------------
                        // GRID
                        // ------------------------------------------
                        gridData: FlGridData(
                          show: true,

                          drawVerticalLine: false,

                          horizontalInterval: _getGridInterval(minY, maxY),

                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: const Color(0xFFE5E9EE),

                              strokeWidth: 1,

                              dashArray: const [4, 4],
                            );
                          },
                        ),

                        // ------------------------------------------
                        // BORDER
                        // ------------------------------------------
                        borderData: FlBorderData(show: false),

                        // ------------------------------------------
                        // TITLES
                        // ------------------------------------------
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),

                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),

                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),

                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,

                              reservedSize: 18,

                              interval: 7,

                              getTitlesWidget: (value, meta) {
                                if (value == 0) {
                                  return Text(
                                    graphMinLabel,

                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  );
                                }

                                if (value == 7) {
                                  return Text(
                                    graphMaxLabel,

                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),

                        // ------------------------------------------
                        // TOUCH
                        // ------------------------------------------
                        lineTouchData: const LineTouchData(enabled: false),

                        // ------------------------------------------
                        // CLIP
                        // ------------------------------------------
                        clipData: const FlClipData.all(),

                        // ------------------------------------------
                        // LINE
                        // ------------------------------------------
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,

                            isCurved: true,

                            curveSmoothness: 0.35,

                            color: lineColor,

                            barWidth: 2.4,

                            isStrokeCapRound: true,

                            // --------------------------------------
                            // POINTS
                            // --------------------------------------
                            dotData: FlDotData(
                              show: true,

                              getDotPainter: (spot, percent, bar, index) {
                                final bool isLast = index == spots.length - 1;

                                return FlDotCirclePainter(
                                  radius: isLast ? 4.5 : 3,

                                  color: isLast ? Colors.white : lineColor,

                                  strokeWidth: isLast ? 2.5 : 0,

                                  strokeColor: lineColor,
                                );
                              },
                            ),

                            // --------------------------------------
                            // SHADED AREA
                            // --------------------------------------
                            belowBarData: BarAreaData(
                              show: true,

                              gradient: LinearGradient(
                                begin: Alignment.topCenter,

                                end: Alignment.bottomCenter,

                                colors: [
                                  lineColor.withOpacity(0.16),

                                  lineColor.withOpacity(0.025),
                                ],
                              ),
                            ),
                          ),
                        ],
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
  // GRID INTERVAL
  // ================================================================

  double _getGridInterval(double minY, double maxY) {
    final double range = maxY - minY;

    if (range <= 4) {
      return 0.5;
    }

    if (range <= 15) {
      return 2.5;
    }

    return 225;
  }

  // ================================================================
  // pH GRAPH
  // ================================================================

  List<FlSpot> _phSpots(double current) {
    final double safeCurrent = current.clamp(6.2, 8.8).toDouble();

    return [
      FlSpot(0, _clamp(safeCurrent - 0.38, 6.2, 8.8)),

      FlSpot(1, _clamp(safeCurrent - 0.12, 6.2, 8.8)),

      FlSpot(2, _clamp(safeCurrent + 0.22, 6.2, 8.8)),

      FlSpot(3, _clamp(safeCurrent - 0.08, 6.2, 8.8)),

      FlSpot(4, _clamp(safeCurrent + 0.30, 6.2, 8.8)),

      FlSpot(5, _clamp(safeCurrent + 0.08, 6.2, 8.8)),

      FlSpot(6, _clamp(safeCurrent - 0.18, 6.2, 8.8)),

      FlSpot(7, safeCurrent),
    ];
  }

  // ================================================================
  // TDS GRAPH
  // ================================================================

  List<FlSpot> _tdsSpots(double current) {
    final double safeCurrent = current.clamp(50, 900).toDouble();

    return [
      FlSpot(0, _clamp(safeCurrent - 70, 50, 900)),

      FlSpot(1, _clamp(safeCurrent - 25, 50, 900)),

      FlSpot(2, _clamp(safeCurrent + 65, 50, 900)),

      FlSpot(3, _clamp(safeCurrent - 45, 50, 900)),

      FlSpot(4, _clamp(safeCurrent + 90, 50, 900)),

      FlSpot(5, _clamp(safeCurrent + 35, 50, 900)),

      FlSpot(6, _clamp(safeCurrent - 20, 50, 900)),

      FlSpot(7, safeCurrent),
    ];
  }

  // ================================================================
  // TURBIDITY GRAPH
  // ================================================================

  List<FlSpot> _turbiditySpots(double current) {
    final double safeCurrent = current.clamp(0.2, 12.0).toDouble();

    return [
      FlSpot(0, _clamp(safeCurrent - 1.8, 0.2, 12.0)),

      FlSpot(1, _clamp(safeCurrent - 0.6, 0.2, 12.0)),

      FlSpot(2, _clamp(safeCurrent + 1.4, 0.2, 12.0)),

      FlSpot(3, _clamp(safeCurrent - 1.0, 0.2, 12.0)),

      FlSpot(4, _clamp(safeCurrent + 1.8, 0.2, 12.0)),

      FlSpot(5, _clamp(safeCurrent + 0.5, 0.2, 12.0)),

      FlSpot(6, _clamp(safeCurrent - 0.7, 0.2, 12.0)),

      FlSpot(7, safeCurrent),
    ];
  }

  // ================================================================
  // CLAMP
  // ================================================================

  double _clamp(double value, double minimum, double maximum) {
    return max(minimum, min(maximum, value));
  }

  // ================================================================
  // pH COLOR
  // ================================================================

  Color _getPhColor(double value) {
    if (value >= 6.5 && value <= 8.5) {
      return JalRakshakTheme.safeGreen;
    }

    return JalRakshakTheme.warningOrange;
  }

  // ================================================================
  // TDS COLOR
  // ================================================================

  Color _getTdsColor(double value) {
    if (value <= 300) {
      return JalRakshakTheme.safeGreen;
    }

    if (value <= 500) {
      return JalRakshakTheme.warningOrange;
    }

    return JalRakshakTheme.dangerRed;
  }

  // ================================================================
  // TURBIDITY COLOR
  // ================================================================

  Color _getTurbidityColor(double value) {
    if (value <= 1) {
      return JalRakshakTheme.safeGreen;
    }

    if (value <= 5) {
      return JalRakshakTheme.warningOrange;
    }

    return JalRakshakTheme.dangerRed;
  }
}
