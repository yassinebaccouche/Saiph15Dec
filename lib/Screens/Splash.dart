import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mysaiph/Screens/SignInScreen.dart'; // Remove the extra space here

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay and navigate to the next screen
    Timer(
      Duration(seconds: 4), // Adjust the duration as needed
          () {
        if(mounted){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()), // Replace SignInScreen() with the screen you want to navigate to
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center( // Center the logo
        child: Image.asset(
          'assets/images/logo.png', // Adjust the path to your logo image
          // You can specify width and height constraints if needed
        ),
      ),
    );
  }
}
