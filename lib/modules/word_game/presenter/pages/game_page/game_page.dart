import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/word_game_provider.dart';
import '../../widgets/vowel_button.dart';
import '../../widgets/word_display.dart';
import '../../widgets/feedback_overlay.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<WordGameProvider>(
            builder: (context, provider, child) {
              if (provider.currentWord == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeader(context, provider),
                        SizedBox(height: size.height * 0.05),
                        _buildProgressIndicator(context, provider),
                        SizedBox(height: size.height * 0.05),
                        _buildCategoryLabel(provider),
                        SizedBox(height: size.height * 0.03),
                        WordDisplay(word: provider.currentWord!),
                        const Spacer(),
                        _buildVowelButtons(context, provider),
                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WordGameProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.indigo),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text(
              provider.userMode == UserMode.teacher ? 'Modo Professor' : 'Modo Aluno',
              style: GoogleFonts.fredoka(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.indigo.shade700,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.indigo),
              onPressed: () => provider.restartGame(),
            ),
          ],
        ),
        _buildBleStatusBar(context, provider),
      ],
    );
  }

  Widget _buildBleStatusBar(BuildContext context, WordGameProvider provider) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: provider.isBleConnected ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                provider.isBleConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                color: provider.isBleConnected ? Colors.green.shade700 : Colors.red.shade700,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                provider.isBleConnected ? 'Dispositivo conectado' : 'Dispositivo desconectado',
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: provider.isBleConnected ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ],
          ),
          if (provider.isBleConnected)
            GestureDetector(
              onTap: () async {
                await provider.disconnectBle();
                Navigator.of(context).pop();
              },
              child: Text(
                'Desconectar',
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, WordGameProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso:',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: Colors.indigo.shade600,
              ),
            ),
            Text(
              '${provider.correctAnswers} palavras completas',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: Colors.indigo.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: provider.progressPercentage,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryLabel(WordGameProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Categoria: ${provider.currentWord!.category}',
        style: GoogleFonts.fredoka(
          fontSize: 16,
          color: Colors.indigo.shade700,
        ),
      ),
    );
  }

  Widget _buildVowelButtons(BuildContext context, WordGameProvider provider) {
    const vowels = ['A', 'E', 'I', 'O', 'U'];
    final lastVowel = provider.lastReceivedVowel.toUpperCase();
    final hasLastVowel = vowels.contains(lastVowel) && provider.isBleConnected;

    return Column(
      children: [
        if (hasLastVowel) _buildLastReceivedVowel(lastVowel),
        Text(
          'Escolha a vogal correta:',
          style: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.indigo.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: vowels.map((vowel) {
            final isHighlighted = vowel == lastVowel && hasLastVowel;

            return VowelButton(
              vowel: vowel,
              isHighlighted: isHighlighted,
              onPressed: () {
                if (provider.currentWord == null) return;

                final missingPositions = provider.currentWord!.getRemainingPositions();
                if (missingPositions.isNotEmpty) {
                  provider.tryVowel(vowel, missingPositions.first);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLastReceivedVowel(String vowel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bluetooth_audio,
            color: Colors.amber.shade800,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Vogal recebida: $vowel',
            style: GoogleFonts.fredoka(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
