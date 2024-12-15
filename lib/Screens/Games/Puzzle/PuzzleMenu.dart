import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mysaiph/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PuzzleMenu extends StatelessWidget {
  const PuzzleMenu({Key? key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    double width = MediaQuery.of(context).size.width -80;
    return Container(
      width: double.infinity,
      height: 1050,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/backgroundSignin.png'),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,40,0,20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'ADOLY',
                    style: TextStyle(
                      fontFamily: 'Marope',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 60,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.7
                        ..color = Colors.white,
                    ),
                  ),
                  Text(
                    'Puzzle',
                    style: TextStyle(
                      fontFamily: 'Marope',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  circButton(FontAwesomeIcons.info),
                  circButton(FontAwesomeIcons.medal),
                  circButton(FontAwesomeIcons.lightbulb),
                  circButton(FontAwesomeIcons.cog),
                ],
              ),
              Wrap(
                runSpacing: 16,
                children: [
                  modelButton('Ranked Mode','Elevate your level',
                  FontAwesomeIcons.trophy,Colors.blue,width),
                  modelButton('Time Trial','Race Aginst the Clock',
                      FontAwesomeIcons.userClock,Color(0xFFDF1D5A),width),
                  modelButton('Free Play','Elevate your level',
                      FontAwesomeIcons.couch,Color(0xFF45D280),width),
                  modelButton('Pass & Paly','Challenge your Friends ',
                      FontAwesomeIcons.userFriends,Color(0xFFFF8306),width),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding circButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RawMaterialButton(
        onPressed: () {},
        fillColor: Colors.white,
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 35, minWidth: 35),
        child: FaIcon(icon, size: 22, color: Colors.blue),
      ),
    );
  }
  GestureDetector modelButton(
      String title,
      String subtitle,
      IconData icon ,
      Color color,
      double width
      ){
    return GestureDetector(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'Marope',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      subtitle,
                      style:TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'Marope',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              child: FaIcon(icon, size: 35, color: Colors.white),
            ),

          ],
        ),
      ),

    );
  }
}
