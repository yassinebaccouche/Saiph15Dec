import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:mysaiph/Models/user.dart' as CustomAppUser;
import 'package:cloud_firestore/cloud_firestore.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Enable Firebase App Check
  if (kIsWeb) {
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  }

  // Initialize Firebase Cloud Messaging (FCM)
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Subscribe to topic
  await messaging.subscribeToTopic("sample");

  // Retrieve FCM Token with error handling
  try {
    final String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      print('FCM Token: $fcmToken');
    } else {
      print('Failed to retrieve FCM Token');
    }
  } catch (e) {
    print('Error retrieving FCM Token: $e');
  }

  // Request notification permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print("User granted permissions: ${settings.authorizationStatus}");

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Local Notifications
  await LocalNotificationService().setup();

  // Request notification permissions using permission_handler
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Ensure dependencies are injected
  await injectDependencies();

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
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final data = snapshot.data!.data() as Map<String, dynamic>?;
                          if (data != null) {
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
