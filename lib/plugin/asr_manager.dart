import 'package:flutter/services.dart';
// 不会安卓，所以坑还没有排。等我学安卓在回来爬坑
class AsrManager {
  static const MethodChannel _channel = const MethodChannel('asr_plugin');

  // 开始录音
  static Future<String> start({Map params}) async {
    return await _channel.invokeMethod('start', params ?? {});
  }

  // 停止录音
  static Future<String> stop() async {
    return await _channel.invokeMethod('stop');
  }

  // 取消录音
  static Future<String> cancel() async {
    return await _channel.invokeMethod('cancel');
  }
}