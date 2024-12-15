import 'package:flutter/material.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/custom_colors.dart';

class UserHeader extends StatelessWidget {
  final String fullname;
  final int score;
  final String image;

  const UserHeader({Key? key, required this.fullname, required this.score, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(userProvider.getUser.photoUrl), // Add user's profile image here
          radius: 30,
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userProvider.getUser.pseudo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: CustomColors.darkBlue,
              ),
            ),
            Text(
              'Score: $score',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CustomColors.darkBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
