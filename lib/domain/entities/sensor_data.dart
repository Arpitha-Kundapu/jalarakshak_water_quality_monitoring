class SensorData {
  final double wqi;
  final double ph;
  final double tds;
  final double turbidity;
  final String status;

  SensorData({
    required this.wqi,
    required this.ph,
    required this.tds,
    required this.turbidity,
    required this.status,
  });
}