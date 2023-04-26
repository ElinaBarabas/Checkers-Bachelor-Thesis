import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:checkers/screens/play.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isButtonVisible;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.isButtonVisible});

  uploadImage(BuildContext context) async {
    final request = http.MultipartRequest("POST", Uri.parse("http://192.168.5.175:50100/upload"));    //ASTA E LOCAL
    // final request = http.MultipartRequest("POST", Uri.parse("https://checkers-scanner.onrender.com/upload"));
    final headers = {"Content-type": "multipart/form-data"};

    var selectedImage = File(imagePath);
    print("CLIENT IS sending" + " {$selectedImage} to the server");
    request.files.add(http.MultipartFile('image', selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(), filename: selectedImage.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send().timeout(const Duration(seconds: 100));

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

  Future<void> saveImage() async{
    print("pressed");
    await GallerySaver.saveImage(imagePath);
    print("saved");
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Image.asset('assets/images/back.png'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              )
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(254, 246, 218, 1),
                          ),
                        ),
                        onPressed: () => {saveImage()},
                        child: const Text(
                          "Save picture",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Visibility(
                      visible: isButtonVisible,
                      child: Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(254, 246, 218, 1),
                            ),
                          ),
                          onPressed: () => { Navigator.pop(context)},
                          child: const Text(
                            "Retake picture",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Image.file(File(imagePath)),
                const SizedBox(height: 15.0),
                GestureDetector(
                    onTap: ()  async {
                      var activeConnection = await checkUserConnection();

                      if(activeConnection == false) {
                        showConnectionAlertDialog(context);
                      }
                      else {
                        uploadImage(context);
                      }
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
                    )),
                const SizedBox(height: 15.0),
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

  Future<bool> checkUserConnection() async {

    bool activeConnection = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          activeConnection = true;
        }
    } on SocketException catch (_) {
        activeConnection = false;
    }

    return activeConnection;
  }

  showConnectionAlertDialog(BuildContext context) {

    Widget noInternetConnectionButton = TextButton(
      child: const Text(
        "OK",
        style: TextStyle(
          color: Color(0xFF2C2623),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor: const Color.fromRGBO(254, 246, 218, 1),
      content:  Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Container(
          height: 70,
          width: 300,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  "assets/images/no-wifi.png",
                  scale: 4,
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "No internet connection!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "Please try again!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        noInternetConnectionButton,
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
}
