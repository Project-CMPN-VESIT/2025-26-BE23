import 'dart:typed_data';
import 'package:flutter/services.dart';

class SegmentationService {
  static const MethodChannel _channel = MethodChannel(
    "natalis.ai/segmentation",
  );

  static Future<List<double>> runModel(Uint8List imageBytes) async {
    final result = await _channel.invokeMethod("runModel", imageBytes);

    return List<double>.from(result);
  }
}
