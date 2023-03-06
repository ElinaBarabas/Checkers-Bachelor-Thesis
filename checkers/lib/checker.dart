import 'checkerboard_coordinate.dart';

class Checker {

  late CheckerboardCoordinate coordinate;
  int player = 0;
  bool isKing = false;

  Checker(this.player, this.isKing, [CheckerboardCoordinate? coordinate])
      : coordinate = coordinate ?? CheckerboardCoordinate(-1, -1);

  Checker.move(Checker checker, {CheckerboardCoordinate? checkerboardCoordinate}) {

    if(checkerboardCoordinate != null) {
      player = checker.player;
      isKing = checker.isKing;
      coordinate = checkerboardCoordinate;
    }
  }

  checkerBecomesKing() { isKing = true;}
}