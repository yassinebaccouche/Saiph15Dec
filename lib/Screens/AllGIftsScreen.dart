import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysaiph/Models/Gift.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

// Define GiftManager outside the _AllGiftsScreenState class
class GiftManager {
  Future<List<GiftModel>> getAllGifts() {
    return FireStoreMethodes().getAllGifts();
  }

  Future<String> claimGift(String giftCard, String userFullScore, String userId) async {
    try {
      // Fetch gift by code
      DocumentSnapshot giftSnapshot = await FirebaseFirestore.instance
          .collection('gifts').doc(giftCard).get();

      // Check if the gift document exists
      if (!giftSnapshot.exists) {
        return 'Cadeau introuvable';
      }

      Map<String, dynamic> giftData = giftSnapshot.data() as Map<String, dynamic>;
      bool isUsed = giftData['isUsed'] ?? false;
      if (isUsed) {
        return 'Le cadeau est déjà utilisé';
      }

      int pointsRequired = int.parse(giftData['points'] ?? '0');
      int userScore = int.parse(userFullScore);

      // Check if the user has enough points to claim the gift
      if (userScore < pointsRequired) {
        return 'Points insuffisants pour réclamer le cadeau';
      }

      int newFullScore = userScore - pointsRequired;

      // Update user's full score
      await FirebaseFirestore.instance.collection('users')
          .doc(userId) // Use the actual user ID
          .update({'FullScore': newFullScore.toString()});

      // Mark gift as used
      await FirebaseFirestore.instance.collection('gifts').doc(giftCard).update(
          {'isUsed': true});

      return 'Cadeau réclamé avec succès';
    } catch (error) {
      // Log the error for debugging purposes
      print('Error claiming gift: $error');
      return 'Erreur lors de la réclamation du cadeau. Veuillez réessayer plus tard.';
    }
  }
}

class AllGiftsScreen extends StatefulWidget {
  const AllGiftsScreen({Key? key}) : super(key: key);

  @override
  _AllGiftsScreenState createState() => _AllGiftsScreenState();
}

class _AllGiftsScreenState extends State<AllGiftsScreen> {
  late int _userFullScore; // Variable to store user's full score

  @override
  void initState() {
    super.initState();
    // Load user's full score when the screen initializes
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _userFullScore = int.parse(userProvider.getUser.FullScore);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final GiftManager giftManager = GiftManager();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Points et Cadeaux',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xFF00B2FF),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF00B2FF),
            size: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 330,
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        'Vous avez: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.grey,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Text(
                      userProvider.getUser.FullScore,
                      // Display user's full score
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Color(0xFF273085),
                      ),
                    ),
                    Text(
                      ' Points',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Color(0xFF273085),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<GiftModel>>(
                future: giftManager.getAllGifts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red));
                  } else {
                    List<GiftModel>? giftList = snapshot.data;
                    if (giftList != null && giftList.isNotEmpty) {
                      return Column(
                        children: giftList
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          GiftModel gift = entry.value;
                          Color color = index.isEven ? Colors.orange : Colors
                              .blue; // Alternating colors

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showDialog(
                                      '${gift.code}', userProvider.getUser.uid, gift
                                  );

                                  },
                                child: Container(
                                  width: 307.17,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: color,
                                    // Use dynamically calculated color
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${gift.card}...${gift.points} Points',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Aucun cadeau disponible. 😔',
                          style: TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showDialog(String giftCode, String userId, GiftModel gift) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.getUser == null ||
        userProvider.getUser.FullScore == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("User data not available."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }

    int userFullScore = int.parse(userProvider.getUser.FullScore!);
    String claimResult = await GiftManager().claimGift(
        giftCode, userFullScore.toString(), userId);

    String message;
    if (claimResult.startsWith('Cadeau réclamé avec succès')) {
      // Update user's score in the provider
      int newScore = userFullScore - int.parse(gift.points);
      userProvider.updateUserFullScore(newScore.toString());

      // Refresh the screen after claiming the gift
      setState(() {});
      message = 'Cadeau réclamé avec succès. Code Cadeau: $giftCode. Veuillez COPIER LE CODE AVANT DE QUITTER !';
    } else {
      message = claimResult;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Claim Gift"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }



}