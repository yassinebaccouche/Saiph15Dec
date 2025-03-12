import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mysaiph/Models/Gift.dart';
import 'package:mysaiph/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:mysaiph/Models/post.dart';
import 'package:mysaiph/Models/Notif.dart';

import '../Models/ArticleReclamation.dart';
import '../Models/NotifReclamation.dart';

class FireStoreMethodes {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String> uploadPost(String description, Uint8List file, String uid,
      String pseudo, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        pseudo: pseudo,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  Future<String> createNotification(NotificationModel notification) async {
    String res = "Some error occurred";
    try {
      String notificationId = const Uuid().v1();
      Map<String, dynamic> notificationData = {
        'question': notification.question,
        'possibleAnswers': notification.possibleAnswers,
        'correctAnswer': notification.correctAnswer,
        'notificationId': notificationId,
        'dateCreated': DateTime.now(),
      };

      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .set(notificationData);
      res = 'success';
    } catch (err, stackTrace) {
      print('Error creating notification: $err');
      print(stackTrace);
      res = 'Error creating notification';
    }
    return res;
  }

  Future<List<NotificationModel>> fetchAllNotifications() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('notifications').get();

      List<NotificationModel> notifications = querySnapshot.docs
          .where((doc) => doc.data() != null)
          .map((doc) =>
          NotificationModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return notifications;
    } catch (err, stackTrace) {
      print('Error fetching notifications: $err');
      print(stackTrace);
      return [];
    }
  }

  Future<String> deleteNotification(String? question, String? correctAnswer) async {
    String res = "Some error occurred";
    try {
      // Check if both question and correctAnswer are not null
      if (question != null && correctAnswer != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('notifications')
            .where('question', isEqualTo: question)
            .where('correctAnswer', isEqualTo: correctAnswer)
            .get();

        // Check if there's at least one document that matches the query
        if (querySnapshot.docs.isNotEmpty) {
          // Delete the first document found
          await _firestore.collection('notifications').doc(querySnapshot.docs.first.id).delete();
          res = 'Success';
        } else {
          res = 'Notification not found';
        }
      } else {
        res = 'Invalid parameters: question or correctAnswer is null';
      }
    } catch (error) {
      res = 'Error: $error'; // Include the actual error message in the response
    }
    return res;
  }

  Future<String> createGift(GiftModel gift) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('gifts').doc(gift.code.toString()).set(gift.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteGift(String giftCode) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('gifts').doc(giftCode).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }



  Future<int> getNotificationCount() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('notifications').get();

