import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chess_logic/chess_board.dart';
import 'chess_logic/chess_board_controller.dart';
import 'chess_logic/constants.dart';

class ChessScreen extends StatefulWidget {
  const ChessScreen({Key? key}) : super(key: key);

  @override
  _ChessScreenState createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
  ChessBoardController controller = ChessBoardController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {
      // Rebuild the widget tree when the controller changes to update the current player widget
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211810),
      appBar: AppBar(
        elevation: 0.0,
        leading: Row(
          children: [
            IconButton(
              icon: Image.asset('images/back.png'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFF211810),
      ),
      body: Column(
        children: [
          Card(
            color: const Color.fromRGBO(255, 255, 255, 1.0),
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
                    flex: 1,
                    child: Image.asset(
                      "images/drag.png",
                      scale: 3,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "For making a move, you must drag a piece to the field on which you want to place it.",
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
          const SizedBox(height: 20),
          Center(
            child: ChessBoard(
              controller: controller,
              boardColor: BoardColor.darkBrown,
              boardOrientation: PlayerColor.white,
            ),
          ),
          SizedBox(height: 20),
          // Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: <Widget>[buildCurrentPlayerWidget()],),

        ],
      ),
    );
  }

  // buildCurrentPlayerWidget() {
  //
  //   print(controller.game.turn);
  //   return SizedBox(
  //     width: 360,
  //     height: 70,
  //     child: Card(
  //         color: const Color.fromRGBO(238,222,189, 1),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(40),
  //         ),
  //         elevation: 1,
  //         child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
  //           const Text(
  //             "CURRENT TURN     ",
  //             style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //           Container(
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(100),
  //                 color: const Color(0xff7e6c62)
  //             ),
  //             child: Padding(padding: const EdgeInsets.all(10),
  //                 child: buildPlayerWidget(
  //                     player: controller.game.turn.toString(), size: 20.0)),
  //           )
  //         ])
  //     ),
  //   );
  //
  //
  // }
  //
  // Widget buildPlayerWidget({required String player, required double size}) {
  //   print(player.toString());
  //
  //   final color = player == "black" ? Colors.black : Colors.grey[100];
  //
  //   return Container(
  //     width: size,
  //     height: size,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       boxShadow: const [
  //         BoxShadow(
  //           color: Colors.black45,
  //           offset: Offset(0, 4),
  //           blurRadius: 4,
  //         ),
  //       ],
  //       color: color,
  //     ),
  //     child: ImageIcon(
  //       const AssetImage("images/piece_style.png"),
  //       color: color?.withOpacity(0.1),
  //       size: size - (size * 0.1),
  //     ),
  //   );
  // }


}

