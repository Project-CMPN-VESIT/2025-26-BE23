class TestModel {
  final String id;
  final String motherId;
  final String motherName;
  final String doctorId;
  final String doctorName;
  final String organizationId;

  final String testType;
  final DateTime testTime;

  final double hcMm;
  final double gaWeeks;
  final String classification;
  final String percentileBand;
  final String edd;

  final String trimester;
  final String weeksRemaining;

  final String annotatedImageBase64;
  final Map<String, dynamic>? additionalResults;

  TestModel({
    required this.id,
    required this.motherId,
    required this.motherName,
    required this.doctorId,
    required this.doctorName,
    required this.organizationId,
    required this.testType,
    required this.testTime,
    required this.hcMm,
    required this.gaWeeks,
    required this.classification,
    required this.percentileBand,
    required this.edd,
    required this.trimester,
    required this.weeksRemaining,
    required this.annotatedImageBase64,
    required this.additionalResults,
  });

  /* =========================
     FROM JSON
     ========================= */

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'],
      motherId: json['motherId'],
      motherName: json['motherName'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'] ?? "Dr. Ved Waje",
      organizationId: json['organizationId'],
      testType: json['testType'],
      testTime: DateTime.parse(json['testTime']),
      hcMm: (json['hcMm'] as num).toDouble(),
      gaWeeks: (json['gaWeeks'] as num).toDouble(),
      classification: json['classification'],
      percentileBand: json['percentileBand'],
      edd: json['edd'],
      trimester: json['trimester'],
      weeksRemaining: json['weeksRemaining'],
      annotatedImageBase64: json['annotatedImageBase64'],
      additionalResults: json['additionalResults'] != null
          ? Map<String, dynamic>.from(json['additionalResults'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'motherId': motherId,
      'motherName': motherName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'organizationId': organizationId,
      'testType': testType,
      'testTime': testTime.toIso8601String(),
      'hcMm': hcMm,
      'gaWeeks': gaWeeks,
      'classification': classification,
      'percentileBand': percentileBand,
      'edd': edd,
      'trimester': trimester,
      'weeksRemaining': weeksRemaining,
      'annotatedImageBase64': annotatedImageBase64,
      'additionalResults': additionalResults,
    };
  }
}
