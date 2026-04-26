import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnnotatedScanViewer extends StatelessWidget {
  final String base64Image;

  const AnnotatedScanViewer({required this.base64Image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.memory(
          base64Decode(base64Image.split(',').last),
          fit: BoxFit.contain,
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.96, 0.96));
  }
}
