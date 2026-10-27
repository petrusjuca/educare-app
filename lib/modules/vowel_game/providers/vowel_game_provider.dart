import 'dart:async';
import 'package:flutter/material.dart';
import '../../ble/services/ble_service.dart';
import '../../../core/services/audio_service.dart';

/// Estados possíveis do feedback do jogo
enum FeedbackEstado { nenhum, correto, incorreto }

/// Modelo de uma rodada do jogo
class RodadaJogo {
  final String palavraComLacuna; // Ex: "C _ S _"
  final String vogalCorreta; // A, E, I, O, U
  final IconData iconeContexto; // Ícone de contexto (casa, animal, etc.)
  final String contextoTexto; // Texto descritivo do contexto

  const RodadaJogo({
    required this.palavraComLacuna,
    required this.vogalCorreta,
    required this.iconeContexto,
    required this.contextoTexto,
  });
}

/// Modelo de uma palavra do jogo
class PalavraJogo {
  final String palavraCompleta;
  final List<String> vogaisNecessarias;
  final IconData iconeContexto;
  final String contextoTexto;

  const PalavraJogo({
    required this.palavraCompleta,
    required this.vogaisNecessarias,
    required this.iconeContexto,
    required this.contextoTexto,
  });
}

/// Provider responsável pela lógica do jogo de vogais
class VowelGameProvider extends ChangeNotifier {
  // Flag para debug - permite toque nos botões
  static const bool habilitarToqueDebug = false;

  // Dependências
  final BleService _bleService;

  // Lista de palavras disponíveis
  final List<PalavraJogo> _palavras = [
    PalavraJogo(
      palavraCompleta: 'CASA',
      vogaisNecessarias: ['A', 'A'],
      iconeContexto: Icons.home,
      contextoTexto: 'Uma casa confortável',
    ),
    PalavraJogo(
      palavraCompleta: 'BOLA',
      vogaisNecessarias: ['O', 'A'],
      iconeContexto: Icons.sports_soccer,
      contextoTexto: 'Uma bola para brincar',
    ),
    PalavraJogo(
      palavraCompleta: 'FACA',
      vogaisNecessarias: ['A', 'A'],
      iconeContexto: Icons.restaurant,
      contextoTexto: 'Uma faca para cortar',
    ),
    PalavraJogo(
      palavraCompleta: 'MALA',
      vogaisNecessarias: ['A', 'A'],
      iconeContexto: Icons.work,
      contextoTexto: 'Uma mala para viagem',
    ),
    PalavraJogo(
      palavraCompleta: 'BOLO',
      vogaisNecessarias: ['O', 'O'],
      iconeContexto: Icons.cake,
      contextoTexto: 'Um bolo delicioso',
    ),
    PalavraJogo(
      palavraCompleta: 'UVA',
      vogaisNecessarias: ['U', 'A'],
      iconeContexto: Icons.restaurant_menu,
      contextoTexto: 'Uma uva suculenta',
    ),
    PalavraJogo(
      palavraCompleta: 'LINDA',
      vogaisNecessarias: ['I', 'A'],
      iconeContexto: Icons.favorite,
      contextoTexto: 'Algo muito bonito',
    ),
  ];

  // Estado do jogo
  int _palavraAtualIndex = 0;
  bool _estaProcessando = false;
  String _mensagemFeedback = '';
  bool _estaCorreto = false;
  String _vogalSelecionada = '';
  bool _mostrarFeedback = false;
  bool _mostrarBotaoProximo = false;
  FeedbackEstado _feedbackEstado = FeedbackEstado.nenhum;
  int _respostasTotais = 0;

  // Estado BLE
  bool _bleConectado = false;
  StreamSubscription? _bleSubscription;

  // Estado da palavra atual
  List<String> _vogaisCompletadas = [];
  bool _palavraCompleta = false;

  // Getters
  PalavraJogo get palavraAtual => _palavras[_palavraAtualIndex];
  int get currentRound => _palavraAtualIndex + 1;
  int get totalRounds => _palavras.length;
  int get correctAnswers => _vogaisCompletadas.length;
  int get totalAnswers => palavraAtual.vogaisNecessarias.length;
  String get currentWord => _construirPalavraAtual();
  List<String> get completedVowels => _vogaisCompletadas;
  String get currentVowel => _getProximaVogal();
  String get feedbackMessage => _mensagemFeedback;
  bool get isCorrect => _estaCorreto;
  String get selectedVowel => _vogalSelecionada;
  String get correctVowel => _getProximaVogal();
  bool get showFeedback => _mostrarFeedback;
  bool get showNextButton => _palavraCompleta && _palavraAtualIndex < _palavras.length - 1;
  int get rodadaAtual => _palavraAtualIndex;
  int get totalRodadas => _palavras.length;
  RodadaJogo? get rodadaAtualData => null; // Não usado mais
  String get preenchimentoAtual => '';
  FeedbackEstado get feedbackEstado => _feedbackEstado;
  bool get estaProcessando => _estaProcessando;
  bool get bleConectado => _bleConectado;
  bool get jogoFinalizado => _palavraCompleta && _palavraAtualIndex >= _palavras.length - 1;
  double get progresso => _vogaisCompletadas.length / palavraAtual.vogaisNecessarias.length;

  VowelGameProvider(this._bleService) {
    _inicializarJogo();
    _configurarBleListener();
  }

  /// Inicializa o jogo com a primeira palavra
  void _inicializarJogo() {
    _palavraAtualIndex = 0;
    _vogaisCompletadas = [];
    _palavraCompleta = false;
    _resetarEstadoRodada();
  }

