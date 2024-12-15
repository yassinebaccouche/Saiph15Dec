import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mysaiph/Screens/Games/flappybird/game/flappy_bird_game.dart';
import 'package:mysaiph/Screens/Games/flappybird/screens/game_over_screen.dart';
import 'package:mysaiph/Screens/Games/flappybird/screens/main_menu_screen.dart';

class FlappyBirdApp extends StatefulWidget {
  @override
  _FlappyBirdAppState createState() => _FlappyBirdAppState();
}

class _FlappyBirdAppState extends State<FlappyBirdApp> {
  late FlappyBirdGame _game;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await Flame.device.fullScreen();
    _game = FlappyBirdGame();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeGame(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: _buildMainScreen(),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildMainScreen() {
    return GameWidget(
      game: _game,
      initialActiveOverlays: const [MainMenuScreen.id],
      overlayBuilderMap: {
        'mainMenu': (context, _) => MainMenuScreen(game: _game),
        'gameOver': (context, _) => GameOverScreen(game: _game),
      },
    );
  }
}


