import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mysaiph/Screens/UpdateUserScreen.dart';
import 'package:mysaiph/Screens/test.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:mysaiph/utils/utils.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_container.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var Usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = Usersnap.data()!;
      followers = Usersnap.data()!['followers'].length;
      following = Usersnap.data()!['following'].length;
      isFollowing = Usersnap.data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return isLoading
        ? Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.white,
              actions: [
                PopupMenuButton<String>(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.info_outline),
                    ),
                  ),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: '1',
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            userData['email'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: '2',
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.local_pharmacy_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            userData['pharmacy'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: '3',
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_city_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            userData['ville'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
              backgroundColor: Color(0xff1331C4).withOpacity(0.5),
              title: Text(
                userData['pseudo'],
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: false,
            ),
            resizeToAvoidBottomInset: false,
            body: ListView(
              children: [
                ProfileContainer(
                  body: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(userData['photoUrl']),
                        radius: 80, // Adjust the radius to your desired size
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? CustomProfieButton(
                              Colors.orange,
                                  Colors.white,
                                  MediaQuery.of(context).size.width / 2,
                                  "Edit profile",
                                  SizedBox(),
                                  () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => UpdateEmailScreen(),
                                        ),
                                      ))
                              : isFollowing
                                  ? CustomProfieButton(
                                      Color(0xffa9b7ee),
                                      Color(0xff273085),
                                      MediaQuery.of(context).size.width / 2,
                                      "Ne plus suivre",
                                      SizedBox(), () async {
                                      await FireStoreMethodes().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid'],
                                      );
                                      setState(() {
                                        isFollowing = false;
                                        followers--;
                                      });
                                    })
                                  : CustomProfieButton(
                                      Color(0xff273085),
                                      Colors.white,
                                      MediaQuery.of(context).size.width / 2,
                                      "Suivre",
                                      SizedBox(), () async {
                                      await FireStoreMethodes().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid'],
                                      );
                                      setState(() {
                                        isFollowing = true;
                                        followers++;
                                      });
                                    }),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10)),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildStatColumn(postLen, "Posts"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            VerticalDivider(
                              indent: 5,
                              endIndent: 5,
                              thickness: 2,
                              color: Colors.black.withOpacity(0.2),
                            ),
                            buildStatColumn(followers, "Abonnés"),
                            VerticalDivider(
                              indent: 5,
                              endIndent: 5,
                              thickness: 2,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        buildStatColumn(following, "Suivant"),
                      ],
                    ),
                  ),
                ),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      // Handle error if there's an issue with the future.
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      // Data is available, so build the grid.
                      final documents = snapshot.data!
                          .docs; // Get the documents from the query result.

                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: documents.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            return Container(
                              child: Image(
                                image: NetworkImage(snap['postUrl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          );
  }

  Container buildStatColumn(int num, String label) {
    return Container(width: MediaQuery.of(context).size.width/4,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              num.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
    );

  }
}

Widget CustomProfieButton(Color bgColor, Color textColor, double width,
    String text, Widget ending, VoidCallback function) {
  return SizedBox(
    width: width,
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: textColor),
                ),
              ),
            ),
          ),
          ending
        ],
      ),
    ),
  );
}
