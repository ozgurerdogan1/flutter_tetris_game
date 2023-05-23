import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tetris_game/piece.dart';
import 'package:flutter_tetris_game/pixel.dart';
import 'package:flutter_tetris_game/value.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLenght,
  (i) => List.generate(
    rowLenght,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

const rowLenght = 10;
const colLenght = 15;

class _GameBoardState extends State<GameBoard> {
  Piece _currentPiece = Piece(type: Tetromino.L);

  bool isGameStop = false;

  @override
  void initState() {
    startGame();
    super.initState();
  }

  void startGame() {
    _currentPiece.initializePiece();

    const Duration frameRate = Duration(milliseconds: 1000);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) async {
    Timer.periodic(frameRate, (timer) {
      if (!isGameStop) {
        setState(() {
          checkLanding();
          _currentPiece.movePiece(Directions.down);
        });
      }
    });
  }

  bool checkCollision(Directions direction) {
    print("checkCollision");
    for (var i = 0; i < _currentPiece.position.length; i++) {
      int row = (_currentPiece.position[i] / rowLenght).floor(); // 0-14
      int col = _currentPiece.position[i] % rowLenght; // 0-9
      if (direction == Directions.down) {
        row += 1;
      } else if (direction == Directions.left) {
        col -= 1;
      } else if (direction == Directions.right) {
        col += 1;
      }

      if (row >= colLenght || col < 0 || col >= rowLenght) {
        return true;
      }
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    return false;
  }

  checkLanding() {
    if (checkCollision(Directions.down)) {
      for (var i = 0; i < _currentPiece.position.length; i++) {
        int row = (_currentPiece.position[i] / rowLenght).floor(); //col lenght item (0-14)
        int col = _currentPiece.position[i] % rowLenght; // row lenght item (0-9)
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = _currentPiece.type;
        }
      }

      createNewPiece();
    }
  }

  createNewPiece() {
    Random random = Random();
    Tetromino randomType = Tetromino.values[random.nextInt(Tetromino.values.length)];
    // _currentPiece = Piece(type: randomType);
    _currentPiece.initializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowLenght),
                  itemCount: rowLenght * colLenght,
                  itemBuilder: (context, index) {
                    int row = (index / rowLenght).floor();
                    int col = index % rowLenght;
                    if (_currentPiece.position.contains(index)) {
                      return Pixel(index: index, color: _currentPiece.color);
                    } else if (gameBoard[row][col] != null) {
                      final Tetromino? type = gameBoard[row][col];

                      return Pixel(
                        index: index,
                        color: tetrominoColors[type],
                      );
                    }
                    return Pixel(index: index, color: Colors.grey.shade900);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isGameStop = !isGameStop;
                          });
                        },
                        icon: Icon(isGameStop ? Icons.play_arrow : Icons.pause)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(onPressed: _moveLeft, icon: const Icon(Icons.arrow_back_ios)),
                        IconButton(onPressed: _rotatePiece, icon: const Icon(Icons.rotate_left)),
                        IconButton(onPressed: _moveRight, icon: const Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _moveRight() {
    setState(() {
      if (!checkCollision(Directions.right)) {
        _currentPiece.movePiece(Directions.right);
      }
    });
  }

  void _moveLeft() {
    setState(() {
      if (!checkCollision(Directions.left)) {
        _currentPiece.movePiece(Directions.left);
      }
    });
  }

  void _rotatePiece() {
    setState(() {
      _currentPiece.rotatePiece();
    });
  }
}
