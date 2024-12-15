import 'package:cloud_firestore/cloud_firestore.dart';

class GiftModel {
  final int code;
  final String card;
  final bool isUsed;
  final String points;

  GiftModel({
    required this.code,
    required this.card,
    required this.points,
    required this.isUsed,
  });

  static GiftModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return GiftModel(
      code: snapshot["code"],
      card: snapshot["card"],
      points: snapshot["points"] ?? '0', // Handle null by providing a default value
      isUsed: snapshot["isUsed"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "card": card,
    "points":points,
    "isUsed": isUsed,
  };
}
