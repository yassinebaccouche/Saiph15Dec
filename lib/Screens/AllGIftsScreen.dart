import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysaiph/Models/Gift.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class GiftManager {
  Future<List<GiftModel>> getAllGifts() {
    return FireStoreMethodes().getAllGifts();
  }

  Future<String> claimGift(String giftCard, String userFullScore, String userId) async {
    try {
      DocumentSnapshot giftSnapshot = await FirebaseFirestore.instance
          .collection('gifts').doc(giftCard).get();

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

      if (userScore < pointsRequired) {
        return 'Points insuffisants pour réclamer le cadeau';
      }

      int newFullScore = userScore - pointsRequired;

      await FirebaseFirestore.instance.collection('users')
          .doc(userId)
          .update({'FullScore': newFullScore.toString()});

      await FirebaseFirestore.instance.collection('gifts').doc(giftCard).update(
          {'isUsed': true, 'uid': userId});

      return 'Cadeau réclamé avec succès';
    } catch (error) {
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
  late int _userFullScore;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _userFullScore = int.parse(userProvider.getUser.FullScore);
  }

  void _showDialog(String giftCode, GiftModel gift) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.getUser.uid; // Fetch user ID from the provider

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmer la réclamation"),
          content: Text("Voulez-vous réclamer ce cadeau : ${gift.card} pour ${gift.points} points ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                GiftManager giftManager = GiftManager();
                String result = await giftManager.claimGift(giftCode, _userFullScore.toString(), userId);

                // Show the result in a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

                // Close the first dialog
                Navigator.of(context).pop();

                // If the gift is successfully claimed, show the second dialog with the gift code
                if (result == 'Cadeau réclamé avec succès') {
                  // Show another dialog containing the gift code
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Cadeau réclamé avec succès"),
                        content: Text("Le code de votre cadeau réclamé est : $giftCode"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Fermer"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Confirmer"),
            ),
          ],
        );
      },
    );
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
                          Color color = index.isEven ? Colors.orange : Colors.blue;

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showDialog(
                                      '${gift.code}', gift
                                  );
                                },
                                child: Container(
                                  width: 307.17,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: color,
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
}
