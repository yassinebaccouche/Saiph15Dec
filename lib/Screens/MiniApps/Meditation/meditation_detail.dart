import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../controllers/meditation_detail_controller.dart';

class MeditationDetailScreen extends StatelessWidget {
  final String title;

  const MeditationDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final MeditationController controller = Get.put(MeditationController(title));
    List<AudioWaveBar> waves = [
      AudioWaveBar(heightFactor: 0.1, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.4, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.2, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.4, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.5, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.9, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.7, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.6, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.2, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.6, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.3, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.9, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.1, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.4, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.2, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.4, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.5, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.5, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.9, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.7, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.6, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.2, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.4, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.5, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.9, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.5, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.4, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.2, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.4, color: Colors.grey),
      AudioWaveBar(heightFactor: 0.1, color: Colors.grey),
    ];
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.delete<MeditationController>();
            Navigator.pop(context);

          },
          child: Container(
              margin: const EdgeInsets.all(10),
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Color(0xFF273085),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back, // Change the icon as needed
                  color: Colors.white,
                  size: 20, // Adjust the size of the icon as needed
                ),
              )),
        ),
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: Color(0xFF273085)),
        ),
        backgroundColor: const Color(0xFFFCFCFC),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                title == "Guérison"
                    ? "assets/images/yoga1.svg"
                    : title == "Sommeil"
                        ? "assets/images/sleeping.svg"
                        : "assets/images/relaxing.svg",
                width: screenWidth - 40,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Respirez !",
                style: TextStyle(color: Color(0xFF273085), fontSize: 24),
              ),
              const SizedBox(
                height: 40,
              ),
              Obx(
                () => StreamBuilder(
                  stream: controller.playerStates.value,
                  builder: (context, state) {
                     PlayerState? audioState=null;
                    if(state.data != null){
                      audioState=state.data!;
                      if(audioState != null){
                        if(audioState.processingState==ProcessingState.completed){

                          controller.player.pause();
                          controller.player.seek(Duration.zero).then((value) => controller.setIsPlaying(false));
                        }
                      }
                    }

                    return StreamBuilder(
                      stream: controller.duration.value,
                      builder: (context, duration) {
                        if (duration.data != null) {
                          var trackDuration = duration.data!;
                          var threshold =
                              trackDuration.inMilliseconds / waves.length;
                          return StreamBuilder(
                              stream: controller.position.value,
                              builder: (context, posStream) {
                                if (posStream.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(
                                    color: Color(0xFF273085),
                                  );
                                } else {
                                  var currentPosition = posStream.data!;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        posStream.data == null
                                            ? "0:00"
                                            : controller.formatDuration(
                                                posStream.data!.inSeconds),
                                        style: const TextStyle(
                                            color: Color(0xFF273085),
                                            fontSize: 17),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AudioWave(
                                            height: 50,
                                            width: screenWidth / 2,
                                            spacing: 2.5,
                                            animation: false,
                                            bars: waves.map((e) {
                                              if (currentPosition
                                                          .inMilliseconds /
                                                      threshold >=
                                                  waves.indexOf(e)) {
                                                e.color =
                                                    e.color = const Color(0xFF273085);
                                              } else {
                                                e.color = Colors.grey;
                                              }
                                              return e;
                                            }).toList(),
                                          ),
                                          SizedBox(
                                            width: screenWidth / 2,
                                            child: SliderTheme(
                                              data: SliderThemeData(
                                                  thumbShape:
                                                  const _RectSliderThumbShape(
                                                          width: 10,
                                                          height: 60),
                                                  activeTrackColor:
                                                      Colors.transparent,
                                                  thumbColor: const Color(0xFF273085),
                                                  inactiveTrackColor:
                                                      Colors.transparent,
                                                  trackShape:
                                                      CustomTrackShape()),
                                              child: Slider(
                                                min: 0,
                                                max: trackDuration
                                                        .inMilliseconds
                                                        .toDouble() +
                                                    40,
                                                value: currentPosition
                                                    .inMilliseconds
                                                    .toDouble(),
                                                onChanged: (val) async {
                                                  controller.player.seek(
                                                      Duration(
                                                          milliseconds:
                                                              val.toInt()));
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        posStream.data == null
                                            ? "0:00"
                                            : controller.formatDuration(
                                                trackDuration.inSeconds),
                                        style: const TextStyle(
                                            color: Color(0xFF273085),
                                            fontSize: 17),
                                      ),
                                    ],
                                  );
                                }
                              });
                        } else {
                          return const SizedBox();
                        }
                      });
                  },
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          size: 40,
                          Icons.skip_previous_rounded,
                          color: Color(0xFF273085),
                        )),
                    FloatingActionButton(
                        elevation: 0,
                        onPressed: () {
                          controller.play();
                        },
                        backgroundColor: const Color(0xFF273085),
                        child: Obx(
                          () => controller.isPlaying.value
                              ? const Icon(
                                  size: 40,
                                  Icons.stop_circle_rounded,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  size: 40,
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                        )),
                    IconButton(
                        onPressed: () {controller.loadAudio();},
                        icon: const Icon(
                          size: 40,
                          Icons.skip_next_rounded,
                          color: Color(0xFF273085),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class CustomTrackShape extends RectangularSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class _RectSliderThumbShape extends SliderComponentShape {
  final double width;
  final double height;

  const _RectSliderThumbShape({required this.width, required this.height});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.thumbColor != null);

    final rect = Rect.fromCenter(center: center, width: width, height: height);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    context.canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(width / 2)), fillPaint);
    context.canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(width / 2)), borderPaint);
  }
}
