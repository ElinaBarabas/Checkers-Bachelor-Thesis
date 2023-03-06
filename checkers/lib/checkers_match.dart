
import 'package:checkers/checker.dart';
import 'package:checkers/checkerboard_coordinate.dart';
import 'package:checkers/checkerboard_field.dart';

import 'captured.dart';

typedef CanMoveAfterCapture = bool Function(CheckerboardCoordinate newCheckerboardCoordinate, Captured captured);  // boolean value indicating whether the move is allowed or not
                                                                                                                // based on the captured value - it involves (or not) a capture
typedef MoveAsKing = void Function(CheckerboardCoordinate newCheckerboardCoordinate);
typedef MoveAsKingIfCaptureIsAvailable = void Function(CheckerboardCoordinate newCheckerboardCoordinate, Captured captured);
typedef KingCanNotBeMovedThere = void Function(CheckerboardCoordinate newCheckerboardCoordinate);

// we have 3 types of moves:
// Type 1: Move a piece to an empty space or capture an opponent's piece if it is the first kill.
// Type 2: Capture multiple pieces in a sequence.
// Type 3: Consider all possible moves that can be made after a capture, in order to determine the best move to make.

class CheckersMatch {

  int currentPlayer = 1;
  int numberOfRows = 8;
  int numberOfColumns = 8;
  List<List<CheckerboardField>> checkerboard = [];

  CheckersMatch() {
    init();
    placeInitialCheckers();
  }

  void init() {
    for(int i = 0; i < numberOfRows; i++)
      {
        List<CheckerboardField> currentRow = [];
        for(int j = 0; j < numberOfColumns; j++)
          {
            CheckerboardField currentCheckerboardField = CheckerboardField.initialization(i, j);
            currentRow.add(currentCheckerboardField);
          }
        checkerboard.add(currentRow);
      }
  }

  bool isValidCheckerboardField(CheckerboardCoordinate checkerboardCoordinate) {   // checkers must be placed on black fields only

    int currentRow = checkerboardCoordinate.row;
    int currentColumn = checkerboardCoordinate.column;

    if(currentRow % 2 == 0 && currentColumn % 2 == 1) {
      return true;
    }

    if(currentRow % 2 == 1 && currentColumn % 2 == 0) {
      return true;
    }

    return false;
  }

  bool isFieldOnBoard(CheckerboardCoordinate checkerboardCoordinate) {

    int currentRow = checkerboardCoordinate.row;
    int currentColumn = checkerboardCoordinate.column;

    if(currentRow >= 0 && currentRow < numberOfRows && currentColumn >= 0 && currentColumn < numberOfColumns) {
      return true;
    }
    return false;
}

  bool containsChecker(CheckerboardCoordinate checkerboardCoordinate) {

    if(!isFieldOnBoard(checkerboardCoordinate) || getCheckerboardField(checkerboardCoordinate).checker.coordinate.row == -1 || getCheckerboardField(checkerboardCoordinate).checker.coordinate.column == -1 ) {
      return false;
    }
    return true;
  }

  bool containsOpponentChecker(CheckerboardCoordinate checkerboardCoordinate)
  {
    if(!containsChecker(checkerboardCoordinate))
      {
        return false;
      }

    int checkerOfPlayer = getCheckerboardField(checkerboardCoordinate).checker.player;

    if(checkerOfPlayer == currentPlayer)
      {
        return false;
      }
    return true;

  }

  CheckerboardField getCheckerboardField(CheckerboardCoordinate checkerboardCoordinate) {

    int currentRow = checkerboardCoordinate.row;
    int currentColumn = checkerboardCoordinate.column;

    return checkerboard[currentRow][currentColumn];
  }

  void addChecker(CheckerboardCoordinate checkerboardCoordinate, int player) {

    if(isValidCheckerboardField(checkerboardCoordinate)) {
      Checker checker = Checker(player, false, checkerboardCoordinate);
      getCheckerboardField(checkerboardCoordinate).checker = checker;
    }
  }

  void placeCheckersOnRow(int row, int player) {
    for(int column = 0; column < numberOfColumns; column++)
      {
        CheckerboardCoordinate checkerboardCoordinate = CheckerboardCoordinate(row, column);
        addChecker(checkerboardCoordinate, player);
      }
  }

  void placeInitialCheckers() {     // initially, checkers are placed on the first two lines and on the last two lines of an 8x8 table
    placeCheckersOnRow(0, 1);
    placeCheckersOnRow(1, 1);
    placeCheckersOnRow(6, 2);
    placeCheckersOnRow(7, 2);
  }

