import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color txtColor;
  final IconData? icon;

  const RoundedContainer({Key? key, required this.text, required this.backgroundColor, required this.txtColor, this.icon,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: txtColor,
              size: screenWidth*0.06,
            ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: txtColor
            ),
          ),
        ],
      ),
    );
  }
}
