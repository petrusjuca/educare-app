import 'package:flutter/material.dart';

/// Cores oficiais do Educare.
/// Fontes da verdade: EDUCARE/pedagogia/design/DESIGN_TOKENS.md e MAPA_CORES_BOTOES.md
/// Se o Figma mudar, muda lá primeiro e depois aqui. Nenhuma tela deve usar Color(0x...) solto.
class EducareCores {
  EducareCores._();

  // --- Base ---
  static const Color fundo = Color(0xFFF2F1EC); // fundo de todas as telas
  static const Color azulPrimario = Color(0xFF589DBC); // header, botões, bordas
  static const Color azulEscuro = Color(0xFF0C4B72); // títulos, botão ENTRAR
  static const Color azulClaro = Color(0xFF9EC6D8); // camada de trás do header/cards
  static const Color azulMedio = Color(0xFF64AACC); // ícones, cards ativos, nav
  static const Color rodape = Color(0xFF9ABAC9); // faixa do rodapé
  static const Color branco = Color(0xFFFFFFFF); // cards, texto sobre azul

  // --- Texto ---
  // O Figma usa 6 azuis de texto; até o Luis padronizar, o app usa só estes dois.
  static const Color textoPergunta = Color(0xFF1877A2); // "Como está se sentindo hoje?"
  static const Color textoTitulo = azulEscuro;

  // --- Formulário e barras ---
  static const Color campo = Color(0xFFD9D9D9);
  static const Color textoCampo = Color(0xFF727272);
  static const Color iconeCampo = Color(0xB33A88AC); // rgba(58,136,172,.7)
  static const Color trilhoSlider = Color(0xFFE7E7E7);
  static const Color trilhoProgresso = Color(0xFFE7E4E7);
  static const Color progresso = azulMedio;
  static const Color listraProgresso = Color(0xFFA7E4FF);
  static const Color bloqueadaBorda = Color(0xFFAFAFAF);
  static const Color bloqueadaFundo = Color(0xFFE5E5E5);

  // --- Semânticas (painel do professor) ---
  static const Color bom = Color(0xFF97CE52); // acima da média / ativo
  static const Color ruim = Color(0xFFE8524A); // precisa de reforço / inativo
  static const Color atencao = Color(0xFFEEC946); // alerta

  // --- Trilhas (barra, texto do %) ---
  static const Color trilha1 = Color(0xFF1787EF);
  static const Color trilha1Texto = Color(0xFF7EBEFA);
  static const Color trilha2 = Color(0xFF9C00FF);
  static const Color trilha2Texto = Color(0xFFD087FF);
  static const Color trilha3 = Color(0xFFEFBD17);
  static const Color trilha3Texto = Color(0xFFFFEDB2);

  // --- Botões do controle (MAPA_CORES_BOTOES.md) ---
  static const Color certo = Color(0xFF2E9E4F);
  static const Color errado = Color(0xFFE8524A);

  /// Cor de cada vogal: letra/borda, texto e fundo claro do card.
  static const Map<String, CorVogal> vogais = {
    'A': CorVogal(letra: Color(0xFFD8399E), texto: Color(0xFFD8399E), fundo: Color(0xFFF2B7E1)),
    'E': CorVogal(letra: Color(0xFFEBBA07), texto: Color(0xFFDEB00A), fundo: Color(0xFFFFEDAA)),
    'I': CorVogal(letra: Color(0xFF2F81CE), texto: Color(0xFF2F81CE), fundo: Color(0xFFADC7FE)),
    'O': CorVogal(letra: Color(0xFF74C015), texto: Color(0xFF68AC14), fundo: Color(0xFFC4F28A)),
    'U': CorVogal(letra: Color(0xFF9C00FF), texto: Color(0xFF9C00FF), fundo: Color(0xFFDAA1FF)),
  };

  // --- Humor (tela 19) ---
  // Medidas no PNG do Figma: ainda não estão no DESIGN_TOKENS.md (pedir ao Luis).
  static const Color humorAnsioso = Color(0xFFFF9600);
  static const Color humorCansado = Color(0xFFAF32FF);
  static const Color humorBravo = Color(0xFFE82837);
  static const Color humorTriste = Color(0xFF64AACC);
  static const Color humorFeliz = Color(0xFFFFCA28);
}

/// As cores de uma vogal.
class CorVogal {
  final Color letra; // letra e borda do card
  final Color texto; // quando a letra aparece como texto
  final Color fundo; // fundo claro do card

  const CorVogal({required this.letra, required this.texto, required this.fundo});
}
