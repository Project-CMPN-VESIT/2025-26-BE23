import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final Color? textColor;
  final bool isLoading;

  const GlassButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.height = 56,
    this.borderRadius = 16,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnTap = isLoading ? null : onTap;

    return Opacity(
      opacity: isLoading ? 0.8 : 1,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: height,
        borderRadius: borderRadius,
        blur: 18,
        border: 1.2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.05),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: isLoading ? Colors.transparent : Colors.white24,
            highlightColor: isLoading ? Colors.transparent : Colors.white10,
            onTap: effectiveOnTap,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null)
                          Icon(
                            icon,
                            color: textColor ?? Colors.white,
                            size: 20,
                          ),
                        if (icon != null) const SizedBox(width: 8),
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor ?? Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
