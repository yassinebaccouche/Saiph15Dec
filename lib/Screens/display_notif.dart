import 'package:flutter/material.dart';
import 'package:mysaiph/Models/Notif.dart';
import 'package:mysaiph/resources/firestore_methods.dart';
import 'package:mysaiph/Models/user.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DisplayNotificationPage extends StatefulWidget {
  final NotificationModel notification;

  DisplayNotificationPage({required this.notification});

  @override
  _DisplayNotificationPageState createState() =>
      _DisplayNotificationPageState();
}

class _DisplayNotificationPageState extends State<DisplayNotificationPage> {
  late double screenWidth;
  late double fontSizeFactor;
  double baseWidth = 380;
  int? selectedIndex;
  TextEditingController selectedAnswerController = TextEditingController();

  void NotifRESPONSE(String uid, String name, String profilePic) async {
    try {
      if (selectedAnswerController.text.isNotEmpty) {
        String res = await FireStoreMethodes().NotifReponse(
          widget.notification.NotifId,
          selectedAnswerController.text,
          uid,
          name,
          profilePic,
        );

        if (res == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Response submitted successfully')),
          );
          // Clear the selected answer text and reset the selected index
          selectedAnswerController.clear();
          setState(() {
            selectedIndex = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an answer')),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser; // Use nullable User

    final double scalingFactor =
        MediaQuery.of(context).size.width / baseWidth;
    fontSizeFactor = scalingFactor * 0.97;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
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
                  NotifRESPONSE(user.uid, user.pseudo, user.photoUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User not found')),
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
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                width: screenWidth / 2,
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16 * fontSizeFactor,
                      color: Colors.white,
                    ),
                  ),
                ),
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
          widget.notification.possibleAnswers?.length ?? 0, (index) {
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                // Set the selected answer to the correct answer
                selectedAnswerController.text =
                widget.notification.possibleAnswers![index];
              });
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(3, 0, 3, 30),
              padding: const EdgeInsets.fromLTRB(25, 17, 25, 17),
              decoration: BoxDecoration(
                color:
                isSelected ? const Color(0xFF00B2FF) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xA9D5D5D5),
                  width: isSelected ? 0.0 : 2.0,
                ),
              ),
              child: Container(
                width: screenWidth / 2,
                child: Text(
                  widget.notification.possibleAnswers![index] ??
                      'No answer available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 15 * fontSizeFactor,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF00B2FF),
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
