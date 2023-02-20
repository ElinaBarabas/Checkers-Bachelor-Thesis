import 'package:checkers/screens/rules.dart';
import 'package:flutter/material.dart';

import 'screens/homepage.dart';

void main() {
  runApp(MaterialApp(
      routes: {
        '/': (context) => const Homepage(),
        '/scan': (context) => const Rules(),
        '/play': (context) => const Rules(),
        '/rules': (context) => const Rules(),
      }
  ));
}

