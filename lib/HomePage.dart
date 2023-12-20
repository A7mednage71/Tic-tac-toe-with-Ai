import 'package:flutter/material.dart';
import 'package:xo/widgets.dart/emptycells.dart';
import 'package:xo/widgets.dart/winner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> ticBoard;
  late bool player;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      ticBoard = ['', '', '', '', '', '', '', '', ''];
      player = true;
    });
  }

  void move(int index) {
    setState(() {
      if (player && ticBoard[index] == '') {
        ticBoard[index] = 'X';
        player = !player;
        if (!gameOver()) {
          Ai_turn();
        }
      }
    });
  }

  Future<void> Ai_turn() async {
    await Future.delayed(const Duration(milliseconds: 400));
    int aiScore = minimax(ticBoard, false);

    if (aiScore != -1) {
      setState(() {
        ticBoard[aiScore] = 'O';
        player = !player;
        gameOver();
      });
    }
  }

  int minimax(List<String> ticBoard, bool ismaximizing) {
    List<int> emptyFields = findEmptyFields(ticBoard);

    if (win(ticBoard, 'X')) {
      return -10;
    } else if (win(ticBoard, 'O')) {
      return 10;
    } else if (emptyFields.isEmpty) {
      return 0;
    }

    if (ismaximizing) {
      int bestScore = -10000;
      int bestMove = -1;
      for (int i = 0; i < emptyFields.length; i++) {
        ticBoard[emptyFields[i]] = 'O';
        int score = minimax(ticBoard, false);
        ticBoard[emptyFields[i]] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = emptyFields[i];
        }
      }
      return bestMove;
    } else {
      int bestScore = 10000;
      int bestMove = -1;
      for (int i = 0; i < emptyFields.length; i++) {
        ticBoard[emptyFields[i]] = 'X';
        int score = minimax(ticBoard, true);
        ticBoard[emptyFields[i]] = '';
        if (score < bestScore) {
          bestScore = score;
          bestMove = emptyFields[i];
        }
      }
      return bestMove;
    }
  }

  bool gameOver() {
    if (win(ticBoard, 'X')) {
      showGameOverDialog('You win!');
      return true;
    } else if (win(ticBoard, 'O')) {
      showGameOverDialog('You lose!');
      return true;
    } else if (!ticBoard.contains('')) {
      showGameOverDialog('it is a Tie !');
      return true;
    }
    return false;
  }

  void showGameOverDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(message),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: const Text('Play Again'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xffBD8F42)),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/peakpx.jpg'), fit: BoxFit.fill),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.16,
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 18,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          move(index);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                              child: Text(
                            ticBoard[index],
                            style: const TextStyle(
                                fontSize: 40.0, color: Colors.white),
                          )),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
