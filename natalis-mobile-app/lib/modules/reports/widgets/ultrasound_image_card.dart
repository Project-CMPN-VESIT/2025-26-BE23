import 'dart:convert';

import 'package:flutter/material.dart';

class UltrasoundImageCard extends StatelessWidget {
  final String base64;

  const UltrasoundImageCard({super.key, required this.base64});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.memory(
          base64Decode(base64.split(',').last),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
