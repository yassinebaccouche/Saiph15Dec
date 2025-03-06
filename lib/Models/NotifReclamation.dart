import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NotificationReclamationModel {
  final String notifId;
  final String uid;
  final DateTime dateResponse;


  NotificationReclamationModel({
    String? notifId, // Rendre optionnel pour générer un ID si non fourni
    required this.uid,
    required this.dateResponse,
  }) : notifId = notifId ?? Uuid().v4(); // Générer un ID si non fourni

  // Convertir un document Firestore en NotificationModel
  factory NotificationReclamationModel.fromJson(Map<String, dynamic> data) {
    return NotificationReclamationModel(
      notifId: data['notifId'] ?? Uuid().v4(),
      uid: data['uid'] ?? "",
      dateResponse: (data['dateResponse'] as Timestamp)
          .toDate(), // Convertir Firestore Timestamp en DateTime
    );
  }

  // Convertir un document Firestore en NotificationModel depuis un snapshot
  factory NotificationReclamationModel.fromSnap(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;
    return NotificationReclamationModel.fromJson(data);
  }

  // Convertir l'objet en JSON pour Firestore
  Map<String, dynamic> toJson() {
    return {
      "notifId": notifId,
      "uid": uid,
      "dateResponse": Timestamp.fromDate(dateResponse),
      // Convertir DateTime en Firestore Timestamp
    };
  }
}
