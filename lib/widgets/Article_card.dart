import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mysaiph/Screens/ArticleDeatilsScreen.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../widgets/like_animation.dart';
import '../models/user.dart';

class ArticleCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  const ArticleCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool isLikeAnimating = false;
  bool showContainer = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.snap['pseudo'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethodes().likePost(
                widget.snap['articleId'],
                userProvider.getUser.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.snap['postUrl'],
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Description Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined, // Agenda icon (Material Icon)
                      size: 16, // Adjust size to fit
                      color: Colors.blue, // Match the text color
                    ),
                    const SizedBox(width: 4), // Add spacing between icon and text
                    Text(
                      DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
             '${widget.snap['question']}?',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 2, // Restricts text to two lines
                  overflow: TextOverflow.ellipsis, // Adds "..." if text overflows
                ),

                const SizedBox(height: 8),
                 ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailsScreen(articleData: widget.snap),
                      ),
                    );


                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Change to your desired blue color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50 ),
                    ),
                    elevation: 2 ,
                  ),
                  child: Text(
                    'lire la suite',
                    style: TextStyle(
                      fontSize: 13 ,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),



        ],
      ),
    );
  }

  void _showCorrectAnswerDialog(BuildContext context, UserProvider userProvider) {
    // Code for dialog
  }

  void _showIncorrectAnswerDialog(BuildContext context) {
    // Code for dialog
  }
}
