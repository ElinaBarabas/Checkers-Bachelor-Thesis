import 'dart:io';

import 'package:flutter/material.dart';


class Rules extends StatefulWidget {
  const Rules({super.key});


  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {

  late bool checkersRule = false;
  late bool chessRule = true;
  // @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF211810),
        body: SingleChildScrollView(
          child: Column(
                children: [
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
                                const Color.fromRGBO(238, 222, 189, 1.0),
                              ),
                            ),
                            onPressed: () => { showChessRules()},
                            child: const Text(
                              "Checkers",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      const SizedBox(width: 5),
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
                                const Color.fromRGBO(238, 222, 189, 1.0),
                              ),
                            ),
                            onPressed: () => {showCheckersRules()},
                            child: const Text(
                              "Chess",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      const SizedBox(width: 5),

                    ],
                  ),
                      _headerView(),
                      Visibility(
                        visible: checkersRule,
                        child: Card(
                          color: const Color.fromRGBO(238, 222, 189, 1.0),
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
                                            "images/checkers1.png",
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
                                            "images/checkers2.png",
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
                        ),
                      ),
                  Visibility(
                    visible: chessRule,
                    child: Card(
                      color: const Color.fromRGBO(238, 222, 189, 1.0),
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
                                      "\nChess is a strategic board game played by two people. \n\n"
                                          "It is often referred to as the sport of the mind. \nIt is demonstrated that it improves skill, strategy, and foresight.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 80.0, top: 40, bottom: 40),
                                      child: Image.asset(
                                        "images/horse.png",
                                        scale: 4,
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
                                      "\nThe goal of the game is to checkmate the opponent's king, putting it under attack with no way out.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 80.0, top: 40, bottom: 40),
                                      child: Image.asset(
                                        "images/mate.png",
                                        scale: 4,
                                      ),
                                    ),
                                    const Text(
                                      "MOVING RULES AND PIECES' VALUE",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Text(
                                      "King - infinitely:\n",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    const Text(
                                      "Moves one field in any direction, avoiding squares under attack.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const Text(
                                      "\nQueen - 9 points:\n",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    const Text(
                                      "Moves any number of squares in any direction.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const Text(
                                      "\nRook - 5 points:\n",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    const Text(
                                      "Moves any number of squares horizontally or vertically.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const Text(
                                      "\nBishop - 3 points:\n",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    const Text(
                                      "Moves any number of squares diagonally.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const Text(
                                      "\nKnight - 3 points:\n",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    const Text(
                                      "Moves in an 'L' shape, consisting of two squares in one direction and then one square perpendicular to that direction.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const Text(
                                      "\nPawn - 1 point:\n",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),

                                    const Text(
                                      "Moves forward one square, captures diagonally, and has special rules for the first move and promotion when "
                                      "reaching the opposite end of the board.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 80.0, top: 30, bottom: 40),
                                      child: Image.asset(
                                        "images/chess_move.png",
                                        scale: 4,
                                      ),
                                    ),
                                    const Text(
                                      "BASIC STRATEGY",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const Text(
                                      "Protect Your King - Safeguard your king by castling early and ensuring its safety.\n"
                                      "\nDon't Give Pieces Away -  Value each chess piece and avoid losing them carelessly.\n"
                                    "\nControl The Center Of The Chessboard -  Aim to dominate the central squares with your pieces and pawns.\n"
                                    "\nUse All Of Your Chess Pieces - Actively involve all your pieces in the game. Avoid keeping them idle on the back row.",
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

  showChessRules() {

    setState(() {
      checkersRule = true;
      chessRule = false;
    });
  }

  showCheckersRules() {

    setState(() {
      checkersRule = false;
      chessRule = true;
    });
  }



}
