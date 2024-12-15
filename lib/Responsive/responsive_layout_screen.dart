import 'package:flutter/material.dart';

import 'package:mysaiph/providers/user_provider.dart';

import 'package:provider/provider.dart';

import '../utils/global_variables.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  Future<void> addData() async {
    try {
      UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUserData(); // Corrected method name
    } catch (error) {
      // Handle any errors that might occur during data refresh
      print('Error adding data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        // 600 can be changed to 900 if you want to display tablet screen with mobile screen layout
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
