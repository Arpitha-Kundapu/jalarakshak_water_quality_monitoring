import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../domain/entities/sensor_data.dart';
import '../providers/sensor_provider.dart';

class LiveScreen extends ConsumerWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorStream = ref.watch(liveSensorProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        automaticallyImplyLeading: false,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Monitoring',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: JalRakshakTheme.textDark,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Real-time sensor readings',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),

      body: sensorStream.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: JalRakshakTheme.primaryBlue,
          ),
        ),

        error: (error, stack) => Center(
          child: Text(
            'Unable to receive sensor data',
            style: TextStyle(
              color: JalRakshakTheme.dangerRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              14,
              4,
              14,
              20,
            ),

            child: Column(
              children: [
                // ==================================================
                // LIVE STATUS
                // ==================================================

                _buildLiveStatus(),

                const SizedBox(height: 14),

                // ==================================================
                // pH
                // ==================================================

                _buildSensorCard(
                  title: 'pH',
                  value: data.ph.toStringAsFixed(1),
                  unit: '',
                  minY: 6,
                  maxY: 9,
                  graphMinLabel: '0',
                  graphMaxLabel: '14',
                  spots: _phSpots(data.ph),
                  lineColor: const Color(0xFF2E7DD7),
                  status: _getPhStatus(data.ph),
                  statusColor: _getPhColor(data.ph),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // TDS
                // ==================================================

                _buildSensorCard(
                  title: 'TDS',
                  value: data.tds.toStringAsFixed(0),
                  unit: 'ppm',
                  minY: 0,
                  maxY: 600,
                  graphMinLabel: '0',
                  graphMaxLabel: '2000',
                  spots: _tdsSpots(data.tds),
                  lineColor: const Color(0xFF55A66A),
                  status: _getTdsStatus(data.tds),
                  statusColor: _getTdsColor(data.tds),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // TURBIDITY
                // ==================================================

                _buildSensorCard(
                  title: 'Turbidity',
                  value: data.turbidity.toStringAsFixed(1),
                  unit: 'NTU',
                  minY: 0,
                  maxY: 6,
                  graphMinLabel: '0',
                  graphMaxLabel: '10',
                  spots: _turbiditySpots(data.turbidity),
                  lineColor: const Color(0xFFFFA726),
                  status: _getTurbidityStatus(data.turbidity),
                  statusColor: _getTurbidityColor(data.turbidity),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // UPDATE MESSAGE
                // ==================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.sync_rounded,
                      size: 13,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Updating every 3 seconds',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
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

  Widget _buildLiveStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),

        border: Border.all(
          color: const Color(0xFFE8ECF2),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          const Text(
            'Live Status',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: JalRakshakTheme.textDark,
            ),
          ),

          const Spacer(),

          Container(
            width: 7,
            height: 7,

            decoration: const BoxDecoration(
              color: JalRakshakTheme.safeGreen,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 5),

          const Text(
            'Connected',
            style: TextStyle(
              fontSize: 11,
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
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        12,
        12,
        10,
        8,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),

        border: Border.all(
          color: const Color(0xFFE9EDF2),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ========================================================
          // TITLE
          // ========================================================

          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: JalRakshakTheme.textDark,
                ),
              ),

              if (unit.isNotEmpty)
                Text(
                  ' ($unit)',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: JalRakshakTheme.textDark,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          // ========================================================
          // VALUE + GRAPH
          // ========================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // VALUE
              SizedBox(
                width: 70,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 25,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        color: JalRakshakTheme.textDark,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      width: 5,
                      height: 5,

                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              // GRAPH
              Expanded(
                child: SizedBox(
                  height: 76,

                  child: Column(
                    children: [
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: 7,
                            minY: minY,
                            maxY: maxY,

                            gridData: const FlGridData(
                              show: false,
                            ),

                            borderData: FlBorderData(
                              show: false,
                            ),

                            titlesData: const FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                            ),

                            lineTouchData: const LineTouchData(
                              enabled: false,
                            ),

                            clipData: const FlClipData.all(),

                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,

                                isCurved: true,

                                curveSmoothness: 0.25,

                                color: lineColor,

                                barWidth: 1.7,

                                isStrokeCapRound: true,

                                dotData: const FlDotData(
                                  show: false,
                                ),

                                belowBarData: BarAreaData(
                                  show: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // =================================================
                      // GRAPH AXIS LABELS
                      // =================================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            graphMinLabel,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.grey,
                            ),
                          ),

                          Text(
                            graphMaxLabel,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
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
  // pH GRAPH
  // ================================================================

  List<FlSpot> _phSpots(double current) {
    final double safeCurrent =
        current.clamp(6.2, 8.8).toDouble();

    return [
      FlSpot(0, _clamp(safeCurrent - 0.20, 6.2, 8.8)),
      FlSpot(1, _clamp(safeCurrent - 0.05, 6.2, 8.8)),
      FlSpot(2, _clamp(safeCurrent + 0.10, 6.2, 8.8)),
      FlSpot(3, _clamp(safeCurrent - 0.02, 6.2, 8.8)),
      FlSpot(4, _clamp(safeCurrent + 0.12, 6.2, 8.8)),
      FlSpot(5, _clamp(safeCurrent - 0.12, 6.2, 8.8)),
      FlSpot(6, _clamp(safeCurrent - 0.20, 6.2, 8.8)),
      FlSpot(7, safeCurrent),
    ];
  }

  // ================================================================
  // TDS GRAPH
  // ================================================================

  List<FlSpot> _tdsSpots(double current) {
    final double safeCurrent =
        current.clamp(50, 550).toDouble();

    return [
      FlSpot(0, _clamp(safeCurrent - 45, 50, 550)),
      FlSpot(1, _clamp(safeCurrent - 20, 50, 550)),
      FlSpot(2, _clamp(safeCurrent + 20, 50, 550)),
      FlSpot(3, _clamp(safeCurrent - 15, 50, 550)),
      FlSpot(4, _clamp(safeCurrent + 30, 50, 550)),
      FlSpot(5, _clamp(safeCurrent + 5, 50, 550)),
      FlSpot(6, _clamp(safeCurrent - 10, 50, 550)),
      FlSpot(7, safeCurrent),
    ];
  }

  // ================================================================
  // TURBIDITY GRAPH
  // ================================================================

  List<FlSpot> _turbiditySpots(double current) {
    final double safeCurrent =
        current.clamp(0.2, 5.5).toDouble();

    return [
      FlSpot(
        0,
        _clamp(safeCurrent - 0.4, 0.2, 5.5),
      ),
      FlSpot(
        1,
        _clamp(safeCurrent + 0.3, 0.2, 5.5),
      ),
      FlSpot(
        2,
        _clamp(safeCurrent + 0.1, 0.2, 5.5),
      ),
      FlSpot(
        3,
        _clamp(safeCurrent - 0.3, 0.2, 5.5),
      ),
      FlSpot(
        4,
        _clamp(safeCurrent + 0.4, 0.2, 5.5),
      ),
      FlSpot(
        5,
        _clamp(safeCurrent + 0.2, 0.2, 5.5),
      ),
      FlSpot(
        6,
        _clamp(safeCurrent - 0.1, 0.2, 5.5),
      ),
      FlSpot(7, safeCurrent),
    ];
  }

  // ================================================================
  // CLAMP HELPER
  // ================================================================
double _clamp(
  double value,
  double minimum,
  double maximum,
) {
  return max(
    minimum,
    min(maximum, value),
  );
}

  // ================================================================
  // pH STATUS
  // ================================================================

  String _getPhStatus(double value) {
    if (value >= 6.5 && value <= 8.5) {
      return 'Normal';
    }

    return 'Check';
  }

  Color _getPhColor(double value) {
    if (value >= 6.5 && value <= 8.5) {
      return JalRakshakTheme.safeGreen;
    }

    return JalRakshakTheme.warningOrange;
  }

  // ================================================================
  // TDS STATUS
  // ================================================================

  String _getTdsStatus(double value) {
    if (value <= 300) {
      return 'Good';
    }

    if (value <= 500) {
      return 'Moderate';
    }

    return 'High';
  }

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
  // TURBIDITY STATUS
  // ================================================================

  String _getTurbidityStatus(double value) {
    if (value <= 1) {
      return 'Excellent';
    }

    if (value <= 5) {
      return 'Good';
    }

    return 'High';
  }

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