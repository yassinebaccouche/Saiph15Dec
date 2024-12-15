import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../Models/puzzle_game/game_state.dart';
import '../../../Models/puzzle_game/level.dart';
import '../../../Models/puzzle_game/puzzle_image.dart';
import '../../../utils/custom_colors.dart';
import '../../../utils/games_utils/images_repository_impl.dart';
import '../../../controllers/puzzle_game_controller.dart';
import '../dialog.dart';
import '../game_top_bar.dart';
import '../rounded_button.dart';
import '../user_header.dart';

class GameButtons extends StatefulWidget {
  final int score;
  final String fullname;

  const GameButtons({Key? key, required this.score, required this.fullname})
      : super(key: key);

  @override
  State<GameButtons> createState() => _GameButtonsState();
}

class _GameButtonsState extends State<GameButtons> {
  var loaded = false;


  var currntimage = puzzleOptions[Random().nextInt(puzzleOptions.length)];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final state = controller.state;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    setupGame() async {
      await Future.delayed(const Duration(milliseconds: 1500), () async {
        if(controller.mounted){
          controller.isItLoading(true);
          await controller.changeGrid(
            state.crossAxisCount,
            currntimage,
          );
          controller.isItLoading(false);
        }

      });
    }
    if (state.puzzle.isTheFirstPic && !loaded ) {
      loaded = true;
      setupGame();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GameTopBar(
                  title: "PUZZLE",
                  onPressedRestart: () async {
                    controller.isItLoading(true);
                    await _reset(context, currntimage);
                    controller.isItLoading(false);
                  },
                  onPressedClose: () {
                    controller.mounted=false;
                    Navigator.pop(context);

                  }),
              SizedBox(
                height: 20,
              ),
              UserHeader(
                image: 'assets/images/profile_pic.png',
                fullname: widget.fullname,
                score: widget.score,
              ),
            ],
          ),
        ),
        //       RoundedContainer(text: "Régénérer", backgroundColor: green, strokeColor: darkBlue, txtColor: darkBlue,icon:Icons.shuffle_outlined),
        const SizedBox(height: 20,),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedButton(
                  text: "Régénérer",
                  backgroundColor: CustomColors.green,
                  txtColor: CustomColors.darkBlue,
                  onPressed: () async {
                    if (!controller.state.puzzle.isTheFirstPic) {
                      controller.isItLoading(true);
                      await _changePicture(context, currntimage);
                      controller.isItLoading(false);
                    }
                  }),
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.yellow,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Level>(
                    dropdownColor: (CustomColors.yellow).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: Transform.rotate(
                        angle: 90 * pi / 180,
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: CustomColors.darkBlue,
                        ),
                      ),
                    ),
                    items:  Level().getLevels()
                        .map(
                          (e) => DropdownMenuItem(
                        value: e,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ).copyWith(left: 10),
                          child: Row(
                            children: [
                              e.title!.contains("1") ||
                                  e.score! <= widget.score
                                  ? const Icon(Icons.lock,
                                  color: Colors.transparent)
                                  : const Icon(Icons.lock, color: CustomColors.darkBlue),
                              SizedBox(width: width * 0.01),
                              Text(
                                "$e ",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: CustomColors.darkBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (crossAxisCount) async {
                      var selectedAxisCount = int.parse(
                          crossAxisCount!.title!.split(":")[1].trim()) +
                          2;
                      if (selectedAxisCount != state.crossAxisCount) {
                        if (widget.score >= crossAxisCount.score!) {
                          controller.isItLoading(true);
                          await controller.changeGrid(
                            selectedAxisCount,
                            currntimage,
                          );
                          controller.isItLoading(false);
                        } else {
                          showCustomDialog(context,
                              title: "Niveau Bloqué",
                              body: const Center(
                                  child: Text(
                                      "Vous devez atteindre un certain score pour débloquer ce niveau !",
                                      textAlign: TextAlign.center,
                                      style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ))),
                              picture: SvgPicture.asset(
                                'assets/images/locked.svg',
                                width:
                                MediaQuery.of(context).size.width / 2.5,
                              ),
                              isNextLevelVisible: false,
                              isHomeVisible: false,
                              isOkVisible: true,
                              isRestartVisible: false);
                        }
                      }
                    },
                    value: state.crossAxisCount == 3
                        ? Level().getLevels()[0]
                        : state.crossAxisCount == 4
                        ? Level().getLevels()[1]
                        : state.crossAxisCount == 5
                        ? Level().getLevels()[2]
                        : Level().getLevels()[0],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _reset(BuildContext context, PuzzleImage img) async {
    final controller = context.read<GameController>();
    final state = controller.state;
    if (state.moves == 0 || state.status == GameStatus.solved) {
      if (!state.puzzle.isTheFirstPic) {
        controller.shuffle();
      }
    } else {
      controller.isItLoading(true);
      await controller.changeGrid(
        state.crossAxisCount,
        img,
      );
      controller.isItLoading(false);
    }
  }

  Future<void> _changePicture(
      BuildContext context, PuzzleImage curentImage) async {
    var image = puzzleOptions[Random().nextInt(puzzleOptions.length)];
    while (image == curentImage) {
      image = puzzleOptions[Random().nextInt(puzzleOptions.length)];
    }
    currntimage = image;
    final controller = context.read<GameController>();
    controller.changeGrid(
      controller.state.crossAxisCount,
      image.name != 'Numeric' ? image : null,
    );
  }
}
