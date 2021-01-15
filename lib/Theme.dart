import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Map<int, Color> themecolor =
{
  50:Color.fromRGBO(119, 23, 184, .1),
  100:Color.fromRGBO(119, 23, 184, .2),
  200:Color.fromRGBO(119, 23, 184, .3),
  300:Color.fromRGBO(119, 23, 184, .4),
  400:Color.fromRGBO(119, 23, 184, .5),
  500:Color.fromRGBO(119, 23, 184, .6),
  600:Color.fromRGBO(119, 23, 184, .7),
  700:Color.fromRGBO(119, 23, 184, .8),
  800:Color.fromRGBO(119, 23, 184, .9),
  900:Color.fromRGBO(119, 23, 184, 1),
};
MaterialColor mainColorTheme = MaterialColor(0xFF7717b8, themecolor);
class Colors {
  const Colors();
  static const Color appthemeColor = Color(0xFF7717b8);
  static const Color appthemeColor2 = Color(0xFFc898ea);
  static const Color appthemeColor3 = Color(0xFFc1666b);
  static const Color appthemeColor4 = Color(0xFF48a9a6);
  static const Color appthemeColor5 = Color(0xFFffffff);
  static const Color appthemeColor6 = Color(0xFFf8ca41);
  static const Color appthemeColor7 = Color(0xFF34d6ef);
  static const Color appthemeColor8 = Color(0xFF8e1b11);
  static const Color appthemeColor9 = Color(0xFF138e2e);



  static const Color primaryFontColor = Color(0xFFE8F1F2);

  static const List<Color> topGradients = [
    Color(0xFF13293D),
    Color(0xFF006494),
    Color(0xFF247BA0),
  ];

  static const List<Color> redGradient = [
    Color(0xFFd3574a),
    Color(0xFF9b433b),
    Color(0xFF7f3831),
  ];

  static const List<Color> aquaGradients = [
    Color(0xFF5AEAF1),
    Color(0xFF8EF7DA),
  ];


}

class Dimens {
  const Dimens();
  static const battleLogoWidth = 100.0;
  static const battleLogoHeight = 180.0;

}

class TextStyles {
  const TextStyles();
  static const TextStyle appBarTitle = const TextStyle(
      color: Colors.appthemeColor,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 36.0
  );

}


class AppTheme {

  static const TextStyle display1 = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.appthemeColor,
    fontSize: 38,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: 'WorkSans',
    color: Colors.appthemeColor,
    fontSize: 32,
    fontWeight: FontWeight.normal,
    letterSpacing: 1.1,
  );

  static final TextStyle heading = TextStyle(
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w900,
    fontSize: 34,
    color: Colors.appthemeColor.withOpacity(0.8),
    letterSpacing: 1.2,
  );

  static final TextStyle subHeading = TextStyle(
    inherit: true,
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: Colors.appthemeColor.withOpacity(0.8),
  );
}







