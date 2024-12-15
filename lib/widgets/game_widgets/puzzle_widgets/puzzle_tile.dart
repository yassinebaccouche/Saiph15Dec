import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import '../../../Models/puzzle_game/game_state.dart';
import '../../../Models/puzzle_game/tile.dart';
import '../../../utils/custom_colors.dart';

/// widget to render every tile in the puzzle
class PuzzleTile extends StatefulWidget {
  final Tile tile;
  final Uint8List? imageTile;
  final double size;
  final VoidCallback onTap;
  final bool showNumbersInTileImage;
  final GameStatus gameStatus;

  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.size,
    required this.onTap,
    required this.imageTile,
    required this.showNumbersInTileImage,
    required this.gameStatus,
  }) : super(key: key);

  @override
  State<PuzzleTile> createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<PuzzleTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angle;
  bool _rotating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _angle = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(
            begin: 0,
            end: 180 * math.pi / 180,
          ),
          weight: 0.1,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 180 * math.pi / 180,
            end: 180 * math.pi / 180,
          ),
          weight: 0.2,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 180 * math.pi / 180,
            end: 270 * math.pi / 180,
          ),
          weight: 0.1,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 270 * math.pi / 180,
            end: 0,
          ),
          weight: 0.1,
        ),
      ],
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotating = false;
      }
    });
  }

  @override
  void didUpdateWidget(covariant PuzzleTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.gameStatus == GameStatus.created &&
        widget.gameStatus == GameStatus.playing) {
      _rotating = true;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(
        milliseconds: 200,
      ),
      left: (widget.tile.position.x - 1) * widget.size + 1,
      top: (widget.tile.position.y - 1) * widget.size + 1,
      child: GestureDetector(onHorizontalDragEnd:(details) {

          if (!_rotating) {
            widget.onTap();
          }

      }, onVerticalDragEnd: (details) {
        if (!_rotating) {
          widget.onTap();
        }
      },
        onTap: () {
          if (!_rotating) {
            widget.onTap();
          }
        },
        child: AnimatedBuilder(
          animation: _angle,
          builder: (_, child) => Transform(
            transform: Matrix4.identity()
              ..rotateY(
                _angle.value,
              ),
            alignment: Alignment.center,
            child: child,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              color: Colors.white.withOpacity(1),
              width: widget.size - 2,
              height: widget.size - 2,
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 200,
                ),
                child: widget.imageTile != null
                    ? Stack(
                        key: Key(
                          widget.imageTile.hashCode.toString(),
                        ),
                        children: [
                          Positioned.fill(
                            child: FlipCard(
                              flipOnTouch: false,
                              fill: Fill.fillBack,
                              // Fill the back side of the card to make in the same size as the front.
                              direction: FlipDirection.VERTICAL,
                              // default
                              side: CardSide.FRONT,
                              // The side to initially display.
                              front: Image.asset("assets/images/default.png"),

                              back: Image.memory(
                                widget.imageTile!,
                                fit: BoxFit.fill,
                              ),
                              autoFlipDuration: const Duration(
                                  seconds:
                                      2), // The flip effect will work automatically after the 2 seconds
                            ),
                          ),
                          if (widget.showNumbersInTileImage)
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                color: CustomColors.lightGray,
                                width: widget.size * 0.3,
                                height: widget.size * 0.3,
                                padding: const EdgeInsets.all(2),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.tile.value.toString(),
                                  style: TextStyle(
                                    fontSize: widget.size * 0.15,
                                  ),
                                ),
                              ),
                            )
                        ],
                      )
                    : Image.asset("assets/images/default.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
