import 'package:flutter/material.dart';
import '../../../../core/theme/educare_cores.dart';
import '../../../../core/theme/educare_textos.dart';
import '../../models/humor_model.dart';

/// Uma linha da tela de humor: nome da emoção, emoji e barra de 5 níveis.
class BarraEmocao extends StatelessWidget {
  final Emocao emocao;
  final int nivel; // 0 a 5
  final ValueChanged<int> aoTocarNivel;

  const BarraEmocao({
    super.key,
    required this.emocao,
    required this.nivel,
    required this.aoTocarNivel,
  });

  static const double _larguraEmoji = 56;
  // Maior que no Figma (34) de propósito: alvo de toque confortável para a criança
  static const double _alturaBarra = 44;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nome da emoção, alinhado com o começo da barra
        Padding(
          padding: const EdgeInsets.only(left: _larguraEmoji + 12),
          child: Text(
            emocao.nome,
            style: EducareTextos.rotuloHumor.copyWith(color: emocao.cor),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            SizedBox(
              width: _larguraEmoji,
              child: Text(
                emocao.emoji,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _barra()),
          ],
        ),
      ],
    );
  }

  // Barra cinza dividida em 5 pedaços; os pedaços até o nível ficam coloridos
  Widget _barra() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_alturaBarra / 2),
      child: SizedBox(
        height: _alturaBarra,
        child: Row(
          children: [
            for (int i = 1; i <= niveisPorEmocao; i++)
              Expanded(
                child: Semantics(
                  button: true,
                  label: '${emocao.nome}, nível $i de $niveisPorEmocao',
                  child: GestureDetector(
                    onTap: () => aoTocarNivel(i),
                    child: Container(
                      // linha branca entre os pedaços, como no Figma
                      margin: EdgeInsets.only(left: i == 1 ? 0 : 2),
                      color: i <= nivel ? emocao.cor : EducareCores.trilhoSlider,
                      alignment: Alignment.centerLeft,
                      // nível 0: só a "pontinha" colorida no começo da barra
                      child: (i == 1 && nivel == 0) ? _pontinha() : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _pontinha() {
    return Container(
      width: 22,
      decoration: BoxDecoration(
        color: emocao.cor,
        borderRadius: BorderRadius.circular(_alturaBarra / 2),
      ),
    );
  }
}
