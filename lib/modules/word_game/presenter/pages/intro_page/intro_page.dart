import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/word_game_provider.dart';
import '../game_page/game_page.dart';
import '../../../../ble/presenter/pages/device_selection_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building IntroPage widget...');
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),
                Text(
                  'Educare',
                  style: GoogleFonts.fredoka(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
                Text(
                  'Aprendendo Vogais',
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    color: Colors.indigo.shade600,
                  ),
                ),
                SizedBox(height: size.height * 0.08),
                Text(
                  'Escolha seu modo:',
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo.shade700,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildModeCard(
                      context,
                      'Professor(a)',
                      Icons.school,
                      Colors.indigo.shade700,
                      UserMode.teacher,
                    ),
                    _buildModeCard(
                      context,
                      'Aluno(a)',
                      Icons.pets,
                      Colors.orange.shade700,
                      UserMode.student,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Um aplicativo educativo para aprender vogais',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    color: Colors.indigo.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    UserMode mode,
  ) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        final provider = Provider.of<WordGameProvider>(context, listen: false);
        provider.setUserMode(mode);
        provider.initializeGame();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DeviceSelectionPage(),
          ),
        );
      },
      child: Container(
        width: size.width * 0.4,
        height: size.width * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
