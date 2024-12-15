import 'package:flutter/material.dart';
import 'package:mysaiph/Screens/MiniApps/recettes/recette_instructions.dart';

import 'models/recette.dart';

class RecetteItem extends StatelessWidget {
  final Recette recette;

  RecetteItem({required this.recette});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSizeRatio = screenHeight * 0.00125;

    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RecetteInstructions(recette: recette),
        ));
      },
      title: Container(
        decoration: BoxDecoration(
          color: const Color(0xffEEEEEE),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recette.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16 * fontSizeRatio,
                fontWeight: FontWeight.w600,
                color: const Color(0xff273085),
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              "Durée totale: ${recette.prep_time + recette.cook_time} minutes",
              style: TextStyle(
                fontSize: 14 * fontSizeRatio,
                fontWeight: FontWeight.w300,
                color: const Color(0xff273085),
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              "Nb de personnes: ${recette.persons}",
              style: TextStyle(
                fontSize: 14 * fontSizeRatio,
                fontWeight: FontWeight.w300,
                color: const Color(0xff273085),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
