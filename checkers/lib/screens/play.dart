
import 'package:flutter/material.dart';

import '../checker.dart';
import '../checkerboard_coordinate.dart';
import '../checkerboard_field.dart';
import '../checkers_match.dart';

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
      home: PlayOfflinePage(title: 'Checkers Game', key: key, responseMatrix: responseMatrix, custom: custom),
    );
  }
}

class PlayOfflinePage extends StatefulWidget {

  final Color whiteFields = Color.fromRGBO(254, 246, 218, 1);
  final Color blackFields = Color(0xff9d7760);
  final Color colorBorderTable = Color(0xff0a0100);
  final Color colorAppBar = Color(0xff6d3935);
  final Color colorBackgroundGame =  const Color(0xFF38302B);
  final Color colorBackgroundHighlight = Colors.blue;
  final Color colorBackgroundHighlightAfterKilling = Colors.deepPurple;

  PlayOfflinePage({required Key? key, required this.title, required this.custom,
    required this.responseMatrix }) : super(key: key);

  final bool custom;
  final List<List<String>> responseMatrix;

  final String title;

  @override
  _PlayOfflinePageState createState() => _PlayOfflinePageState(custom, responseMatrix);
}

class _PlayOfflinePageState extends State<PlayOfflinePage> {

  late final bool custom;
  late final List<List<String>> responseMatrix;

  CheckersMatch gameTable = CheckersMatch();
  int modeWalking = 1;
  double blockSize = 1;

  _PlayOfflinePageState(this.custom, this.responseMatrix);

  @override
  void initState() {

    if(custom == false) {
      initGame();
      super.initState();
    }
    else {
      for(int i=0; i < gameTable.numberOfRows; i++)
        {
          for(int j=0; j < gameTable.numberOfColumns; j++)
            {
              if(responseMatrix[i][j] == 'W')
                {
                  CheckerboardCoordinate checkerboardCoordinate = CheckerboardCoordinate(i, j);
                  gameTable.addChecker(checkerboardCoordinate, 1);
                }
              if(responseMatrix[i][j] == 'B')
              {
                CheckerboardCoordinate checkerboardCoordinate = CheckerboardCoordinate(i, j);
                gameTable.addChecker(checkerboardCoordinate, 2);
              }
            }
        }
    }

  }

  void initGame() {
    gameTable.placeInitialCheckers();
    // print(gameTable.getCheckerboard()[0][0].checker);
    // print(gameTable.getCheckerboard()[0][0].row);
    // print(gameTable.getCheckerboard()[0][0].column);
    // print(gameTable.getCheckerboard()[0][0].canCaptureAgain);
    // print(gameTable.getCheckerboard()[0][0].capturedChecker);
    // print(gameTable.getCheckerboard()[0][0].isHighlightedAfterCapturing);
  }



  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Scaffold(

        body: Container(color: widget.colorBackgroundGame, child:
        Column(children: <Widget>[
          const SizedBox(width: 100, height: 50),
          Expanded(
              child: Center(
                child: buildGameTable(),
              )),
          buildWinnerWidget(),
          const SizedBox(width: 100, height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[buildCurrentPlayerTurn()],),

          const SizedBox(width: 100, height: 100),
        ]))
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

  buildGameTable() {
    List<Widget> listCol = [];
    for (int row = 0; row < gameTable.numberOfRows; row++) {
      List<Widget> listRow = [];
      for (int col = 0; col < gameTable.numberOfColumns; col++) {
        listRow.add(buildBlockContainer(CheckerboardCoordinate(row, col)));
      }

      listCol.add(Row(mainAxisSize: MainAxisSize.min,
          children: listRow));
    }

    return Container(
      color: Color(0xffecd7ce),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(padding: const EdgeInsets.all(2),
            color: widget.colorBorderTable,
            child: Column(mainAxisSize: MainAxisSize.min,
                children: listCol)),
      ),
    );
  }

  Widget buildBlockContainer(CheckerboardCoordinate coordinate) {
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
          Center(child: buildMenWidget(
              player: men.player, isKing: men.isKing, size: blockSize - 1));

      if (men.player == gameTable.currentPlayer) {
        menWidget = Draggable<Checker>(
            feedback: menWidget,
            childWhenDragging: Container(),
            data: men,
            onDragStarted: () {
              setState(() {
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

            if (diffRow <= 2 && diffColumn <= 2 && oldRow != newRow &&
                oldColumn != newColumn && canMove &&
                gameTable.isMovingBackAllowed(men, oldRow, newRow)) {
              setState(() {
                gameTable.moveChecker(
                    men, CheckerboardCoordinate.change(coordinate));
                gameTable.canCapture(coordinate);
                if (gameTable.canCaptureMore(men, coordinate)) {
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
          });
    }

    return buildBlockTableContainer(colorBackground, menWidget);
  }

  Widget buildBlockTableContainer(Color colorBackground, Widget menWidget) {
    Widget containerBackground = Container(
        width: blockSize + (blockSize * 0.1),
        height: blockSize + (blockSize * 0.1),
        color: colorBackground,
        margin: const EdgeInsets.all(3),
        child: menWidget);
    return containerBackground;
  }

  Widget buildCurrentPlayerTurn() {
    return SizedBox(
      width: 360,
      height: 70,
      child: Card(
          color: const Color.fromRGBO(254, 246, 218, 1),
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
                  color: const Color(0xff9d7760)
              ),
              child: Padding(padding: const EdgeInsets.all(10),
                  child: buildMenWidget(
                      player: gameTable.currentPlayer, size: blockSize)),
            )
          ])
      ),
    );
  }

  buildWinnerWidget() {
    var winner = "-";
    if (gameTable.checkWinner() == 1) {
      winner = "White";
    } else if (gameTable.checkWinner() == 2) {
      winner = "Black";
    }

    // winner = winner.toUpperCase();

    return gameTable.checkWinner() != 0 ? Card(

        color: const Color(0xff9d7760),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 1,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            "WINNER: $winner ",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10, height: 75),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  color: const Color.fromRGBO(254, 246, 218, 1)
              ),
              child: Padding(padding: const EdgeInsets.all(3),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const Play(custom: false, responseMatrix: [[]],)),
                      );
                    },
                    child: const Text("Play again", style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),)
              )
          )
        ])
    ) : const SizedBox(width: 1.0, height: 1.0);
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
          child: ImageIcon(const AssetImage("assets/images/king1.png"),
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
            color: player == 2 ? Colors.black54 : Colors.grey[100]));
  }


}