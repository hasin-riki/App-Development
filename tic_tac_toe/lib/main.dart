import 'package:flutter/material.dart';
import 'package:tic_tac_toe/scores.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

const double defaultPadding = 16.0;
String player1 = 'Player 1';
String player2 = 'Player 2';
int scorePlayer1 = 0;
int scorePlayer2 = 0;
String playerWon = "";
ValueNotifier<bool> playerTurn = ValueNotifier(false);
bool firstTurn = false;
bool startGame = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Color(0xFFFAF9F6)),
      home: const MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController1 = TextEditingController(text: player1);
  TextEditingController textController2 = TextEditingController(text: player2);
  List<bool?> board = [];
  bool currentTurn = firstTurn; //false=Player1,true=Player2

  @override
  void initState() {
    for (int i = 0; i < 9; i++) {
      board.add(null);
    }

    super.initState();
  }

  Future createScore(int result) async {
    final docScore = FirebaseFirestore.instance.collection('scores').doc();

    final json = {
      'player1': player1,
      'player2': player2,
      'result': result,
      'createdAt': Timestamp.now(),
    };
    await docScore.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(color: Color(0xFFFAF9F6))),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: defaultPadding * 2),
              ValueListenableBuilder(
                valueListenable: playerTurn,
                builder: (context, turn, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onDoubleTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Name yourself!'),
                              content: TextField(
                                controller: textController1,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          textController1.clear();
                                        },
                                        icon: Icon(Icons.clear))),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        player1 = textController1.text;
                                      });
                                    },
                                    child: Text('ENTER'))
                              ],
                            ),
                          );
                        },
                        child: Column(children: [
                          Text((player1),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: startGame == false
                                      ? Colors.indigo
                                      : turn
                                          ? Colors.indigo
                                          : Colors.green)),
                          Text("(X)",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: startGame == false
                                      ? Colors.indigo
                                      : turn
                                          ? Colors.indigo
                                          : Colors.green)),
                        ]),
                      ),
                      Text(
                        'vs',
                        style: TextStyle(fontSize: 19, color: Colors.indigo),
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Name yourself!'),
                              content: TextField(
                                controller: textController2,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          textController2.clear();
                                        },
                                        icon: Icon(Icons.clear))),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        player2 = textController2.text;
                                      });
                                    },
                                    child: Text('ENTER'))
                              ],
                            ),
                          );
                        },
                        child: Column(children: [
                          Text((player2),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: startGame == false
                                      ? Colors.indigo
                                      : turn
                                          ? Colors.green
                                          : Colors.indigo)),
                          Text("(O)",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: startGame == false
                                      ? Colors.indigo
                                      : turn
                                          ? Colors.green
                                          : Colors.indigo)),
                        ]),
                      ),
                    ]),
              ),
              SizedBox(height: defaultPadding * 5),
              Table(
                border: TableBorder(
                    horizontalInside:
                        BorderSide(width: 5, color: Colors.indigo),
                    verticalInside: BorderSide(width: 5, color: Colors.indigo),
                    borderRadius: BorderRadius.circular(200)),
                defaultColumnWidth: FractionColumnWidth(0.28),
                children: [
                  TableRow(children: [
                    TableCell(child: slot(0)),
                    TableCell(child: slot(1)),
                    TableCell(child: slot(2)),
                  ]),
                  TableRow(children: [
                    TableCell(child: slot(3)),
                    TableCell(child: slot(4)),
                    TableCell(child: slot(5)),
                  ]),
                  TableRow(children: [
                    TableCell(child: slot(6)),
                    TableCell(child: slot(7)),
                    TableCell(child: slot(8)),
                  ]),
                ],
              ),
              SizedBox(height: defaultPadding * 3.5),
              ValueListenableBuilder(
                valueListenable: playerTurn,
                builder: (context, turn, child) => ElevatedButton(
                    onPressed: () {
                      setState(() {
                        startGame = true;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        startGame == false
                            ? "Start Match!"
                            : turn
                                ? "$player2's turn"
                                : "$player1's turn",
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFFFAF9F6)
                        ),
                      ),
                    )),
              ),
              SizedBox(height: defaultPadding * 3.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      children: [
                        Text(
                            scorePlayer1 == scorePlayer2
                                ? "$player1🙃"
                                : scorePlayer1 > scorePlayer2
                                    ? "$player1🤣"
                                    : "$player1😡",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: scorePlayer1 == scorePlayer2
                                    ? Colors.indigo
                                    : scorePlayer1 > scorePlayer2
                                        ? Colors.green
                                        : Colors.red)),
                        Text(scorePlayer1.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: scorePlayer1 == scorePlayer2
                                    ? Colors.indigo
                                    : scorePlayer1 > scorePlayer2
                                        ? Colors.green
                                        : Colors.red))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Column(
                      children: [
                        Text(
                            scorePlayer1 == scorePlayer2
                                ? "😎$player2"
                                : scorePlayer1 > scorePlayer2
                                    ? "🥲$player2"
                                    : "😁$player2",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: scorePlayer1 == scorePlayer2
                                    ? Colors.indigo
                                    : scorePlayer1 > scorePlayer2
                                        ? Colors.red
                                        : Colors.green)),
                        Text(scorePlayer2.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: scorePlayer1 == scorePlayer2
                                    ? Colors.indigo
                                    : scorePlayer1 > scorePlayer2
                                        ? Colors.red
                                        : Colors.green))
                      ],
                    ),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Scores()));
                  },
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: const Text(
                        'Scores ->',
                        style: TextStyle(fontSize: 17),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  bool hasWonGame(bool turn) {
    const List<List<int>> winningCombos = [
      // horizontal
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      // vertical
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      // diagonal
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (int i = 0; i < winningCombos.length; i++) {
      List<int> checkWinningCombo = winningCombos[i];
      if ((board[checkWinningCombo[0]] == turn) &&
          (board[checkWinningCombo[1]] == turn) &&
          (board[checkWinningCombo[2]] == turn)) {
        return true;
      }
    }
    return false;
  }

  bool tie() {
    for (int i = 0; i < 9; i++) {
      if (board[i] == null) {
        return false;
      }
    }
    return true;
  }

  evaluateGame() async {
    if (hasWonGame(currentTurn)) {
      if (currentTurn) {
        playerWon = (player2);
        scorePlayer2++;
        createScore(2);
      } else {
        playerWon = (player1);
        scorePlayer1++;
        createScore(1);
      }
      return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Win!"),
          content: Text(
              "Congratulations " + (playerWon) + "! You have won the match!"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  for (int i = 0; i < 9; i++) {
                    board[i] = null;
                  }
                  firstTurn = !firstTurn;
                  currentTurn = firstTurn;
                  playerTurn = ValueNotifier(currentTurn);
                  startGame = false;
                });
                Navigator.of(context).pop();
              },
              child: Text("PLAY AGAIN"),
            ),
          ],
        ),
      );
    }
    if (tie()) {
      createScore(0);
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Tie!"),
          content: Text("A tough match!"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  for (int i = 0; i < 9; i++) {
                    board[i] = null;
                    firstTurn = !firstTurn;
                    currentTurn = firstTurn;
                    playerTurn = ValueNotifier(currentTurn);
                    startGame = false;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text("PLAY AGAIN"),
            ),
          ],
        ),
      );
    }
    currentTurn = !currentTurn;
    playerTurn = ValueNotifier(currentTurn);
    playerTurn.notifyListeners();
  }

  Widget slot(int i) {
    return InkWell(
      onTap: () {
        if (board[i] != null || startGame == false) {
          return;
        }
        setState(() {
          board[i] = currentTurn;
        });
        return evaluateGame();
      },
      child: board[i] == null
          ? const SizedBox(
              height: 100,
            )
          : Image.asset(
              board[i] == false ? 'assets/x.png' : 'assets/o.jpeg',
              height: 100,
            ),
    );
  }
}
