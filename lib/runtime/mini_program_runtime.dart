import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../bridge/js_bridge.dart';
import '../bridge/bridge_methods.dart';
import 'dart:convert';

class MiniProgramRuntime extends StatefulWidget {
  final String appId;
  final String? programPath;
  
  const MiniProgramRuntime({
    required this.appId, 
    this.programPath, 
    Key? key
  }) : super(key: key);

  @override
  State<MiniProgramRuntime> createState() => _MiniProgramRuntimeState();
}

class _MiniProgramRuntimeState extends State<MiniProgramRuntime> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    
    // Format the asset path
    final String assetPath = widget.programPath != null
        ? widget.programPath!.trim()
            .replaceAll('//', '/')
            .replaceAll(RegExp('^/'), '') // Remove leading slash
            .replaceAll(RegExp('/\$'), '') // Remove trailing slash
        : 'index.html';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (JavaScriptMessage message) {
          final data = jsonDecode(message.message);
          JSBridge.handleJSCall(data['method'], data['params']).then((result) {
            JSBridge.callJS(data['callback'], result);
          });
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            BridgeMethods.registerBasicMethods(context);
          },
        ),
      )
      ..loadFlutterAsset('assets/$assetPath');
    
    JSBridge.init(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}