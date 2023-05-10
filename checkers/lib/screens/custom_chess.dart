import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../chess_logic/chess_board.dart';
import '../chess_logic/chess_board_controller.dart';
import '../chess_logic/constants.dart';


class CustomChessScreen extends StatefulWidget {
  const CustomChessScreen({Key? key, required this.fenString, required this.isPasted}) : super(key: key);
  final String fenString;
  final bool isPasted;

  @override
  _CustomChessScreenState createState() => _CustomChessScreenState();
}

class _CustomChessScreenState extends State<CustomChessScreen> {
  ChessBoardController controller = ChessBoardController();
  late bool isCheck = false;
  late bool isMate = false;
  late bool isStaleMate = false;
  late bool isDraw = false;
  late bool isInvalid = false;
  late bool canStart = false;
  late bool isSelectPlayerDisplayed = true;
  late String suggestion = "Before starting the game, choose whose turn is! \n";
  late String error = "";
  late bool isInitialConfiguration = false;


  final List<bool> selectedPlayer= <bool>[false, true];

  @override
  void initState() {

    error = "";
    //4k2r/6r1/8/8/8/8/3R4/R3K3 b Qk - 0 1
    if(widget.fenString == "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
      {
        isInitialConfiguration = true;
      }

    controller.loadFen(widget.fenString);


    super.initState();
    controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    isCheck = controller.isInCheck();
    isMate = controller.isCheckMate();
    isStaleMate = controller.isStaleMate();
    isDraw = controller.isDraw();

    setState(() {
      // Rebuild the widget tree when the controller changes to update the current player widget
    });
  }


  @override
  Widget build(BuildContext context) {

    checkConfiguration(context);

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
          error != "" ? buildErrorWidget() : const SizedBox(width: 1 ,),
          error == "" && !isInvalid ? buildMovingSuggestionWidget() : const SizedBox(width: 1,height: 1,),
          // (!canStart && !widget.isPasted) ? showAlertDialog(context) : SizedBox(width: 1,),
          const SizedBox(height: 5),
          (!widget.isPasted && isSelectPlayerDisplayed && error == "" && !isInitialConfiguration) ? buildSelectCurrentPlayer() : const SizedBox(width: 1, height: 1,),
          const SizedBox(height: 5),

          GestureDetector(
            onVerticalDragStart: hide(context),
            onTap: hide(context),
            child: Center(
              child: ChessBoard(
                controller: controller,
                boardColor: BoardColor.darkBrown,
                boardOrientation: PlayerColor.white,
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[buildCurrentPlayerWidget()],),
          SizedBox(height: 10),
          buildMatchStatesWidget(),


        ],
      ),
    );
  }

  buildCurrentPlayerWidget() {

    print(isSelectPlayerDisplayed);
    print(!widget.isPasted && isSelectPlayerDisplayed && error == "");

    if(isMate || isStaleMate || isDraw || isInvalid) {
      return SizedBox(
          width: 360,
          height: 60,
          child: GestureDetector(
              onTap: () => {isInvalid = false, error = "", controller.resetBoard()},
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
      visible: !isMate && !isDraw && !isStaleMate,
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

  buildMatchStatesWidget() {

    var currentTurn = controller.game.turn.toString();

    String kingInCheck = currentTurn =="Color.BLACK" ? "Black" : "White";
    String kingInMate = currentTurn =="Color.WHITE" ? "Black" : "White";

    if(isStaleMate){
      return Visibility(
        visible: isStaleMate,
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
                      "images/draw.png",
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
                          children: const [
                            Text(
                              "    Stalemate!",
                              style: TextStyle(
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

    if(isDraw){
      return Visibility(
        visible: isDraw,
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
                      "images/draw.png",
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
                          children: const [
                            Text(
                              "        Draw!",
                              style: TextStyle(
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
  Widget buildSelectCurrentPlayer() {

    const List<Widget> players = <Widget>[
      Text('   Black   ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      Text('   White   ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
    ];

    return Visibility(
      visible: !canStart,
      child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffb2a59b),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: ToggleButtons(
            onPressed: (int index) {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < selectedPlayer.length; i++) {
                  selectedPlayer[i] = i == index;

                  if(index == 0) {;
                    var my_fen = widget.fenString.replaceFirst("w", "b");
                    print(my_fen);
                    controller.loadFen(my_fen);
                  }
                  else {
                    print("alb");
                  }
                  canStart = true;
                }
              });
            },
            selectedBorderColor: Color(0xFFFFFFFF),
            selectedColor:  Color(0xFF7e6c62),
            fillColor:  Colors.black54,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            isSelected: selectedPlayer,
            children: players,
          ),
        ),
    );
  }

   checkConfiguration(BuildContext context) {

    try {
      print(controller.getPossibleMoves());
    }
    catch(e)
    {
      error = "Invalid Match";
      isInvalid = true;
      setState(() {

      });
    }


  }

  Widget buildErrorWidget() {

    return SizedBox(
      height: 75,
      child: Card(
        color: const Color.fromRGBO(255, 255, 255, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  "images/cross.png",
                  scale: 5,
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Invalid Configuration!",
                          style: TextStyle(
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
    );

  }

  buildMovingSuggestionWidget() {

    return Card(
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
                    children: [
                      Text(
                        "$suggestion"
                            "For making a move, you must drag a piece to the field on which you want to place it.",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );


  }

  hide(BuildContext context) {

    suggestion = "";
    isSelectPlayerDisplayed = false;
  }



}

