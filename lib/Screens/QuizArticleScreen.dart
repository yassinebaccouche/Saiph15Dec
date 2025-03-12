import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:provider/provider.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:mysaiph/providers/user_provider.dart'; // Adjust path if necessary
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/user.dart';

class ArticleQuizScreen extends StatefulWidget {
  final String question;
  final List<String> possibleAnswers;
  final String? correctAnswer;
  final String articleId;
  final int points;
  final String quizBackgroundUrl; // New field for background image

  const ArticleQuizScreen({
    Key? key,
    required this.question,
    required this.possibleAnswers,
    this.correctAnswer,
    required this.articleId,
    required this.points,
    required this.quizBackgroundUrl,
  }) : super(key: key);

  @override
  _ArticleQuizScreenState createState() => _ArticleQuizScreenState();
}

class _ArticleQuizScreenState extends State<ArticleQuizScreen> {
  final Duration _animationDuration = const Duration(milliseconds: 500);
  String? _selectedAnswer;
  bool _isAnswerCorrect = false;
  bool _isAnswerSubmitted = false;

  final FireStoreMethodes _fireStoreMethodes = FireStoreMethodes();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final String uid = userProvider.getUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Article Quiz"),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.quizBackgroundUrl), // Fetch from Firestore
            fit: BoxFit.contain, // Cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.question,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Ensure text is visible
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              for (var answer in widget.possibleAnswers)
                _buildAnswerCard(answer, userProvider), // Pass userProvider here
              const SizedBox(height: 30),
              if (_isAnswerSubmitted) _buildResultMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerCard(String answer, UserProvider userProvider) {
    return AnimatedOpacity(
      opacity: _isAnswerSubmitted ? 0.7 : 1.0,
      duration: _animationDuration,
      child: GestureDetector(
        onTap: () async {
          if (!_isAnswerSubmitted) {
            var responses = await _fireStoreMethodes
                .getArticleResponsesByArticle(widget.articleId);

            bool hasResponded = responses.any((response) => response.uid == userProvider.getUser.uid);

            if (hasResponded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Vous avez déjà répondu à ce quiz!"),
                ),
              );
            } else {
              setState(() {
                _selectedAnswer = answer;
                _isAnswerSubmitted = true;
                _isAnswerCorrect = (answer == widget.correctAnswer);
              });

              await _fireStoreMethodes.createArticleResponse(userProvider.getUser.uid, widget.articleId);

              if (_isAnswerCorrect) {
                int newScore = widget.points;
                User user = userProvider.getUser;
                int currentScore = int.parse(user.FullScore);
                int updatedScore = currentScore + newScore;
                user.FullScore = updatedScore.toString();

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update(user.toJson())
                    .then((_) {
                  userProvider.setUser(user);
                }).catchError((error) {
                  print("Erreur de mise à jour du score: $error");
                });
              }
            }
          }
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: _isAnswerSubmitted && _selectedAnswer == answer
              ? (_isAnswerCorrect ? Colors.green.shade300 : Colors.red.shade300)
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultMessage() {
    return Column(
      children: [
        Text(
          _isAnswerCorrect ? "Correct!" : "Mauvaise réponse!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _isAnswerCorrect ? Colors.green : Colors.red,
          ),
        ),
        if (!_isAnswerCorrect) _correctAnswerWidget(),
      ],
    );
  }

  Widget _correctAnswerWidget() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "La bonne réponse était :",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.correctAnswer ?? "Aucune réponse correcte définie",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
