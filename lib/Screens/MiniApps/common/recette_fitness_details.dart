import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysaiph/Screens/MiniApps/recettes/models/recette_type.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../fitness/course/video_item.dart';
import '../fitness/models/fitness_data.dart';
import '../fitness/models/video_meta_data.dart';
import '../recettes/models/recette.dart';
import '../recettes/recette_item.dart';

class RecetteFitnessDetails extends StatefulWidget {
  final String title;
  final String image;
  final bool isFitness;

  const RecetteFitnessDetails({super.key, required this.title, required this.image, required this.isFitness});

  @override
  State<RecetteFitnessDetails> createState() => _RecetteFitnessDetailsState();
}

class _RecetteFitnessDetailsState extends State<RecetteFitnessDetails> {

  late List<String> fitnessVideos;
  late List<VideoMetadata> videoMetadataList = [];
  List<Recette> filteredRecettes=[];

  @override
  void initState() {
    super.initState();
    if(widget.isFitness){
      initDataList();
      fetchVideoMetaDataForAll();
    }else{
      filteredRecettes = recettes.where((recette) => recette.type.toStringValue() == widget.title).toList();
    }
  }

  Future<void> fetchVideoMetaDataForAll() async {
    final yt = YoutubeExplode();
    try {
      List<Future<VideoMetadata>> futures = [];
      for (var videoId in fitnessVideos) {
        Future<Video> videoFuture = yt.videos.get(videoId);
        futures.add(videoFuture.then((v) => VideoMetadata(
          title: v.title ?? "",
          author: v.author ?? "",
          duration: v.duration ?? const Duration(minutes: 0, seconds: 0),
        )));
      }
      List<VideoMetadata> metadataList = await Future.wait(futures);
      if(mounted){
        setState(() {
          videoMetadataList = metadataList;
        });
      }
    } finally {
      yt.close();
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeRatio = screenHeight * 0.00125;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: Image.asset(
                  widget.image,
                  width: screenWidth,
                  height: screenHeight/2.5,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: screenWidth,
                height: screenHeight / 2.5,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44*fontSizeRatio,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                top: 25,
                left: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                  },
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back, // Change the icon as needed
                          color: Color(0xFF273085),
                          size: 20, // Adjust the size of the icon as needed
                        ),
                      )),
                ),
              ),
            ],
          ),
          widget.isFitness ?
            Expanded(
            child: FutureBuilder(
              future: Future.value(true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || videoMetadataList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Une erreur s\'est produite'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: fitnessVideos.length,
                      itemBuilder: (context, index) {
                        return VideoItem(
                          videoId: fitnessVideos[index],
                          videoMetadata: videoMetadataList[index],
                        );
                      },
                    );
                  }
                }
              },
            ),

          )
          : Expanded(
            child: ListView.builder(
              itemCount: filteredRecettes.length,
              itemBuilder: (context, index) {
                return RecetteItem(recette: filteredRecettes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void initDataList() {
    switch (widget.title) {
      case "Corps":
        fitnessVideos = FitnessData.fullBodyVideos;
        break;
      case "Bras":
        fitnessVideos = FitnessData.armsVideos;
        break;
      case "Abdo":
        fitnessVideos = FitnessData.absVideos;
      case "Jambes":
        fitnessVideos = FitnessData.legsVideos;
        break;
      case "Poitrine":
        fitnessVideos = FitnessData.chestVideos;
        break;
      case "Épaules":
        fitnessVideos = FitnessData.shoulderVideos;
        break;
      case "Dos":
        fitnessVideos = FitnessData.backVideos;
        break;
      case "Cardio":
        fitnessVideos = FitnessData.cardioVideos;
        break;
      default:
        fitnessVideos = [];
        break;
    }
  }
}
