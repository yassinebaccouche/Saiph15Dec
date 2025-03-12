import 'package:cloud_firestore/cloud_firestore.dart';

class GiftModel {
  final int code;
  final String card;
  final bool isUsed;
  final String points;
  final String uid; // Ajout de uid

  GiftModel({
    required this.code,
    required this.card,
    required this.points,
    required this.isUsed,
    required this.uid, // Correction ici
  });

  static GiftModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return GiftModel(
      code: snapshot["code"] ?? 0, // Gérer null avec une valeur par défaut
      card: snapshot["card"] ?? '', // Gérer null avec une valeur par défaut
      points: snapshot["points"] ?? '0', // Gérer null avec une valeur par défaut
      isUsed: snapshot["isUsed"] ?? false, // Gérer null avec une valeur par défaut
      uid: snapshot["uid"] ?? '', // Gérer null avec une valeur par défaut
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "card": card,
    "points": points,
    "isUsed": isUsed,
    "uid": uid,
  };
}
