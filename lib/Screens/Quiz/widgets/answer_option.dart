import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysaiph/Screens/Quiz/controller/quiz_controller.dart';

class AnswerOption extends StatelessWidget {
  const AnswerOption({
    Key? key,
    required this.text,
    required this.index,
    required this.questionId,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final int index;
  final int questionId;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      init: Get.find<QuizController>(),
      builder: (controller) => InkWell(
        onTap: controller.checkIsQuestionAnswered(questionId) ? null : onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white, // Set the background color to white
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the items horizontally
              children: [
                Expanded(
                  child: Text(
                    ' $text',
                    textAlign: TextAlign.center, // Center the text within the available space
                    style: TextStyle(
                      color: Color(0xFF000000), // Set the text color to black
                      fontSize: 16,
                    ),
                  ),
                ),
                if (controller.checkIsQuestionAnswered(questionId) &&
                    controller.selectAnswer == index)
                  Container(
                    width: 30,
                    height: 30,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFE49528), // Set the center color to blue
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.getIcon(index),
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
