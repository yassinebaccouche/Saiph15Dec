import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final Map<String, dynamic> quizData;

  const QuizCard({Key? key, required this.quizData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> questions = quizData['questions'] ?? [];

    return Column(
      children: questions.map((question) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...List<Widget>.from(question['options'].map((option) {
              return ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: question['selectedOption'],
                  onChanged: (String? value) {
                    // Handle the quiz option selection
                  },
                ),
              );
            })),
            Divider(),
          ],
        );
      }).toList(),
    );
  }
}
