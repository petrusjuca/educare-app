import 'package:flutter/material.dart';
import '../models/humor_model.dart';

/// Guarda o que a criança marcou na tela de humor.
/// Por enquanto fica só na memória: fechou o app, perdeu (ainda não há banco de dados).
class HumorProvider extends ChangeNotifier {
  // Aluno de teste (simulado) até existir login
  final String estudanteId = 'est1';
  final String nomeAluno = 'Ana';

  // Nível atual de cada emoção (todas começam em 0)
  final Map<Emocao, int> _niveis = {
    for (final emocao in Emocao.values) emocao: 0,
  };

  // Cada toque vira um registro novo (nunca apaga os anteriores)
  final List<RegistroHumor> _registros = [];

  int nivel(Emocao emocao) => _niveis[emocao]!;
  List<RegistroHumor> get registros => List.unmodifiable(_registros);

  /// A criança tocou no nível [nivel] da barra de [emocao].
  /// Tocar de novo no mesmo nível desmarca (volta para 0).
  void marcarNivel(Emocao emocao, int nivel) {
    _niveis[emocao] = (_niveis[emocao] == nivel) ? 0 : nivel;
    _registros.add(RegistroHumor(
      estudanteId: estudanteId,
      niveis: Map.of(_niveis),
      dataHora: DateTime.now(),
    ));
    notifyListeners();
  }
}
