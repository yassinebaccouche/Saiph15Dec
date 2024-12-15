
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mysaiph/Screens/Quiz/screens/welcome_screen.dart';


import 'controller/quiz_controller.dart';

class QuizgameScreen extends StatefulWidget {
  @override
  _QuizgameScreenState createState() => _QuizgameScreenState();
}

class _QuizgameScreenState extends State<QuizgameScreen> {
  final QuizController quizController = Get.put(QuizController());
  @override
  Widget build(BuildContext context) {
    return WelcomeScreen();
  }
}
