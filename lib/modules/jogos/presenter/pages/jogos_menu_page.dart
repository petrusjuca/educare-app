import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/conhecer_vogal_page.dart';
import '../pages/formar_silabas_page.dart';
import '../pages/construir_palavras_page.dart';

/// Página de menu para seleção das fases do jogos
class JogosMenuPage extends StatelessWidget {
  const JogosMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jogos',
          style: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Escolha uma atividade:',
              style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildPhaseCard(
              context,
              'Conhecer a vogal',
              'Aprenda o som de cada vogal',
              Colors.blue.shade100,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConhecerVogalPage()),
              ),
            ),
            const SizedBox(height: 20),
            _buildPhaseCard(
              context,
              'Formar sílabas',
              'Reconheça e ouça sílabas',
              Colors.green.shade100,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormarSilabasPage()),
              ),
            ),
            const SizedBox(height: 20),
            _buildPhaseCard(
              context,
              'Construir palavras',
              'Complete palavras simples',
              Colors.orange.shade100,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConstruirPalavrasPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseCard(BuildContext context, String title, String subtitle, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.fredoka(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}