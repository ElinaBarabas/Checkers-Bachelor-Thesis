import 'package:checkers/checkerboard_field.dart';
import 'package:checkers/screens/rules.dart';
import 'package:flutter/material.dart';

import 'checker.dart';
import 'checkerboard_coordinate.dart';
import 'checkers_match.dart';
import 'screens/homepage.dart';

void main() {

  // CheckersMatch match = CheckersMatch();
  //
  // match.printCheckers();
  //
  // print("-----------------------");
  // Checker checker = Checker(1, false, CheckerboardCoordinate(1, 0));
  // Checker checker2 = Checker(2, false, CheckerboardCoordinate(7, 6));
  // match.moveChecker(checker, CheckerboardCoordinate(2,1));
  // match.printCheckers();
  //
  // print("-----------------------");
  // match.moveChecker(checker2, CheckerboardCoordinate(3,2));
  // match.printCheckers();


  // match.containsOpponentChecker(CheckerboardCoordinate(0,1));
  // print("-----------------------");
  // match.containsChecker(CheckerboardCoordinate(3, 2));
  // match.containsChecker(CheckerboardCoordinate(4, 0));


  runApp(MaterialApp(
      routes: {
        '/': (context) => const Homepage(),
        '/scan': (context) => const Rules(),
        '/play': (context) => const MyApp(),
        '/rules': (context) => const Rules(),
      }
  ));
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkers Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyGamePage(title: 'Checkers Game', key: key),
    );
  }
}

class MyGamePage extends StatefulWidget {

  final Color whiteFields = Color.fromRGBO(254, 246, 218, 1);
  final Color blackFields = Color(0xff9d7760);
  final Color colorBorderTable = Color(0xff0a0100);
  final Color colorAppBar = Color(0xff6d3935);
  final Color colorBackgroundGame =  const Color(0xFF38302B);
  final Color colorBackgroundHighlight = Colors.blue;
  final Color colorBackgroundHighlightAfterKilling = Colors.deepPurple;

  MyGamePage({required Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {

  CheckersMatch gameTable = CheckersMatch();
  int modeWalking = 1;
  double blockSize = 1;

  @override
  void initState() {
    initGame();
    super.initState();
  }

  void initGame() {
      gameTable.placeInitialCheckers();
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    var winner = "-";
    if(gameTable.checkWinner() == 1) {
      winner = "Black";
    } else if(gameTable.checkWinner() == 2) {
      winner = "White";
    }


    Widget alertWidget = gameTable.checkWinner() != 0 ? AlertDialog(
      content: Text(
      "Congratulations!\n\n\WINNER: $winner", style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,) ,
      backgroundColor: const Color(0xFF2C2623),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const MyApp()),
            );
          },
          child: const Text("OK", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ],
    ) : const SizedBox( width: 1.0, height: 1.0);


    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: widget.colorAppBar,
        //   centerTitle: true,
        //   title: Text(widget.title.toUpperCase()),
        //   elevation: 0,
        // ),
        body: Container(color: widget.colorBackgroundGame, child:
        Column(children: <Widget>[
          Expanded(
              child: Center(
                child: buildGameTable(),
              )),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[buildCurrentPlayerTurn()],),
          const SizedBox(width: 100, height: 50),
            alertWidget,
          const SizedBox(width: 100, height: 20),

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
        child: Container(padding: const EdgeInsets.all(4),
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
    if (block.checker.coordinate.row != -1 && block.checker.coordinate.column != -1) {
      Checker men = gameTable
          .getCheckerboardField(coordinate)
          .checker;

      menWidget =
          Center(child: buildMenWidget(player: men.player, isKing: men.isKing, size: blockSize - 7));

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

    if (!gameTable.containsChecker(coordinate) && gameTable.isValidCheckerboardField(coordinate)) {

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
            print("onAccept");
            setState(() {
              gameTable.moveChecker(men, CheckerboardCoordinate.change(coordinate));
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
    return Card(
      color: Colors.deepPurple,
      child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text("Current turn".toUpperCase(),
                style: const TextStyle(fontSize: 20, color: Colors.white)),
            Padding(padding: const EdgeInsets.all(20),
                child: buildMenWidget(player: gameTable.currentPlayer, size: blockSize))
          ]),
    );
  }

  buildMenWidget({int player = 1, bool isKing = false, double size = 32}) {
    if (isKing) {
      return Container(width: size, height: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(
                  color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)
              ],
              color: player == 1 ? Colors.black54 : Colors.grey[100]),
          child: Icon(Icons.star,
              color: player == 1 ? Colors.grey[100]?.withOpacity(0.5) : Colors
                  .black54.withOpacity(0.5),
              size: size - (size * 0.1)));
    }

    return Container(width: size, height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(
                color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)
            ],
            color: player == 1 ? Colors.black54 : Colors.grey[100]));
  }


}