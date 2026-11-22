import 'package:flutter_tts/flutter_tts.dart';

/// Reads Chinese aloud with the phone's built-in TTS (zh-CN, slow rate).
class TtsService {
  late final FlutterTts _tts = FlutterTts(); // created on first use
  bool _ready = false;

  /// False when the phone has no TTS engine or no Chinese voice.
  Future<bool> speak(String hanzi) async {
    if (!_ready) {
      if (await _tts.setLanguage('zh-CN') != 1) return false;
      await _tts.setSpeechRate(0.45);
      _ready = true;
    }
    await _tts.stop();
    return await _tts.speak(hanzi) == 1;
  }
}
