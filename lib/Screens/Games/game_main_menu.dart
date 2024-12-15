import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Models/memory_game.dart';
import '../../controllers/memory_game_contoller.dart';
import '../../providers/user_provider.dart';
import '../../services/puzzle_game_service.dart';
import '../../utils/custom_colors.dart';
import '../../widgets/game_widgets/container_wooden.dart';
import '../../widgets/game_widgets/level_description_dialog_body.dart';
import '../../widgets/game_widgets/rounded_button.dart';
import '../../widgets/game_widgets/user_header.dart';
import 'Dawini/memory_game_board.dart';
import 'Puzzle/puzzle_game_screen.dart';
import 'game_levels_screen.dart';

class GameMainMenu extends StatefulWidget {
  final String title;
  final Widget backgroundImage;
  final Color buttonPlayColor;
  final Color buttonInstructColor;
  final Color buttonOptionsColor;
  final Color buttonsContainerColor;
  final Color dialogBg;
  final Gradient backgroundGradient;

  const GameMainMenu({
    Key? key,
    required this.title,
    required this.backgroundImage,
    required this.buttonPlayColor,
    required this.buttonInstructColor,
    required this.buttonOptionsColor,
    required this.buttonsContainerColor,
    required this.dialogBg,
    required this.backgroundGradient,
  }) : super(key: key);

  @override
  State<GameMainMenu> createState() => _GameMainMenuState();
}

class _GameMainMenuState extends State<GameMainMenu> {
  late String userEmail;
  late UserProvider userProvider;
  String username = "";
  String gameId = "";
  int userScore = 0;
  int userLevel = 1;
  String gameDifficulty = '';
  late bool isCompleted;

  final MemoryGameController _gameController = MemoryGameController();

  fetchPuzzleGameScore() async {
    PuzzleGameService().getPuzzleScore(userProvider.getUser.uid).then((value) {
      if (mounted) {
        setState(() {
          userScore = int.parse(value);
        });
      }
    });
  }

  Future<void> fetchMemoryGameScore(String userEmail) async {
    Stream<MemoryGame?> gameStream = _gameController.getGameByUser(userEmail);
    gameStream.listen((MemoryGame? game) async {
      if (game != null) {
        if (mounted) {
          setState(() {
            userScore = game.score;
            userLevel = game.level;
            gameDifficulty = game.difficulty;
            isCompleted = game.completed;
          });
        }
      } else {
        await _gameController.createUserGame(userEmail);
        fetchMemoryGameScore(userEmail);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //get user game details (score/level/difficulty) + username and pic
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    userProvider = Provider.of<UserProvider>(context);
    userEmail = userProvider.getUser.email;
    if (mounted) {
      if (widget.title.toLowerCase() != 'puzzle') {
        fetchMemoryGameScore(userEmail);
      } else {
        fetchPuzzleGameScore();
      }
    }

    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        body: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: widget.backgroundGradient,
          ),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 6,child:UserHeader(
                          image: 'assets/images/profile_pic.png',
                          fullname: username,
                          score: userScore,
                        )),
                        Expanded(flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(
                                "assets/images/close_icon.svg",
                                width: 30,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Center(child: widget.backgroundImage),
                    const SizedBox(
                      height: 70,
                    ),
                    Container(
                      child: WoodenContainer(
                        paddingV: 30,
                        containerBackground: widget.buttonsContainerColor,
                        child: Align(
                          alignment: Alignment.center,
                          child: IntrinsicWidth(
                            child: gameButtons(context, username, userScore),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget gameButtons(BuildContext context, String fullname, int score) {
    return Column(
      children: [
        RoundedButton(
          text: 'Commencer',
          backgroundColor: widget.buttonPlayColor,
          txtColor: Colors.white,
          onPressed: () {
            if (widget.title.contains("PUZZLE")) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PuzzleGameScreen(
                        fullname: fullname,
                        score: score,
                      )));
            } else {
              if (isCompleted) {
                _showGameFinishedSnackbar(context);
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MemoryGameBoard(
                          fullname: fullname,
                        )));
              }
            }
          },
        ),
        const SizedBox(height: 20),
        RoundedButton(
          text: 'Régles',
          backgroundColor: widget.buttonInstructColor,
          txtColor: Colors.white,
          onPressed: () {
            if (widget.title.contains("PUZZLE")) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LevelsScreen(
                    dialogBg: widget.dialogBg,
                    containerBackground: widget.buttonsContainerColor,
                    backgroundGradient: widget.backgroundGradient,
                        fullname: fullname,
                        showDifficulty: false,
                        score: score,
                        levelsDescription: const [
                          LevelInfoBody(rules: [
                            MapEntry("< 2 min", 30),
                            MapEntry("> 2 min et < 5 min", 20),
                            MapEntry("> 5 min", 10),
                          ]),
                          LevelInfoBody(rules: [
                            MapEntry("< 5 min", 40),
                            MapEntry("> 5 min et < 10 min", 30),
                            MapEntry("> 10 min", 20),
                          ]),
                          LevelInfoBody(rules: [
                            MapEntry("< 10 min", 50),
                            MapEntry("> 10 min et < 20 min", 40),
                            MapEntry("> 20 min", 30),
                          ])
                        ],
                      )));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LevelsScreen(
                    dialogBg: widget.dialogBg,
                    containerBackground: widget.buttonsContainerColor,
                    backgroundGradient: widget.backgroundGradient,
                        fullname: fullname,
                        showDifficulty: true,
                        score: score,
                      )));
            }
          },
        ),
        const SizedBox(height: 20),
        RoundedButton(
          text: 'Quitter',
          backgroundColor: widget.buttonOptionsColor,
          txtColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showGameFinishedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Vous avez déjà terminé le jeu !"),
        duration: Duration(seconds: 3),
        // Adjust the duration as needed
        backgroundColor: Colors.green,
      ),
    );
  }
}
