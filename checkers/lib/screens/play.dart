
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../checker.dart';
import '../checkerboard_coordinate.dart';
import '../checkerboard_field.dart';
import '../checkers_match.dart';
import 'homepage.dart';

class Play extends StatelessWidget {
  const Play({super.key,
  required this.custom,
  required this.responseMatrix});

  final bool custom;
  final List<List<String>> responseMatrix;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkers Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayPage(title: 'Checkers Game', key: key, responseMatrix: responseMatrix, custom: custom),
    );
  }
}

class PlayPage extends StatefulWidget {

  final Color whiteFields = Color.fromRGBO(238,222,189, 1);
  final Color blackFields = Color(0xff7e6c62);
  final Color colorBorderTable = Color(0xff0a0100);
  final Color colorAppBar = Color(0xff6d3935);
  final Color colorBackgroundGame =  const Color(0xFF211810);
  final Color colorBackgroundHighlight = Colors.blue;
  final Color colorBackgroundHighlightAfterKilling = Colors.deepPurple;


  PlayPage({required Key? key, required this.title, required this.custom,
    required this.responseMatrix }) : super(key: key);

  final bool custom;
  final List<List<String>> responseMatrix;

  final String title;

  @override
  _PlayPageState createState() => _PlayPageState(custom, responseMatrix);
}

class _PlayPageState extends State<PlayPage> {

  late final bool custom;
  late final List<List<String>> responseMatrix;

  CheckersMatch gameTable = CheckersMatch();
  int modeWalking = 1;
  double blockSize = 1;
  bool isMatchStarted = false;
  bool isMatchFinished = false;
  bool isCurrentPlayerWidget = true;
  bool isWinnerWidget = true;
  bool isTipWidget = true;
  bool isOneColor = true;
  bool separateCustomGame = false;

  var winner = "-";

  int whitePieces = 0, blackPieces = 0;
  final List<bool> selectedPlayer= <bool>[true, false];


  _PlayPageState(this.custom, this.responseMatrix);

  @override
  void initState() {

    if(custom == false) {
      initGame();
      super.initState();
    }
    else {

      print(winner);

      for(int i=0; i < gameTable.numberOfRows; i++)
        {
          for(int j=0; j < gameTable.numberOfColumns; j++)
            {
              if(responseMatrix[i][j] == 'W')
                {
                  whitePieces += 1;
                  CheckerboardCoordinate checkerboardCoordinate = CheckerboardCoordinate(i, j);
                  gameTable.addChecker(checkerboardCoordinate, 1);
                }
              if(responseMatrix[i][j] == 'B')
              {
                blackPieces += 1;
                CheckerboardCoordinate checkerboardCoordinate = CheckerboardCoordinate(i, j);
                gameTable.addChecker(checkerboardCoordinate, 2);
              }
            }
        }
      if(whitePieces == 0 && blackPieces == 0)
      {
        isCurrentPlayerWidget = false;
        isWinnerWidget = false;
        isTipWidget = false;
        isMatchFinished = true;
      }
      if(whitePieces == 0 && blackPieces != 0) {
        isOneColor = true;
      }

      if(whitePieces != 0 && blackPieces == 0) {
        isOneColor = true;
      }
    }

  }

  void initGame() {
    gameTable.placeInitialCheckers();
  }



  @override
  Widget build(BuildContext context) {
    initScreenSize(context);
    return Scaffold(

        body: Container(color: widget.colorBackgroundGame, child:
        Column(children: <Widget>[
          const SizedBox(width: 100, height: 70),
          Visibility(
            visible: (custom && !isMatchStarted && isTipWidget),
            child: Card(
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
                        "images/king1.png",
                        scale: 2,
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
                                "Tap on checkers that were upgraded to kings before scanning the match!"
                                    "\n\nSelect the player who will make the next move!",
                                style: TextStyle(
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
            ),
          ),
          buildPlayingSuggestionWidget(),
          Expanded(
              child: Center(
                child: buildGameTable(context),
              )),

          buildWinnerWidget(),
          const SizedBox(width: 100),
          winner == "-" ? Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[buildCurrentPlayerTurn()],) : const SizedBox(height: 10),
          buildEmptyBoardWidget(),

          const SizedBox(width: 100, height: 7),
          buildSelectCurrentPlayer(),
          const SizedBox(width: 100, height: 20),
          buildStartMatchButton(),
          const SizedBox(width: 100, height: 30)
        ]))
    );
  }

