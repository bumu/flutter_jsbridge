import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'js_bridge.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

    // 添加返回处理器
    JSBridge.registerHandler('navigateBack', (params) {
      Navigator.of(context).pop();
      return {'success': true};
    });

    // 注册文件加载方法
    JSBridge.registerHandler('loadLocalFile', (params) async {
      try {
        final path = params['path'] ?? '';
        final content = await rootBundle.loadString(path);
        return {'success': true, 'content': content};
      } catch (e) {
        return {'success': false, 'error': e.toString()};
      }
    });

    // Add remote file loading handler
    JSBridge.registerHandler('loadRemoteFile', (params) async {
      try {
        final url = params['url'] ?? '';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          return {'success': true, 'content': response.body};
        } else {
          return {
            'success': false,
            'error': 'Failed to load remote file: ${response.statusCode}'
          };
        }
      } catch (e) {
        return {'success': false, 'error': e.toString()};
      }
    });
  }
} 