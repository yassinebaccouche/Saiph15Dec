import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Models/puzzle_game/game_state.dart';
import '../../controllers/puzzle_game_controller.dart';
import '../../utils/custom_colors.dart';

class GameTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onPressedRestart;
  final VoidCallback? onPressedClose;

  const GameTopBar({
    Key? key,
    required this.title,
    this.onPressedRestart,
    this.onPressedClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    GameController? controller;
    GameState? state;
    if(title.contains("PUZZLE")){
      controller = context.watch<GameController>();
      state = controller.state;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toLowerCase().trim().contains("puzzle") ? "RAKABNI": title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: CustomColors.darkBlue,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            if(onPressedRestart != null)
              GestureDetector(
                  onTap: () {
                    onPressedRestart!();
                  },
                  child: !title.contains("PUZZLE")?SvgPicture.asset('assets/images/restart_icon.svg', width: 30,):state!.puzzle.isTheFirstPic
                      ? SvgPicture.asset('assets/images/play.svg',width: 30,)
                      : state.status == GameStatus.playing
                      ? SvgPicture.asset('assets/images/restart_icon.svg',width: 30,)
                      : SvgPicture.asset('assets/images/play.svg', width: 30,)),
            if(onPressedClose != null)
              const SizedBox(width: 15,),
            if(onPressedClose != null)
              GestureDetector(
                onTap: () {
                  onPressedClose!();
                },
                child: SvgPicture.asset(
                  "assets/images/close_icon.svg",
                  width: 30,
                ),
              ),
          ],
        )
      ],
    );
  }
}
