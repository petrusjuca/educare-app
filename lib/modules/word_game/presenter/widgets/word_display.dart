import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/word_model.dart';

class WordDisplay extends StatelessWidget {
  final Word word;

  const WordDisplay({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final letters = word.currentState;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(letters.length, (index) {
              return _buildLetterBox(context, index, letters[index]);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterBox(BuildContext context, int index, String? letter) {
    final size = MediaQuery.of(context).size;
    final isVowel = letter == null;
    final boxSize = size.width * 0.15;
    
    return Container(
      width: boxSize,
      height: boxSize,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isVowel ? Colors.indigo.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isVowel ? Colors.indigo.shade300 : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          letter ?? '_',
          style: GoogleFonts.fredoka(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: isVowel ? Colors.indigo.shade300 : Colors.indigo.shade700,
          ),
        ),
      ),
    );
  }
}