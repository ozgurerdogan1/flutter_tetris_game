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
  bool _isGameOver = false;

  int _score = 0;

  @override
  void initState() {
    startGame();
    super.initState();
  }

  void startGame() {
    _currentPiece.initializePiece();

    const Duration frameRate = Duration(milliseconds: 700);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) async {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        if (_isGameOver) {
          timer.cancel();
          showDialogGameOver();
        }
        checkLanding();
        clearLines();
        _currentPiece.movePiece(Directions.down);
      });
    });
  }

  bool checkCollision(Directions direction) {
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
    _currentPiece = Piece(type: randomType);
    _currentPiece.initializePiece();

    gameOver();
  }

  clearLines() {
    for (int row = colLenght - 1; row >= 0; row--) {
      bool rowIsFull = true;

      for (int col = 0; col < rowLenght; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        gameBoard[0] = List.generate(rowLenght, (index) => null);
        _score++;
      }
    }
  }

  void gameOver() {
    if (gameBoard[0].any((element) => element != null)) {
      _isGameOver = true;
    }
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("Score: $_score"),
              ),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowLenght),
                  itemCount: rowLenght * colLenght,
                  itemBuilder: (context, index) {
                    int row = (index / rowLenght).floor();
                    int col = index % rowLenght;

                    if (_currentPiece.position.contains(index)) {
                      return Pixel(color: _currentPiece.color);
                    } else if (gameBoard[row][col] != null) {
                      final Tetromino? type = gameBoard[row][col];

                      return Pixel(
                        color: Colors.pink,
                      );
                    }
                    return Pixel(color: Colors.grey.shade900);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: _moveLeft, icon: const Icon(Icons.arrow_back_ios)),
                    IconButton(onPressed: _rotatePiece, icon: const Icon(Icons.rotate_right)),
                    IconButton(onPressed: _moveRight, icon: const Icon(Icons.arrow_forward_ios)),
                  ],
                ),
              ),
              IconButton(
                onPressed: _putDown,
                icon: Transform.rotate(
                  angle: pi * 0.5,
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ),
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

  void _putDown() {
    bool res = true;

    setState(() {
      while (res) {
        if (checkCollision(Directions.down)) {
          res = false;
        } else {
          _currentPiece.movePiece(Directions.down);
        }
      }
    });
  }

  void showDialogGameOver() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text("Your score is: $_score"),
          actions: [
            TextButton(
                onPressed: () {
                  resetGame();
                  Navigator.pop(context);
                },
                child: const Text("Play again")),
          ],
        );
      },
    );
  }

  void resetGame() {
    gameBoard = List.generate(
      colLenght,
      (i) => List.generate(
        rowLenght,
        (j) => null,
      ),
    );

    _isGameOver = false;
    _score = 0;
    createNewPiece();
    startGame();
  }
}
