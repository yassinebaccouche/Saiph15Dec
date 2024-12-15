import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width = 140,
    this.color = Colors.white, // Default color is white
  }) : super(key: key);

  final Function() onPressed;
  final String text;
  final double width;
  final Color color; // Color property for the button

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        // Set the button color
      ),
      child: FloatingActionButton.extended(
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: onPressed,
        label: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white), // Set text color to black
        ),
      ),
    );
  }
}
