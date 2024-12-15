import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mysaiph/Screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

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
                    borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  hintText: 'Rechercher un utilisateur...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        searchController.clear();
                        onChanged("");
                      },
                      child: Icon(Icons.close))),
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
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No users found.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data();

                      // Check if 'pseudo' and 'photoUrl' fields exist in the document
                      final pseudo = data['pseudo'] ?? 'N/A';
                      final photoUrl = data['photoUrl'] ??
                          ''; // Provide a default value or handle the absence

                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid'],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(photoUrl),
                          ),
                          title: Text(pseudo),
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
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                              color: Color(0xFF00B2FF).withOpacity(0.2)
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(photoUrl),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  pseudo,
                                  style: TextStyle(
                                      color: Color(0xFF00B2FF),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                }
              },
            ),
    );
  }
}
