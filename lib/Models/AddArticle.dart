import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CreateArticlePage extends StatefulWidget {
  @override
  _CreateArticlePageState createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final TextEditingController _correctAnswerController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final List<TextEditingController> _answerControllers = [];

  void _addPossibleAnswer() {
    setState(() {
      _answerControllers.add(TextEditingController());
    });
  }

  void _removePossibleAnswer(int index) {
    setState(() {
      _answerControllers.removeAt(index);
    });
  }

  Future<void> _uploadArticle() async {
    String articleId = Uuid().v4();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "Unknown";
    String pseudo = FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous";
    List<String> possibleAnswers = _answerControllers.map((c) => c.text).toList();
    int points = int.tryParse(_pointsController.text) ?? 0;

    await FirebaseFirestore.instance.collection('articles').doc(articleId).set({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'question': _questionController.text,
      'hint': _hintController.text,
      'possibleAnswers': possibleAnswers,
      'correctAnswer': _correctAnswerController.text,
      'points': points,
      'articleId': articleId,
      'uid': uid,
      'pseudo': pseudo,
      'datePublished': DateTime.now(),
      'likes': [],
      'postUrl': '', // Can add image upload later
      'profImage': '', // Can fetch user profile pic later
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Article')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _hintController,
              decoration: InputDecoration(labelText: 'Hint'),
            ),
            ..._answerControllers.asMap().entries.map((entry) {
              int index = entry.key;
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(labelText: 'Answer ${index + 1}'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => _removePossibleAnswer(index),
                  ),
                ],
              );
            }).toList(),
            ElevatedButton(
              onPressed: _addPossibleAnswer,
              child: Text('Add Possible Answer'),
            ),
            TextField(
              controller: _correctAnswerController,
              decoration: InputDecoration(labelText: 'Correct Answer'),
            ),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Points'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadArticle,
              child: Text('Submit Article'),
            ),
          ],
        ),
      ),
    );
  }
}