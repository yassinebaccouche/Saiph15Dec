import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/custom_colors.dart';
import '../../../utils/games_utils/time_parser.dart';
import '../../../controllers/puzzle_game_controller.dart';
import '../max_text_scale_factor.dart';
import '../rounded_container.dart';

/// widget to show the time and the moves counter
class TimeWidget extends StatelessWidget {
  const TimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    final time = Provider
        .of<GameController>(context, listen: false)
        .time;
    return MaxTextScaleFactor(max: 1,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ValueListenableBuilder<int>(
              valueListenable: time, builder: (_, time, icon) {
            return SizedBox(width: width * 0.4,
                child: RoundedContainer(text: parseTime(time),
                    backgroundColor: CustomColors.redPrimary,
                    txtColor: Colors.white,
                    icon: Icons.timer)); /*RoundedContainer(text: "${parseTime(time)}",
                backgroundColor: redPrimary, strokeColor: darkBlue,
                txtColor: Colors.white, icon: Icons.timer);*/
          })],),);
  }
}
