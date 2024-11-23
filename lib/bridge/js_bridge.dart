import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class JSBridge {
  static WebViewController? _controller;
  static final Map<String, Function> _handlers = {};

  static void init(WebViewController controller) {
    _controller = controller;
  }

  static void registerHandler(String method, Function handler) {
    _handlers[method] = handler;
  }

  static Future<dynamic> handleJSCall(String method, dynamic params) async {
    if (_handlers.containsKey(method)) {
      return await _handlers[method]!(params);
    }
    throw Exception('Method $method not found');
  }

  static Future<void> callJS(String method, dynamic params) async {
    if (_controller == null) return;
    
    final paramsString = jsonEncode(params);
    await _controller!.runJavaScript(
      'window.miniProgramBridge.callback("$method", $paramsString)'
    );
  }

  void initialize(WebViewController controller) {
    // initialization code
  }
} 