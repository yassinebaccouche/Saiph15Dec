import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class ArticleQuizScreen extends StatefulWidget {
  final String question;
  final List<String> possibleAnswers;
  final String? correctAnswer;

  const ArticleQuizScreen({
    Key? key,
    required this.question,
    required this.possibleAnswers,
    this.correctAnswer,
  }) : super(key: key);

  @override
  _ArticleQuizScreenState createState() => _ArticleQuizScreenState();
}

class _ArticleQuizScreenState extends State<ArticleQuizScreen> {
  final _animationDuration = const Duration(milliseconds: 500);
  String? _selectedAnswer;
  bool _isAnswerCorrect = false;
  bool _isAnswerSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article Quiz"),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blueAccent.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Question text
              Text(
                widget.question,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Display possible answers
              for (var answer in widget.possibleAnswers)
                AnimatedOpacity(
                  opacity: _isAnswerSubmitted ? 0.7 : 1.0,
                  duration: _animationDuration,
                  child: GestureDetector(
                    onTap: () {
                      if (!_isAnswerSubmitted) {
                        setState(() {
                          _selectedAnswer = answer;
                          _isAnswerSubmitted = true;

                          if (_selectedAnswer == widget.correctAnswer) {
                            _isAnswerCorrect = true;
                          } else {
                            _isAnswerCorrect = false;
                          }
                        });
                      }
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: _isAnswerSubmitted && _selectedAnswer == answer
                          ? (_isAnswerCorrect
                          ? Colors.green.shade300
                          : Colors.red.shade300)
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 25.0),
                        child: Text(
                          answer,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 30),

              // Show feedback after the answer is selected
              if (_isAnswerSubmitted)
                Text(
                  _isAnswerCorrect ? "Correct!" : "Wrong answer!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _isAnswerCorrect ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
