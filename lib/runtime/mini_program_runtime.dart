import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../bridge/js_bridge.dart';
import '../bridge/bridge_methods.dart';

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
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset(widget.programPath ?? 'lib/demo_program/hello/index.html');
    
    JSBridge().initialize(_controller);
    BridgeMethods.registerBasicMethods(context);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}