import 'package:flutter/material.dart';
class LevelInfoBody extends StatelessWidget {
  final List<MapEntry<String,int>> rules;
  const LevelInfoBody({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
            rules.map((rule) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rule.key,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    "${rule.value} points",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              );
            }).toList(),
         /*   Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "< 2 min",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  "30 points",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "> 2 min et < 5 min",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  "20 points",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "> 5 min",
                    style:
                    TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    "10 points",
                    style:
                    TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ])*/

        ),
      ],
    );
  }
}
