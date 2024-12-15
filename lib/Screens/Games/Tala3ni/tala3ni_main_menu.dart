import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mysaiph/utils/custom_colors.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../widgets/game_widgets/container_wooden.dart';
import '../../../widgets/game_widgets/rounded_button.dart';
import '../../../widgets/game_widgets/up_to_down.dart';
import '../../../widgets/game_widgets/user_header.dart';
import 'package:mysaiph/Screens/Games/flappybird/main.dart';
import 'package:mysaiph/Responsive/mobile_screen_layout.dart';
import 'package:mysaiph/Responsive/responsive_layout_screen.dart';
import 'package:mysaiph/Responsive/web_screen_layout.dart';
class Tala3niMainMenu extends StatefulWidget {
  final Widget backgroundImage;
  final Color buttonPlayColor;
  final Color buttonInstructColor;
  final Color buttonOptionsColor;
  final Color buttonsContainerColor;
  final Gradient backgroundGradient;

  const Tala3niMainMenu({
    Key? key,
    required this.backgroundImage,
    required this.buttonPlayColor,
    required this.buttonInstructColor,
    required this.buttonOptionsColor,
    required this.buttonsContainerColor,
    required this.backgroundGradient,
  }) : super(key: key);

  @override
  State<Tala3niMainMenu> createState() => _Tala3niMainMenuState();
}

class _Tala3niMainMenuState extends State<Tala3niMainMenu> {
  late String userEmail;
  late UserProvider userProvider;
  String username = "";
  String gameId = "";
  int userScore = 0;
  int userLevel = 1;
  String gameDifficulty = '';
  late bool isCompleted;

  Future<void> fetchTalaaniGameScore(String userEmail) async {
    // FETCH TALA3NI GAME SCORE
    /*Stream<MemoryGame?> gameStream = _gameController.getGameByUser(userEmail);
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
    });*/
  }

  @override
  Widget build(BuildContext context) {

    // Get user game details + username and pic
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    userProvider = Provider.of<UserProvider>(context);
    userEmail = userProvider.getUser.email;
    if (mounted) {
      fetchTalaaniGameScore(userEmail);
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: UserHeader(
                              image: 'assets/images/profile_pic.png',
                              fullname: userProvider.getUser.pseudo,

                              score: int.parse( userProvider.getUser.FullScore),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => ResponsiveLayout(
                                        mobileScreenLayout: MobileScreenLayout(),
                                        webScreenLayout: WebScreenLayout(),
                                      ),
                                    ),
                                );
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
                SizedBox(
                  height: 70,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Center(child: widget.backgroundImage),
                      SizedBox(
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
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
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
            // NAVIGATE TO TALAANI GAME
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FlappyBirdApp(),
            ));
          },
        ),
        SizedBox(height: 20),
        RoundedButton(
          text: 'Régles',
          backgroundColor: widget.buttonInstructColor,
          txtColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => displayInfoDialog(
                context,
                "Règles du jeu",
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    // HOW GAME CALCULATES SCORE
                    "Dans Tala3ni, le joueur contrôle un oiseau en tapotant sur l'écran pour éviter les tuyaux verts. Chaque passage entre les tuyaux rapporte un point, mais la partie se termine si l'oiseau touche un tuyau ou le sol. Le défi réside dans la coordination des tapotements pour maintenir l'oiseau en vol et battre son propre record.",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                CustomColors.lightBlue2,
              ),
            );
          },
        ),
        SizedBox(height: 20),
        RoundedButton(
          text: 'Quitter',
          backgroundColor: widget.buttonOptionsColor,
          txtColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  ),
                ),
            );
          },
        ),
      ],
    );
  }

  Widget displayInfoDialog(
      BuildContext context, String title, Widget body, Color dialogBg) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: UpToDown(
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: dialogBg,
            ),
            child: SizedBox(
              width: width / 1.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    child: body,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
