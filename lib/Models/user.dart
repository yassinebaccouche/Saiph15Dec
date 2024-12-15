import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
class User {

  final String email;
  final String uid;
  final String photoUrl;
  final String pseudo;
  final String Datedenaissance;
  final String phoneNumber;
  final String pharmacy;
  final String Profession;
  final List followers;
  final int? lastLogin;
  final List following;
  final String Verified;
  String FullScore; // Change from final to regular instance variable
  final String PuzzleScore;
  final String CodeClient;

  User({
    required this.pseudo,
    required this.lastLogin,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.Profession,
    required this.phoneNumber,
    required this.pharmacy,
    required this.Datedenaissance,
    required this.followers,
    required this.following,
    required this.Verified,
    required this.FullScore,
    required this.PuzzleScore,
    required this.CodeClient,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      pseudo: snapshot["pseudo"],
      lastLogin: snapshot["lastLogin"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      Datedenaissance: snapshot["Datedenaissance"],
      pharmacy: snapshot["pharmacy"],
      phoneNumber: snapshot["phoneNumber"],
      Profession: snapshot["Profession"],
      photoUrl: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      Verified: snapshot["Verified"],
      FullScore: snapshot["FullScore"],
      PuzzleScore: snapshot["PuzzleScore"],
      CodeClient: snapshot["CodeClient"],
    );
  }

  Map<String, dynamic> toJson() => {
    "pseudo": pseudo,
    "uid": uid,
    "email": email,
    "photoUrl": photoUrl,
    "Datedenaissance": Datedenaissance,
    "Profession": Profession,
    "pharmacy": pharmacy,
    "phoneNumber": phoneNumber,
    "followers": followers,
    "following": following,
    "Verified": Verified,
    "FullScore": FullScore,
    "PuzzleScore": PuzzleScore,
    "CodeClient": CodeClient,
  };
}