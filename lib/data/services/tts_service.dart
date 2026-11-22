import 'package:flutter_tts/flutter_tts.dart';

/// Reads Chinese aloud with the phone's built-in TTS (zh-CN, slow rate).
class TtsService {
  late final FlutterTts _tts = FlutterTts(); // created on first use
  bool _ready = false;

  Future<void> speak(String hanzi) async {
    if (!_ready) {
      await _tts.setLanguage('zh-CN');
      await _tts.setSpeechRate(0.45);
      _ready = true;
    }
    await _tts.stop();
    await _tts.speak(hanzi);
  }
}
