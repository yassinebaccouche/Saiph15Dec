import 'package:flutter/material.dart';
import 'package:mysaiph/Responsive/mobile_screen_layout.dart';
import 'package:mysaiph/Responsive/responsive_layout_screen.dart';
import 'package:mysaiph/responsive/web_screen_layout.dart';

class FirstNotifScreen extends StatefulWidget {
  const FirstNotifScreen({super.key});

  @override
  State<FirstNotifScreen> createState() => _FirstNotifScreenState();
}

class _FirstNotifScreenState extends State<FirstNotifScreen> {

  int selectedIndex = -1;
  List<String> answersList = ["Movies","Fitness","Yoga et méditation","Nourriture"];
  List<bool> selectedAnswers = List.generate(4, (index) => false);
  late double screenWidth;
  late double fontSizeFactor;
  double baseWidth = 380;
  @override
  Widget build(BuildContext context) {
    final double scalingFactor = MediaQuery.of(context).size.width / baseWidth;
    fontSizeFactor = scalingFactor * 0.97;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Quel est votre centre d'intérêt ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24*fontSizeFactor,
                    color: const Color(0xFF00B2FF),
                  ),
                ),
                buildAnswerItems(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ResponsiveLayout(
                          mobileScreenLayout: MobileScreenLayout(),
                          webScreenLayout: WebScreenLayout(),
                        ),
                      ),
                    );
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
                    width: screenWidth/2,
                    child: Center(
                      child: Text(
                        'Envoyer',
                        style: TextStyle(
                          fontSize: 16 * fontSizeFactor,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }

  Widget buildAnswerItems() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: List.generate(answersList.length, (index) {


          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAnswers[index] = !selectedAnswers[index];
              });
            },


            child: Container(
            margin: const EdgeInsets.fromLTRB(3, 0, 3, 30),
            padding: const EdgeInsets.fromLTRB(25, 17, 25, 17),
            decoration: BoxDecoration(
            color: selectedAnswers[index] ? const Color(0xff273085) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
            color: const Color(0xFF00B2FF),
            width: selectedAnswers[index] ? 0.0 : 2.0,
            ),
            ),
              child: Container(
                width: screenWidth/2,
                child: Text(
                  answersList[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 15*fontSizeFactor,
                    color: selectedAnswers[index] ? Colors.white : const Color(0xff273085),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
