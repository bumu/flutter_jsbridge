import 'package:flutter/material.dart';
import 'runtime/mini_program_runtime.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  String? _currentAppId;
  String? _programPath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Program Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mini Program'),
        ),
        body: _currentAppId != null 
          ? MiniProgramRuntime(
              appId: _currentAppId!,
              programPath: _programPath,
            )
          : const Center(child: Text('首页内容')),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: '工作台',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '我的',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              if (index == 1) {
                _currentAppId = 'demo';
                _programPath = 'demo_program/hello/index.html';
              } else if (index == 2) {
                _currentAppId = 'demo';
                _programPath = null;
              } else {
                _currentAppId = null;
                _programPath = null;
              }
            });
          },
        ),
      ),
    );
  }
}
