class ComplicationRecord {
  final double value;
  final String type; // 'Hypoglycemia', 'Hyperglycemia'
  final String severity; // 'Chronic', 'Acute'
  final DateTime timestamp;

  ComplicationRecord({
    required this.value,
    required this.type,
    required this.severity,
    required this.timestamp,
  });
}
