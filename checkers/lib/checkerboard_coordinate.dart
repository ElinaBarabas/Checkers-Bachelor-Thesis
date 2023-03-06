class CheckerboardCoordinate {

  int row = -1;
  int column = -1;

  CheckerboardCoordinate(this.row, this.column);

  CheckerboardCoordinate.change(CheckerboardCoordinate oldCoordinate, {int newRowValue = 0, int newColumnValue = 0}) {
    row = oldCoordinate.row + newRowValue;
    column = oldCoordinate.column + newColumnValue;
  }
}