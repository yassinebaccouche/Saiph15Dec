import 'package:flutter/material.dart';
import 'package:mysaiph/Screens/MiniApps/fitness/course/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/video_meta_data.dart';

class VideoItem extends StatefulWidget {
  final String videoId;
  final VideoMetadata videoMetadata;

  const VideoItem({
    required this.videoId,
    required this.videoMetadata,
  });

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeRatio = screenHeight * 0.00125;
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  VideoPlayer(videoUrl: "https://www.youtube.com/watch?v=${widget.videoId}"),
            ));
          },
          title:
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffEEEEEE),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Row(
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      'https://img.youtube.com/vi/${widget.videoId}/0.jpg',
                      width: screenWidth / 3,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.videoMetadata.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16 * fontSizeRatio,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff273085)
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        formatDuration(widget.videoMetadata.duration),
                        style: TextStyle(
                          fontSize: 14 * fontSizeRatio,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff273085)
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                          "Chaîne: ${widget.videoMetadata.author}",
                        style: TextStyle(
                            fontSize: 14 * fontSizeRatio,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xff273085)
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),


        ),
      ],
    );
  }

  String formatDuration(Duration duration) {
    String minutesPart = '${duration.inMinutes}min';
    String secondsPart = '${duration.inSeconds.remainder(60)}s';

    return '$minutesPart $secondsPart';
  }

}
