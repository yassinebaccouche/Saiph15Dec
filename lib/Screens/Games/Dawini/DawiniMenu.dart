import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class DawiniMenu extends StatelessWidget {
  const DawiniMenu({Key? key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      width: double.infinity,
      height: 1050,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/rectangle-10-bg-Fp8.jpg'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 52.0), // Adjust the value as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Align children at the bottom
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally

          children: [
            // Add other widgets or images as needed
            Image.asset('assets/images/DawiniMenu.png', height: 80, width: 200),
            buildImageButton(
              'assets/images/DawiniJouerButton.png',
                  () {
                // Handle DawiniJouerButton press
                print('DawiniJouerButton pressed');
              },
            ),
            buildImageButton(
              'assets/images/DawiniScoreButton.png',
                  () {
                // Handle DawiniScoreButton press
                print('DawiniScoreButton pressed');
              },
            ),
            buildImageButton(
              'assets/images/DawiniOptionButton.png',
                  () {
                // Handle DawiniOptionButton press
                print('DawiniOptionButton pressed');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageButton(String imagePath, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 200,
          height: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(imagePath),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
