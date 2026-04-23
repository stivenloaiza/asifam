import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  void setStartHandler(Function() handler) {
    _flutterTts.setStartHandler(() => handler());
  }

  void setCompletionHandler(Function() handler) {
    _flutterTts.setCompletionHandler(() => handler());
  }

  void setErrorHandler(Function(String message) handler) {
    _flutterTts.setErrorHandler((message) => handler(message));
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
