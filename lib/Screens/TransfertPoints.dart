import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysaiph/Screens/profile_screen.dart';
import 'package:mysaiph/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransfertPointScreen extends StatefulWidget {
  const TransfertPointScreen({Key? key}) : super(key: key);

  @override
  State<TransfertPointScreen> createState() => _TransfertPointScreenState();
}

class _TransfertPointScreenState extends State<TransfertPointScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  bool isTransferEnabled = true;

  @override
  void initState() {
    super.initState();
    // Retrieve the last donation timestamp when the widget is initialized
    getLastDonationTimestamp().then((lastTimestamp) {
      setState(() {
        lastDonationTimestamp = lastTimestamp;
        if (lastDonationTimestamp != null &&
            DateTime.now().difference(lastDonationTimestamp!) <
                Duration(minutes: 1)) {
          isTransferEnabled = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  onChanged(String _) {
    setState(() {
      isShowUsers = true;
    });
    print(searchController.text);
  }

  // Define last donation timestamp
  DateTime? lastDonationTimestamp;

  // Retrieve the last donation timestamp from SharedPreferences
  Future<DateTime?> getLastDonationTimestamp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('lastDonationTimestamp');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // Save the last donation timestamp to SharedPreferences
  Future<void> saveLastDonationTimestamp(DateTime timestamp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastDonationTimestamp', timestamp.millisecondsSinceEpoch);
  }

  // Update the transferPoints function to use SharedPreferences
  void transferPoints(User recipient) async {
    // Check if last donation timestamp exists and if it's within the last 24 hours
    if (lastDonationTimestamp != null &&
        DateTime.now().difference(lastDonationTimestamp!) <
            Duration(minutes: 1)) {
      // Don't allow donation if within 24 hours
      print('Vous ne pouvez faire un don qu’une fois toutes les 24 heures.');
      // Optionally, you can show a message to the user indicating the restriction
      return;
    }

    // Assuming each user has a FullScore field which represents their total points
    // Update the recipient's FullScore by adding 50 points
    int newScore = int.parse(recipient.FullScore) + 50;

    // Update the recipient's FullScore in Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(recipient.uid)
        .update({'FullScore': newScore.toString()})
        .then((value) async {
      // Transfer successful
      print('Points transférés avec succès');
      // Update the last donation timestamp
      await saveLastDonationTimestamp(DateTime.now());
      setState(() {
        lastDonationTimestamp = DateTime.now();
        isTransferEnabled = false;
      });
      // Optionally, you can show a message to the user indicating successful transfer
    }).catchError((error) {
      // Handle any errors that occur during the transfer process
      print('Échec du transfert des points: $error');
      // Optionally, you can show a message to the user indicating failure
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xFF00B2FF),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          width: double.infinity,
          child: Center(
            child: TextFormField(
              onChanged: onChanged,
              controller: searchController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                hintText: 'Rechercher un utilisateur...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: GestureDetector(
                  onTap: () {
                    searchController.clear();
                    onChanged("");
                  },
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: searchController.text == ""
            ? FirebaseFirestore.instance.collection('users').get()
            : FirebaseFirestore.instance
            .collection('users')
            .where('pseudo', isEqualTo: searchController.text)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Aucun utilisateur trouvé.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data();

                final pseudo = data['pseudo'] ?? 'N/A';
                final photoUrl = data['photoUrl'] ?? '';

                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: (snapshot.data! as dynamic).docs[index]
                        ['uid'],
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFF00B2FF).withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                            SizedBox(width: 10),
                            Text(
                              pseudo,
                              style: TextStyle(
                                color: Color(0xFF00B2FF),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: isTransferEnabled
                              ? () {
                            // Handle the transfer action here
                            // Pass the recipient user object to the transferPoints function
                            transferPoints(User.fromSnap(
                                snapshot.data!.docs[index]));
                          }
                              : null,
                          child: Text('Transfer 50 points'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      )
          : FutureBuilder(
        future: isShowUsers
            ? FirebaseFirestore.instance
            .collection('users')
            .where('pseudo', isEqualTo: searchController.text)
            .get()
            : FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No users found.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data();

                final pseudo = data['pseudo'] ?? 'N/A';
                final photoUrl = data['photoUrl'] ?? '';

                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: (snapshot.data! as dynamic).docs[index]
                        ['uid'],
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 8),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFF00B2FF).withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                            SizedBox(width: 10),
                            Text(
                              pseudo,
                              style: TextStyle(
                                color: Color(0xFF00B2FF),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: isTransferEnabled
                              ? () {
                            // Handle the transfer action here
                            // Pass the recipient user object to the transferPoints function
                            transferPoints(User.fromSnap(
                                snapshot.data!.docs[index]));
                          }
                              : null,
                          child: Text('Transfer 50 points'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomSheet: lastDonationTimestamp != null &&
          DateTime.now().difference(lastDonationTimestamp!) <
              Duration(minutes:1 )
          ? Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Vous ne pouvez transférer des points qu à un seul utilisateur toutes les 24 heures.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      )
          : null,
    );
  }
}
