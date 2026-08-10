import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Treatments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Active Warnings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: JalRakshakTheme.textDark)),
            const SizedBox(height: 15),
            _buildWarningCard(
              title: 'Water is NOT SAFE for Drinking',
              subtitle: 'Multiple parameters exceed BIS limits.',
              icon: Icons.warning_amber_rounded,
              color: JalRakshakTheme.dangerRed,
            ),
            const SizedBox(height: 30),
            const Text('AI Treatment Suggestions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: JalRakshakTheme.textDark)),
            const SizedBox(height: 15),
            _buildTreatmentCard(
              title: 'High TDS Detected (> 500 ppm)',
              description: 'Use Reverse Osmosis (RO) filter to remove excess dissolved minerals.',
              icon: Icons.filter_alt_outlined,
            ),
            const SizedBox(height: 15),
            _buildTreatmentCard(
              title: 'High Turbidity Detected (> 5 NTU)',
              description: 'Use Sedimentation, Sand Filtration, or Alum to clear physical impurities.',
              icon: Icons.water_drop_outlined,
            ),
            const SizedBox(height: 15),
            _buildTreatmentCard(
              title: 'pH Imbalance Detected',
              description: 'Use pH correction drops (alkaline or acidic neutralizers).',
              icon: Icons.science_outlined,
            ),
          ],
        ),
      ),
    );
  }

  // --- Top Warning Banner ---
  Widget _buildWarningCard({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(subtitle, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- AI Prescription Cards ---
  Widget _buildTreatmentCard({required String title, required String description, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: JalRakshakTheme.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: JalRakshakTheme.primaryBlue),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 5),
                Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}