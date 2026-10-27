import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WordDisplay extends StatelessWidget {
  final String word;
  final List<String> completedVowels;
  final String currentVowel;

  const WordDisplay({
    super.key,
    required this.word,
    required this.completedVowels,
    required this.currentVowel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildWordLetters(),
      ),
    );
  }

  List<Widget> _buildWordLetters() {
    List<Widget> letters = [];
    List<String> wordLetters = word.split('');

    for (int i = 0; i < wordLetters.length; i++) {
      String letter = wordLetters[i];
      bool isVowel = 'AEIOUaeiou'.contains(letter);
      bool isCompleted = completedVowels.contains(letter.toUpperCase());
      bool isCurrent = letter.toUpperCase() == currentVowel;

      if (isVowel) {
        if (isCompleted) {
          // Show completed vowel
          letters.add(_buildLetterBox(letter.toUpperCase(), true, false));
        } else if (isCurrent) {
          // Show current vowel as placeholder
          letters.add(_buildLetterBox('_', false, true));
        } else {
          // Show placeholder for incomplete vowel
          letters.add(_buildLetterBox('_', false, false));
        }
      } else {
        // Show consonant
        letters.add(_buildLetterBox(letter.toUpperCase(), false, false));
      }

      // Add space between letters
      if (i < wordLetters.length - 1) {
        letters.add(const SizedBox(width: 8));
      }
    }

    return letters;
  }

  Widget _buildLetterBox(String letter, bool isCompleted, bool isCurrent) {
    Color backgroundColor;
    Color textColor;

    if (isCompleted) {
      backgroundColor = const Color(0xFF4CAF50); // Green for completed
      textColor = Colors.white;
    } else if (isCurrent) {
      backgroundColor = const Color(0xFFFFEB3B); // Yellow for current
      textColor = Colors.black;
    } else {
      backgroundColor = const Color(0xFFF5F5F5); // Light gray for consonants
      textColor = Colors.black;
    }

    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? const Color(0xFFFFC107) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}