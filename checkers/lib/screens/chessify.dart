import 'dart:io';

import 'package:checkers/screens/custom_chess.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import '../chess_logic/chess_board_controller.dart';
import 'display_image.dart';


class SelectChessMatchSource extends StatefulWidget {

  const SelectChessMatchSource({super.key});



  @override
  State<SelectChessMatchSource> createState() => _SelectChessMatchSourceState();
}

class _SelectChessMatchSourceState extends State<SelectChessMatchSource> {

  final ChessBoardController chessBoardController = ChessBoardController();

  late bool isPastePressed = false;

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
                  height: 65,
                ),
                _headerView(),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      isPastePressed ? showFENInputWidget() :  _cardDetailView("images/paste.png", "paste",
                          "Start from FEN (Forsyth-Edwards Notation)"),
                      _cardDetailView("images/upload.png", "upload",
                          "Upload from Gallery "),
                      _cardDetailView("images/camera.png", "camera",
                          "Take Picture"),
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
                    "Select the source of the custom match that you want to play:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
          if(title.toLowerCase() == "paste")
            {
              isPastePressed = true;
              setState(() {});
            }
          else if (navigation == "/camera") {
            navigation += "_chess";
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
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 35, bottom: 35, right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    imagePath,
                    scale: 4,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: const TextStyle(
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
        ));
  }

  Widget showFENInputWidget() {

    FocusNode _focusNode = FocusNode();
    String fenInput = "";
    final _controller = TextEditingController();

    return SizedBox(
      height: 300,
      width: 350,
      child: Card(
          color: const Color(0xFF7e6c62),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text("Custom match using FEN:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                const SizedBox(height: 15,),
                TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  minLines: 5,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87), borderRadius: BorderRadius.circular(40)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87), borderRadius: BorderRadius.circular(40)),
                    hintText: 'Paste the FEN',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  cursorColor: Colors.black,
                  onChanged: (value) => {fenInput = value,} ,
                  onSubmitted: (value) => {fenInput = value} ,
                ),
                const SizedBox(height: 15,),
                ElevatedButton(
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
                  onPressed: () =>
                  {
                    _focusNode.unfocus(),
                    processInput(fenInput, _controller, context)
                    // Navigator.pop(context),
                 },
                  child: const Text(
                    "Play!",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
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
              imagePath: imagePath, isButtonVisible: false, isCheckers: false,
            ),
          )).then((value) => Navigator.pop(context));
    }
  }

  processInput(String fenInput, TextEditingController controller, BuildContext context) {

    fenInput = fenInput.trim();
    if(!chessBoardController.game.load(fenInput))
      {
        showNonValidFenAlert(context);
        controller.text =  "";
      }
    else
    {

      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomChessScreen(fenString: fenInput, isPasted: true)));
      controller.text =  "";

    }
  }

  void showNonValidFenAlert(BuildContext context) {

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

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      backgroundColor: const Color.fromRGBO(238, 222, 189, 1.0),
      contentPadding: EdgeInsets.only(top: 40, left: 20),
      content: SizedBox(
        height: 90,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                "images/wrong.png",
                scale: 2,
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "FEN not valid!",
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
}
