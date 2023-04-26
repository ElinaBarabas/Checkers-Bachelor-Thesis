import 'dart:io';

import 'package:camera/camera.dart';
import 'package:checkers/checkerboard_field.dart';
import 'package:checkers/screens/play.dart';
import 'package:checkers/screens/rules.dart';
import 'package:checkers/screens/scan.dart';
import 'package:checkers/screens/select_image_source.dart';
import 'package:flutter/material.dart';

import 'checker.dart';
import 'checkerboard_coordinate.dart';
import 'checkers_match.dart';
import 'screens/homepage.dart';

Future<void> main() async {

  // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  bool activeConnection = false;
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        activeConnection = true;
      }
    } on SocketException catch (_) {
      activeConnection = false;
    };
  }

  checkUserConnection();

  runApp(MaterialApp(
      routes: {
        '/': (context) => const Homepage(),
        // '/scan': (context) => Scan(camera: firstCamera),
        '/scan': (context) => const SelectImageSource(),
        '/camera': (context) => Scan(camera: firstCamera),
        '/play': (context) => const Play(custom: false, responseMatrix: [[]]),
        '/rules': (context) => const Rules(),
      }
  ));



}

// void main() => runApp(MyApp());
