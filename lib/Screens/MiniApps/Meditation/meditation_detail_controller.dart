import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../Models/music.dart';

class MeditationController extends GetxController {
  final String title;
  MeditationController(this.title);

  RxBool isPlaying = false.obs; // Updated to simpler Rx type
  final AudioPlayer player = AudioPlayer();

  // Stream Observables for UI bindings
  late Rx<Stream<Duration>> position;
  late Rx<Stream<Duration?>> duration;
  late Rx<Stream<PlayerState>> playerStates;

  String previousSong = "";
  late List<String> songsList;

  void togglePlayPause() {
    if (isPlaying.value) {
      player.pause();
    } else {
      player.play();
    }
    isPlaying.toggle(); // Toggles the play state
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize observables with initial streams
    position = Rx(player.positionStream);
    duration = Rx(player.durationStream);
    playerStates = Rx(player.playerStateStream);

    // Clone the song list based on the provided title
    songsList = List<String>.from(
      title == "Guérison"
          ? MusicDataSet.healingMusic
          : title == "Sommeil"
          ? MusicDataSet.sleepingMusic
          : MusicDataSet.relaxingMusic,
    );

    initPlayer();
  }

  Future<void> initPlayer() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      player.playbackEventStream.listen(
            (event) {},
        onError: (Object e, StackTrace stackTrace) {
          print("Audio Player Error: $e");
        },
      );

      await loadAudio();
    } catch (e) {
      print("Error during player initialization: $e");
    }
  }

  Future<void> loadAudio() async {
    try {
      final trackId = getTrackId();
      if (trackId.isNotEmpty) {
        await player.setAudioSource(AudioSource.asset(trackId));
      } else {
        print("Error: No valid track ID found to load audio.");
      }
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  String getTrackId() {
    if (songsList.isEmpty) return "";

    songsList.shuffle(); // Randomize the song list
    final nextSong = songsList.firstWhere(
          (song) => song != previousSong,
      orElse: () => songsList.first, // Fallback in case all are the same
    );

    previousSong = nextSong;
    return nextSong;
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    player.dispose(); // Dispose of the player to free resources
    super.onClose();
  }
}
