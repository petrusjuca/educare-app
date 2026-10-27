import 'dart:async';
import 'package:flutter/material.dart';
import '../../ble/services/ble_service.dart';

/// Provider responsável pela lógica do jogo de sílabas
class SyllableGameProvider extends ChangeNotifier {
  final BleService _bleService;

  // Dados do jogo
  final List<String> _todasAsSilabas = [
    'CA', 'CE', 'CI', 'CO', 'CU',
    'BA', 'BE', 'BI', 'BO', 'BU',
    'DA', 'DE', 'DI', 'DO', 'DU',
    'FA', 'FE', 'FI', 'FO', 'FU',
    'GA', 'GE', 'GI', 'GO', 'GU',
    'LA', 'LE', 'LI', 'LO', 'LU',
    'MA', 'ME', 'MI', 'MO', 'MU',
    'NA', 'NE', 'NI', 'NO', 'NU',
    'PA', 'PE', 'PI', 'PO', 'PU',
    'RA', 'RE', 'RI', 'RO', 'RU',
    'SA', 'SE', 'SI', 'SO', 'SU',
    'TA', 'TE', 'TI', 'TO', 'TU',
    'VA', 'VE', 'VI', 'VO', 'VU',
    'ZA', 'ZE', 'ZI', 'ZO', 'ZU',
  ];

  // Estado do jogo
  int _silabaAtual = 0;
  List<bool> _silabasCompletadas = [];
  String _mensagemFeedback = '';
  bool _estaCorreto = false;
  bool _mostrarFeedback = false;
  int _totalAcertos = 0;
  bool _estaProcessando = false;
  StreamSubscription? _bleSubscription;
  bool _bleConectado = false;

  // Getters
  int get silabaAtual => _silabaAtual + 1;
  int get totalSilabas => _todasAsSilabas.length;
  String get silabaAtualTexto => _todasAsSilabas[_silabaAtual];
  List<String> get todasSilabas => _todasAsSilabas;
  List<bool> get silabasCompletadas => _silabasCompletadas;
  int get totalAcertos => _totalAcertos;
  double get progresso => _silabasCompletadas.where((c) => c).length / _todasAsSilabas.length;
  String get mensagemFeedback => _mensagemFeedback;
  bool get isCorrect => _estaCorreto;
  bool get showFeedback => _mostrarFeedback;
  bool get jogoCompleto => _silabasCompletadas.every((c) => c);
  bool get bleConectado => _bleConectado;

  SyllableGameProvider(this._bleService) {
    _inicializarJogo();
    _configurarBleListener();
  }

  /// Inicializa o jogo
  void _inicializarJogo() {
    _silabaAtual = 0;
    _silabasCompletadas = List<bool>.filled(_todasAsSilabas.length, false);
    _totalAcertos = 0;
    _mostrarFeedback = false;
    _estaProcessando = false;
  }

  /// Configura o listener para eventos BLE
  void _configurarBleListener() {
    _bleConectado = _bleService.isConnected;

    _bleService.connectionStateStream.listen((conectado) {
      _bleConectado = conectado;
      notifyListeners();
    });

    // Listener para dados de vogais da ESP32
    _bleSubscription = _bleService.bleDataStream.listen((dados) {
      if (dados.containsKey('vogal')) {
        final vogal = dados['vogal'] as String;
        _processarVogalSilaba(vogal);
      }
    });
  }

  /// Processa a vogal pressionada na ESP32
  void _processarVogalSilaba(String vogal) {
    if (_estaProcessando || jogoCompleto) return;

    final vogalCorreta = _todasAsSilabas[_silabaAtual][1]; // Última letra da sílaba
    
    if (vogal.toUpperCase() == vogalCorreta) {
      // Acertou!
      _silabasCompletadas[_silabaAtual] = true;
      _totalAcertos++;
      _estaCorreto = true;
      _mensagemFeedback = 'Excelente! ${_todasAsSilabas[_silabaAtual]} ✓';
      
      // Avança para próxima sílaba
      if (_silabaAtual < _todasAsSilabas.length - 1) {
        _silabaAtual++;
      }
    } else {
      // Errou
      _estaCorreto = false;
      _mensagemFeedback = 'Tente novamente! Letra: ${vogalCorreta}';
    }

    _mostrarFeedback = true;
    _estaProcessando = true;
    notifyListeners();

    // Esconde feedback após delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      _mostrarFeedback = false;
      _estaProcessando = false;
      notifyListeners();
    });
  }

  /// Seleciona uma sílaba (para debug/toque)
  void selecionarSilaba(String silaba) {
    if (silaba.length >= 2) {
      final vogal = silaba[1];
      _processarVogalSilaba(vogal);
    }
  }

  /// Reinicia o jogo
  void reiniciarJogo() {
    _inicializarJogo();
    notifyListeners();
  }

  /// Pula para sílaba específica
  void irParaSilaba(int index) {
    if (index >= 0 && index < _todasAsSilabas.length) {
      _silabaAtual = index;
      _mostrarFeedback = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _bleSubscription?.cancel();
    super.dispose();
  }
}
