import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:natalis_frontend/models/scan_result.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:natalis_frontend/core/network/api_client.dart';

class ScanService {
  final ApiClient apiClient;

  ScanService(this.apiClient);

  Future<ScanResult> uploadAndAnalyzeScan({
    required File imageFile,
    String race = "Hispanic",
    double pixelSizeMm = 0.5,
    required DateTime scanDate,
  }) async {
    try {
      log("Sending req to model");
      final response = await apiClient.multipartPost(
        '/api/analyze_image',
        file: imageFile,
        fileFieldName: 'image',
        fields: {
          "race": race,
          "pixel_size_mm": pixelSizeMm.toString(),
          "scan_date": scanDate.toIso8601String().split("T").first,
        },
      );

      final json = response.data;
      log(json.toString());

      if (json["status"] != "success") {
        throw Exception(json["error"] ?? "Unknown analysis error");
      }

      final String imageString = json["annotated_image_base64"];

      // final annotatedImageBase64 = await _fetchAnnotatedImage(imageId);

      return ScanResult(
        hcMm: (json["hc_mm"] as num).toDouble(),
        gaWeeks: json["ga_weeks"] != null
            ? (json["ga_weeks"] as num).toDouble()
            : null,
        classification: json["classification"],
        percentileBand: json["percentile_band"],
        edd: json["edd"],
        trimester: json["trimester"],
        weeksRemaining: json["weeks_remaining"],
        annotatedImageBase64: imageString,
      );
    } catch (e) {
      throw Exception("Scan analysis failed: $e");
    }
  }

  // Future<String> _fetchAnnotatedImage(String imageId) async {
  //   final response = await apiClient.get('/api/get_annotated_image/$imageId');

  //   final json = response.data;
  //   log("json received");

  //   if (json["image_base64"] == null) {
  //     throw Exception("Invalid annotated image response");
  //   }

  //   return json["image_base64"];
  // }
}
