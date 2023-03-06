import 'package:checkers/captured.dart';
import 'package:checkers/checker.dart';
import 'package:checkers/checkerboard_coordinate.dart';

class CheckerboardField {

  int row = -1;
  int column = -1;
  Checker checker = Checker(0, false, CheckerboardCoordinate(-1, -1));
  bool isHighlighted = false;
  bool isHighlightedAfterCapturing = false;
  Captured capturedChecker = Captured.notCaptured();
  bool canCaptureAgain = false;     // boolean value used in case that another jump can be made in order to capture again

  CheckerboardField(this.row, this.column, this.checker, this.isHighlighted, this.isHighlightedAfterCapturing, this.canCaptureAgain);
  CheckerboardField.initialization(this.row, this.column);

}