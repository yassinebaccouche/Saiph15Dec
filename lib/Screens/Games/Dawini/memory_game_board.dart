import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../Models/memory_game.dart';
import '../../../Models/memory_game/data.dart';
import '../../../Models/memory_game/enums/game_difficulty.dart';
import '../../../controllers/memory_game_contoller.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/custom_colors.dart';
import '../../../widgets/game_widgets/container_wooden.dart';
import '../../../widgets/game_widgets/game_top_bar.dart';
import '../../../widgets/game_widgets/rounded_container.dart';
import '../../../widgets/game_widgets/user_game_details_bar.dart';
import '../../../widgets/game_widgets/user_header.dart';
import 'game_confetti.dart';

class MemoryGameBoard extends StatefulWidget {
  final String fullname;

  const MemoryGameBoard({Key? key, required this.fullname});

  @override
  State<MemoryGameBoard> createState() => _MemoryGameBoardState();
}

class _MemoryGameBoardState extends State<MemoryGameBoard> {
  int _previousIndex = -1;
  bool _mounted = false;
  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  late bool _isFinished;
  bool _isGameCompleted=false;
  late bool _isTimeOut=false;
  bool _isLoading=true;
  late Timer _timer;
  int _time = 7;
  Timer _gameTimer = Timer(const Duration(seconds: 1), () {});
  late int _gameTime;
  //late int _left;
  late List _data;
  late List<bool> _cardFlips;
  late List<GlobalKey<FlipCardState>> _cardStateKeys;
  late double screenHeight;
  late double screenWidth;
  int userScore=0;
  late int updatedScore;
  int userLevel=1;
  String userDifficultyLevel=GameDifficulty.FACILE.displayName;
  late int gameTimePlayed;
  late int timeToPlay;

  late String userEmail;

  final MemoryGameController _gameController = MemoryGameController();

