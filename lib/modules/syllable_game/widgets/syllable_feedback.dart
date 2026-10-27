import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SyllableFeedback extends StatelessWidget {
  final String mensagem;
  final bool isCorrect;

  const SyllableFeedback({
    super.key,
    required this.mensagem,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFE8F5E8) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensagem,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
