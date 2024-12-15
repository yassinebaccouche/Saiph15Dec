import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../Models/puzzle_game/game_state.dart';
import '../Models/puzzle_game/move_to.dart';
import '../Models/puzzle_game/puzzle.dart';
import '../Models/puzzle_game/puzzle_image.dart';
import '../Models/puzzle_game/tile.dart';
import '../utils/games_utils/images_repository.dart';
import '../utils/games_utils/images_repository_impl.dart';

class GameController extends ChangeNotifier {
  final ImagesRepository _imagesRepository = GetIt.I.get();
 // final AudioRepository audioRepository = GetIt.I.get();

  bool _isLoading=false;
  bool _mounted=false;

  set mounted(bool v){
    _mounted=v;
  }


  GameState _state = GameState(
    crossAxisCount: 3,
    puzzle: Puzzle.create(true,3,image: puzzleOptions[Random().nextInt(puzzleOptions.length)]),
    solved: false,
    moves: 0,
    status: GameStatus.created,
    sound: true,
    vibration: true,
  );

  final ValueNotifier<int> time = ValueNotifier(0);
  bool get mounted=>_mounted;

  final StreamController<void> _streamController = StreamController.broadcast();

  Stream<void> get onFinish => _streamController.stream;

  Timer? _timer;

  GameState get state => _state;

  Puzzle get puzzle => _state.puzzle;
  bool get isLoading => _isLoading;

  void isItLoading(bool bool){
    _isLoading=bool;
    notifyListeners();
  }


  Future<void> restartGame()async {
    if (state.moves == 0 || state.status == GameStatus.solved) {
      if (!state.puzzle.isTheFirstPic) {
       shuffle();
      }
    } else {
      isItLoading(true);
      await changeGrid(
        state.crossAxisCount,
        state.puzzle.image,
      );
      isItLoading(false);
    }
  }

  Future<void> startNextLevel()async {
    isItLoading(true);
    await changeGrid(
      state.crossAxisCount+1,
      state.puzzle.image,
    );
    isItLoading(false);
    shuffle();

  }



  void onTileTapped(Tile tile) {
    final canMove = puzzle.canMove(tile.position);

    /// if the tile can be moved
    if (canMove) {
      // move the tile or multiples tiles
      final newPuzzle = puzzle.move(tile);

      // check if the puzzle was solved
      final solved = newPuzzle.isSolved();
      _state = state.copyWith(
        puzzle: newPuzzle,
        moves: state.moves + 1,
        status: solved ? GameStatus.solved : state.status,
      );
      notifyListeners();

      if (state.vibration) {
        HapticFeedback.lightImpact();
      }

      if (state.sound) {
        // play a sound
        //audioRepository.playMove();
      }

      if (solved) {
        _timer?.cancel();

        // notify to the game view
        _streamController.sink.add(null);
      }
    }

  }

