import 'package:flutter/material.dart';

import 'board.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: GameBoard(),
    );
  }
}
