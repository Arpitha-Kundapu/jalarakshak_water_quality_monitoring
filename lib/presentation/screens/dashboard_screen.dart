import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../domain/entities/sensor_data.dart';
import '../providers/sensor_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        toolbarHeight: 82,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Team 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: JalRakshakTheme.textDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Live Water Status',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
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
                  const Text(
                    'Unable to receive sensor data',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
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
              padding: const EdgeInsets.fromLTRB(
                20,
                5,
                20,
                25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // LIVE STATUS
                  // ==================================================

                  _buildLiveStatus(),

                  const SizedBox(height: 18),

                  // ==================================================
                  // WQI CARD
                  // ==================================================

                  _buildWqiCard(
                    data.wqi,
                    data.status,
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // WATER PARAMETERS
                  // ==================================================

                  const Text(
                    'Water Parameters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: JalRakshakTheme.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildSensorGrid(
                    data.ph,
                    data.tds,
                    data.turbidity,
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // WATER CLASSIFICATION
                  // ==================================================

                  _buildClassificationCard(data),

                  const SizedBox(height: 18),

                  // ==================================================
                  // AI WATER ALERT
                  // ==================================================

                  _buildAiAlertCard(data),

                  const SizedBox(height: 22),

                  // ==================================================
                  // LAST UPDATED
                  // ==================================================

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.sync_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Sensor data updates every 3 seconds',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: JalRakshakTheme.safeGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: JalRakshakTheme.safeGreen.withOpacity(0.25),
        ),
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
          const Expanded(
            child: Text(
              'ESP32 Sensor Connected',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: JalRakshakTheme.textDark,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: JalRakshakTheme.safeGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'LIVE',
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
  // WQI CARD
  // ================================================================

  Widget _buildWqiCard(
    double wqi,
    String status,
  ) {
    final bool isSafe = wqi >= 80;

    final Color statusColor = isSafe
        ? JalRakshakTheme.safeGreen
        : JalRakshakTheme.warningOrange;

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
          const Text(
            'WATER QUALITY SCORE',
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
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
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
                        Icon(
                          isSafe
                              ? Icons.check_circle_rounded
                              : Icons.warning_rounded,
                          color: statusColor,
                          size: 25,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isSafe ? 'GOOD' : 'CHECK',
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

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSafe
                    ? Icons.verified_rounded
                    : Icons.warning_rounded,
                size: 21,
                color: statusColor,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _buildSensorGrid(
    double ph,
    double tds,
    double turbidity,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSensorCard(
                title: 'pH Level',
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
                title: 'Turbidity',
                value: turbidity.toStringAsFixed(1),
                unit: 'NTU',
                icon: Icons.opacity_outlined,
                color: JalRakshakTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSensorCard(
                title: 'Monitoring',
                value: 'LIVE',
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
                child: Icon(
                  icon,
                  size: 21,
                  color: color,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.more_horiz,
                color: Colors.grey,
                size: 20,
              ),
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
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
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
  // WATER CLASSIFICATION
  // ================================================================

  Widget _buildClassificationCard(
    SensorData data,
  ) {
    String category;
    String description;
    IconData icon;
    Color color;

    if (data.wqi >= 90) {
      category = 'Drinking Water';

      description =
          'Water quality is excellent and suitable for drinking after normal treatment.';

      icon = Icons.local_drink_rounded;

      color = JalRakshakTheme.safeGreen;
    } else if (data.wqi >= 80) {
      category = 'Good Quality';

      description =
          'Water quality is good and suitable for most household uses.';

      icon = Icons.water_drop_rounded;

      color = JalRakshakTheme.safeGreen;
    } else if (data.wqi >= 60) {
      category = 'Irrigation / Cleaning';

      description =
          'Water may be suitable for irrigation or cleaning purposes.';

      icon = Icons.grass_rounded;

      color = JalRakshakTheme.warningOrange;
    } else {
      category = 'Critical';

      description =
          'Water requires treatment before use. Do not consume directly.';

      icon = Icons.warning_rounded;

      color = JalRakshakTheme.dangerRed;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 27,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WATER CLASSIFICATION',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  category,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    height: 1.3,
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
  // AI WATER ALERT
  // ================================================================

  Widget _buildAiAlertCard(
    SensorData data,
  ) {
    final bool highTds = data.tds > 500;
    final bool highTurbidity = data.turbidity > 5;
    final bool phAbnormal =
        data.ph < 6.5 || data.ph > 8.5;
    final bool criticalWater = data.wqi < 60;

    String title;
    String message;
    String recommendation;
    IconData icon;
    Color color;

    // --------------------------------------------------------------
    // CRITICAL WATER
    // --------------------------------------------------------------

    if (criticalWater) {
      title = 'AI Alert: Water Requires Treatment';

      message =
          'The current water quality score is below the safe range.';

      recommendation =
          'Avoid direct consumption and check the recommended treatment.';

      icon = Icons.warning_rounded;

      color = JalRakshakTheme.dangerRed;
    }

    // --------------------------------------------------------------
    // HIGH TDS
    // --------------------------------------------------------------

    else if (highTds) {
      title = 'AI Alert: High TDS Detected';

      message =
          'The dissolved solids level is above the recommended range.';

      recommendation =
          'Consider RO or suitable filtration before drinking.';

      icon = Icons.filter_alt_rounded;

      color = JalRakshakTheme.warningOrange;
    }

    // --------------------------------------------------------------
    // HIGH TURBIDITY
    // --------------------------------------------------------------

    else if (highTurbidity) {
      title = 'AI Alert: High Turbidity';

      message =
          'The water contains a high level of suspended particles.';

      recommendation =
          'Consider sedimentation and filtration before use.';

      icon = Icons.opacity_rounded;

      color = JalRakshakTheme.warningOrange;
    }

    // --------------------------------------------------------------
    // pH PROBLEM
    // --------------------------------------------------------------

    else if (phAbnormal) {
      title = 'AI Alert: pH Imbalance';

      message =
          'The measured pH is outside the expected range.';

      recommendation =
          'Check the water source and consider pH correction.';

      icon = Icons.science_rounded;

      color = JalRakshakTheme.warningOrange;
    }

    // --------------------------------------------------------------
    // SAFE
    // --------------------------------------------------------------

    else {
      title = 'AI Water Analysis: Safe';

      message =
          'No major abnormality has been detected in the current readings.';

      recommendation =
          'Continue monitoring the water quality regularly.';

      icon = Icons.auto_awesome_rounded;

      color = JalRakshakTheme.safeGreen;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.25),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================================
          // AI HEADER
          // ==========================================================

          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.auto_awesome,
                          size: 14,
                          color:
                              JalRakshakTheme.primaryBlue,
                        ),

                        SizedBox(width: 5),

                        Text(
                          'AI ANALYSIS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color:
                                JalRakshakTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ==========================================================
          // MESSAGE
          // ==========================================================

          Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              color: JalRakshakTheme.textDark,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 8),

          // ==========================================================
          // RECOMMENDATION
          // ==========================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: color,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    recommendation,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}