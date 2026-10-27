import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/educare_cores.dart';
import '../../models/humor_model.dart';
import '../../providers/humor_provider.dart';
import '../widgets/barra_emocao.dart';

/// Tela "Como está se sentindo hoje?" (Figma, tela 19_humor.png).
/// A criança marca de 0 a 5 em cada emoção; cada toque é registrado.
class HumorPage extends StatelessWidget {
  const HumorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final humor = context.watch<HumorProvider>();

    return Scaffold(
      backgroundColor: EducareCores.fundo,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Cabecalho(titulo: 'Olá, ${humor.nomeAluno}!'),
            // No tablet, o conteúdo não estica além de 640 px
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                  child: Column(
                    children: [
                      _Pergunta(),
                      const SizedBox(height: 32),
                      _CartaoEmocoes(humor: humor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Header azul em duas camadas (padrão "card de dupla camada" do DESIGN_TOKENS)
class _Cabecalho extends StatelessWidget {
  final String titulo;
  const _Cabecalho({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: EducareCores.azulClaro,
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        color: EducareCores.azulPrimario,
        padding: EdgeInsets.fromLTRB(
            24, MediaQuery.of(context).padding.top + 48, 24, 40),
        // Mesma largura máxima do conteúdo, para o título alinhar no tablet
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 592),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                titulo,
                style: GoogleFonts.nunito(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Como está se sentindo hoje?" + mascote
class _Pergunta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Como está se sentindo hoje?',
            style: GoogleFonts.nunito(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: EducareCores.textoPergunta,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // PROVISÓRIO: recortado do PNG do Figma até o Luis exportar o mascote
        Image.asset(
          'assets/images/mascote_neutro_provisorio.png',
          width: 110,
          semanticLabel: 'Mascote do Educare',
        ),
      ],
    );
  }
}

/// Cartão branco com as 5 emoções
class _CartaoEmocoes extends StatelessWidget {
  final HumorProvider humor;
  const _CartaoEmocoes({required this.humor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          for (final emocao in Emocao.values) ...[
            BarraEmocao(
              emocao: emocao,
              nivel: humor.nivel(emocao),
              aoTocarNivel: (nivel) => humor.marcarNivel(emocao, nivel),
            ),
            if (emocao != Emocao.values.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