  /// shuffle the current puzzle
  void shuffle() {
    if (_timer != null) {
      time.value = 0;
      _timer!.cancel();
    }
    _state = state.copyWith(
      puzzle: puzzle.shuffle(),
      status: GameStatus.playing,
      moves: 0,
    );
    notifyListeners();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        time.value++;
      },
    );
  }

  /// change the current size of the puzzle
  ///
  ///
  /// [crossAxisCount] number of rows and columns
  ///
  /// [image] is different of null when the puzzle
  /// has to be a segmented image
  Future<void> changeGrid(
    int crossAxisCount,
    PuzzleImage? image,
  ) async {
    _timer?.cancel();
    time.value = 0;

    List<Uint8List>? segmentedImage;

    if (image != null) {
      if(mounted) {
        isItLoading(true);
        segmentedImage = await _imagesRepository.split(
          image.assetPath,
          crossAxisCount,
        );
        isItLoading(false);
      }
    }

    /// reset the game with a new puzzle
    final newState = GameState(
      crossAxisCount: crossAxisCount,
      puzzle: Puzzle.create(false,
        crossAxisCount,
        segmentedImage: segmentedImage,
        image: image,
      ),
      solved: false,
      moves: 0,
      status: GameStatus.created,
      sound: state.sound,
      vibration: state.vibration,
    );
    _state = newState;
    notifyListeners();
  }

  Future<void> updateFirstGrid(
      int crossAxisCount,
      PuzzleImage? image,
      ) async {
    _timer?.cancel();
    time.value = 0;

    List<Uint8List>? segmentedImage;

    if (image != null) {
      isItLoading(true);

      segmentedImage = await _imagesRepository.split(
        image.assetPath,
        crossAxisCount,
      );
      isItLoading(false);

    }

    /// reset the game with a new puzzle
    final newState = GameState(
      crossAxisCount: crossAxisCount,
      puzzle: Puzzle.create(true,
        crossAxisCount,
        segmentedImage: segmentedImage,
        image: image,
      ),
      solved: false,
      moves: 0,
      status: GameStatus.created,
      sound: state.sound,
      vibration: state.vibration,
    );
    _state = newState;
    notifyListeners();
  }


  /// handle the keyboard events and  check if
  /// the keyboard action can move a tile using as
  /// reference the empty position
  void onMoveByKeyboard(MoveTo moveTo) {
    final index = _handleKeyboard(moveTo, state);

    if (index != null) {
      onTileTapped(
        puzzle.tiles[index],
      );
    }
  }

  /// handle the keyboard events and  check if
  /// the keyboard action can move a tile using as
  /// reference the empty position
  ///
  /// return [int] the index tile to be moved, if any
  /// tile can be moved the value returned is null
  int? _handleKeyboard(MoveTo moveTo, GameState state) {
    final crossAxisCount = state.crossAxisCount;
    final emptyPosition = puzzle.emptyPosition;
    final tiles = puzzle.tiles;

    /// will store the tile index to be moved
    int? index;

    switch (moveTo) {
      case MoveTo.up:
        if (emptyPosition.y + 1 <= crossAxisCount) {
          index = tiles.indexWhere(
            (e) {
              return e.position.x == emptyPosition.x &&
                  e.position.y == emptyPosition.y + 1;
            },
          );
        }
        break;
      case MoveTo.down:
        if (emptyPosition.y > 0) {
          index = tiles.indexWhere(
            (e) {
              return e.position.x == emptyPosition.x &&
                  e.position.y == emptyPosition.y - 1;
            },
          );
        }
        break;
      case MoveTo.left:
        if (emptyPosition.x >= 1) {
          index = tiles.indexWhere(
            (e) {
              return e.position.x - 1 == emptyPosition.x &&
                  e.position.y == emptyPosition.y;
            },
          );
        }
        break;
      case MoveTo.right:
        if (emptyPosition.x <= crossAxisCount) {
          index = tiles.indexWhere(
            (e) {
              return e.position.x + 1 == emptyPosition.x &&
                  e.position.y == emptyPosition.y;
            },
          );
        }
        break;
    }

    return index;
  }

  int calculateLevelReached(int oldScore, int newScore) {
    if (oldScore < 200 && newScore >= 200 && newScore < 300) {
      return 2;
    } else if (oldScore >= 200 && oldScore < 300 && newScore >= 300) {
      return 3;
    } else {
      // Add additional conditions or levels as needed
      return 0; // Default level or indicator for no level reached
    }
  }

  int newScore(int time, int level) {
    Map<int, Map<int, int>> timeScores = {
      3: {120: 30, 300: 20, 600: 10},
      4: {300: 40, 600: 30, 1300: 20},
      5: {600: 50, 1300: 40, 1800: 30},
    };

    int timeScore = timeScores[level]!
        .entries
        .firstWhere((entry) => time <= entry.key,
        orElse: () => timeScores[level]!.entries.last)
        .value;

    return timeScore;
  }
  /// release memory
  @override
  void dispose() {
    _mounted=false;
    _streamController.close();
    _timer?.cancel();
    super.dispose();
  }

}
