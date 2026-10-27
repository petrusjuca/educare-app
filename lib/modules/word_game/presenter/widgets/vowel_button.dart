import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VowelButton extends StatelessWidget {
  final String vowel;
  final VoidCallback onPressed;
  final bool isHighlighted;

  const VowelButton({
    super.key,
    required this.vowel,
    required this.onPressed,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonSize = size.width * 0.15;

    // Different colors for different vowels
    final Map<String, Color> vowelColors = {
      'A': Colors.red.shade400,
      'E': Colors.green.shade400,
      'I': Colors.blue.shade400,
      'O': Colors.orange.shade400,
      'U': Colors.purple.shade400,
    };

    final color = vowelColors[vowel.toUpperCase()] ?? Colors.indigo.shade400;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isHighlighted ? buttonSize * 1.1 : buttonSize,
        height: isHighlighted ? buttonSize * 1.1 : buttonSize,
        decoration: BoxDecoration(
          color: isHighlighted ? color.withOpacity(0.3) : color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color,
            width: isHighlighted ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isHighlighted ? color.withOpacity(0.5) : color.withOpacity(0.3),
              blurRadius: isHighlighted ? 8 : 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                vowel.toUpperCase(),
                style: GoogleFonts.fredoka(
                  fontSize: isHighlighted ? 36 : 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            if (isHighlighted)
              Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.bluetooth_audio,
                  color: color,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
