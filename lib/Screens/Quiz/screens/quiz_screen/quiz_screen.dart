import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:mysaiph/Screens/Quiz/controller/quiz_controller.dart';

import 'package:mysaiph/Screens/Quiz/widgets/progress_timer.dart';
import 'package:mysaiph/Screens/Quiz/widgets/question_card.dart';
import 'package:mysaiph/providers/user_provider.dart';

import '../../../../Models/user.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final User? user = Provider.of<UserProvider>(context).getUser;
    final screenHeight = MediaQuery.of(context).size.height;
    final pageViewHeight = (2 / 3) * screenHeight;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/images/QuizBackground.png', // Replace with your image path
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: GetBuilder<QuizController>(
              init: QuizController(),
              builder: (controller) => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          GestureDetector(

                            onTap: () {
                              user?.FullScore = (int.parse(user?.FullScore ?? '0') + controller.scoreResult).toString();
                              controller.startAgain();
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
                    ),
                    SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user!.photoUrl),
                          ),
                          SizedBox(height: 10),
                          Text(
                            user!.pseudo,// Replace with user's name
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Score:1200', // Replace with user's title
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Question ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Adjust font size here
                          fontWeight: FontWeight.bold, // Adjust font weight here
                        ),
                        children: [
                          TextSpan(
                            text: controller.numberOfQuestion.round().toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20, // Adjust font size here
                              fontWeight: FontWeight.bold, // Adjust font weight here
                            ),
                          ),
                          TextSpan(
                            text: '/',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Adjust font size here
                              fontWeight: FontWeight.normal, // Adjust font weight here
                            ),
                          ),
                          TextSpan(
                            text: controller.countOfQuestion.toString(),
                            style: TextStyle(
                              color: Colors.grey[300], // Adjust color here
                              fontSize: 18, // Adjust font size here
                              fontWeight: FontWeight.normal, // Adjust font weight here
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: pageViewHeight,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => QuestionCard(
                          questionModel: controller.questionsList[index],
                        ),
                        controller: controller.pageController,
                        itemCount: controller.questionsList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GetBuilder<QuizController>(
        init: QuizController(),
        builder: (controller) {
          controller.context = context;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              ProgressTimer(),
              FloatingActionButton.extended(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
                backgroundColor: Color(0xFFED9B24),
                onPressed: () {
                  controller.nextQuestion();
                },
                label: Text(
                  'Suivant',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),

                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
