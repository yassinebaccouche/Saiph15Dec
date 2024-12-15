import 'package:mysaiph/Models/user.dart' as model;
import 'package:mysaiph/Screens/comments_screen.dart';
import 'package:mysaiph/widgets/like_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../resources/firestore_methods.dart';
import '../utils/utils.dart';
class PostCard extends StatefulWidget {

  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);


  @override
  State<PostCard> createState() => _PostCardState();
}


class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }
  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }
  deletePost(String postId) async {
    try {
      await FireStoreMethodes().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),

                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['pseudo'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
            // IMAGE SECTION OF THE POST

          ),

          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethodes().likePost(
                widget.snap['postId'].toString(),
                user.uid,

                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height*0.35,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), // Adjust the radius value as needed
                      child: Image.network(
                        widget.snap['postUrl'].toString(),
                        fit: BoxFit.cover,
                      ),
                    )

                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(child: const Icon(Icons.favorite,color: Colors.white,size: 120,),
                    isAnimating:  isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                      : const Icon(
                    Icons.favorite_border,
                  ),
                  onPressed: () => FireStoreMethodes().likePost(
                    widget.snap['postId'].toString(),
                    user.uid,
                    widget.snap['likes'],
                  ),
                ),
              ),
              IconButton(

                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.grey,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      postId: widget.snap['postId'].toString(),
                    ),
                  ),
                ),
              ),


            ],
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child:
                  Text('${widget.snap['likes'].length} likes',  style: Theme.of(context).textTheme.bodyMedium,),

                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: widget.snap['pseudo'].toString(),
                          style:  const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                          ),


                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color:Colors.grey,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'Inter',


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
}
