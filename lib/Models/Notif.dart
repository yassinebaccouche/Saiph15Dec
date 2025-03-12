import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NotificationModel {
  final String NotifId; // ID field
  final String question;
  final List<String> possibleAnswers;
  final String? correctAnswer;
  String? selectedAnswer; // User's selected answer
  final int points; // Points field

  NotificationModel({
    String? NotifId, // Optional so it can be generated if missing
    required this.question,
    required this.possibleAnswers,
    this.correctAnswer,
    this.selectedAnswer,
    required this.points, // Required in constructor
  }) : NotifId = NotifId ?? Uuid().v4(); // Generate an ID if not provided

  // Convert Firestore document into a NotificationModel instance
  factory NotificationModel.fromJson(Map<String, dynamic> data) {
    return NotificationModel(
      NotifId: data['notificationId'] ?? Uuid().v4(),
      question: data['question'] ?? "",
      possibleAnswers: List<String>.from(data['possibleAnswers'] ?? []),
      correctAnswer: data['correctAnswer'],
      selectedAnswer: data['selectedAnswer'],
      points: data["points"] ?? 0,
    );
  }

  // Convert Firestore document snapshot into a NotificationModel instance
  factory NotificationModel.fromSnap(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return NotificationModel.fromJson(data);
  }

  // Convert the model to a JSON object for Firestore
  Map<String, dynamic> toJson() {
    return {
      "notificationId": NotifId,
      "question": question,
      "possibleAnswers": possibleAnswers,
      "correctAnswer": correctAnswer,
      "selectedAnswer": selectedAnswer,
      "points": points,
    };
  }
}
