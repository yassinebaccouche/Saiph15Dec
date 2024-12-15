import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mysaiph/Screens/Games/Tala3ni/tala3ni_main_menu.dart';
import 'package:mysaiph/Screens/Quiz/Quiz_screen.dart';
import 'package:mysaiph/providers/user_provider.dart';

import 'package:mysaiph/utils/custom_colors.dart';
import 'package:mysaiph/widgets/game_widgets/container_wooden.dart';

import 'Games/game_main_menu.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _refreshUser();
  }
  void _refreshUser() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'JEUX',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: CustomColors.lightBlueButton),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: const Color(0xffEDEDED),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 170.0,
                  viewportFraction: 0.6,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,


                ),

                items: [

                  cardItem(CustomColors.lightBlue3, 'assets/images/talaani_no_bg.png',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) =>
                                Tala3niMainMenu(
                                  backgroundGradient: const RadialGradient(radius: 2,center: Alignment.center,
                                    colors: [

                                      Colors.white,
                                      CustomColors.lightBlue3,
                                      CustomColors.lightBlue3,
                                    ],
                                  ),
                                  backgroundImage: WoodenContainer(
                                    paddingV: 70,
                                    containerBackground: CustomColors.lightBlue2.withOpacity(0.5),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: IntrinsicWidth(
                                        child: Image.asset('assets/images/talaani_no_bg.png',),
                                      ),
                                    ),
                                  ),
                                  buttonPlayColor: CustomColors.radiGreen,
                                  buttonInstructColor: CustomColors.radiBlue,
                                  buttonOptionsColor: CustomColors.radBlue,
                                  buttonsContainerColor: CustomColors.lightBlue2.withOpacity(0.8),
                                )
                        ),
                      );
                    },
                    250,
                    30,
                    50,
                  ),
                  cardItem(CustomColors.radialBlue, 'assets/images/rakabni.png',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) =>
                                GameMainMenu(
                                  title: 'PUZZLE',
                                  backgroundGradient: const RadialGradient(radius: 2,center: Alignment.center,
                                    colors: [

                                      CustomColors.radialGreen,
                                      CustomColors.radialBlue,
                                      CustomColors.radialBlue,

                                    ],
                                  ),
                                  backgroundImage: WoodenContainer(
                                    paddingV: 70,
                                    containerBackground: CustomColors.lightBlue2.withOpacity(0.8),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: IntrinsicWidth(
                                        child: Image.asset('assets/images/rakabni.png',),
                                      ),
                                    ),
                                  ),
                                  buttonPlayColor: CustomColors.radiGreen,
                                  buttonInstructColor: CustomColors.radiBlue,
                                  buttonOptionsColor: CustomColors.radBlue,
                                  buttonsContainerColor: CustomColors.lightBlue2.withOpacity(0.8),
                                  dialogBg: CustomColors.lightBlue2,
                                )
                        ),
                      );
                    },
                    250,
                    30,
                    50,
                  ),
                  cardItem(const Color(0xff1331C4), 'assets/images/dawini.png',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) =>
                                GameMainMenu(
                                  title: 'JEU DE MÉMOIRE',
                                  backgroundGradient: const LinearGradient(
                                    colors: [
                                      Color(0xff1A81FF),
                                      Color(0xff8eb3e3),
                                      Color(0xff1A81FF)],
                                    stops: [0.25, 0.75, 0.87],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  backgroundImage:
                                  WoodenContainer(
                                    paddingV: 70,
                                    containerBackground: CustomColors.blueButton.withOpacity(0.8),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: IntrinsicWidth(
                                        child: Image.asset('assets/images/dawini.png',),
                                      ),
                                    ),
                                  ),
                                  buttonPlayColor: CustomColors.radiGreen,
                                  buttonInstructColor: CustomColors.radiBlue,
                                  buttonOptionsColor: CustomColors.radBlue,
                                  buttonsContainerColor: CustomColors.blueButton.withOpacity(0.7),
                                  dialogBg: CustomColors.blueButton,
                                )
                        ),
                      );
                    },
                    250,
                    30,
                    50,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset('assets/images/ramadan_kareem.png',fit: BoxFit.cover),
            ),
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'QUIZ',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color:  CustomColors.lightBlueButton),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffEDEDED),
                child: cardItem(Colors.transparent, 'assets/images/taarafchi.png', () {                Navigator.push(context, MaterialPageRoute(builder: (context) => QuizgameScreen()));
                },  MediaQuery.of(context).size.width, 30, 20)
            ),
            const SizedBox(height: 20,),

            /*SizedBox(
            height: 250,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                viewportFraction: 0.75,
                aspectRatio: 16 / 9,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
              ),
              items: [

                buildCarouselItem(
                    'assets/quiz.png',
                    'Quiz 1',
                    () { Navigator.push(context, MaterialPageRoute(builder: (context) => QuizgameScreen()),);},
                    0.3
                ),
                buildCarouselItem(
                    'assets/quiz1.png',
                    'Quiz 2',
                    () { Navigator.push(context, MaterialPageRoute(builder: (context) => QuizClutureGenerale()),);},
                    0.3
                ),
              ],
            ),
          ),*/
          ],
        ),
      ),
    );
  }

  Widget cardItem(Color color, String image, VoidCallback onPressed, double width, double paddingV, double paddingH){
    return InkWell(
      onTap: onPressed,
      child: Padding( // Add Padding widget here
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust horizontal padding as needed
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: paddingV,horizontal: paddingH),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color
          ),
          child: Image.asset(image,fit: BoxFit.contain),
        ),
      ),
    );
  }


  Widget buildCarouselItem(String imagePath, String title,VoidCallback onPressed, double overlayOpacity) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(overlayOpacity),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }

}
