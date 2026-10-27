import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/syllable_game_provider.dart';
import '../../../ble/services/ble_service.dart';
import '../../widgets/syllable_grid.dart';
import '../../widgets/syllable_progress.dart';
import '../../widgets/syllable_feedback.dart';

class SyllableGameScreen extends StatefulWidget {
  const SyllableGameScreen({super.key});

  @override
  State<SyllableGameScreen> createState() => _SyllableGameScreenState();
}

class _SyllableGameScreenState extends State<SyllableGameScreen> with TickerProviderStateMixin {
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _feedbackAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
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
          'Jogo das Sílabas',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: Consumer<SyllableGameProvider>(
        builder: (context, gameProvider, child) {
          final bleService = Provider.of<BleService>(context, listen: false);

          // Anima feedback quando necessário
          if (gameProvider.showFeedback) {
            _feedbackController.forward(from: 0.0);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Status BLE
                Container(
                  color: gameProvider.bleConectado ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bluetooth,
                        color: gameProvider.bleConectado ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        gameProvider.bleConectado ? 'ESP32 Conectada ✓' : 'ESP32 Desconectada ✗',
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          color: gameProvider.bleConectado ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Progresso do jogo
                SyllableProgress(
                  totalAcertos: gameProvider.totalAcertos,
                  totalSilabas: gameProvider.totalSilabas,
                  progresso: gameProvider.progresso,
                ),

                // Sílaba atual em grande
                Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Sílaba ${gameProvider.silabaAtual} de ${gameProvider.totalSilabas}',
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _feedbackAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _feedbackAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2196F3),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  gameProvider.silabaAtualTexto,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Feedback
                if (gameProvider.showFeedback)
                  SyllableFeedback(
                    mensagem: gameProvider.mensagemFeedback,
                    isCorrect: gameProvider.isCorrect,
                  ),

                // Grid de sílabas
                SyllableGrid(
                  silabas: gameProvider.todasSilabas,
                  silabasCompletadas: gameProvider.silabasCompletadas,
                  silabaAtual: gameProvider.silabaAtual,
                  onSelectSilaba: gameProvider.selecionarSilaba,
                ),

                // Botão de reiniciar (se jogo completo)
                if (gameProvider.jogoCompleto)
                  Container(
                    margin: const EdgeInsets.all(24),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: gameProvider.reiniciarJogo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Jogar Novamente 🎮',
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
