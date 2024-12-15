import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NotificationModel {
  final String NotifId; // Add an ID field
  final String question;
  final List<String> possibleAnswers;
  final String? correctAnswer;
  String? selectedAnswer; // New field to store the user's selected answer

  NotificationModel({
    required this.NotifId, // Include id in the constructor
    required this.question,
    required this.possibleAnswers,
    this.correctAnswer,
    this.selectedAnswer,
  });

  NotificationModel.fromJson(Map<String, dynamic> data)
      : NotifId = data['NotifId'] ?? Uuid().v4(), // Generate an ID if not provided
        question = data['question'] ?? "",
        possibleAnswers = List<String>.from(data['possibleAnswers'] ?? []),
        correctAnswer = data['correctAnswer'] ?? "",
        selectedAnswer = data['selectedAnswer'] ?? null;

  Map<String, dynamic> toJson() => {
    "NotifId": NotifId, // Include id when serializing to JSON
    "question": question,
    "possibleAnswers": possibleAnswers,
    "correctAnswer": correctAnswer,
    "selectedAnswer": selectedAnswer,
  };
}
