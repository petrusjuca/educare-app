import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameProgressBar extends StatelessWidget {
  final int currentRound;
  final int totalRounds;
  final int correctAnswers;
  final int totalAnswers;

  const GameProgressBar({
    super.key,
    required this.currentRound,
    required this.totalRounds,
    required this.correctAnswers,
    required this.totalAnswers,
  });

  @override
  Widget build(BuildContext context) {
    double progress = totalAnswers > 0 ? correctAnswers / totalAnswers : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Round indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rodada $currentRound de $totalRounds',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 0.8 ? const Color(0xFF4CAF50) : // Green for good progress
                  progress >= 0.6 ? const Color(0xFFFFC107) : // Yellow for medium progress
                  const Color(0xFFF44336), // Red for low progress
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Score text
          Text(
            '$correctAnswers/$totalAnswers corretas',
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}