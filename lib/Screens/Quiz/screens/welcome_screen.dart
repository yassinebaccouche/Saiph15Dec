import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Ensure the correct package for SVG
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:mysaiph/Screens/Quiz/controller/quiz_controller.dart';
import 'package:mysaiph/Screens/Quiz/screens/quiz_screen/quiz_screen.dart';
import 'package:mysaiph/providers/user_provider.dart';

import '../../../Models/user.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _submit(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context, listen: false).getUser;
    final QuizController controller = Get.find<QuizController>();

    if (user != null) {
      final int previousScore = int.tryParse(user.FullScore) ?? 0;
      final int newScore = previousScore + controller.scoreResult;

      // Update user score
      user.FullScore = newScore.toString();

      // Restart quiz controller
      controller.startAgain();

      // Navigate to the QuizScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen()),
      );

      // Start the quiz timer
      controller.startTimer();
    } else {
      // Handle the case where the user is null
      print("User not found");
    }

    // Unfocus any active input fields
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: SizedBox(),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                "assets/images/close_icon.svg",
                width: 25,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/QuizBack.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.large(
                    heroTag: null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(500),
                    ),
                    onPressed: () => _submit(context),
                    backgroundColor: const Color(0xFF2D8592),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
