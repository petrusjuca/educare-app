import 'package:flutter/material.dart';

/// Provider para gerenciar o estado da atividade "Conhecer a vogal"
class ConhecerVogalProvider extends ChangeNotifier {
  final List<String> _vowels = ['A', 'E', 'I', 'O', 'U'];
  int _currentIndex = 0;
  bool _showFeedbackAnimation = false;

  String get currentVowel => _vowels[_currentIndex];
  bool get canGoNext => _currentIndex < _vowels.length - 1;
  bool get canGoPrevious => _currentIndex > 0;
  bool get showFeedbackAnimation => _showFeedbackAnimation;

  void nextVowel() {
    if (canGoNext) {
      _currentIndex++;
      _showFeedbackAnimation = false;
      notifyListeners();
    }
  }

  void previousVowel() {
    if (canGoPrevious) {
      _currentIndex--;
      _showFeedbackAnimation = false;
      notifyListeners();
    }
  }

  void showFeedback() {
    _showFeedbackAnimation = true;
    notifyListeners();
    // Esconder feedback após 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      _showFeedbackAnimation = false;
      notifyListeners();
    });
  }
}