      return querySnapshot.size;
    } catch (err, stackTrace) {
      print('Error fetching notification count: $err');
      print(stackTrace);
      return 0; // Return 0 in case of an error
    }
  }

  Future<List<NotificationModel>> getNotificationsByQuestion(String question) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('notifications')
          .where('question', isEqualTo: question)
          .get();

      List<NotificationModel> notifications = querySnapshot.docs
          .where((doc) => doc.data() != null)
          .map((doc) =>
          NotificationModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return notifications;
    } catch (err, stackTrace) {
      print('Error fetching notifications by question: $err');
      print(stackTrace);
      return [];
    }
  }

  Future<String> updateNotification(NotificationModel notification) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('notifications')
          .doc(notification.NotifId)
          .update(notification.toJson());
      res = 'Notification updated successfully';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<String> NotifReponse(String NotifId, String selectedAnswer, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (selectedAnswer.isNotEmpty) {
        String responseId = Uuid().v1(); // corrected variable name to responseId
        await _firestore
            .collection('Notification')
            .doc(NotifId)
            .collection('Reponse')
            .doc(responseId) // corrected variable name to responseId
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'selectedAnswer': selectedAnswer,
          'ReponseID': responseId, // corrected variable name to responseId
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<List<GiftModel>> getAllGifts() async {
    List<GiftModel> gifts = [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('gifts')
          .where('isUsed', isEqualTo: false)
          .get();

      print('Number of documents: ${querySnapshot.docs.length}');

      gifts = querySnapshot.docs.map((doc) => GiftModel.fromSnap(doc)).toList();
      print('Gifts: $gifts');
    } catch (err) {
      print("Error fetching gifts: $err");
      // You might want to handle errors here, such as logging or returning an empty list.
    }

    return gifts;
  }


  Future<String> markGiftAsUsed(String giftCard) async {
    try {
      await _firestore.collection('gifts').doc(giftCard).update({
        'isUsed': true,
      });
      return 'success';
    } catch (err) {
      return err.toString();
    }
  }
  // Create a new article response using uid, articleId and current response time.
  Future<String> createArticleResponse(String uid, String articleId) async {
    String res = "Some error occurred";
    try {
      String responseId = const Uuid().v1();
      ArticleReponse articleResponse = ArticleReponse(
        uid: uid,
        articleId: articleId,
        dateResponse: DateTime.now(),
      );
      await _firestore
          .collection('articleResponses')
          .doc(responseId)
          .set(articleResponse.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Retrieve all responses for a specific article.
  Future<List<ArticleReponse>> getArticleResponsesByArticle(String articleId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('articleResponses')
          .where('articleId', isEqualTo: articleId)
          .get();

      List<ArticleReponse> responses =
      querySnapshot.docs.map((doc) => ArticleReponse.fromSnap(doc)).toList();

      print("Nombre de réponses récupérées pour l'article $articleId : ${responses.length}");
      return responses;
    } catch (err) {
      if (kDebugMode) print("Erreur Firestore: $err");
      return [];
    }
  }

  /// Vérifier si un utilisateur a déjà répondu à un article
  Future<bool> hasUserResponded(String userId, String articleId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('articleResponses')
          .where('articleId', isEqualTo: articleId)
          .where('uid', isEqualTo: userId)
          .get();

      bool hasResponded = querySnapshot.docs.isNotEmpty;
      print("L'utilisateur $userId a-t-il déjà répondu à l'article $articleId ? $hasResponded");

      return hasResponded;
    } catch (err) {
      if (kDebugMode) print("Erreur Firestore: $err");
      return false;
    }
  }
  // Optionally, update an article response. (For example, if you later want to change the response time)
  Future<String> updateArticleResponse(String responseId, DateTime newDateResponse) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('articleResponses').doc(responseId).update({
        'dateResponse': newDateResponse,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete an article response by its document id.
  Future<String> deleteArticleResponse(String responseId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('articleResponses').doc(responseId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // Get all responses for a specific notification


  Future<List<NotificationReclamationModel>> getNotifResponsesByNotif(String NotifId) async {
    try {
      // Query the collection 'notifResponse' for documents where the 'notifId' matches
      QuerySnapshot querySnapshot = await _firestore
          .collection('notifResponse')
          .where('notifId', isEqualTo: NotifId)
          .get();

      // Map the fetched documents into NotificationReclamationModel instances
      List<NotificationReclamationModel> responses = querySnapshot.docs
          .map((doc) => NotificationReclamationModel.fromSnap(doc))
          .toList();

      // Print out the number of responses fetched for debugging
      if (kDebugMode) {
        print("Nombre de réponses récupérées pour la notification $NotifId : ${responses.length}");
      }

      return responses;
    } catch (err) {
      // Handle errors by printing and returning an empty list
      if (kDebugMode) {
        print("Erreur Firestore: $err");
      }
      return [];
    }
  }


  // Create a response for a notification
  Future<String> createNotifResponse(String uid, String notifId) async {
    String res = "Some error occurred";
    try {
      String responseId = const Uuid().v1(); // Generate a unique ID for the response
      NotificationReclamationModel notifResponse = NotificationReclamationModel(
        uid: uid,
        notifId: notifId,
        dateResponse: DateTime.now(),
      );

      // Create a new document in Firestore for the response
      await _firestore
          .collection('notifResponse')
          .doc(responseId)
          .set(notifResponse.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<List<NotificationModel>> fetchNotificationsWithoutUserResponse(String currentUserId) async {
    List<NotificationModel> notifications = [];

    try {
      // Step 1: Fetch all notifications from the 'notifications' collection.
      QuerySnapshot querySnapshot = await _firestore.collection('notifications').get();

      // Step 2: Loop through each notification and check if the current user has already responded.
      for (var doc in querySnapshot.docs) {
        NotificationModel notification = NotificationModel.fromJson(doc.data() as Map<String, dynamic>);

        // Step 3: Check if the current user has responded to this notification.
        bool hasResponded = await _firestore
            .collection('notifresponses') // Ensure you're using the correct collection name
            .where('notifId', isEqualTo: notification.NotifId)
            .where('userId', isEqualTo: currentUserId)
            .get()
            .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

        // Step 4: If the user has not responded, add this notification to the list.
        if (!hasResponded) {
          notifications.add(notification);
        }
      }

      return notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  // Check if a user has already responded to a specific notification
  Future<bool> hasUserRespondedNotif(String userId, String notifId) async {
    try {
      var response = await _firestore
          .collection('notifresponses')
          .where('userId', isEqualTo: userId)
          .where('notifId', isEqualTo: notifId)
          .get();

      return response.docs.isNotEmpty;  // If there's a matching response, return true
    } catch (e) {
      print('Error checking user response: $e');
      return false;
    }
  }

  // Optionally, update a notification response (e.g., change response time)
  Future<String> updateNotifResponse(String responseId, DateTime newDateResponse) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('notifResponse').doc(responseId).update({
        'dateResponse': newDateResponse,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}







