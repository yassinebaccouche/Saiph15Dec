import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mysaiph/widgets/game_widgets/puzzle_widgets/puzzle_tile.dart';
import 'package:provider/provider.dart';

import '../../../Models/puzzle_game/game_state.dart';
import '../../../controllers/puzzle_game_controller.dart';
import '../../../utils/custom_colors.dart';

/// render the puzzle
class PuzzleInteractor extends StatelessWidget {
  const PuzzleInteractor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: CustomColors.lightBlue2.withOpacity(0.8),

    ),
      child: !controller.isLoading
          ? LayoutBuilder(
              builder: (context, constraints) {
                final controller = context.watch<GameController>();
                final state = controller.state;
                final tileSize = constraints.maxWidth / state.crossAxisCount;

                final puzzle = state.puzzle;

                /// the puzzle is locked is the game status is not playing
                ///

                return AbsorbPointer(
                  absorbing: state.status != GameStatus.playing,
                  child: Stack(
                    children: puzzle.tiles
                        .map(
                          (e) => PuzzleTile(
                            tile: e,
                            size: tileSize,
                            gameStatus: state.status,
                            showNumbersInTileImage: state.crossAxisCount > 3,
                            onTap: () => controller.onTileTapped(e),

                            imageTile: puzzle.segmentedImage != null
                                ? puzzle.segmentedImage![e.value - 1]
                                : null,
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            )
          : Container(
              margin: const EdgeInsets.all(60),
              child: const LoadingIndicator(
                indicatorType: Indicator.pacman,

                colors:  [Colors.white],

                strokeWidth: 2,

              )),
    );
  }
}
