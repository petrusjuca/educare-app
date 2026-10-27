import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SyllableGrid extends StatelessWidget {
  final List<String> silabas;
  final List<bool> silabasCompletadas;
  final int silabaAtual;
  final Function(String) onSelectSilaba;

  const SyllableGrid({
    super.key,
    required this.silabas,
    required this.silabasCompletadas,
    required this.silabaAtual,
    required this.onSelectSilaba,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: silabas.length,
        itemBuilder: (context, index) {
          final silaba = silabas[index];
          final isCompleted = silabasCompletadas[index];
          final isCurrent = index == silabaAtual;

          return GestureDetector(
            onTap: () => onSelectSilaba(silaba),
            child: Container(
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF4CAF50)
                    : isCurrent
                        ? const Color(0xFFFFEB3B)
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrent ? const Color(0xFFFFC107) : Colors.grey[300]!,
                  width: isCurrent ? 3 : 1,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFFC107).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      silaba,
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isCompleted
                            ? Colors.white
                            : isCurrent
                                ? Colors.black
                                : Colors.black87,
                      ),
                    ),
                    if (isCompleted)
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
