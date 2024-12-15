import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:mysaiph/Screens/TransfertPoints.dart';
import 'package:mysaiph/Screens/AllGIftsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({Key? key}) : super(key: key);

  // Function to handle the refresh operation
  void _refresh(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUserData(); // Assuming you have a method to refresh user data
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double baseWidth = 380;
    final double baseHeight = 820; // Adjust the base height as needed
    final double scalingFactor = screenWidth / baseWidth;
    final double fontSizeFactor = scalingFactor * 0.97;
    final double verticalSpacing = 20 * scalingFactor;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: verticalSpacing),
            Text(
              'Points et Cadeaux',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16 * fontSizeFactor,
                color: Color(0xff696969),
              ),
            ),
            SizedBox(height: verticalSpacing),
            Text(
              'Vous avez',
              style: TextStyle(
                fontSize: 16 * fontSizeFactor,
                color: Color(0xff696969),
                fontFamily: 'Inter',
              ),
            ),
            Text(
              '${userProvider.getUser.FullScore} Points',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30 * fontSizeFactor,
                color: Color(0xFF00B2FF),
                fontFamily: 'Inter',
              ),
            ),

            SizedBox(height: verticalSpacing),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
              child: ClipRRect(
                // Adjust the radius value as needed
                child: Image.asset(
                  'assets/images/Cadeaux.png', // Replace 'assets/cadeaux.png' with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),
            ElevatedButton(
              onPressed: () async {
                // Convert user information to JSON string
                String userJson = json.encode(userProvider.getUser.toJson());

                // Store user information in shared preferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('currentUser', userJson);

                // Navigate to the AllGiftsScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllGiftsScreen(),
                  ),
                ).then((_) => _refresh(context)); // Refresh after navigating back
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 50 * scalingFactor,
                  vertical: 15 * scalingFactor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30 * scalingFactor),
                ),
                backgroundColor: Color(0xFF00B2FF),
              ),
              child: Text(
                'Transformez en cadeaux',
                style: TextStyle(
                  fontSize: 16 * fontSizeFactor,
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TransfertPointScreen(),
                  ),
                ).then((_) => _refresh(context)); // Refresh after navigating back
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 70 * scalingFactor,
                  vertical: 15 * scalingFactor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30 * scalingFactor),
                ),
                backgroundColor: Color(0xffF6A020),
              ),
              child: Text(
                'Envoyer des points',
                style: TextStyle(
                  fontSize: 16 * fontSizeFactor,
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
