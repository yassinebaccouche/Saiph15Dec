import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mysaiph/Screens/Quiz/controller/quiz_controller.dart';
import 'package:mysaiph/Screens/Quiz/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'package:mysaiph/Models/user.dart'; // import your User model
import 'package:mysaiph/providers/user_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.transparent,
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
          )
        ],
      ),
      body: Stack(
        children: [
          // Updated Gradient Background
          Image.asset(
            'assets/images/QuizBackground.png', // Replace with your image path
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: GetBuilder<QuizController>(
              init: Get.find<QuizController>(),
              builder: (controller) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Celebration Icon
                    Icon(
                      Icons.emoji_events,
                      color: Colors.yellow[700],
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    // Congratulatory Message
                    Text(
                      'Félicitations!',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User Name
                    Text(
                      controller.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Score Label
                    Text(
                      'Votre Score est',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Score Value
                    Text(
                      '${controller.scoreResult} /10',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Colors.yellow[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Restart Button
                    FloatingActionButton.extended(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      backgroundColor: const Color(0xFF00C853),
                      onPressed: () {
                        user?.FullScore = (int.parse(user?.FullScore ?? '0') + controller.scoreResult).toString();
                        controller.startAgain();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                        );
                      },
                      label: Text(
                        'Recommencer',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