  void printCheckers() {
    for (int row = 0; row < numberOfRows; row++) {
      String rowString = "";
      for (int column = 0; column < numberOfColumns; column++) {
        if ((row + column) % 2 == 0) {
          rowString += ". ";
        } else {
          CheckerboardField piece = checkerboard[row][column];
          Checker checker = piece.checker;
          int player = checker.player;
          rowString += "$player ";
        }
      }
      print(rowString);
    }
  }

  void moveChecker(Checker checker, CheckerboardCoordinate newCheckerboardCoordinate) {
    getCheckerboardField(checker.coordinate).checker = Checker(0, false, CheckerboardCoordinate(-1, -1));
    getCheckerboardField(newCheckerboardCoordinate).checker = checker;
    // print("OLD POSITION");
    // print(checker.coordinate.row);
    // print(checker.coordinate.column);
    checker.coordinate = newCheckerboardCoordinate;
    // print("NEW POSITION");
    // print(checker.coordinate.row);
    // print(checker.coordinate.column);
  }

  void changePlayerTurn(){
    if (currentPlayer == 1)
      {
        currentPlayer = 2;
      }
    else {
      currentPlayer = 1;
    }
  }

  void resetCheckerboardState() {
    for (int row = 0; row < numberOfRows; row++) {
      for (int column = 0; column < numberOfColumns; column++) {
        checkerboard[row][column].isHighlighted = false;
        checkerboard[row][column].isHighlightedAfterCapturing = false;
        checkerboard[row][column].canCaptureAgain = false;
        checkerboard[row][column].capturedChecker = Captured.notCaptured();
      }
    }
  }

  void setHighlightSimpleMove(CheckerboardCoordinate checkerboardCoordinate) {

    if(!isFieldOnBoard(checkerboardCoordinate)) {
      return;
    }

    if(!containsChecker(checkerboardCoordinate)) {
      return;
    }
    getCheckerboardField(checkerboardCoordinate).isHighlighted = true;
  }


  void setHighlightMoveWithCapture(CheckerboardCoordinate checkerboardCoordinate) {

    if(!isFieldOnBoard(checkerboardCoordinate)) {
      return;
    }

    if(!containsChecker(checkerboardCoordinate)) {
      return;
    }
    getCheckerboardField(checkerboardCoordinate).isHighlightedAfterCapturing = true;
  }

  bool isCheckerboardFieldReachable(int typeOfMove, CheckerboardCoordinate possibleCheckerCoordinate, CheckerboardCoordinate futureMoveIfCaptureCoordinate, CanMoveAfterCapture? canMoveAfterCapture) {

    if(containsChecker(possibleCheckerCoordinate)) {   // checking if there is any piece on the next position on which we want to move

      if(containsOpponentChecker(possibleCheckerCoordinate)) { // checking if that checker is an opponent's piece, so there is a chance for capture

        CheckerboardCoordinate opponentCheckerCoordinate = possibleCheckerCoordinate;
          if(isFieldOnBoard(futureMoveIfCaptureCoordinate) && !containsChecker(futureMoveIfCaptureCoordinate)) {    // checking if the adjacent is valid, so the position can be highlighted in case of capturing

            if(typeOfMove == 1 && typeOfMove == 2) {    //these two types of move involve moving a piece with capture
                    setHighlightMoveWithCapture(futureMoveIfCaptureCoordinate);
            }

            Checker capturedChecker = getCheckerboardField(opponentCheckerCoordinate).checker;
            Captured capturedPiece = Captured(true, capturedChecker);
            getCheckerboardField(futureMoveIfCaptureCoordinate).capturedChecker = capturedPiece;

            if(canMoveAfterCapture != null) {
                bool canMove = canMoveAfterCapture(futureMoveIfCaptureCoordinate, capturedPiece);
                getCheckerboardField(futureMoveIfCaptureCoordinate).canCaptureAgain = canMove;
            }
            return true;
          }
      }
    } else {
      if(typeOfMove == 1) {
        setHighlightSimpleMove(possibleCheckerCoordinate);
        return true;
      }
    }
    return false;
  }

  // player 1 moves from top to bottom of the board

  bool canMoveFirstPlayerToLeft(CheckerboardCoordinate checkerboardCoordinate, int typeOfMove, CanMoveAfterCapture canMoveAfterCapture) {
    CheckerboardCoordinate possibleCheckerCoordinate = CheckerboardCoordinate(checkerboardCoordinate.row + 1, checkerboardCoordinate.column - 1);
    CheckerboardCoordinate futureMoveIfCaptureCoordinate = CheckerboardCoordinate(checkerboardCoordinate.row + 2, checkerboardCoordinate.column - 2);
    return isCheckerboardFieldReachable(typeOfMove,
        possibleCheckerCoordinate,
        futureMoveIfCaptureCoordinate,
        canMoveAfterCapture);
  }

