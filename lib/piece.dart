// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_tetris_game/value.dart';

import 'board.dart';

class Piece {
  Tetromino type;
  Piece({
    required this.type,
  });

  List<int> position = [];

  Color get color {
    return tetrominoColors[type] ?? Colors.white;
  }

  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetromino.I:
        position = [-36, -26, -16, -6];
        break;
      case Tetromino.O:
        position = [-26, -16, -25, -15];
        break;
      case Tetromino.S:
        position = [-26, -25, -17, -16];
        break;
      case Tetromino.Z:
        position = [-27, -26, -16, -15];
        break;
      case Tetromino.T:
        position = [-26, -16, -15, -6];
        break;
    }
  }

  void movePiece(Directions directions) {
    switch (directions) {
      case Directions.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLenght;
        }
        break;
      case Directions.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      case Directions.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      default:
    }
  }

  int rotateState = 0;

  void rotatePiece() {
    List<int> newPosition = [0, 0, 0, 0];

    switch (type) {
      case Tetromino.L:
        switch (rotateState) {
          case 0: //4,14,24,25  ->15,14,13,23
            newPosition[0] = position[0] + rowLenght + 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] - rowLenght - 1;
            newPosition[3] = position[3] - 2;

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }

            break;

          case 1: //15,14,13,23 -> 24,14,4,3
            newPosition[0] = position[0] + rowLenght - 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] - rowLenght + 1;
            newPosition[3] = position[3] - rowLenght * 2;

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }

            break;
          case 2: //25,14,4,3 ->13,14,15,5
            newPosition[0] = position[0] - rowLenght - 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] + rowLenght + 1;
            newPosition[3] = position[3] + 2;

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }

            break;
          case 3: //13,14,15,5 -> 4,14,24,25
            newPosition[0] = position[0] - rowLenght + 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] + rowLenght - 1;
            newPosition[3] = position[3] + rowLenght * 2;

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotateState = (rotateState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.J:
        switch (rotateState) {
          case 0: //5,15,25,24  ->16,15,14,4
            newPosition[0] = position[0] + rowLenght + 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] - rowLenght - 1;
            newPosition[3] = position[3] - rowLenght * 2;

            position = newPosition;
            rotateState = (rotateState + 1) % 4;
            break;

          case 1: //16,15,14,4 -> 25,15,5,6
            newPosition[0] = position[0] + rowLenght - 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] - rowLenght + 1;
            newPosition[3] = position[3] + 2;

            position = newPosition;
            rotateState = (rotateState + 1) % 4;
            break;
          case 2: //25,15,5,6 -> 14,15,16,26
            newPosition[0] = position[0] - rowLenght - 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] + rowLenght + 1;
            newPosition[3] = position[3] + rowLenght * 2;

            position = newPosition;
            rotateState = (rotateState + 1) % 4;
            break;
          case 3: //14,15,16,26 -> 5,15,25,24
            newPosition[0] = position[0] - rowLenght + 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] + rowLenght - 1;
            newPosition[3] = position[3] - 2;

            position = newPosition;
            rotateState = (rotateState + 1) % 4;
            break;
        }
      case Tetromino.I:
        switch (rotateState) {
          case 0: //4,14,24,34  ->13,14,15,16
            newPosition[0] = position[0] + rowLenght - 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] - rowLenght + 1;
            newPosition[3] = position[3] - rowLenght * 2 + 2;

            position = newPosition;
            rotateState = (rotateState + 1) % 2;
            break;

          case 1: //13,14,15,16 -> 4,14,24,34
            newPosition[0] = position[0] - rowLenght + 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] + rowLenght - 1;
            newPosition[3] = position[3] + rowLenght * 2 - 2;

            position = newPosition;
            rotateState = (rotateState + 1) % 2;
            break;
        }
      case Tetromino.S:
        switch (rotateState) {
          case 0: //4,5,13,14  ->4,25,15,14
            newPosition[0] = position[0];
            newPosition[1] = position[1] + rowLenght * 2;
            newPosition[2] = position[2] + 2;
            newPosition[3] = position[3];

            position = newPosition;
            rotateState = (rotateState + 1) % 2;
            break;

          case 1: //4,25,15,14 -> 4,5,13,14
            newPosition[0] = position[0];
            newPosition[1] = position[1] - rowLenght * 2;
            newPosition[2] = position[2] - 2;
            newPosition[3] = position[3];

            position = newPosition;
            rotateState = (rotateState + 1) % 2;
            break;
        }
      case Tetromino.Z:
        switch (rotateState) {
          case 0: //13,14,24,25  ->5,14,24,15
            newPosition[0] = position[0] - rowLenght + 2;
            newPosition[1] = position[1];
            newPosition[2] = position[2];
            newPosition[3] = position[3] - rowLenght;

            position = newPosition;
            rotateState = (rotateState + 1) % 2;
            break;

          case 1: //5,14,24,15 -> 13,14,24,25
            newPosition[0] = position[0] + rowLenght - 2;
            newPosition[1] = position[1];
            newPosition[2] = position[2];
            newPosition[3] = position[3] + rowLenght;

            position = newPosition;
            rotateState = (rotateState + 1) % 2;
            break;
        }
      case Tetromino.T:
        switch (rotateState) {
          case 0: //4,14,15,24  ->15,14,24,13
            newPosition[0] = position[0] + rowLenght + 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] + rowLenght - 1;
            newPosition[3] = position[3] - rowLenght - 1;

            position = newPosition;
            rotateState = (rotateState + 1) % 4;
            break;

          case 1: //15,14,24,13 -> 24,14,13,4
            newPosition[0] = position[0] + rowLenght - 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] - rowLenght - 1;
            newPosition[3] = position[3] - rowLenght + 1;

            position = newPosition;
            rotateState = (rotateState + 1) % 4;
            break;
          case 2: //24,14,13,4-> 13,14,4,15
            newPosition[0] = position[0] - rowLenght - 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] - rowLenght + 1;
            newPosition[3] = position[3] + rowLenght + 1;

            position = newPosition;
            rotateState = (rotateState + 1) % 4;
            break;
          case 3: //13,14,4,15 -> 4,14,15,24
            newPosition[0] = position[0] - rowLenght + 1;
            newPosition[1] = position[1];
            newPosition[2] = position[2] + rowLenght + 1;
            newPosition[3] = position[3] + rowLenght - 1;

            position = newPosition;
            rotateState = (rotateState + 1) % 4;
            break;
        }

        break;
      default:
    }
  }

  bool positionIsValid(int position) {
    int row = (position / rowLenght).floor();
    int col = position % rowLenght;

    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      print("positionIsValid false");
      return false;
    }
    print("positionIsValid true");
    return true;
  }

  bool piecePositionIsValid(List<int> piecePositions) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePositions) {
      if (!positionIsValid(pos)) {
        print("piecePositionIsValid false");
        return false;
      }

      int col = pos % rowLenght;

      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLenght - 1) {
        lastColOccupied = true;
      }
    }
    print("firstcol: $firstColOccupied, lastcol: $lastColOccupied");
    print("piecePositionIsValid: ${!(firstColOccupied && lastColOccupied)}");
    return !(firstColOccupied && lastColOccupied);
  }
}

Map<Tetromino, Color> tetrominoColors = {
  Tetromino.I: Colors.blue,
  Tetromino.J: Colors.amber,
  Tetromino.L: Colors.cyan,
  Tetromino.O: Colors.purple,
  Tetromino.S: Colors.indigo,
  Tetromino.Z: Colors.deepOrange,
  Tetromino.T: Colors.teal,
};
