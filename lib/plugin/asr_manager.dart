

import 'package:flutter/services.dart';

class AsrManager{

  static const MethodChannel _channel = const MethodChannel('asr_plugin');

  ///开始录音
  static Future<String> start({Map params}) async {
    await _channel.invokeMethod('start',params??{});
  }
  ///停止录音
  static Future<String> stop() async {
    await _channel.invokeMethod('stop');
  }
  ///取消录音
  static Future<String> cancel() async {
    await _channel.invokeMethod('cancel');
  }

}