import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mysaiph/Screens/ArticleScreen.dart';
import 'package:mysaiph/Screens/GiftScreen.dart';
import 'package:mysaiph/Screens/HomeScreen.dart';
import 'package:mysaiph/Screens/MiniApps/MiniAppsScreen.dart';
import 'package:mysaiph/Screens/SettingScreen.dart';
import 'package:mysaiph/providers/user_provider.dart';
import '../utils/custom_colors.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0; // Current page index
  late PageController pageController; // For managing page view navigation
  bool showNotification = false;

  // List of page widgets
  final List<Widget> homeScreenItems = [
    const ArticleScreen(),
    const HomePage(),
    const MiniAppsScreen(),
    const GiftScreen(),
 // Placeholder example
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final items = <Widget>[
      Icon(Icons.person, size: 30, color: Colors.white),
      Icon(Icons.videogame_asset, size: 30, color: Colors.white),
      Icon(Icons.self_improvement, size: 30, color: Colors.white),
      Icon(Icons.shopping_bag, size: 30, color: Colors.white),
    ];

    return Scaffold(
      // Universal AppBar
      appBar: AppBar(
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 45,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      userProvider.getUser.photoUrl, // User's profile picture
                    ),
                    radius: 20,
                  ),
                  if (showNotification) // Show notification indicator if needed
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '1', // Notification count
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),

      // PageView for body content
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),

      // Universal Bottom Navigation Bar
      bottomNavigationBar: CurvedNavigationBar(
        color: CustomColors.lightBlueButton,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        items: items,
        onTap: navigationTapped,
        index: _page,
      ),
    );
  }
}
