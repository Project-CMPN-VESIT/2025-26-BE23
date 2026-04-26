import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int current;
  final int count;

  const PageIndicator({super.key, required this.current, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: current == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: current == index
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
