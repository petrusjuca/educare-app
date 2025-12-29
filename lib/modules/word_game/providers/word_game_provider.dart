import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/models/word_model.dart';
import '../../ble/services/ble_service.dart';

enum UserMode { teacher, student }

class WordGameProvider extends ChangeNotifier {
  WordGameProvider() {
    // Initialize the game
    initializeGame();
  }

  // Game state
  UserMode _userMode = UserMode.student;
  Word? _currentWord;
  List<Word> _words = [];
  int _currentWordIndex = 0;
  int _correctAnswers = 0;
  int _incorrectAttempts = 0;
  bool _showFeedback = false;
  bool _isCorrectFeedback = false;
  String _feedbackMessage = '';

  // BLE state
  final BleService _bleService = BleService();
  StreamSubscription? _vowelSubscription;
  bool _isBleConnected = false;
  String _lastReceivedVowel = '';

  // Getters for game state
  UserMode get userMode => _userMode;
  Word? get currentWord => _currentWord;
  int get correctAnswers => _correctAnswers;
  int get incorrectAttempts => _incorrectAttempts;
  bool get showFeedback => _showFeedback;
  bool get isCorrectFeedback => _isCorrectFeedback;
  String get feedbackMessage => _feedbackMessage;
  bool get isGameComplete => _words.isNotEmpty && _currentWordIndex >= _words.length;
  double get progressPercentage => _words.isEmpty ? 0 : _currentWordIndex / _words.length;

  // Getters for BLE state
  bool get isBleConnected => _isBleConnected;
  String get lastReceivedVowel => _lastReceivedVowel;

  void initializeGame() {
    // Initialize game state
    _words = [
      Word.fromString('CASA', 'Lugares'),
      Word.fromString('BOLA', 'Objetos'),
      Word.fromString('GATO', 'Animais'),
      Word.fromString('PATO', 'Animais'),
      Word.fromString('MESA', 'Objetos'),
      Word.fromString('SAPO', 'Animais'),
      Word.fromString('FACA', 'Objetos'),
      Word.fromString('LOBO', 'Animais'),
      Word.fromString('RATO', 'Animais'),
      Word.fromString('VELA', 'Objetos'),
    ];
    _words.shuffle(Random());

    _currentWordIndex = 0;
    _correctAnswers = 0;
    _incorrectAttempts = 0;
    _showFeedback = false;
    _lastReceivedVowel = '';

    if (_words.isNotEmpty) {
      _currentWord = _words[0];
    }

    // Initialize BLE service if not already done
    _initializeBleListeners();

    notifyListeners();
  }

  // Initialize BLE listeners
  void _initializeBleListeners() {
    // Cancel any existing subscriptions
    _vowelSubscription?.cancel();

    // Listen for connection state changes
    _bleService.connectionStateStream.listen((connected) {
      _isBleConnected = connected;
      notifyListeners();
    });

    // Listen for vowel notifications
    _vowelSubscription = _bleService.vowelNotificationStream.listen((vowel) {
      debugPrint('Received vowel from BLE: $vowel');
      _lastReceivedVowel = vowel;

      // Process the vowel input
      _processVowelInput(vowel);

      notifyListeners();
    });
  }

  void setUserMode(UserMode mode) {
    _userMode = mode;
    notifyListeners();
  }

  void tryVowel(String vowel, int position) {
    if (_currentWord == null) return;

    final isCorrect = _currentWord!.checkVowel(vowel, position);

    if (isCorrect) {
      final updatedState = List<String?>.from(_currentWord!.currentState);
      updatedState[position] = vowel.toUpperCase();

      _currentWord = _currentWord!.copyWith(
        currentState: updatedState,
      );

      if (!_currentWord!.currentState.contains(null)) {
        _correctAnswers++;
        Future.delayed(const Duration(milliseconds: 500), () {
          nextWord();
        });
      }
    } else {
      _incorrectAttempts++;
    }

    notifyListeners();
  }

  void nextWord() {
    if (_words.isEmpty) return;

    _currentWordIndex++;

    if (_currentWordIndex < _words.length) {
      _currentWord = _words[_currentWordIndex];
    }

    notifyListeners();
  }


  void restartGame() {
    initializeGame();
  }

  // BLE methods

  void _processVowelInput(String vowel) {
    if (_currentWord == null) return;
    if (vowel.isEmpty) return;

    // Ensure vowel is uppercase for consistency
    final upperVowel = vowel.toUpperCase();

    // Check if it's a valid vowel
    if (!Word.vowels.contains(upperVowel)) return;

    // Get the first missing position
    final missingPositions = _currentWord!.getRemainingPositions();
    if (missingPositions.isNotEmpty) {
      tryVowel(upperVowel, missingPositions.first);
    }
  }

  // Disconnect from BLE device
  Future<void> disconnectBle() async {
    await _bleService.disconnect();
  }

  @override
  void dispose() {
    _vowelSubscription?.cancel();
    _bleService.dispose();
    super.dispose();
  }
}
