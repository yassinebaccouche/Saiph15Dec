import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysaiph/Screens/Quiz/controller/quiz_controller.dart';
import 'package:mysaiph/Screens/Quiz/model/question_model.dart';

import 'answer_option.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel questionModel;

  const QuestionCard({
    Key? key,
    required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              questionModel.question,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,

              ),
            ),
            SizedBox(height: 20),
            ...List.generate(
              questionModel.options.length,
                  (index) => Column(
                children: [
                  AnswerOption(
                    questionId: questionModel.id,
                    text: questionModel.options[index],
                    index: index,
                    onPressed: () => Get.find<QuizController>()
                        .checkAnswer(questionModel, index),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
