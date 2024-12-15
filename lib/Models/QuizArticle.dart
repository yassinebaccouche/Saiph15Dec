import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String description;
  final String uid;
  final String pseudo;
  final String? Title;
  final String? Hint;
  final likes;
  final String articleId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final String question;
  final List<String> possibleAnswers;
  final String? correctAnswer;


  const Article(
      {required this.description,
        required this.uid,
        required this.pseudo,
        required this.likes,
        required this.articleId,
        required this.datePublished,
        required this.postUrl,
        required this.profImage,
        required this.question,
        required this.possibleAnswers,
        this.correctAnswer,
        this.Title,
        this.Hint,
      });

  static Article fromSnap(DocumentSnapshot snap) {

    var snapshot = snap.data() as Map<String, dynamic>;

    return Article(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        articleId: snapshot["articleId"],
        datePublished: snapshot["datePublished"],
        pseudo: snapshot["pseudo"],
        Title: snapshot["Title"],
      Hint: snapshot["Hint"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
      question: snapshot["question"] as String? ?? "",
      possibleAnswers: (snapshot["possibleAnswers"] as List<String>?) ?? [],
      correctAnswer: snapshot["correctAnswer"] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "likes": likes,
    "pseudo": pseudo,
    "articleId": articleId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage,
    "question": question,
    "possibleAnswers": possibleAnswers,
    "correctAnswer": correctAnswer,
    "Title":Title,
    "Hint":Hint,

  };
}
