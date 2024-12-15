import 'package:flutter/material.dart';
import 'package:mysaiph/widgets/game_widgets/rounded_container.dart';

import '../../utils/custom_colors.dart';

class UserGameDetailsBar extends StatelessWidget {
  final String difficulty;
  final int level;
  final Color difficultyColor;

  const UserGameDetailsBar({Key? key, required this.difficulty, required this.level, required this.difficultyColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: RoundedContainer(text: difficulty, backgroundColor: difficultyColor, txtColor: CustomColors.darkBlue,)),
        const SizedBox(width: 15,),
        Expanded(child: RoundedContainer(text: 'Niveau: $level', backgroundColor: CustomColors.yellow, txtColor: CustomColors.darkBlue,)),
      ],
    );
  }
}
