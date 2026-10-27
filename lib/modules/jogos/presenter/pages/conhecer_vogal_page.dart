import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/audio_service.dart';
import '../../providers/conhecer_vogal_provider.dart';

/// Página para conhecer as vogais uma por vez
class ConhecerVogalPage extends StatelessWidget {
  const ConhecerVogalPage({super.key});

  static const bool habilitarToqueDebug = true; // Para testes sem hardware

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConhecerVogalProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Conhecer a vogal',
            style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<ConhecerVogalProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Toque para ouvir o som',
                    style: GoogleFonts.fredoka(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      AudioService().playVowel(provider.currentVowel.toLowerCase());
                      provider.showFeedback();
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          provider.currentVowel,
                          style: GoogleFonts.fredoka(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (provider.showFeedbackAnimation)
                    Text(
                      '🎉 Ótimo!',
                      style: GoogleFonts.fredoka(fontSize: 24, color: Colors.green),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: provider.canGoPrevious ? provider.previousVowel : null,
                        child: const Text('Anterior'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: provider.canGoNext ? provider.nextVowel : null,
                        child: const Text('Próximo'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}