  Widget buildStartMatchButton() {

    return Visibility(
      visible: (custom && !isMatchStarted),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromRGBO(238,222,189, 1),
          ),
        ),
        onPressed: () => {startMatch()},
        child: const Padding(
          padding: EdgeInsets.all(13.0),
          child: Text(
            "Start match!",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ),
    );

  }

  void initScreenSize(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double shortestSide = MediaQuery
        .of(context)
        .size
        .shortestSide;

    if (width < height) {
      blockSize = (shortestSide / 8) - (shortestSide * 0.03);
    } else {
      blockSize = (shortestSide / 8) - (shortestSide * 0.05);
    }
  }

  buildGameTable(BuildContext context) {
    List<Widget> listCol = [];
    for (int row = 0; row < gameTable.numberOfRows; row++) {
      List<Widget> listRow = [];
      for (int col = 0; col < gameTable.numberOfColumns; col++) {
        listRow.add(buildBlockContainer(CheckerboardCoordinate(row, col), context));
      }

      listCol.add(Row(mainAxisSize: MainAxisSize.min,
          children: listRow));
    }

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(padding: const EdgeInsets.all(5),
            color: widget.colorBorderTable,
            child: Column(mainAxisSize: MainAxisSize.min,
                children: listCol)),
      ),
    );
  }

  Widget buildBlockContainer(CheckerboardCoordinate coordinate, BuildContext context) {

    CheckerboardField block = gameTable.getCheckerboardField(coordinate);
    Color colorBackground;

    if (block.isHighlighted) {
      colorBackground = widget.colorBackgroundHighlight;
    } else if (block.isHighlightedAfterCapturing) {
      colorBackground = widget.colorBackgroundHighlightAfterKilling;
    } else {
      if (gameTable.isValidCheckerboardField(coordinate)) {
        colorBackground = widget.blackFields;
      } else {
        colorBackground = widget.whiteFields;
      }
    }



    Widget menWidget;
    if (block.checker.coordinate.row != -1 &&
        block.checker.coordinate.column != -1) {
      Checker men = gameTable
          .getCheckerboardField(coordinate)
          .checker;


      menWidget =
          GestureDetector(
            onTap: () {
              if(!isMatchStarted && custom) {
                men.checkerBecomesKing();
              }
              else
              {
                print(men.isKing);
              }
              setState(() {});
              },
            child: Center(child: buildMenWidget(
                player: men.player, isKing: men.isKing, size: blockSize)),
          );

      if (men.player == gameTable.currentPlayer) {

        menWidget = Draggable<Checker>(
            feedback: menWidget,
            childWhenDragging: Container(),
            data: men,
            onDragStarted: () {
              setState(() {
                isMatchStarted = true;
                gameTable.highlightPossibleMoves(men, type: modeWalking);
              });
            },
            onDragEnd: (details) {
              setState(() {
                gameTable.resetCheckerboardState();
              });
            },
            child: menWidget);
      }
    } else {
      menWidget = Container();
    }

    if (!gameTable.containsChecker(coordinate) &&
        gameTable.isValidCheckerboardField(coordinate)) {
      return DragTarget<Checker>(
          builder: (context, candidateData, rejectedData) {
            return buildBlockTableContainer(colorBackground, menWidget);
          },
          onWillAccept: (men) {
            CheckerboardField blockTable = gameTable
                .getCheckerboardField(coordinate);
            return true;
            // blockTable.isHighlighted || blockTable.isHighlightedAfterCapturing;
          },
          onAccept: (men) {
            int oldRow = men.coordinate.row;
            int oldColumn = men.coordinate.column;

            int newRow = coordinate.row;
            int newColumn = coordinate.column;


            int diffRow = (oldRow - newRow).abs();
            int diffColumn = (oldColumn - newColumn).abs();


            bool canMove = true;
            if (diffRow > 1 || diffColumn > 1) {
              canMove = gameTable.isJumpOnFieldAllowed(
                  oldRow, oldColumn, newRow, newColumn);
            }
            if ((isMatchStarted && custom) || !custom) {
              if (diffRow <= 2 && diffColumn <= 2 && oldRow != newRow &&
                  oldColumn != newColumn && canMove &&
                  gameTable.isMovingBackAllowed(men, oldRow, newRow)) {
                setState(() {
                  gameTable.moveChecker(
                      men, CheckerboardCoordinate.change(coordinate));
                  var canCapture = gameTable.canCapture(coordinate);
                  if ((gameTable.canCaptureMore(men, coordinate) && !men.isKing) || (men.isKing && gameTable.isSurroundedByOpponentFields(coordinate) && canCapture && gameTable.isJumpOnAtLeastOneFieldAllowed(coordinate))) {
                    modeWalking = 2;
                  } else {
                    if (gameTable.isOnKingRow(
                        gameTable.currentPlayer, coordinate)) {
                      men.checkerBecomesKing();
                    }
                    modeWalking = 1;
                    gameTable.resetCheckerboardState();
                    gameTable.changePlayerTurn();
                  }
                });
              }
            }
          });
    }


    return buildBlockTableContainer(colorBackground, menWidget);
  }

  Widget buildBlockTableContainer(Color colorBackground, Widget menWidget) {
    Widget containerBackground = Container(
        width: blockSize + (blockSize * 0.13),
        height: blockSize + (blockSize * 0.13),
        color: colorBackground,
        margin: const EdgeInsets.all(0),
        child: menWidget);
    return containerBackground;
  }

  Widget buildCurrentPlayerTurn() {

    print(isMatchFinished);
    print(isMatchStarted);


    return Visibility(
      visible: ((custom && isMatchStarted)  ||  (!custom && isMatchFinished) || (!custom && separateCustomGame && !isMatchFinished)),
      child: SizedBox(
        width: 360,
        height: 70,
        child: Card(
            color: const Color.fromRGBO(238,222,189, 1),
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
                    child: buildMenWidget(
                        player: gameTable.currentPlayer, size: blockSize)),
              )
            ])
        ),
      ),
    );
  }

  buildWinnerWidget() {

    if(whitePieces == 0 && blackPieces != 0) {
      isOneColor = true;
    }

    if(whitePieces != 0 && blackPieces == 0) {
      isOneColor = true;
    }

    if (gameTable.checkWinner() == 1) {
      winner = "White";
    } else if (gameTable.checkWinner() == 2) {
      winner = "Black";
    }

    isMatchFinished = true;
    // winner = winner.toUpperCase();

    return (gameTable.checkWinner() != 0 && isWinnerWidget && ((isMatchStarted && custom) || !custom)) ? Column(
            children: [
              SizedBox(
                height: 70,
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
                            "images/the-end.png",
                            scale: 2,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, top: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "   $winner won! ",
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
              const SizedBox(width: 30, height: 50),
              Container(
                  width: 350,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      color: const Color.fromRGBO(238, 222, 189, 1.0)
                  ),
                  child: Padding(padding: const EdgeInsets.all(3),
                      child: TextButton(
                        onPressed: () {
                          isMatchFinished = false;
                          isMatchStarted = true;
                          separateCustomGame = true;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                const Play(custom: false, responseMatrix: [[]],)),
                          );
                        },
                        child: const Text("Play Again!", style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),)
                  )
              )
            ]) : const SizedBox(width: 1.0, height: 1.0);
  }

  buildMenWidget({int player = 1, bool isKing = false, double size = 32}) {
    if (isKing) {
      return Container(width: size, height: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(
                  color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)
              ],
              color: player == 2 ? Colors.black54 : Colors.grey[100]),
          child: ImageIcon(const AssetImage("images/king1.png"),
              color: player == 2 ? Colors.grey[100]?.withOpacity(0.5) : Colors
                  .black54.withOpacity(0.5),
              size: size - (size * 0.1)));
    }

    return Container(width: size, height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: const [BoxShadow(
                color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)
            ],
            color: player == 2 ? Colors.black54 : Colors.grey[100]),
            child: ImageIcon(const AssetImage("images/piece_style.png"),
                color: player == 2 ? Colors.grey[100]?.withOpacity(0.1) : Colors
                    .black54.withOpacity(0.1),
                size: size - (size * 0.1)));
  }

  void startMatch() {
    isMatchFinished = false;
    isMatchStarted = true;
    setState(() {
    });
  }

  Widget buildSelectCurrentPlayer() {

    const List<Widget> players = <Widget>[
      Text('   Black   ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      Text('   White   ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
    ];

    return Visibility(
      visible: (custom && !isMatchStarted && isCurrentPlayerWidget),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(252, 252, 252, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ToggleButtons(
          onPressed: (int index) {
            setState(() {
              // The button that is tapped is set to true, and the others to false.
              for (int i = 0; i < selectedPlayer.length; i++) {
                selectedPlayer[i] = i == index;

                if(index == 0) {
                  gameTable.currentPlayer = 2;
                }
                else {
                  gameTable.currentPlayer = 1;
                }
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

  buildEmptyBoardWidget() {

    var isEmpty = false;

    if(whitePieces == 0 && blackPieces ==0 && custom){
      isEmpty = true;
      isMatchStarted = true;
    }

    return Visibility(
      visible: isEmpty,
      child: Column(
        children: [Visibility(
        visible: isEmpty,
        child: SizedBox(
          height: 90,
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
                      "images/the-end.png",
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
                              "   Empty Chessboard! \n        No Winner!",
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
      ),
                const SizedBox(width: 30, height: 50),
                Container(
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        color: const Color.fromRGBO(238, 222, 189, 1.0)
                    ),
                    child: Padding(padding: const EdgeInsets.all(3),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  const Play(custom: false, responseMatrix: [[]],)),
                            );
                          },
                          child: const Text("Play Again!", style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),)
                    )
                )
              ])
      );
  }

  buildPlayingSuggestionWidget() {


    return Visibility(
      visible: ((isMatchStarted || !custom) && gameTable.checkWinner() == 0),
      child: Card(
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
                  scale: 2,
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
    );
  }

}