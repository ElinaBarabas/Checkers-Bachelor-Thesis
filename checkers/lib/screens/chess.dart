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
  late bool isCheck = false;
  late bool isMate = false;

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
    isCheck = controller.game.in_check;
    isMate = controller.isCheckMate();
    print(isMate);
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
          const SizedBox(height: 5),
          Center(
            child: ChessBoard(
              controller: controller,
              boardColor: BoardColor.darkBrown,
              boardOrientation: PlayerColor.white,
            ),
          ),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[buildCurrentPlayerWidget()],),
          buildCheckWidget(),

        ],
      ),
    );
  }

  buildCurrentPlayerWidget() {

    if(isMate) {
      return SizedBox(
          width: 360,
          height: 60,
          child: GestureDetector(
              onTap: () => {controller.resetBoard()},
              child: Card(
                color: const Color.fromRGBO(238, 222, 189, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: const Center(
                  child: Text(
                    "Play Again!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
          ));
    }

    return Visibility(
      visible: !isMate,
      child: SizedBox(
        width: 360,
        height: 60,
        child: Card(
            color: const Color.fromRGBO(238, 222, 189, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 1,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Text(
                "CURRENT TURN     ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xff7e6c62)
                ),
                child: Padding(padding: const EdgeInsets.all(10),
                    child: buildPlayerWidget(
                        player: controller.game.turn.toString(), size: 20.0)),
              )
            ])
        ),
      ),
    );
  }


  Widget buildPlayerWidget({required String player, required double size}) {

    final color = player == "Color.BLACK" ? Colors.black : Colors.grey[100];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
        color: color,
      )
    );
  }

  buildCheckWidget() {

    var currentTurn = controller.game.turn.toString();

    String kingInCheck = currentTurn =="Color.BLACK" ? "Black" : "White";
    String kingInMate = currentTurn =="Color.WHITE" ? "Black" : "White";

    if (isMate)
    {
      return Visibility(
        visible: isMate,
        child: SizedBox(
          height: 75,
          child: Card(
            color: const Color.fromRGBO(255, 255, 255, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      "images/checkmate.png",
                      scale: 2,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, top: 13),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Checkmate! $kingInMate Wins!",
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
          ),
        ),
      );

    }
    else {
      return Visibility(
        visible: (isCheck && !isMate),
        child: SizedBox(
          height: 75,
          child: Card(
            color: const Color.fromRGBO(255, 255, 255, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      "images/king.png",
                      scale: 2,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 13),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$kingInCheck King is in check!",
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
          ),
        ),
      );
    }
  }

}

