import 'package:checkers/screens/rules.dart';
import 'package:flutter/material.dart';

import 'checker.dart';
import 'checkerboard_coordinate.dart';
import 'checkers_match.dart';
import 'screens/homepage.dart';

void main() {

  CheckersMatch match = CheckersMatch();

  match.printCheckers();

  print("-----------------------");
  Checker checker = Checker(1, false, CheckerboardCoordinate(1, 0));
  Checker checker2 = Checker(2, false, CheckerboardCoordinate(7, 6));
  match.moveChecker(checker, CheckerboardCoordinate(2,1));
  match.printCheckers();

  print("-----------------------");
  match.moveChecker(checker2, CheckerboardCoordinate(3,2));
  match.printCheckers();

  // match.containsOpponentChecker(CheckerboardCoordinate(0,1));
  // print("-----------------------");
  // match.containsChecker(CheckerboardCoordinate(3, 2));
  // match.containsChecker(CheckerboardCoordinate(4, 0));


  runApp(MaterialApp(
      routes: {
        '/': (context) => const Homepage(),
        '/scan': (context) => const Rules(),
        '/play': (context) => const Rules(),
        '/rules': (context) => const Rules(),
      }
  ));
}

