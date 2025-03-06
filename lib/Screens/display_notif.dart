import 'package:flutter/material.dart';
import 'package:mysaiph/Models/Notif.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:mysaiph/Models/user.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayNotificationPage extends StatefulWidget {
  final NotificationModel notification;

  const DisplayNotificationPage({Key? key, required this.notification}) : super(key: key);

  @override
  _DisplayNotificationPageState createState() => _DisplayNotificationPageState();
}

class _DisplayNotificationPageState extends State<DisplayNotificationPage> {
  late double screenWidth;
  late double fontSizeFactor;
  final double baseWidth = 380;
  int? selectedIndex;
  final TextEditingController selectedAnswerController = TextEditingController();
  final FireStoreMethodes _fireStoreMethodes = FireStoreMethodes();
  bool _isAnswerSubmitted = false;
  bool _isAnswerCorrect = false;

  Future<void> submitNotificationResponse(String uid) async {
    if (selectedAnswerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer')),
      );
      return;
    }

    try {
      // Check if the user has already responded to this notification
      var responses = await _fireStoreMethodes.getNotifResponsesByNotif(widget.notification.NotifId);

      bool hasResponded = responses.any((response) => response.uid == uid);

      if (hasResponded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have already responded to this notification!')),
        );
      } else {
        // Proceed with submitting the response
        setState(() {
          _isAnswerSubmitted = true;
          _isAnswerCorrect = (selectedAnswerController.text == widget.notification.correctAnswer);
        });

        // Create a response for this notification
        await _fireStoreMethodes.createNotifResponse(uid, widget.notification.NotifId);

        // If the answer is correct, update the user's score
        if (_isAnswerCorrect) {
          User user = Provider.of<UserProvider>(context, listen: false).getUser;
          int currentScore = int.parse(user.FullScore);
          int updatedScore = currentScore + widget.notification.points;

          // Update the score in Firestore
          FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'FullScore': updatedScore.toString(),
          }).then((_) {
            // Update the user locally after the successful Firestore update
            user.FullScore = updatedScore.toString();
            Provider.of<UserProvider>(context, listen: false).setUser(user);
          }).catchError((error) {
            print("Failed to update user's score: $error");
            // Handle error
          });
        }
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final double scalingFactor = MediaQuery.of(context).size.width / baseWidth;
    fontSizeFactor = scalingFactor * 0.97;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.notification.question ?? 'No question available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24 * fontSizeFactor,
                color: const Color(0xFF00B2FF),
              ),
            ),
            buildAnswerItems(),
            ElevatedButton(
              onPressed: () {
                if (user != null) {
                  submitNotificationResponse(user.uid);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not found')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50 * scalingFactor),
                ),
                backgroundColor: const Color(0xFF00B2FF),
                shadowColor: Colors.grey.withOpacity(0.5),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                width: screenWidth / 2,
                child: const Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            if (_isAnswerSubmitted)
              Text(
                _isAnswerCorrect ? 'Correct!' : 'Wrong answer!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _isAnswerCorrect ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAnswerItems() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: List.generate(
          widget.notification.possibleAnswers?.length ?? 0,
              (index) {
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  selectedAnswerController.text = widget.notification.possibleAnswers![index];
                });
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(3, 0, 3, 30),
                padding: const EdgeInsets.fromLTRB(25, 17, 25, 17),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF00B2FF) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xA9D5D5D5),
                    width: isSelected ? 0.0 : 2.0,
                  ),
                ),
                child: SizedBox(
                  width: screenWidth / 2,
                  child: Text(
                    widget.notification.possibleAnswers![index] ?? 'No answer available',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15 * fontSizeFactor,
                      color: isSelected ? Colors.white : const Color(0xFF00B2FF),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
