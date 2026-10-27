import 'package:flutter/material.dart';

/// Quantos níveis cada barra de emoção tem (Figma, tela 19).
const int niveisPorEmocao = 5;

/// As 5 emoções da tela "Como está se sentindo hoje?" (Figma, tela 19).
/// Cores medidas no PNG exportado do Figma.
enum Emocao {
  ansioso('Ansioso', '😰', Color(0xFFFF9600)),
  cansado('Cansado', '😫', Color(0xFFAF32FF)),
  bravo('Bravo', '😠', Color(0xFFE82837)),
  triste('Triste', '😢', Color(0xFF64AACC)),
  feliz('Feliz', '🙂', Color(0xFFFFCA28));

  const Emocao(this.nome, this.emoji, this.cor);

  final String nome;
  final String emoji;
  final Color cor;
}

/// Um registro do que a criança marcou, com data e hora.
/// É só registro: o app NÃO analisa nem interpreta o humor.
class RegistroHumor {
  final String estudanteId;
  final Map<Emocao, int> niveis; // 0 = não marcou; 1 a 5 = nível tocado
  final DateTime dataHora;

  const RegistroHumor({
    required this.estudanteId,
    required this.niveis,
    required this.dataHora,
  });
}