  void startTimerCardsVisibility() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
        setState(() {
          if (_time > 0) {
            _time--;
          } else {
            timer.cancel();
            if (_mounted) {
              setState(() {
                _start = true;
                if(_timer!=null && _timer.isActive){
                  _timer.cancel();
                }
                startTimerGameplay();
              });
            }
          }
        });
      },
    );
  }

  void startTimerGameplay() {
    _gameTimer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
        if (_gameTime > 0) {
          setState(() {
            _gameTime--;
          });
        }else{
          timer.cancel();
          _isFinished = true;
          _isTimeOut = true;
          showResultDialog(context, false, false);
        }
      },
    );
  }

  /*void startGameAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {

    });
  }*/

  void initializeGameData() {
    int gridLinesNb=getGridLinesNb(userLevel);
    _data = createShuffledListFromImageSource(gridLinesNb);
    _cardFlips = getInitialItemStateList(gridLinesNb);
    _cardStateKeys = createFlipCardStateKeysList(gridLinesNb);
    //_left = (_data.length ~/ 2);
    _isFinished = false;
  }

  Future<void> fetchMemoryGameDetails(String userEmail) async {
    Stream<MemoryGame?> gameStream = _gameController.getGameByUser(userEmail);
    gameStream.listen((MemoryGame? game) {
      if (game != null) {
        if(mounted){
          setState(() {
            _isLoading=false;
            userScore = game.score;
            userLevel = game.level;
            userDifficultyLevel = game.difficulty;
            timeToPlay = getGameplayTime(userLevel, userDifficultyLevel);
            _gameTime=timeToPlay;
            startTimerCardsVisibility();
            initializeGameData();
          });
        }
      }
    });
  }

  @override
  void initState() {
    _mounted = true;
    //final UserProvider userProvider = Provider.of<UserProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if(mounted){
        setState(() {
          userEmail = userProvider.getUser.email;
          fetchMemoryGameDetails(userEmail);

        });
      }
    });
   // userEmail=userProvider.getUser.email;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer!=null && _timer.isActive){
      _timer.cancel();
    }
    if(_gameTimer!=null && _gameTimer.isActive){
      _gameTimer.cancel();
    }
    _mounted = false;
  }

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(_data[index])),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Future<void> updateGame(String userEmail, int score, int level, String difficulty) async {
    await _gameController.updateGame(userEmail, score, level, difficulty);
  }

  Future<void> updateTotalScore(String userEmail, int pointsToAdd) async {
    await _gameController.updateTotalScore(userEmail, pointsToAdd);
  }


  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        body: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff1A81FF),
                Color(0xff1669d4),
                Color(0xff015cd1)],
              stops: [0.25, 0.75, 0.87],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: _isLoading ? const CircularProgressIndicator()
          : SingleChildScrollView(
            child: Stack(
              children:[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GameTopBar(title: 'DAWINI',
                              onPressedRestart: (){
                                restartGame();
                              },
                              onPressedClose: (){
                                if(_timer!=null && _timer.isActive){
                                  _timer.cancel();
                                }
                                if(_gameTimer!=null && _gameTimer.isActive){
                                  _gameTimer.cancel();
                                }
                                Navigator.of(context).pop();
                              }),
                          const SizedBox(height: 20,),
                          UserHeader(image: 'assets/images/profile_pic.png',fullname: widget.fullname, score: userScore,),
                          const SizedBox(height: 70,),
                          UserGameDetailsBar(difficulty: capitalizeFirstLetter(userDifficultyLevel), level: userLevel, difficultyColor: userDifficultyLevel.toLowerCase()==GameDifficulty.FACILE.displayName.toLowerCase() ? CustomColors.green : userDifficultyLevel.toLowerCase()==GameDifficulty.MOYEN.displayName.toLowerCase() ? CustomColors.orange : CustomColors.redPrimary,),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: screenWidth*0.4,
                        child: RoundedContainer(text: _isGameCompleted ? '0s' :'${_gameTime}s', backgroundColor: CustomColors.redPrimary, txtColor: Colors.white, icon: Icons.timer,)
                    ),
                    const SizedBox(height: 70,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: WoodenContainer(
                        paddingV: 30,
                        containerBackground: CustomColors.blueButton.withOpacity(0.7),
                        child: gridView(screenWidth),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
                _isGameCompleted ? GameConfetti() : Container(),
              ] ,
            ),
          ),
        ),
      ),
    );
  }

  Widget gridView(double screenWidth){
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal:15),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) => _start
          ? FlipCard(
          key: _cardStateKeys[index],
          onFlip: () {
            //debugPrint('flip detected');

              if (!_flip) { // check if this is the first flip for current guess
                //debugPrint('first flip: previous index is $_previousIndex and current index is $index');
                _flip = true;
                _previousIndex = index;
              } else { // check if this is the second flip for current guess
                //debugPrint('second flip: previous index is $_previousIndex and current index is $index');
                _flip = false;

                if (_previousIndex != index) { //check if the second click is not on the same item of the first click
                  if (_data[_previousIndex] != _data[index]) {
                    //debugPrint('CARDS DONT MATCH');
                    _wait = true;
                    Future.delayed(
                        const Duration(milliseconds: 1500),
                            () {
                          _cardStateKeys[_previousIndex].currentState!.toggleCard();
                          _previousIndex = index;
                          _cardStateKeys[index].currentState!.toggleCard();
                          Future.delayed(
                              const Duration(milliseconds: 160),
                                  () {
                                setState(() {
                                  _wait = false;
                                });
                              });
                        });
                  } else {
                    //debugPrint('CARDS MATCH');
                    _cardFlips[_previousIndex] = false;
                    _cardFlips[index] = false;
                    if (_cardFlips.every((t) => t == false)) {
                      Future.delayed(
                          const Duration(milliseconds: 160),
                              () async {
                                if(!_isFinished){
                                  _isFinished = true;
                                  if(_timer!=null && _timer.isActive){
                                    _timer.cancel();
                                  }
                                  if(_gameTimer!=null && _gameTimer.isActive){
                                    gameTimePlayed=timeToPlay-_gameTime;
                                    _gameTimer.cancel();
                                  }
                                  int pointsToAdd=calculateScore(userDifficultyLevel,userLevel,gameTimePlayed,timeToPlay);
                                  await updateTotalScore(userEmail, pointsToAdd);
                                  updatedScore=pointsToAdd+userScore;
                                  setState(() {
                                    userScore=updatedScore;
                                  });
                                  if(userDifficultyLevel==GameDifficulty.DIFFICILE.displayName && userLevel==5){
                                    _gameController.setGameCompleted(userEmail);
                                    _isGameCompleted=true;
                                    await updateGame(userEmail, userScore, 5, GameDifficulty.DIFFICILE.displayName);
                                    if(_timer!=null && _timer.isActive){
                                      _timer.cancel();
                                    }
                                    if(_gameTimer!=null && _gameTimer.isActive){
                                      _gameTimer.cancel();
                                    }
                                    showResultDialog(context, true, true);
                                  }else{
                                    var result = moveToNextLevel();
                                    String nextDifficulty = result[0];
                                    int nextLevel = result[1];
                                    await updateGame(userEmail, userScore, nextLevel, nextDifficulty);
                                    setState(() {
                                      _previousIndex = -1;
                                      _flip = false;
                                      _start = false;
                                      _wait = false;
                                      _isFinished = false;
                                      _isTimeOut = false;
                                      _time = 7;
                                      timeToPlay = getGameplayTime(userLevel, userDifficultyLevel);
                                      _gameTime = timeToPlay;
                                    });
                                    restartTimers();
                                  }
                                }
                          });
                    }
                  }
                }else{
                  if(_cardStateKeys[index].currentState!.isFront){
                    _wait = true;
                    Future.delayed(
                        const Duration(milliseconds: 1500),
                            () {
                          _cardStateKeys[index].currentState!.toggleCard();
                          _flip = false;
                          Future.delayed(
                              const Duration(milliseconds: 160),
                                  () {
                                setState(() {
                                  _wait = false;
                                });
                              });
                        });
                  }
                  //debugPrint('THE SAME CARD INDEX');
                }
              }
              setState(() {});
          },
          flipOnTouch: _wait ? false : _cardFlips[index],
          direction: FlipDirection.HORIZONTAL,
          front: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage(
                  "assets/images/default.png",
                ),
              ),
            ),
            margin: const EdgeInsets.all(2),
          ),
          back: getItem(index))
          : getItem(index),
      itemCount: _data.length,
    );
  }

  void showResultDialog(BuildContext context, bool hasWon, bool isGameFinished) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: WoodenContainer(
            paddingV: 30,
            containerBackground: CustomColors.blueButton,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasWon && !isGameFinished ? "Bravo,\nvous avez gagné !" : hasWon && isGameFinished ? "Félicitations,\n vous avez compléter\ntous les niveaux !" : "Dommage,\nvous avez perdu",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset('assets/images/home_icon.svg', width: screenWidth*0.1, height: screenWidth*0.1,),
                    ),
                    if (!hasWon)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          restartGame();
                        },
                        child: SvgPicture.asset('assets/images/restart_icon.svg', width: screenWidth*0.1, height: screenWidth*0.1,),
                      ),
                    /*if (hasWon && !isGameFinished)
                      GestureDetector(
                        onTap: () async {
                          _timer.cancel();
                          _gameTimer.cancel();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MemoryGameBoard(
                                fullname: widget.fullname,
                              ),
                            ),
                          );
                        },
                        child: SvgPicture.asset('assets/images/next_icon.svg', width: screenWidth * 0.1, height: screenWidth * 0.1,),
                      ),*/
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  int getGridLinesNb(int level){
    return level+1;
  }

  int getGameplayTime(int level, String difficulty){
    int gridLinesNb=level+1;
    int gridColumnsNb=3;
    int time;
    if(difficulty.toLowerCase()==GameDifficulty.DIFFICILE.displayName.toLowerCase()){
      time=gridColumnsNb*gridLinesNb+gridLinesNb;
    }else if(difficulty.toLowerCase()==GameDifficulty.MOYEN.displayName.toLowerCase()){
      time=(gridColumnsNb*gridLinesNb+gridLinesNb)*1.5.ceil();
    }else{
      time=(gridColumnsNb*gridLinesNb+gridLinesNb)*2;
    }
    return time;
  }

  int calculateScore(String difficulty, int level, int gameTimePlayed, int timeToPlay) {
    int baseScore;

    switch (difficulty.toLowerCase()) {
      case 'difficile':
        baseScore = 300;
        break;
      case 'moyen':
        baseScore = 200;
        break;
      case 'facile':
        baseScore = 100;
        break;
      default:
        throw Exception('Invalid difficulty level');
    }

    if (level < 1 || level > 5) {
      throw Exception('Invalid level');
    }
    int score=baseScore + (level - 1) * 100;
    return (gameTimePlayed<(timeToPlay/2).ceil()) ? (score *1.5).floor() : score;
  }

  void restartTimers() {
    if(_timer!=null && _timer.isActive){
      _timer.cancel();
    }
    if(_gameTimer!=null && _gameTimer.isActive){
      _gameTimer.cancel();
    }
    startTimerCardsVisibility();
  }

  void restartGame() {
    restartTimers();
    setState(() {
      _previousIndex = -1;
      _flip = false;
      _start = false;
      _wait = false;
      _isFinished = false;
      _isTimeOut = false;
      _time = 7;
      timeToPlay = getGameplayTime(userLevel, userDifficultyLevel);
      _gameTime = timeToPlay;
    });
    initializeGameData();
  }

  List<dynamic> moveToNextLevel() {
    String nextDifficulty;
    int nextLevel;
    switch (userDifficultyLevel) {
      case 'Facile':
        if (userLevel < 5) {
          nextDifficulty = capitalizeFirstLetter(GameDifficulty.FACILE.displayName);
          nextLevel = userLevel + 1;
        } else {
          nextDifficulty = capitalizeFirstLetter(GameDifficulty.MOYEN.displayName);
          nextLevel = 1;
        }
        break;
      case 'Moyen':
        if (userLevel < 5) {
          nextDifficulty = capitalizeFirstLetter(GameDifficulty.MOYEN.displayName);
          nextLevel = userLevel + 1;
        } else {
          nextDifficulty = capitalizeFirstLetter(GameDifficulty.DIFFICILE.displayName);
          nextLevel = 1;
        }
        break;
      case 'Difficile':
        if (userLevel < 5) {
          nextDifficulty = capitalizeFirstLetter(GameDifficulty.DIFFICILE.displayName);
          nextLevel = userLevel + 1;
        } else {
          return [capitalizeFirstLetter(GameDifficulty.DIFFICILE.displayName), 5];
        }
        break;
      default:
        return [capitalizeFirstLetter(GameDifficulty.FACILE.displayName), 1];
    }
    return [nextDifficulty, nextLevel];
  }


  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }


}
