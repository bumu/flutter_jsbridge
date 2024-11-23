import 'package:flutter/material.dart';
import 'js_bridge.dart';

class BridgeMethods {
  static void registerBasicMethods(BuildContext context) {
    // 注册显示消息方法
    JSBridge.registerHandler('showToast', (params) {
      final message = params['message'] ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return {'success': true};
    });

    // 获取设备信息
    JSBridge.registerHandler('getDeviceInfo', (params) {
      return {
        'platform': Theme.of(context).platform.toString(),
        'screenWidth': MediaQuery.of(context).size.width,
        'screenHeight': MediaQuery.of(context).size.height,
      };
    });
  }
} 