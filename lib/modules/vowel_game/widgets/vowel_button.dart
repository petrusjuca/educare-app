import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VowelButton extends StatelessWidget {
  final String vowel;
  final bool isSelected;
  final bool isCorrect;
  final bool isIncorrect;
  final VoidCallback onPressed;

  const VowelButton({
    super.key,
    required this.vowel,
    required this.isSelected,
    required this.isCorrect,
    required this.isIncorrect,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;
    Color borderColor;

    if (isCorrect) {
      backgroundColor = const Color(0xFF4CAF50); // Green for correct
      borderColor = const Color(0xFF388E3C);
    } else if (isIncorrect) {
      backgroundColor = const Color(0xFFF44336); // Red for incorrect
      borderColor = const Color(0xFFD32F2F);
    } else if (isSelected) {
      backgroundColor = const Color(0xFF2196F3); // Blue for selected
      borderColor = const Color(0xFF1976D2);
    } else {
      backgroundColor = const Color(0xFF9E9E9E); // Gray for unselected
      borderColor = const Color(0xFF757575);
    }

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            vowel,
            style: GoogleFonts.fredoka(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}