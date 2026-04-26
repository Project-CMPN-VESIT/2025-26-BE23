class ScanResult {
  final double hcMm;
  final double? gaWeeks;
  final String classification;
  final String percentileBand;
  final String? edd;
  final String? trimester;
  final String? weeksRemaining;
  final String annotatedImageBase64;

  ScanResult({
    required this.hcMm,
    required this.gaWeeks,
    required this.classification,
    required this.percentileBand,
    required this.edd,
    required this.trimester,
    required this.weeksRemaining,
    required this.annotatedImageBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      "hcMm": hcMm,
      "gaWeeks": gaWeeks,
      "classification": classification,
      "percentileBand": percentileBand,
      "edd": edd,
      "trimester": trimester,
      "weeksRemaining": weeksRemaining,
      "annotatedImageBase64": annotatedImageBase64,
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      hcMm: (json['hcMm'] as num).toDouble(),
      gaWeeks: json['gaWeeks'] != null
          ? (json['gaWeeks'] as num).toDouble()
          : null,
      classification: json['classification'],
      percentileBand: json['percentileBand'],
      edd: json['edd'],
      trimester: json['trimester'],
      weeksRemaining: json['weeksRemaining'],
      annotatedImageBase64: json['annotatedImageBase64'],
    );
  }
}
