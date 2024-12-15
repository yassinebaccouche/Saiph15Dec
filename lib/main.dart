import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:mysaiph/Screens/SignInScreen.dart';

import 'package:mysaiph/providers/user_provider.dart';
import 'package:mysaiph/services/notifservice.dart';
import 'package:mysaiph/utils/games_utils/inject_dependencies.dart';
import 'package:mysaiph/Screens/Splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mysaiph/Responsive/mobile_screen_layout.dart';
import 'package:mysaiph/Responsive/responsive_layout_screen.dart';
import 'package:mysaiph/Responsive/web_screen_layout.dart';
import 'package:mysaiph/Models/user.dart' as CustomAppUser; // Renamed import
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();
  await LocalNotificationService().setup();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDd73LUWiKhfIm9hoS7OtqqfrsIdpGf3-I",
          authDomain: "mysaiph-26b1c.firebaseapp.com",
          projectId: "mysaiph-26b1c",
          storageBucket: "mysaiph-26b1c.appspot.com",
          messagingSenderId: "154959907692",
          appId: "1:154959907692:web:519c2023e47834f7518149",
          measurementId: "G-1Z9EGRPDCD"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await FirebaseAuth.instance.currentUser;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: false),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  // Retrieve user data from Firestore based on user's UID
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final data = snapshot.data!.data() as Map<String, dynamic>?;
                          if (data != null) {
                            // Create a CustomAppUser.User object from Firestore data
                            CustomAppUser.User? userData = CustomAppUser.User.fromSnap(snapshot.data!);
                            if (userData != null && userData.Verified == '1') {
                              return ResponsiveLayout(
                                mobileScreenLayout: MobileScreenLayout(),
                                webScreenLayout: WebScreenLayout(),
                              );
                            }
                          }
                        }
                        return SignInScreen();
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                }
              }
            }
            return SplashScreen();
          },
        ),
      ),
    );
  }
}
