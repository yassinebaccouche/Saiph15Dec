import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mysaiph/Models/puzzle_game/move_to.dart';
import 'package:mysaiph/services/memory_game_service.dart';
import 'package:provider/provider.dart';

import '../../../controllers/puzzle_game_controller.dart';
import '../../../providers/user_provider.dart';
import '../../../services/puzzle_game_service.dart';
import '../../../utils/custom_colors.dart';
import '../../../utils/games_utils/puzzle_icons.dart';
import '../../../utils/games_utils/time_parser.dart';
import '../../../widgets/game_widgets/dialog.dart';
import '../../../widgets/game_widgets/puzzle_widgets/game_buttons.dart';
import '../../../widgets/game_widgets/puzzle_widgets/puzzle_interactor.dart';
import '../../../widgets/game_widgets/puzzle_widgets/time_widget.dart';

class PuzzleGameScreen extends StatefulWidget {
  final String? fullname;
  int? score;

  PuzzleGameScreen({
    Key? key,
    this.fullname,
    this.score,
  }) : super(key: key);

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  late GameController controller;

  void _onKeyBoardEvent(BuildContext context, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final moveTo = event.logicalKey.keyLabel.moveTo;
      if (moveTo != null) {
        context.read<GameController>().onMoveByKeyboard(moveTo);
      }
    }
  }

  @override
  void initState() {
    controller = GameController();
    controller.mounted = true;
    super.initState();
  }

  @override
  void dispose() {
    controller.mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return ChangeNotifierProvider(
      create: (_) {
        controller.onFinish.listen(
          (_) {
            Timer(
              const Duration(
                milliseconds: 200,
              ),
              () {
                var oldscore = widget.score;

                setState(() {
                  widget.score = widget.score! +
                      controller.newScore(controller.time.value,
                          controller.state.crossAxisCount);
                });
                var resultLevel =
                    controller.calculateLevelReached(oldscore!, widget.score!);

                oldscore = widget.score;
                PuzzleGameService()
                    .setNewScore(widget.score!, userProvider.getUser.uid);
                MemoryGameService().updateTotalScore(userProvider.getUser.email, widget.score!);
                if (resultLevel == 0) {
                  showCustomDialog(context,
                      title: "Félicitations!",
                      body: dialogBody(context, controller.time.value,
                          controller.state.moves),
                      picture: SvgPicture.asset(
                        'assets/images/success.svg',
                        width: MediaQuery.of(context).size.width / 2.5,
                      ),
                      isRestartVisible: true,
                      isOkVisible: false,
                      isHomeVisible: true,
                      isNextLevelVisible: false, restarGameFunction: () async {
                    Navigator.pop(context);
                    await controller.restartGame();
                  });
                } else if (resultLevel == 2) {
                  showCustomDialog(context,
                      title: "Bravo!",
                      body: const Text(
                        "Tu viens de débloquer le niveau 2!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      picture: SvgPicture.asset(
                        'assets/images/unlocked.svg',
                        width: MediaQuery.of(context).size.width / 2.5,
                      ),
                      isHomeVisible: true,
                      isOkVisible: false,
                      isNextLevelVisible: true,
                      isRestartVisible: true, restarGameFunction: () async {
                    Navigator.pop(context);
                    await controller.restartGame();
                  }, nextLevelFunction: () async {
                    Navigator.pop(context);
                    await controller.startNextLevel();
                  });
                } else {
                  showCustomDialog(context,
                      title: "Bravo!",
                      body: const Text(
                        "Tu viens de débloquer le niveau 3!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      picture: SvgPicture.asset(
                        'assets/images/unlocked.svg',
                        width: MediaQuery.of(context).size.width / 2.5,
                      ),
                      isHomeVisible: true,
                      isOkVisible: false,
                      isNextLevelVisible: true,
                      isRestartVisible: true, restarGameFunction: () async {
                    Navigator.pop(context);
                    await controller.restartGame();
                  }, nextLevelFunction: () async {
                    Navigator.pop(context);
                    await controller.startNextLevel();
                  });
                }
              },
            );
          },
        );

        return controller;
      },
      builder: (context, child) => RawKeyboardListener(
        autofocus: true,
        includeSemantics: false,
        focusNode: FocusNode(),
        onKey: (event) => _onKeyBoardEvent(context, event),
        child: child!,
      ),
      child: Scaffold(
        body: SafeArea(
          child: OrientationBuilder(
            builder: (_, orientation) {
              final isPortrait = orientation == Orientation.portrait;

              return Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(radius: 2,center: Alignment.center,
                    colors: [
                      CustomColors.radialGreen,
                      CustomColors.radialBlue,
                      CustomColors.radialBlue,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          final height = constraints.maxHeight;
                          final puzzleHeight =
                              (isPortrait ? height * 0.45 : height * 0.5)
                                  .clamp(250, 700)
                                  .toDouble();

                          return SizedBox(
                            height: height,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  GameButtons(
                                    score: widget.score!,
                                    fullname: widget.fullname!,
                                  ),
                                  const SizedBox(height: 20,),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: SizedBox(
                                      height: puzzleHeight,
                                      child: const AspectRatio(
                                        aspectRatio: 1,
                                        child: PuzzleInteractor(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  const TimeWidget(),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget dialogBody(BuildContext context, int time, int moves) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          Text(
            parseTime(time),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.multiple_stop_rounded,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            "Mouvements $moves",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    ],
  );
}
