import 'dart:io';

import 'package:flutter/material.dart';


class Rules extends StatefulWidget {
  const Rules({super.key});


  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {


  // @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF2C2623),
        body: SingleChildScrollView(
          child: Column(
                children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 300),
                        child: IconButton(
                          icon: Image.asset('assets/images/back.png'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      _headerView(),
                      Card(
                        color: const Color.fromRGBO(254, 246, 218, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "\nINTRODUCTION",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "\nCheckers is a two-player board game played on an 8x8 checked board with 12 pieces each. \n"
                                            "\n\nThe players move their pieces diagonally in the forward direction, and if there's an opponent's piece adjacent to theirs and an empty space on the other side, they can jump over and capture the opponent's piece.",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 85.0),
                                        child: Image.asset(
                                          "assets/images/checkers1.png",
                                          scale: 3,
                                        ),
                                      ),
                                      const Text(
                                        "MAIN GOAL",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "\nIf a piece reaches the last row on the opponent's side, it becomes a 'king' and can move in both directions.\n\n"
                                            "\nThe game is won by capturing all the opponent's pieces or by blocking their ability to move.",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 85.0),
                                        child: Image.asset(
                                          "assets/images/checkers2.png",
                                          scale: 3,
                                        ),
                                      ),
                                      const Text(
                                        "STRATEGY",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "\nIt's a good strategy to sacrifice one piece to capture two, keep pieces on the sides to avoid being jumped, and avoid bunching all pieces in the middle.\n\n\n\Planning ahead and practicing can also help improve the game.",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      // _bottomView(context),
                    ],
                  )
              ),
          ),
    );
  }

  Widget _headerView() {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0, right: 40.0, bottom: 30.0),
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
                    "Rules",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "How to play",
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



}
