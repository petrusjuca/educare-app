import 'package:flutter/material.dart';
import '../../../vowel_game/presenter/pages/vowel_game_screen.dart';

/// Página para construir palavras simples (usa a tela existente do jogo de vogais)
class ConstruirPalavrasPage extends StatelessWidget {
  const ConstruirPalavrasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VowelGameScreen();
  }
}