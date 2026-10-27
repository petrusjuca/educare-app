import 'package:flutter/material.dart';
import '../models/humor_model.dart';

/// Provider responsável pela lógica de entrada de humor
class HumorProvider extends ChangeNotifier {
  // ID do estudante atual (simulado)
  final String estudanteId = 'est1'; // Ana Silva

  // Estado atual da seleção de humor
  Humor? _humorSelecionado;
  double _intensidade = 0.5; // 50% por padrão
  bool _estaSalvando = false;

  // Histórico de humores (mockado)
  final List<EntradaHumor> _historicoHumores = [
    EntradaHumor(
      id: 'humor1',
      estudanteId: 'est1',
      humor: Humor.feliz,
      intensidade: 0.8,
      dataHora: DateTime.now().subtract(const Duration(hours: 2)),
      observacao: 'Aula de matemática foi divertida!',
    ),
    EntradaHumor(
      id: 'humor2',
      estudanteId: 'est1',
      humor: Humor.muitoFeliz,
      intensidade: 0.9,
      dataHora: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Getters
  Humor? get humorSelecionado => _humorSelecionado;
  double get intensidade => _intensidade;
  bool get estaSalvando => _estaSalvando;
  List<EntradaHumor> get historicoHumores => _historicoHumores;

  // Retorna o último humor registrado
  EntradaHumor? get ultimoHumor {
    if (_historicoHumores.isEmpty) return null;
    return _historicoHumores.first; // Assumindo que está ordenado por data decrescente
  }

  // Seleciona um humor
  void selecionarHumor(Humor humor) {
    _humorSelecionado = humor;
    notifyListeners();
  }

  // Ajusta a intensidade
  void ajustarIntensidade(double valor) {
    _intensidade = valor.clamp(0.0, 1.0);
    notifyListeners();
  }

  // Salva a entrada de humor
  Future<bool> salvarHumor({String? observacao}) async {
    if (_humorSelecionado == null) return false;

    _estaSalvando = true;
    notifyListeners();

    try {
      // Simula delay de salvamento
      await Future.delayed(const Duration(seconds: 1));

      // Cria nova entrada
      final novaEntrada = EntradaHumor(
        id: 'humor_${DateTime.now().millisecondsSinceEpoch}',
        estudanteId: estudanteId,
        humor: _humorSelecionado!,
        intensidade: _intensidade,
        dataHora: DateTime.now(),
        observacao: observacao,
      );

      // Adiciona ao histórico (no início para manter ordem decrescente)
      _historicoHumores.insert(0, novaEntrada);

      // Limpa seleção
      _humorSelecionado = null;
      _intensidade = 0.5;

      _estaSalvando = false;
      notifyListeners();

      return true;
    } catch (e) {
      _estaSalvando = false;
      notifyListeners();
      return false;
    }
  }

  // Limpa a seleção atual
  void limparSelecao() {
    _humorSelecionado = null;
    _intensidade = 0.5;
    notifyListeners();
  }
}