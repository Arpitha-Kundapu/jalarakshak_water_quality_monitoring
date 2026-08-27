import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as language_provider;

import '/core/theme.dart';
import '/domain/entities/sensor_data.dart';
import '/presentation/providers/sensor_provider.dart';
import '/presentation/providers/language_provider.dart';

class LiveScreen extends ConsumerStatefulWidget {
  const LiveScreen({super.key});

  @override
  ConsumerState<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends ConsumerState<LiveScreen> {
  // ============================================================
  // REAL SENSOR HISTORY FOR LIVE GRAPHS
  // ============================================================

  final List<double> _phHistory = [];
  final List<double> _tdsHistory = [];
  final List<double> _turbidityHistory = [];

  static const int maxPoints = 8;

  // Prevent duplicate values from being added repeatedly.
  int? _lastTds;
  int? _lastTurbidity;

  @override
  Widget build(BuildContext context) {
    final sensorStream = ref.watch(liveSensorProvider);

    final language =
        language_provider.Provider.of<LanguageProvider>(context);

    // ============================================================
    // LISTEN FOR REAL SENSOR DATA
    // ============================================================

    ref.listen<AsyncValue<SensorData>>(
      liveSensorProvider,
      (previous, next) {
        next.whenData((data) {
          final int currentTds =
              (data.tds * 100).round();

          final int currentTurbidity =
              (data.turbidity * 100).round();

          // Only add a new graph point when the reading changes.
          if (_lastTds != currentTds ||
              _lastTurbidity != currentTurbidity) {
            _lastTds = currentTds;
            _lastTurbidity = currentTurbidity;

            setState(() {
              _addPoint(
                _phHistory,
                data.ph,
              );

              _addPoint(
                _tdsHistory,
                data.tds,
              );

              _addPoint(
                _turbidityHistory,
                data.turbidity,
              );
            });
          }
        });
      },
    );

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
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 45,
                  color: JalRakshakTheme.dangerRed,
                ),

                const SizedBox(height: 12),

                Text(
                  language.text('unableSensorData'),
                  style: const TextStyle(
                    color: JalRakshakTheme.dangerRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Check Firebase connection.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },

        // ----------------------------------------------------------
        // REAL DATA
        // ----------------------------------------------------------

        data: (data) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(
              16,
              2,
              16,
              22,
            ),

            child: Column(
              children: [

                // ==================================================
                // LIVE STATUS
                // ==================================================

                _buildLiveStatus(language),

                const SizedBox(height: 14),

                // ==================================================
                // pH
                // ==================================================

                _buildSensorCard(
                  title: 'pH',
                  value: data.ph.toStringAsFixed(1),
                  unit: '',
                  minY: 6.2,
                  maxY: 8.8,
                  graphMinLabel: '6.2',
                  graphMaxLabel: '8.8',
                  spots: _historyToSpots(
                    _phHistory,
                    fallback: data.ph,
                  ),
                  lineColor: const Color(0xFF2E7DD7),
                  statusColor: _getPhColor(data.ph),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // TDS
                // ==================================================

                _buildSensorCard(
                  title: 'TDS',
                  value: data.tds.toStringAsFixed(0),
                  unit: 'ppm',
                  minY: 0,
                  maxY: _getTdsMaxY(),
                  graphMinLabel: '0',
                  graphMaxLabel:
                      _formatGraphValue(_getTdsMaxY()),
                  spots: _historyToSpots(
                    _tdsHistory,
                    fallback: data.tds,
                  ),
                  lineColor: const Color(0xFF39A95A),
                  statusColor: _getTdsColor(data.tds),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // TURBIDITY
                // ==================================================

                _buildSensorCard(
                  title: language.text('turbidity'),
                  value: data.turbidity.toStringAsFixed(2),
                  unit: 'NTU',
                  minY: 0,
                  maxY: _getTurbidityMaxY(),
                  graphMinLabel: '0',
                  graphMaxLabel:
                      _formatGraphValue(
                    _getTurbidityMaxY(),
                  ),
                  spots: _historyToSpots(
                    _turbidityHistory,
                    fallback: data.turbidity,
                  ),
                  lineColor: const Color(0xFFFF8C00),
                  statusColor:
                      _getTurbidityColor(
                    data.turbidity,
                  ),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // UPDATE MESSAGE
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      size: 15,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      language.text(
                        'updatingEvery3Seconds',
                      ),
                      style: const TextStyle(
                        fontSize: 11,
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

  // ============================================================
  // ADD REAL READING TO HISTORY
  // ============================================================

  void _addPoint(
    List<double> history,
    double value,
  ) {
    history.add(value);

    if (history.length > maxPoints) {
      history.removeAt(0);
    }
  }

  // ============================================================
  // CONVERT REAL HISTORY TO FLSPOTS
  // ============================================================

  List<FlSpot> _historyToSpots(
    List<double> history, {
    required double fallback,
  }) {
    final values = history.isEmpty
        ? [fallback]
        : List<double>.from(history);

    final List<FlSpot> spots = [];

    for (int i = 0; i < values.length; i++) {
      spots.add(
        FlSpot(
          i.toDouble(),
          values[i],
        ),
      );
    }

    return spots;
  }

  // ============================================================
  // LIVE STATUS
  // ============================================================

  Widget _buildLiveStatus(
    LanguageProvider language,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFEAF7EE),

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: const Color(0xFFB9DFC3),
        ),

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

          // ========================================================
          // LIVE DOT
          // ========================================================

          Container(
            width: 8,
            height: 8,

            decoration: const BoxDecoration(
              color: Color(0xFF39A95A),
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 8),

          // ========================================================
          // LIVE TEXT
          // ========================================================

          const Text(
            'Live Sensor Data',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF236B37),
            ),
          ),

          const Spacer(),

          // ========================================================
          // LIVE LABEL
          // ========================================================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFF39A95A),
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Text(
              'LIVE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SENSOR CARD
  // ============================================================

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

      padding: const EdgeInsets.fromLTRB(
        14,
        16,
        14,
        12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFFE7EBF0),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ========================================================
          // VALUE
          // ========================================================

          SizedBox(
            width: 82,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              JalRakshakTheme
                                  .textDark,
                        ),
                      ),
                    ),

                    if (unit.isNotEmpty)
                      Text(
                        ' ($unit)',
                        style:
                            const TextStyle(
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
                    fontWeight:
                        FontWeight.w600,
                    color:
                        JalRakshakTheme.textDark,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: 7,
                  height: 7,

                  decoration:
                      BoxDecoration(
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

              child: LineChart(
                LineChartData(
                  minX: 0,

                  maxX: max(
                    1,
                    maxPoints - 1,
                  ).toDouble(),

                  minY: minY,
                  maxY: maxY,

                  // ==================================================
                  // GRID
                  // ==================================================

                  gridData: FlGridData(
                    show: true,

                    drawVerticalLine: false,

                    horizontalInterval:
                        _getGridInterval(
                      minY,
                      maxY,
                    ),

                    getDrawingHorizontalLine:
                        (value) {
                      return FlLine(
                        color:
                            const Color(
                          0xFFE5E9EE,
                        ),
                        strokeWidth: 1,
                        dashArray: const [
                          4,
                          4,
                        ],
                      );
                    },
                  ),

                  // ==================================================
                  // BORDER
                  // ==================================================

                  borderData:
                      FlBorderData(
                    show: false,
                  ),

                  // ==================================================
                  // TITLES
                  // ==================================================

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
                        const AxisTitles(
                      sideTitles:
                          SideTitles(
                        showTitles: false,
                      ),
                    ),

                    bottomTitles:
                        AxisTitles(
                      sideTitles:
                          SideTitles(
                        showTitles: true,

                        reservedSize: 18,

                        interval:
                            maxPoints - 1,

                        getTitlesWidget:
                            (value, meta) {
                          if (value == 0) {
                            return Text(
                              graphMinLabel,
                              style:
                                  const TextStyle(
                                fontSize: 8,
                                color:
                                    Colors.grey,
                              ),
                            );
                          }

                          if (value ==
                              maxPoints - 1) {
                            return Text(
                              graphMaxLabel,
                              style:
                                  const TextStyle(
                                fontSize: 8,
                                color:
                                    Colors.grey,
                              ),
                            );
                          }

                          return const SizedBox
                              .shrink();
                        },
                      ),
                    ),
                  ),

                  // ==================================================
                  // TOUCH
                  // ==================================================

                  lineTouchData:
                      const LineTouchData(
                    enabled: false,
                  ),

                  // ==================================================
                  // CLIP
                  // ==================================================

                  clipData:
                      const FlClipData.all(),

                  // ==================================================
                  // LINE
                  // ==================================================

                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,

                      isCurved: true,

                      curveSmoothness: 0.25,

                      color: lineColor,

                      barWidth: 2.4,

                      isStrokeCapRound: true,

                      // =================================================
                      // DOTS
                      // =================================================

                      dotData: FlDotData(
                        show: true,

                        getDotPainter:
                            (
                          spot,
                          percent,
                          bar,
                          index,
                        ) {
                          final bool
                              isLast =
                              index ==
                                  spots.length -
                                      1;

                          return FlDotCirclePainter(
                            radius:
                                isLast
                                    ? 4.5
                                    : 3,

                            color: isLast
                                ? Colors.white
                                : lineColor,

                            strokeWidth:
                                isLast
                                    ? 2.5
                                    : 0,

                            strokeColor:
                                lineColor,
                          );
                        },
                      ),

                      // =================================================
                      // AREA
                      // =================================================

                      belowBarData:
                          BarAreaData(
                        show: true,

                        gradient:
                            LinearGradient(
                          begin:
                              Alignment
                                  .topCenter,

                          end:
                              Alignment
                                  .bottomCenter,

                          colors: [
                            lineColor
                                .withOpacity(
                              0.16,
                            ),
                            lineColor
                                .withOpacity(
                              0.025,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRID INTERVAL
  // ============================================================

  double _getGridInterval(
    double minY,
    double maxY,
  ) {
    final double range =
        maxY - minY;

    if (range <= 4) {
      return 0.5;
    }

    if (range <= 15) {
      return 2.5;
    }

    if (range <= 100) {
      return 25;
    }

    if (range <= 500) {
      return 100;
    }

    return 225;
  }

  // ============================================================
  // TDS GRAPH MAXIMUM
  // ============================================================

  double _getTdsMaxY() {
    if (_tdsHistory.isEmpty) {
      return 900;
    }

    final double highest =
        _tdsHistory.reduce(max);

    if (highest <= 900) {
      return 900;
    }

    return (highest * 1.2)
        .ceilToDouble();
  }

  // ============================================================
  // TURBIDITY GRAPH MAXIMUM
  // ============================================================

  double _getTurbidityMaxY() {
    if (_turbidityHistory.isEmpty) {
      return 12;
    }

    final double highest =
        _turbidityHistory.reduce(max);

    if (highest <= 12) {
      return 12;
    }

    return (highest * 1.2)
        .ceilToDouble();
  }

  // ============================================================
  // GRAPH LABEL
  // ============================================================

  String _formatGraphValue(
    double value,
  ) {
    if (value >= 1000) {
      return value.toStringAsFixed(0);
    }

    if (value >= 100) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }

  // ============================================================
  // pH COLOR
  // ============================================================

  Color _getPhColor(
    double value,
  ) {
    if (value >= 6.5 &&
        value <= 8.5) {
      return JalRakshakTheme.safeGreen;
    }

    return JalRakshakTheme.warningOrange;
  }

  // ============================================================
  // TDS COLOR
  // ============================================================

  Color _getTdsColor(
    double value,
  ) {
    if (value <= 300) {
      return JalRakshakTheme.safeGreen;
    }

    if (value <= 500) {
      return JalRakshakTheme.warningOrange;
    }

    return JalRakshakTheme.dangerRed;
  }

  // ============================================================
  // TURBIDITY COLOR
  // ============================================================

  Color _getTurbidityColor(
    double value,
  ) {
    if (value <= 1) {
      return JalRakshakTheme.safeGreen;
    }

    if (value <= 5) {
      return JalRakshakTheme.warningOrange;
    }

    return JalRakshakTheme.dangerRed;
  }
}