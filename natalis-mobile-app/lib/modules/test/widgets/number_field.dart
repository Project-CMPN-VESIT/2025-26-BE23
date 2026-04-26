import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:natalis_frontend/modules/test/widgets/number_picker.dart';

class NumberField extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 6),

        /// 👇 Height constrained
        SizedBox(
          height: 30, // 🔑 key fix
          width: 60,
          child: NumberPicker(
            minValue: 0,
            maxValue: 10,
            value: value,
            itemCount: 3,
            itemHeight: 36,
            itemWidth: 60,
            axis: Axis.vertical,
            infiniteLoop: true,
            onChanged: onChanged,
            textStyle: GoogleFonts.inter(fontSize: 14, color: Colors.white54),
            selectedTextStyle: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
