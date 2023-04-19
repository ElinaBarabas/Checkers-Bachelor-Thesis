import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:checkers/screens/play.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

// A screen that allows users to take a picture using a given camera.
class Scan extends StatefulWidget {
  const Scan({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  ScanState createState() => ScanState();
}




class ScanState extends State<Scan> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2623),

      // appBar: AppBar(backgroundColor: const Color(0xFF2C2623), title: const Text('Scan the match')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              children: [
                const SizedBox(width: 300, height: 30),
                Card(
                  color: const Color.fromRGBO(254, 246, 218, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.asset(
                            "assets/images/checkers3.png",
                            scale: 1,
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Aim your camera at the checkerboard to scan it and convert it into a playable game!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 300, height: 10),
                Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 300,
                      child: CameraPreview(_controller),
                    )),
                const SizedBox(width: 300, height: 10),
                GestureDetector(
                    onTap: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Attempt to take a picture and get the file `image`
                        // where it was saved.
                        final image = await _controller.takePicture();

                        if (!mounted) return;

                        // If the picture was taken, display it on a new screen.
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              // Pass the automatically generated path to
                              // the DisplayPictureScreen widget.
                              imagePath: image.path, isButtonVisible: false,
                            ),
                          ),
                        );
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    child:
                    Card(
                      color: const Color.fromRGBO(254, 246, 218, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/scan.png",
                                scale: 12,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Convert game!",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }

        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isButtonVisible;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.isButtonVisible});

  uploadImage(BuildContext context) async {
    final request = http.MultipartRequest("POST", Uri.parse("http://192.168.5.175:50100/upload"));    //ASTA E LOCAL
    // final request = http.MultipartRequest("POST", Uri.parse("http://localhost:50100/upload"));
    final headers = {"Content-type": "multipart/form-data"};

    var selectedImage = File(imagePath);
    request.files.add(http.MultipartFile('image', selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(), filename: selectedImage.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    var message = resJson['message'];

    if(message == "NOT FOUND")
      {
        showAlertDialog(context);
      }
    else {
      List<List<String>> responseMatrix = processResponse(message);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Play(custom: true, responseMatrix: responseMatrix)));
    }



  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: const Color(0xFF2C2623),
      // appBar: AppBar(backgroundColor: const Color(0xFF2C2623), title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: isButtonVisible,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      )) ,backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(254, 246, 218, 1))),
                    onPressed: () => { Navigator.pop(context)},
                    child: const Text("Retake picture", style: TextStyle(color: Colors.black))
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Image.file(File(imagePath)),
            const SizedBox(height: 15.0),
          GestureDetector(
              onTap: ()  {
                uploadImage(context);
              },
              child:
              Card(
                color: const Color.fromRGBO(254, 246, 218, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          "assets/images/play.png",
                          scale: 7,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Let's play virtually!",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ))
          ]
        ),
      )
    );
  }

  showAlertDialog(BuildContext context) {

    Widget retakePictureButton = Padding(
      padding: const EdgeInsets.only(right: 10.0, bottom: 5),
      child: TextButton(
        child: const Text("Retake picture", style: TextStyle(color: Color(0xFF2C2623), fontSize: 17, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => DisplayPictureScreen(imagePath: imagePath, isButtonVisible: true)));
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor: const Color.fromRGBO(254, 246, 218, 1),
      content: const Padding(
          padding: EdgeInsets.only(top: 25.0),
          child: Text("No checkerboard could be detected!", textAlign: TextAlign.center, style: TextStyle(
                color: Colors.black,
                fontSize: 20)),
      ),
      actions: [
        retakePictureButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<List<String>> processResponse(String response) {

    List<String> charList = response.split('');

    // Create an empty 8x8 matrix
    List<List<String>> matrix = List.generate(8, (_) => List.filled(8, ''));

    // Fill the matrix with characters from the list
    for (int i = 0; i < charList.length; i++) {
      int row = i ~/ 8;
      int col = i % 8;
      matrix[row][col] = charList[i];
    }

    // Print the resulting matrix
    if (kDebugMode) {
      print(matrix);
    }

    return matrix;
  }
}

