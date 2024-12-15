import 'package:flutter/material.dart';
import 'package:mysaiph/Screens/MiniApps/Meditation/meditation_app_home.dart';
import 'package:mysaiph/Screens/MiniApps/Movies/movie_list.dart';
import 'package:mysaiph/Screens/MiniApps/fitness/home/fitness_home_page.dart';
import 'package:mysaiph/Screens/MiniApps/recettes/home/recettes_home_page.dart';

class MiniAppsScreen extends StatefulWidget {
  const MiniAppsScreen({Key? key}) : super(key: key);

  @override
  _MiniAppsScreenState createState() => _MiniAppsScreenState();
}

class _MiniAppsScreenState extends State<MiniAppsScreen> {
  List<Widget> gridItems = [];

  @override
  void initState() {
    gridItems.add(buildGridItem(
        gridItems.length, miniAppIcon('fitness.jpg'), 'Fitness', () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FitnessHomePage(),
          ));
    }));
    gridItems.add(buildGridItem(gridItems.length, miniAppIcon('recette.jpeg'),
        'Recette du jour', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecettesHomePage(),
              ));
        }));
    /*gridItems.add(buildGridItem(
        gridItems.length, miniAppIcon('calorie.png'), 'Calories', null));
    gridItems.add(buildGridItem(
        gridItems.length, miniAppIcon('horoscope.png'), 'Horoscope', null));
    gridItems.add(buildGridItem(
        gridItems.length, miniAppIcon('avisiter.jpg'), 'À visiter', null));
    gridItems.add(buildGridItem(
        gridItems.length, miniAppIcon('Note.png'), 'Notes', null));
    gridItems.add(buildGridItem(
        gridItems.length, miniAppIcon('Rappel.png'), 'Rappel', null));*/
    gridItems.add(buildGridItem(
        gridItems.length, miniAppIcon('mediation.png'), 'Méditation', () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MeditationHomePage(),
          ));
    }));
    gridItems.add(buildGridItem(
        gridItems.length, miniAppIcon('movies.jpg'), 'Films', () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MovieList(),
          ));
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: gridItems.length,
              itemBuilder: (BuildContext context, int index) {
                return gridItems[index];
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget buildGridItem(
      int index, Widget item, String title, Function? navigate) {
    return GestureDetector(
      onTap: () {
        if(navigate!=null){
          navigate();
        }
      },
      child: Column(
        children: [
          item,
          const SizedBox(height: 3),
          Text(
            title,
            maxLines: 1,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget miniAppIcon(String icon) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/$icon',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        /*Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.lock,
                color: Colors.white,
              ),
            ),
          ),
        ),*/
      ],
    );
  }

  Widget addButton() {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Color(0xFF273085),
          size: 40,
        ),
      ),
    );
  }
}
