import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:checkers/screens/play.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'custom_chess.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isButtonVisible;
  final bool isCheckers;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.isButtonVisible, required this.isCheckers});


  sendImageToServer(BuildContext context) async {

    var isTimeout = false;
    var isResponseRetrieved =  false;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Visibility(
            visible: (!isResponseRetrieved && !isButtonVisible) || isButtonVisible,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),),
              // The background color
              backgroundColor: Color.fromRGBO(238, 222, 189, 1.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    // The loading indicator
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7e6c62)),),
                    SizedBox(
                      height: 15,
                    ),
                    // Some text
                    Text('Loading...')
                  ],
                ),
              ),
            ),
          );
        });

    // await Future.delayed(const Duration(seconds: 5, milliseconds: 50));

    http.MultipartRequest request;

    if(isCheckers)
      {
        request = http.MultipartRequest("POST", Uri.parse("http://192.168.5.175:50100/upload"));    //ASTA E LOCAL CARE MERGE
      }
    else {
      request = http.MultipartRequest("POST", Uri.parse("http://192.168.5.175:50100/chessify"));    //ASTA E LOCAL CARE MERGE
    }


    // final request = http.MultipartRequest("POST", Uri.parse("http://172.30.113.212:50100/upload"));    //ASTA E LOCAL LA FACULTATE

    // final request = http.MultipartRequest("POST", Uri.parse("https://checkers-scanner.onrender.com/upload"));

    final headers = {"Content-type": "multipart/form-data"};

    var selectedImage = File(imagePath);
    print("CLIENT IS sending" + " {$selectedImage} to the server");
    request.files.add(http.MultipartFile('image', selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(), filename: selectedImage.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send().timeout(
      const Duration(seconds: 100),
      onTimeout: () {
        isTimeout = true;
        throw TimeoutException("The request timed out.");
      },
    );

    http.Response res = await http.Response.fromStream(response);
    isResponseRetrieved = true;
    final resJson = jsonDecode(res.body);

    var message = resJson['message'];

    if(message == "NOT FOUND")
    {
      showAlertDialog(context);
      isResponseRetrieved = true;
    }
    else {
      Navigator.pop(context);    // we pop the loading alert since the conversion is done

      if(isCheckers) {
        List<List<String>> responseMatrix = processResponse(message);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            Play(custom: true, responseMatrix: responseMatrix)));
      }
      else {

        if(!message.split(" ")[0].contains("K") || !message.split(" ")[0].contains("k"))
          {
            print("NU e ok");
            showTwoKingsAlertDialog(context);
          }
        else {
          print(message);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CustomChessScreen(fenString: message, isPasted: false)));
        }
      }
    }
  }

  Future<void> saveImage(BuildContext context) async{

    await GallerySaver.saveImage(imagePath);
    showSaveImageAlertDialog(context);


  }

  Future<void> uploadImage(BuildContext context) async {
    final picker = ImagePicker();

    final selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {

       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (BuildContext context) => DisplayPictureScreen(imagePath: selectedImage.path, isButtonVisible: true, isCheckers: isCheckers,)));

    }
  }
  
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color(0xFF211810),
        // appBar: AppBar(backgroundColor: const Color(0xFF2C2623), title: const Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Image.asset('images/back.png'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                      ),
                      SizedBox(width: 5,height: 100,),
                      Visibility(
                        visible: isButtonVisible,
                        child: Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  )
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(238, 222, 189, 1.0),
                              ),
                            ),
                            onPressed: () => {uploadImage(context)},
                            child: const Text(
                              "Upload picture",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isButtonVisible,
                        child: Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  )
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(238, 222, 189, 1.0),
                              ),
                            ),
                            onPressed: () => { saveImage(context)},
                            child: const Text(
                              "Save picture",
                              style: TextStyle(color: Colors.black),
                            ),
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
                                const Color.fromRGBO(238, 222, 189, 1.0),
                              ),
                            ),
                            onPressed: () => { Navigator.pop(context),
                            if(isCheckers)
                              Navigator.of(context).pushNamed("/camera")
                            else
                              Navigator.of(context).pushNamed("/camera_chess")
                            },
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
                          // buildFetchDataWidget(context);
                          sendImageToServer(context);
                        }
                      },
                      child:
                      Card(
                        color: const Color.fromRGBO(238, 222, 189, 1.0),
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
                                  "images/play.png",
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
          ),
        )
    );
  }

  showAlertDialog(BuildContext context) {

    Widget retakePictureButton = Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TextButton(
        child: const Text("Choose another picture", style: TextStyle(color: Color(
            0xff070000), fontSize: 15, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => DisplayPictureScreen(imagePath: imagePath, isButtonVisible: true, isCheckers: isCheckers,)));
        },
      ),
    );


    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor: const Color.fromRGBO(238, 222, 189, 1.0),
      content:  Padding(
        padding: const EdgeInsets.only(top: 40),
        child: SizedBox(
          height: 60,
          width: 400,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  "images/search.png",
                  scale: 2,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Couldn't detect any chessboard!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
          color: Color(0xFF7e6c62),
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
      backgroundColor: const Color.fromRGBO(238, 222, 189, 1.0),
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
                  "images/no-wifi.png",
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

  showSaveImageAlertDialog(BuildContext context) {

    Widget okPictureButton = Padding(
      padding: const EdgeInsets.only(right: 5),
      child: TextButton(
        child: const Text("OK!", style: TextStyle(color: Color(
            0xff070000), fontSize: 12, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    // set up the AlertDialog
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor: const Color.fromRGBO(238, 222, 189, 1.0),
      content:  Padding(
        padding: const EdgeInsets.only(top: 45),
        child: SizedBox(
          height: 50,
          width: 350,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  "images/image.png",
                  scale: 2,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Image saved successfully!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
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
        okPictureButton,
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

  showTwoKingsAlertDialog(BuildContext context) {

    Widget noInternetConnectionButton = TextButton(
      child: const Text(
        "OK",
        style: TextStyle(
          color: Color(0xff000000),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => DisplayPictureScreen(imagePath: imagePath, isButtonVisible: true, isCheckers: isCheckers, )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor: const Color.fromRGBO(238, 222, 189, 1.0),
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
                  "images/search.png",
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
                        "The Kings could not be detected!",
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
