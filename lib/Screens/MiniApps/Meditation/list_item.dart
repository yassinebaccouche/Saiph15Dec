import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'meditation_detail.dart';

Widget listItem(BuildContext context, String image, String title) {
  return GestureDetector(
    onTap: () {
      Get.to(()=>MeditationDetailScreen(title: title));
          },
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Image with corner radius
        ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),

        // Button in the center
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xFF273085))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeditationDetailScreen(title: title),
                ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Text(title),
          ),
        ),
      ],
    ),
  );
}
