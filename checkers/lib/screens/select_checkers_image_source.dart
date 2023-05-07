import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'display_image.dart';


class SelectCheckersImageSource extends StatefulWidget {
  const SelectCheckersImageSource({super.key});


  @override
  State<SelectCheckersImageSource> createState() => _SelectCheckersImageSourceState();
}

class _SelectCheckersImageSourceState extends State<SelectCheckersImageSource> {


  // @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF211810),
        
        body: SingleChildScrollView(
          child: Stack(children: [
            _backgroundImage(),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 15),
              child: IconButton(
                icon: Image.asset('images/back.png'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 90,
                ),
                _headerView(),
                const SizedBox(
                  height: 30,
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      _cardDetailView("images/camera.png", "camera",
                          "Take Picture"),
                      const SizedBox(height: 50),
                      _cardDetailView("images/upload.png", "upload",
                          "Upload from Gallery"),
                    ],
                  ),
                ),

              ],
            ),
            // _bottomView(context),
          ]),
        ));
  }

  Widget _backgroundImage() {
    return Container(
        color: const Color(0xFF211810)
    );
  }

  Widget _headerView() {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  Text(
                    "Select the Checkers match that you want to virtualize:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _cardDetailView(String imagePath, String title, String description) {
    return GestureDetector(

        onTap: () {
          var navigation = "/${title.toLowerCase()}";

          if (navigation == "/camera") {
            Navigator.of(context).pushNamed(navigation);
          }
          else {
            print("UPLOAD");
            uploadImage();
          }
        },
        child:
        Card(
          color: const Color.fromRGBO(238, 222, 189, 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 35.0, top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    imagePath,
                    scale: 6,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }


  Future<void> uploadImage() async {
    final picker = ImagePicker();

    final selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      String imagePath = selectedImage.path;
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              // Pass the automatically generated path to
              // the DisplayPictureScreen widget.
              imagePath: imagePath, isButtonVisible: false,
            ),
          )).then((value) => Navigator.pop(context));
    }
  }
}