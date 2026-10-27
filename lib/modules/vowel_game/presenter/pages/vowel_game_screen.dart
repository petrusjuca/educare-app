import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/vowel_game_provider.dart';
import '../../../ble/services/ble_service.dart';
import '../../widgets/vowel_button.dart';
import '../../widgets/word_display.dart';
import '../../widgets/game_progress_bar.dart';
import '../../widgets/ble_status_banner.dart';

class VowelGameScreen extends StatefulWidget {
  const VowelGameScreen({super.key});

  @override
  State<VowelGameScreen> createState() => _VowelGameScreenState();
}

class _VowelGameScreenState extends State<VowelGameScreen> with TickerProviderStateMixin {
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _feedbackAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Jogo das Vogais',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: Consumer<VowelGameProvider>(
        builder: (context, gameProvider, child) {
          final bleService = Provider.of<BleService>(context, listen: false);

          // Trigger feedback animation
          if (gameProvider.showFeedback) {
            _feedbackController.forward(from: 0.0);
          }

          return Column(
            children: [
              // BLE Status Banner
              StreamBuilder<bool>(
                stream: bleService.connectionStateStream,
                builder: (context, snapshot) {
                  final isConnected = snapshot.data ?? false;
                  return BleStatusBanner(
                    isConnected: isConnected,
                    deviceName: bleService.connectedDevice?.platformName ?? 'ESP32',
                  );
                },
              ),

              // Game Progress
              GameProgressBar(
                currentRound: gameProvider.currentRound,
                totalRounds: gameProvider.totalRounds,
                correctAnswers: gameProvider.correctAnswers,
                totalAnswers: gameProvider.totalAnswers,
              ),

              // Word Display
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: WordDisplay(
                  word: gameProvider.currentWord,
                  completedVowels: gameProvider.completedVowels,
                  currentVowel: gameProvider.currentVowel,
                ),
              ),

              // Context Display
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      gameProvider.palavraAtual.iconeContexto,
                      size: 40,
                      color: const Color(0xFF2196F3),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        gameProvider.palavraAtual.contextoTexto,
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Feedback Message
              gameProvider.feedbackMessage.isNotEmpty
                  ? AnimatedBuilder(
                      animation: _feedbackAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _feedbackAnimation.value,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: gameProvider.isCorrect ? const Color(0xFFE8F5E8) : const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: gameProvider.isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  gameProvider.isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: gameProvider.isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  gameProvider.feedbackMessage,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: gameProvider.isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink(),

              // Vowel Buttons
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: ['A', 'E', 'I', 'O', 'U'].map((vowel) {
                      final isSelected = gameProvider.selectedVowel == vowel;
                      final isCorrect = gameProvider.correctVowel == vowel && gameProvider.showFeedback;
                      final isIncorrect = isSelected && !gameProvider.isCorrect && gameProvider.showFeedback;

                      return VowelButton(
                        vowel: vowel,
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        isIncorrect: isIncorrect,
                        onPressed: () => gameProvider.selectVowel(vowel),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Next Round Button
              gameProvider.showNextButton
                  ? Container(
                      margin: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: gameProvider.nextRound,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Próxima Rodada',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}