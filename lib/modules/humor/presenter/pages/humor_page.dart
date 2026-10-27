import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/educare_cores.dart';
import '../../../../core/theme/educare_textos.dart';
import '../../../../core/widgets/cabecalho_educare.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CabecalhoEducare(titulo: 'Olá, ${humor.nomeAluno}!'),
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

/// "Como está se sentindo hoje?" + mascote
class _Pergunta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Como está se sentindo hoje?', style: EducareTextos.pergunta),
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
        color: EducareCores.branco,
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
