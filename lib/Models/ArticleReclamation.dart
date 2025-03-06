import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleReponse {

  final String uid;

  final String articleId;
  final DateTime dateResponse;



  const ArticleReponse(
      {
        required this.uid,
        required this.articleId,
        required this.dateResponse,

      });

  static ArticleReponse fromSnap(DocumentSnapshot snap) {

    var snapshot = snap.data() as Map<String, dynamic>;

    return ArticleReponse(

      uid: snapshot["uid"],

      articleId: snapshot["articleId"],
      dateResponse: snapshot["dateResponse"],

    );
  }

  Map<String, dynamic> toJson() => {

    "uid": uid,
    "articleId": articleId,
    "dateResponse": dateResponse,



  };
}
