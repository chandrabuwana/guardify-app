import 'package:flutter/material.dart';

// Red color scheme based on the design
const primaryColor = Color(0xFF8B0000); // Dark red as specified
const primaryDark = Color(0xFF5D0000);
const primaryAccent = Color(0xFFBB0000);

const Color primary10 = Color(0xFFFDEDEA);
const Color primary30 = Color(0xFFF1948A);
const Color primary50 = Color(0xFFE74C3C);
const Color primary70 = Color(0xFFC0392B);
const Color primary90 = Color(0xFF922B21);

const Color secondary90 = Color(0xFF922B21);
const Color secondary70 = Color(0xFFC0392B);
const Color secondary50 = Color(0xFFE74C3C);
const Color secondary30 = Color(0xFFF1948A);
const Color secondary10 = Color(0xFFFDEDEA);

const Color neutral90 = Color(0xFF101820);
const Color neutral70 = Color(0xFF333333);
const Color neutral50 = Color(0xFFBDBDBD);
const Color neutral30 = Color(0xFFDCDCDC);
const Color neutral20 = Color(0xFF808080);
const Color neutral10 = Color(0xFFF5F1F1);
const Color neutral5 = Color(0xFFFFFFFF);

const Color bgColor = Color(0xFFFFFFFF);
const Color bgColorDark = Color.fromARGB(255, 105, 105, 105);

const focusColor = Color(0xFFE74C3C);
const errorColor = Color(0xFFE74C3C);
const successColor = Color.fromARGB(255, 91, 212, 109);
const normalColor = Color.fromARGB(255, 177, 177, 177);
const disabledColor = Color.fromARGB(255, 149, 149, 149);

const appTextColor = Color.fromARGB(255, 27, 27, 27);
const appHintColor = Color(0xFFBDBDBD);
const inputColor = Color.fromARGB(186, 235, 238, 246);

const white = Colors.white;
const greySecond = Color.fromARGB(118, 231, 231, 231);
const grey = Color(0xFFBDBDBD);
const darkGrey = Color.fromARGB(255, 136, 136, 136);
const cardColor = Color.fromARGB(195, 247, 248, 255);
const favoriteColor = Color.fromARGB(255, 250, 200, 38);
const tabbarColor = Color(0xFFFAFAFA);
const babyBlueColor = Color(0xFFEEF2FF);


// Red theme material color map
const Map<int, Color> materialColor = {
  50: Color.fromRGBO(231, 76, 60, .1),
  100: Color.fromRGBO(231, 76, 60, .2),
  200: Color.fromRGBO(231, 76, 60, .3),
  300: Color.fromRGBO(231, 76, 60, .4),
  400: Color.fromRGBO(231, 76, 60, .5),
  500: Color.fromRGBO(231, 76, 60, .6),
  600: Color.fromRGBO(231, 76, 60, .7),
  700: Color.fromRGBO(231, 76, 60, .8),
  800: Color.fromRGBO(231, 76, 60, .9),
  900: Color.fromRGBO(231, 76, 60, 1),
};

class Gradients {
  static LinearGradient primary() {
    return const LinearGradient(
      colors: [
        Color(0xFFE74C3C),
        Color(0xFFC0392B),
      ],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    );
  }

  static LinearGradient primaryAccent() {
    return const LinearGradient(
      colors: [
        Color(0xFFE74C3C),
        Color(0xFFF1948A),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static LinearGradient neutral() {
    return const LinearGradient(
      colors: [
        Color(0xFFDCDCDC),
        Color(0xFFF5F1F1),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static LinearGradient cardGradient() {
    return const LinearGradient(
      colors: [
        Color(0xFFE74C3C),
        Color(0xFFC0392B),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