  bool canMoveFirstPlayerToRight(CheckerboardCoordinate checkerboardCoordinate, int typeOfMove, CanMoveAfterCapture canMoveAfterCapture) {
    CheckerboardCoordinate possibleCheckerCoordinate = CheckerboardCoordinate(checkerboardCoordinate.row + 1, checkerboardCoordinate.column + 1);
    CheckerboardCoordinate futureMoveIfCaptureCoordinate = CheckerboardCoordinate(checkerboardCoordinate.row + 2, checkerboardCoordinate.column + 2);
    return isCheckerboardFieldReachable(typeOfMove,
        possibleCheckerCoordinate,
        futureMoveIfCaptureCoordinate,
        canMoveAfterCapture);
  }

  // player 2 moves from bottom to top

  bool canMoveSecondPlayerToLeft(CheckerboardCoordinate checkerboardCoordinate, int typeOfMove, CanMoveAfterCapture canMoveAfterCapture) {
    CheckerboardCoordinate possibleCheckerCoordinate = CheckerboardCoordinate(checkerboardCoordinate.row - 1, checkerboardCoordinate.column - 1);
    CheckerboardCoordinate futureMoveIfCaptureCoordinate = CheckerboardCoordinate(checkerboardCoordinate.row - 2, checkerboardCoordinate.column - 2);
    return isCheckerboardFieldReachable(typeOfMove,
        possibleCheckerCoordinate,
        futureMoveIfCaptureCoordinate,
        canMoveAfterCapture);
  }

  bool canMoveSecondPlayerToRight(CheckerboardCoordinate checkerboardCoordinate, int typeOfMove, CanMoveAfterCapture canMoveAfterCapture) {
    CheckerboardCoordinate possibleCheckerCoordinate = CheckerboardCoordinate(checkerboardCoordinate.row - 1, checkerboardCoordinate.column + 1);
    CheckerboardCoordinate futureMoveIfCaptureCoordinate = CheckerboardCoordinate(checkerboardCoordinate.row - 2, checkerboardCoordinate.column + 2);
    return isCheckerboardFieldReachable(typeOfMove,
        possibleCheckerCoordinate,
        futureMoveIfCaptureCoordinate,
        canMoveAfterCapture);
  }

  bool canFirstPlayerMove(Checker checker, {int type = 1}) {
    bool canMoveToLeft = canMoveFirstPlayerToLeft(checker.coordinate, type,
            (newCheckerboardCoordinate, captured) {
          Checker newChecker =
          Checker.move(checker, checkerboardCoordinate: newCheckerboardCoordinate);
          return canFirstPlayerMove(newChecker, type: 3); // it returns if the checker of the first player can be moved to left
        });

    bool canMoveToRight = canMoveFirstPlayerToRight(checker.coordinate, type,
            (newCheckerboardCoordinate, captured) {
          Checker newChecker =
          Checker.move(checker, checkerboardCoordinate: newCheckerboardCoordinate);
          return canFirstPlayerMove(newChecker, type: 3);  // it returns if the checker of the first player can be moved to right
        });

    return canMoveToLeft || canMoveToRight; // based on the returned values, we know if the checker of the first player can be moved in one/both direction(s) or in neither of them
  }


  bool canSecondPlayerMove(Checker checker, {int type = 1}) {
    bool canMoveToLeft = canMoveSecondPlayerToLeft(checker.coordinate, type,
            (newCheckerboardCoordinate, captured) {
          Checker newChecker =
          Checker.move(checker, checkerboardCoordinate: newCheckerboardCoordinate);
          return canSecondPlayerMove(newChecker, type: 3);  // it returns if the checker of the second player can be moved to left
        });

    bool canMoveToRight = canMoveSecondPlayerToRight(checker.coordinate, type,
            (newCheckerboardCoordinate, captured) {
          Checker newChecker =
          Checker.move(checker, checkerboardCoordinate: newCheckerboardCoordinate);
          return canSecondPlayerMove(newChecker, type: 3);   // it returns if the checker of the second player can be moved to right
        });

    return canMoveToLeft || canMoveToRight; // based on the returned values, we know if the checker of the second player can be moved in one/both direction(s) or in neither of them
  }

}









