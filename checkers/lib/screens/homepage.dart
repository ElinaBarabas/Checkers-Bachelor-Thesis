import 'dart:io';

import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});


  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  // @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          _backgroundImage(),
          Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              _headerView(),
              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    _cardDetailView("assets/images/checker-board.png", "Play",
                    "Learn by yourself"),
                    _cardDetailView("assets/images/qr-code.png", "Scan",
                        "Continue the 'real' game virtually"),
                    _cardDetailView("assets/images/rules.png", "Rules",
                        "How to play Checkers"),
                  ],
                ),
              ),

            ],
          ),
          // _bottomView(context),
        ]));
  }

  Widget _backgroundImage() {
    return Container(
        color: const Color(0xFF2C2623)
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
                    "Checkers",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "from photo to playing",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
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
        color: const Color.fromRGBO(254, 246, 218, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
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
                  scale: 1,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
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


}
