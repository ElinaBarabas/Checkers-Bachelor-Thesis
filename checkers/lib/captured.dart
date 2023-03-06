import 'package:checkers/checker.dart';

import 'checkerboard_coordinate.dart';

class Captured {

  bool isCaptured = false;
  Checker checker = Checker(0, false, CheckerboardCoordinate(-1, -1));

  Captured(this.isCaptured, this.checker);

  Captured.notCaptured() {
    isCaptured = false;
  }

}