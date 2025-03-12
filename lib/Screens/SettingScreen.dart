import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysaiph/Screens/NotificationPage.dart';
import 'package:mysaiph/Screens/SignInScreen.dart';
import 'package:mysaiph/Screens/links_list_screen.dart';
import 'package:mysaiph/Screens/profile_screen.dart';
import 'package:mysaiph/Screens/search_screen.dart';
import 'package:mysaiph/Screens/test.dart';
import 'package:mysaiph/resources/auth-methode.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:mysaiph/widgets/profile_container.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileContainer(
                body: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
                      )),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userProvider.getUser.photoUrl),
                            radius: 80,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: Image.asset(
                              "assets/images/editpic.png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          userProvider.getUser.pseudo,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    ProfileButton(
                      screenWidth,
                      "Notifications",
                      Container(
                        width: 17,
                        height: 17,


                      ),
                          () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ));
                      },
                    ),
                    SizedBox(height: 10),
                    ProfileButton(
                      screenWidth,
                      "Update Email",
                      const SizedBox(),
                          () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UpdateEmailScreen(),
                        ));
                      },
                    ),
                    SizedBox(height: 10),
                    ProfileButton(
                      screenWidth,
                      "Amis",
                      const SizedBox(),
                          () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ));
                      },
                    ),
                    SizedBox(height: 10),
                    ProfileButton(
                      screenWidth,
                      "Liens",
                      const SizedBox(),
                          () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LinksListScreen(),
                        ));
                      },
                    ),

                    SizedBox(height: 10),
                    ProfileButton(
                      screenWidth,
                      "Desactivate account",
                      const SizedBox(),
                          () async {
                        await AuthMethodes().deactivateAccount();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                    ),

                    SizedBox(height: 10),
                    ProfileButton(
                      screenWidth,
                      "Déconnexion",
                      const SizedBox(),
                          () async {
                        await AuthMethodes().signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget ProfileButton(
    double width,
    String text,
    Widget ending,
    VoidCallback function,
    ) {
  return SizedBox(
    width: width,
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00B2FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ending,
        ],
      ),
    ),
  );
}
