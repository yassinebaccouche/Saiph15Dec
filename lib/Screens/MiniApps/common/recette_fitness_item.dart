import 'package:flutter/material.dart';
import 'package:mysaiph/Screens/MiniApps/common/recette_fitness_details.dart';

class RecetteFitnessItem extends StatelessWidget {
  final String title;
  final String image;
  final bool isFitness;

  const RecetteFitnessItem({Key? key, required this.title, required this.image, required this.isFitness}) : super(key: key);

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
              builder: (context) => RecetteFitnessDetails(title: title, image: image, isFitness: isFitness,),
            ));
          },
          title:
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  image,
                  width: screenWidth,
                  height: screenHeight/4,
                  fit: BoxFit.cover,

                ),
                Container(
                  width: screenWidth,
                  height: screenHeight / 4,
                  color: Colors.black.withOpacity(0.4),
                ),
                Container(
                  width: screenWidth/2.5,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xff273085),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16*fontSizeRatio,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      ],
    );
  }
}
