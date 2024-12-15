import 'package:flutter/material.dart';

import '../../utils/custom_colors.dart';

class WoodenContainer extends StatelessWidget {
  final Widget child;
  final Color containerBackground;
  final double paddingV;

  const WoodenContainer({Key? key, required this.child, required this.containerBackground, required this.paddingV,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: paddingV),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: containerBackground,
      ),
      child: child,
    );
  }
}