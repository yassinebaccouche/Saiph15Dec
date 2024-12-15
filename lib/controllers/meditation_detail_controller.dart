import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../Models/music.dart';

class MeditationController extends GetxController {
  final String title ;
  MeditationController(this.title);


  Rx<bool> isPlaying = false.obs;
  var player = AudioPlayer();
  Rx<Stream<Duration>> position =
      Stream<Duration>.fromIterable([const Duration(seconds: 0)]).obs;

  Rx<Stream<Duration?>> duration =
      Stream<Duration?>.fromIterable([const Duration(seconds: 0)]).obs;

  Rx<Stream<PlayerState>> playerStates =
      Stream<PlayerState>.fromIterable([PlayerState(false,ProcessingState.loading)]).obs;


  String previousSong = "";
  List<String> songsList=[];


  void setIsPlaying(bool val) {
    isPlaying.value = val;
  }

  play() {
    if (isPlaying.isFalse) {
      isPlaying.value = true;
      player.play();
    } else {
      isPlaying.value = false;
      player.pause();
    }
  }

  @override
  void onInit() {

    initPlayer();
    songsList=title == "Guérison"
    ? MusicDataSet.healingMusic
        : title == "Sommeil"
    ? MusicDataSet.sleepingMusic
        : MusicDataSet.relaxingMusic;
    super.onInit();
  }

  initPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
    });
    loadAudio();
  }

  loadAudio() async {
    try {
      await player
          .setAudioSource(AudioSource.asset(getTrackId()));
      position.value = player.positionStream;
      duration.value = player.durationStream;
      playerStates.value=player.playerStateStream;
    } catch (e) {
    }
  }

  String getTrackId(){

    for (int i = 0; i < songsList.length; i++) {
      songsList.shuffle();
      int randomIndex = i;
      String currentElement = songsList[randomIndex];
      if (currentElement != previousSong) {
        previousSong = currentElement;
        return currentElement;
      }
    }
    return "";

  }

  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
