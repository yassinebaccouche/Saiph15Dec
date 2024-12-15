import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../utils/custom_colors.dart';


class GameConfetti extends StatelessWidget {
  final ConfettiController controllerCenter =
  ConfettiController(duration: const Duration(seconds: 20));

  GameConfetti({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controllerCenter.play();
    return Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: controllerCenter,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          gravity: 0.5,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          colors: const [
            CustomColors.green,
            CustomColors.lightBlue,
            CustomColors.red,
            CustomColors.orange,
            CustomColors.yellow,
            Colors.purple,
            Colors.white,
          ],
        ));
  }
}