  /// Constrói a palavra atual mostrando as vogais completadas
  String _construirPalavraAtual() {
    String resultado = '';
    int vogalIndex = 0;

    for (int i = 0; i < palavraAtual.palavraCompleta.length; i++) {
      String letra = palavraAtual.palavraCompleta[i];
      if ('AEIOUaeiou'.contains(letra)) {
        // É vogal
        if (vogalIndex < _vogaisCompletadas.length) {
          resultado += letra;
        } else {
          resultado += '_';
        }
        vogalIndex++;
      } else {
        // É consoante
        resultado += letra;
      }
    }

    return resultado;
  }

  /// Retorna a próxima vogal que precisa ser pressionada
  String _getProximaVogal() {
    if (_vogaisCompletadas.length < palavraAtual.vogaisNecessarias.length) {
      return palavraAtual.vogaisNecessarias[_vogaisCompletadas.length];
    }
    return '';
  }

  /// Configura o listener para eventos BLE
  void _configurarBleListener() {
    // Verifica estado inicial da conexão
    _bleConectado = _bleService.isConnected;

    // Escuta mudanças no estado da conexão
    _bleService.connectionStateStream.listen((conectado) {
      _bleConectado = conectado;
      notifyListeners();
    });

    // Escuta dados BLE (vogais pressionadas)
    _bleSubscription = _bleService.bleDataStream.listen((dados) {
      if (dados.containsKey('vogal')) {
        final vogal = dados['vogal'] as String;
        processarInputVogal(vogal);
      }
    });
  }

  /// Navega para seleção de dispositivo BLE
  void navegarParaSelecaoDispositivo(BuildContext context) {
    // TODO: Implementar navegação para página de seleção BLE
    // Por enquanto, apenas um placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegar para seleção de dispositivo BLE')),
    );
  }

  /// Processa toque no botão (apenas para debug)
  void processarToqueBotao(String vogal) {
    if (!habilitarToqueDebug) {
      // Mostra aviso para usar controle físico
      // (Será chamado do widget com context)
      return;
    }
    processarInputVogal(vogal);
  }

  /// Seleciona uma vogal (chamado da UI)
  void selectVowel(String vowel) {
    if (habilitarToqueDebug) {
      processarInputVogal(vowel);
    }
  }

  /// Processa input de vogal (BLE ou toque)
  void processarInputVogal(String vogal) {
    if (_estaProcessando || _palavraCompleta) return;

    final vogalCorreta = _getProximaVogal();
    if (vogal.toUpperCase() != vogalCorreta) {
      _mensagemFeedback = 'Pressione o botão $vogalCorreta! 🎯';
      _estaCorreto = false;
      _mostrarFeedback = true;
      notifyListeners();

      // Esconde feedback após delay
      Future.delayed(const Duration(seconds: 1), () {
        _mostrarFeedback = false;
        notifyListeners();
      });
      return;
    }

    _estaProcessando = true;
    _vogalSelecionada = vogal;
    _respostasTotais++;

    // Adiciona a vogal à lista de completadas
    _vogaisCompletadas.add(vogalCorreta);
    _estaCorreto = true;
    _mensagemFeedback = 'Excelente! Continue pressionando $vogalCorreta 🎉';

    // Toca o som da vogal
    AudioService().playVowel(vogalCorreta.toLowerCase());

    // Verifica se completou todas as vogais da palavra
    if (_vogaisCompletadas.length >= palavraAtual.vogaisNecessarias.length) {
      _palavraCompleta = true;
      _mensagemFeedback = 'Parabéns! Você completou ${palavraAtual.palavraCompleta}! ${palavraAtual.iconeContexto == Icons.home ? '🏠' : palavraAtual.iconeContexto == Icons.sports_soccer ? '⚽' : palavraAtual.iconeContexto == Icons.restaurant ? '🍴' : palavraAtual.iconeContexto == Icons.cake ? '🎂' : palavraAtual.iconeContexto == Icons.restaurant_menu ? '🍇' : palavraAtual.iconeContexto == Icons.favorite ? '💖' : '👜'}🎊';
      _mostrarBotaoProximo = true;

      // Toca o som da palavra completa
      AudioService().playWord(palavraAtual.palavraCompleta.toLowerCase());
    }

    _mostrarFeedback = true;
    notifyListeners();

    // Auto-esconde feedback após delay (exceto se palavra completa)
    if (!_palavraCompleta) {
      Future.delayed(const Duration(seconds: 1), () {
        _mostrarFeedback = false;
        _estaProcessando = false;
        notifyListeners();
      });
    } else {
      _estaProcessando = false;
    }
  }

  /// Reseta o estado da rodada atual
  void _resetarEstadoRodada() {
    _vogalSelecionada = '';
    _mensagemFeedback = '';
    _estaCorreto = false;
    _mostrarFeedback = false;
    _mostrarBotaoProximo = false;
    _estaProcessando = false;
  }

  /// Avança para a próxima rodada (próxima palavra)
  void nextRound() {
    if (_palavraCompleta && _palavraAtualIndex < _palavras.length - 1) {
      _palavraAtualIndex++;
      _vogaisCompletadas = [];
      _palavraCompleta = false;
      _resetarEstadoRodada();
      notifyListeners();
    }
  }

  /// Reinicia o jogo
  void reiniciarJogo() {
    _inicializarJogo();
    notifyListeners();
  }

  @override
  void dispose() {
    _bleSubscription?.cancel();
    super.dispose();
  }
}