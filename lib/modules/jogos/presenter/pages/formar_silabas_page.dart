import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/audio_service.dart';
import '../../providers/formar_silabas_provider.dart';

/// Página para formar sílabas com reconhecimento e som
class FormarSilabasPage extends StatelessWidget {
  const FormarSilabasPage({super.key});

  static const bool habilitarToqueDebug = true; // Para testes sem hardware

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormarSilabasProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Formar sílabas',
            style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<FormarSilabasProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selecione a sílaba correta:',
                    style: GoogleFonts.fredoka(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    provider.currentSyllable,
                    style: GoogleFonts.fredoka(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: provider.options.map((option) {
                      return ElevatedButton(
                        onPressed: () => provider.selectOption(option),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          option,
                          style: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  if (provider.feedbackMessage.isNotEmpty)
                    Text(
                      provider.feedbackMessage,
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        color: provider.isCorrect ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: provider.canGoNext ? provider.nextSyllable : null,
                    child: const Text('Próxima sílaba'),
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