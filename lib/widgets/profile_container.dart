
import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
  final Widget body;
  const ProfileContainer({super.key, required this.body});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width, // Adjust the width as needed
      height: MediaQuery.of(context).size.height/2.7, // Adjust the height as needed
      decoration: BoxDecoration(
        color: const Color(0xFF00B2FF),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
      child: body,
    );
  }}
