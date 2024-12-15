import 'package:flutter/material.dart';
import 'package:mysaiph/Screens/Games/flappybird/game/assets.dart';
import 'package:mysaiph/Screens/Games/flappybird/game/flappy_bird_game.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysaiph/Models/user.dart';
import 'package:mysaiph/utils/custom_colors.dart';
import 'package:mysaiph/widgets/game_widgets/container_wooden.dart';
import 'package:mysaiph/Screens/Games/Tala3ni/tala3ni_main_menu.dart';
class GameOverScreen extends StatelessWidget {
  final FlappyBirdGame game;

  const GameOverScreen({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: ${game.bird.score}',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: 'Game',
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(Assets.gameOver),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onRestart(context, userProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'Restart',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20), // Add space between buttons
            ElevatedButton(
              onPressed: () => onQuit(context, userProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Quit',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onRestart(BuildContext context, UserProvider userProvider) {
    int newScore = game.bird.score;
    game.bird.reset();
    game.overlays.remove('gameOver');
    game.resumeEngine();

    // Update user's FullScore in memory
    User user = userProvider.getUser;
    int currentScore = int.parse(user.FullScore);
    int updatedScore = currentScore + newScore;
    user.FullScore = updatedScore.toString();

    // Update user's FullScore in Firestore
    FirebaseFirestore.instance.collection('users').doc(user.uid).update(user.toJson())
        .then((_) {
      // Update locally in the provider after successful update
      userProvider.setUser(user);
    })
        .catchError((error) {
      print("Failed to update user's score: $error");
      // Handle error
    });
  }

  void onQuit(BuildContext context, UserProvider userProvider) {
    int newScore = game.bird.score; // Navigate back to the previous screen
    Navigator.push(
      context,
      MaterialPageRoute(
          builder:
              (context) =>
              Tala3niMainMenu(
                backgroundGradient: const RadialGradient(radius: 2,center: Alignment.center,
                  colors: [
                    CustomColors.lightBlue3,
                    CustomColors.lightBlue3,
                  ],
                ),
                backgroundImage: WoodenContainer(
                  paddingV: 70,
                  containerBackground: CustomColors.lightBlue2.withOpacity(0.8),
                  child: Align(
                    alignment: Alignment.center,
                    child: IntrinsicWidth(
                      child: Image.asset('assets/images/talaani_no_bg.png',),
                    ),
                  ),
                ),
                buttonPlayColor: CustomColors.greenButton,
                buttonInstructColor: CustomColors.yellowButton,
                buttonOptionsColor: CustomColors.orangeButton,
                buttonsContainerColor: CustomColors.lightBlue2.withOpacity(0.8),
              )
      ),
    );
    User user = userProvider.getUser;
    int currentScore = int.parse(user.FullScore);
    int updatedScore = currentScore + newScore;
    user.FullScore = updatedScore.toString();

    // Update user's FullScore in Firestore
    FirebaseFirestore.instance.collection('users').doc(user.uid).update(user.toJson())
        .then((_) {
      // Update locally in the provider after successful update
      userProvider.setUser(user);
    })
        .catchError((error) {
      print("Failed to update user's score: $error");
      // Handle error
    });
  }
}
