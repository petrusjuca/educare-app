import 'package:flutter/material.dart';
import '../../../core/services/audio_service.dart';

/// Provider para gerenciar o estado da atividade "Formar sílabas"
class FormarSilabasProvider extends ChangeNotifier {
  final List<String> _syllables = ['CA', 'CE', 'CI', 'CO', 'CU'];
  int _currentIndex = 0;
  List<String> _options = [];
  String _feedbackMessage = '';
  bool _isCorrect = false;

  String get currentSyllable => _syllables[_currentIndex];
  List<String> get options => _options;
  String get feedbackMessage => _feedbackMessage;
  bool get isCorrect => _isCorrect;
  bool get canGoNext => _currentIndex < _syllables.length - 1;

  FormarSilabasProvider() {
    _generateOptions();
  }

  void _generateOptions() {
    final correct = currentSyllable;
    final allOptions = ['CA', 'CE', 'CI', 'CO', 'CU'];
    allOptions.remove(correct);
    allOptions.shuffle();
    _options = [correct, ...allOptions.take(2)]..shuffle();
  }

  void selectOption(String option) {
    _isCorrect = option == currentSyllable;
    if (_isCorrect) {
      _feedbackMessage = 'Correto! 🎉';
      AudioService().playSyllable(currentSyllable.toLowerCase());
    } else {
      _feedbackMessage = 'Tente novamente';
    }
    notifyListeners();
    // Limpar feedback após 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      _feedbackMessage = '';
      notifyListeners();
    });
  }

  void nextSyllable() {
    if (canGoNext) {
      _currentIndex++;
      _feedbackMessage = '';
      _generateOptions();
      notifyListeners();
    }
  }
}