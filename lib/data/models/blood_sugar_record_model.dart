class BloodSugarRecord {
  final double value;
  final DateTime timestamp;
  final String type; // 'normal', 'hypoglycemia', 'hyperglycemia'
  final String severity; // 'chronic', 'acute'

  BloodSugarRecord({
    required this.value,
    required this.timestamp,
    required this.type,
    required this.severity,
  });
}
