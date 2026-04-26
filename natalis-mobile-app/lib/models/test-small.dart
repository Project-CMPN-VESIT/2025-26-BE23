// lib/features/tests/model/test_list_item.dart
class TestListItem {
  final String id;
  final String motherId;
  final String motherName;
  final String doctorName;
  final String testType; // enum as string
  final DateTime testTime; // parsed from Instant
  final String classification;
  final String trimester; // STRING (matches backend)
  final double gaWeeks; // STRING (matches backend)

  TestListItem({
    required this.id,
    required this.motherId,
    required this.motherName,
    required this.doctorName,
    required this.testType,
    required this.testTime,
    required this.classification,
    required this.trimester,
    required this.gaWeeks,
  });

  factory TestListItem.fromJson(Map<String, dynamic> json) {
    return TestListItem(
      id: json['id'] as String,
      motherId: json['motherId'] as String,
      motherName: json['motherName'] as String,
      doctorName: json['doctorName'] as String,
      testType: json['testType'] as String,
      testTime: DateTime.parse(json['testTime'] as String),
      classification: json['classification'] as String,
      trimester: json['trimester'] as String,
      gaWeeks: json['gaWeeks'] is String
          ? double.parse(json['gaWeeks'] as String)
          : (json['gaWeeks'] as num).toDouble(),
    );
  }
}
