import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedPeriod = 'Week'; // Default toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Trends', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: JalRakshakTheme.textDark)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTimeToggle(),
            const SizedBox(height: 20),
            const Text('12 May - 18 May 2026', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            _buildChartCard(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // --- Time Period Toggle ---
  Widget _buildTimeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Day', 'Week', 'Month', 'Year'].map((period) {
          bool isActive = selectedPeriod == period;
          return GestureDetector(
            onTap: () => setState(() => selectedPeriod = period),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: isActive ? JalRakshakTheme.primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Interactive Fl_Chart ---
  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Water Quality Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 30),
          SizedBox(
            height: 220, // Height of the graph
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1)),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(days[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 12));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 25),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 60), FlSpot(1, 75), FlSpot(2, 65),
                      FlSpot(3, 85), FlSpot(4, 95), FlSpot(5, 88), FlSpot(6, 84),
                    ],
                    isCurved: true,
                    color: JalRakshakTheme.primaryBlue,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: JalRakshakTheme.primaryBlue.withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 40),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Average Score', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('84/100', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Trend', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('↑ Improving', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: JalRakshakTheme.safeGreen)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- Download Button ---
  Widget _buildActionButtons() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.download, color: Colors.white),
      label: const Text('Download Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: JalRakshakTheme.primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}