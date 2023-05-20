import 'dart:io';

import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});


  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  bool activeConnection = false;

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
            Column(
              children: [
                const SizedBox(
                  height: 45,
                ),
                _headerView(),
                // const SizedBox(
                //   height: 10,
                // ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      _cardDetailView("images/chess.png", "Chess",
                          "Learn by playing"),
                      _cardDetailView("images/game1.png", "Chessify",
                          "Play Chess from a custom configuration"),
                      _cardDetailView("images/checker-board.png", "Checkers",
                          "Play from scratch"),
                      _cardDetailView("images/qr-code.png", "Scan",
                          "Virtualize the Checkers physical match"),
                      _cardDetailView("images/rules.png", "Rules",
                          "How to play"),

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
      padding: const EdgeInsets.all(40.0),
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
                    "SmartBoard Scanner",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "from photo to playing",
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

      onTap: ()  {
          var navigation = "/${title.toLowerCase()}";
          Navigator.of(context).pushNamed(navigation);
        },
      child:
        Card(
        color: const Color.fromRGBO(238, 222, 189, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  scale: 5,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
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

}
