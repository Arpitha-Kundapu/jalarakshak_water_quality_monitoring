import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../providers/sensor_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the live data stream!
    final sensorStream = ref.watch(liveSensorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Added explicit color here
            Text('Hello, Team 👋', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: JalRakshakTheme.textDark)),
            Text('Live Water Status', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
      
      body: sensorStream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildWqiCard(data.wqi, data.status),
                const SizedBox(height: 20),
                _buildSensorRow(data.ph, data.tds, data.turbidity),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWqiCard(double wqi, String status) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'WATER QUALITY SCORE',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    wqi.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: JalRakshakTheme.textDark,
                    ),
                  ),
                  const Text(
                    '/100',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: wqi / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade200,
                  color: wqi >= 80
                      ? JalRakshakTheme.safeGreen
                      : JalRakshakTheme.warningOrange,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ],
          ),
          const Divider(height: 40, thickness: 1),
          Text(
            status,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: JalRakshakTheme.safeGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorRow(double ph, double tds, double turbidity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sensorBadge('pH', ph.toStringAsFixed(1), ''),
        _sensorBadge('TDS', tds.toStringAsFixed(0), 'ppm'),
        _sensorBadge('Turbidity', turbidity.toStringAsFixed(1), 'NTU'),
      ],
    );
  }

  Widget _sensorBadge(String title, String value, String unit) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: JalRakshakTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (unit.isNotEmpty)
                  Text(
                    ' $unit',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
