import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Serviço de áudio para tocar sons de vogais e sílabas
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Toca o som da vogal especificada
  Future<void> playVowel(String vogal) async {
    try {
      final assetPath = 'assets/audio/vogais/$vogal.mp3';
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao tocar vogal $vogal: $e');
      }
      // Fail gracefully
    }
  }

  /// Toca o som da sílaba especificada
  Future<void> playSyllable(String silaba) async {
    try {
      final assetPath = 'assets/audio/silabas/$silaba.mp3';
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao tocar sílaba $silaba: $e');
      }
      // Fail gracefully
    }
  }

  /// Toca o som da palavra completa especificada
  Future<void> playWord(String palavra) async {
    try {
      final assetPath = 'assets/audio/palavras/$palavra.mp3';
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao tocar palavra $palavra: $e');
      }
      // Fail gracefully
    }
  }

  /// Libera recursos
  void dispose() {
    _audioPlayer.dispose();
  }
}