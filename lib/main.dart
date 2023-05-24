import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'board.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'Tetris Game',
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      theme: ThemeData.dark(),
      home: const GameBoard(),
    );
  }
}
