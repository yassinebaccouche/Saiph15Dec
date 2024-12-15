import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_colors.dart';

class ThemeController extends ChangeNotifier {



  ThemeMode get themeMode =>  ThemeMode.light;



  TextTheme get _textTheme {
    return GoogleFonts.latoTextTheme();
  }

  ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: CustomColors.lightGray,
        ),
      ),
      textTheme: _textTheme,
      primaryColorLight: CustomColors.lightGray,

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: CustomColors.darkBlue,
        ),
      ),
    );
  }


}
