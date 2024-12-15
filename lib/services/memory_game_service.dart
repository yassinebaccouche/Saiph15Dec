import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/memory_game.dart';
import '../Models/memory_game/enums/game_difficulty.dart';

class MemoryGameService {

  final CollectionReference _gamesCollection = FirebaseFirestore.instance.collection('memory_game');
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUserGame(String user) async {
    final newGameDoc = _gamesCollection.doc();
    final game = MemoryGame(id: newGameDoc.id, score: 0, level: 1, difficulty: GameDifficulty.FACILE.displayName, user: user, completed: false);
    await newGameDoc.set(game.toJson());
  }

  Stream<List<MemoryGame>> fetchGames(){
    return _gamesCollection.snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MemoryGame.fromJson(doc.data()! as Map<String, dynamic>))
        .toList());
  }



  Stream<MemoryGame?> fetchGameByUser(String user) {
    return _gamesCollection
        .where('user', isEqualTo: user)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return MemoryGame.fromJson(snapshot.docs.first.data()! as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }


  Future<void> updateGame(String userEmail, int score, int level, String difficulty) async {
    var querySnapshot = await _gamesCollection.where('user', isEqualTo: userEmail).get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        'score': score,
        'level': level,
        'difficulty': difficulty,
      });
    }
  }

  Future<void> setGameCompleted(String userEmail) async {
    var querySnapshot = await _gamesCollection.where('user', isEqualTo: userEmail).get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        'completed': true,
      });
    }
  }

  Future<void> resetGame(String id) async {
    await _gamesCollection.doc(id).update({
      'score': 0,
      'level': 1,
      'difficulty': GameDifficulty.FACILE.displayName,
      'completed': false,
    });
  }

  Future<void> updateTotalScore(String userEmail, int pointsToAdd) async {
    var querySnapshot = await _usersCollection.where('email', isEqualTo: userEmail).get();

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        var currentTotalScore = int.tryParse(data['FullScore'] ?? "0") ?? 0;
        var newTotalScore = currentTotalScore + pointsToAdd;

        // Convert the new total score back to a string
        await doc.reference.update({
          'FullScore': newTotalScore.toString(),
        });
      }
    }
  }




/*
  Future<List<MemoryGame>> fetchGames() async {
    var collectionSnapshot =
        await FirebaseFirestore.instance.collection('memory_game').get();

    return collectionSnapshot.docs.map((doc) => MemoryGame.fromJson(doc.data())).toList();
  }*/

}