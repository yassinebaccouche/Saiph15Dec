import 'package:cloud_firestore/cloud_firestore.dart';

class PuzzleGameService {

  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection('users');


  Future<String> getPuzzleScore(String userId) async {
    var snapshot = await _usersCollection.doc(userId).get();
    final userData = snapshot.data() as Map<String, dynamic>;
    return  userData['PuzzleScore'] ?? "0";

  }

  /*Stream<String> getPuzzleScore(String userId){
    return _usersCollection.doc(userId).snapshots().map((snapshot)  {
      final userData = snapshot.data() as Map<String, dynamic>;
      return  userData['PuzzleScore'] ?? "0";
    });
  }*/

  Future<void> setNewScore(int newScore,String userId) async {
     await _usersCollection.doc(userId).update({
      'PuzzleScore':newScore.toString(),

    });
  }



}


