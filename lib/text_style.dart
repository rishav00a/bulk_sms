import 'package:flutter/material.dart';
import 'Theme.dart' as CustomTheme;

class CustomStyle {
  static final baseTextStyle = const TextStyle(
      fontFamily: 'Poppins'
  );
  static final smallTextStyle = commonTextStyle.copyWith(
    fontSize: 9.0,
  );
  static final commonTextStyle = baseTextStyle.copyWith(
      color: CustomTheme.Colors.appthemeColor4,
      fontSize: 14.0,
      fontWeight: FontWeight.w400
  );
  static final titleTextStyle = baseTextStyle.copyWith(
      color: CustomTheme.Colors.appthemeColor,
      fontSize: 18.0,
      fontWeight: FontWeight.w600
  );

  static final whiteTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 15,
  );

  static final themeTextStyle = baseTextStyle.copyWith(
    color: CustomTheme.Colors.appthemeColor,
    fontSize: 15,
  );
  static final pricingStyle = baseTextStyle.copyWith(
      color: Colors.greenAccent,
      fontSize: 18.0,
      fontWeight: FontWeight.w600
  );
  static final headerTextStyle = baseTextStyle.copyWith(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w600
  );

  static final headerTextStyleDark = baseTextStyle.copyWith(
      color: CustomTheme.Colors.appthemeColor,
      fontSize: 20.0,
      fontWeight: FontWeight.w600
  );

  static final dbHeader= baseTextStyle.copyWith(
      color: CustomTheme.Colors.appthemeColor,
      fontSize: 25.0,
      fontWeight: FontWeight.w600
  );
  static final nothingThereText = baseTextStyle.copyWith(
      color: CustomTheme.Colors.appthemeColor,
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins'
  );
  static final rewardStyle = baseTextStyle.copyWith(
      color: Color(0xFFf7c604),
      fontSize: 18.0,
      fontWeight: FontWeight.w600
  );
  static final othPrizesStyle = baseTextStyle.copyWith(
      color: Colors.blueGrey,
      fontSize: 14.0,
      fontWeight: FontWeight.w600
  );

  static const TextStyle planetLocation = const TextStyle(
      color: CustomTheme.Colors.appthemeColor3,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w300,
      fontSize: 14.0
  );

  static const TextStyle smallHeader = const TextStyle(
      color: CustomTheme.Colors.appthemeColor3,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 14.0
  );

  static const TextStyle subTitle = const  TextStyle(
      color: CustomTheme.Colors.appthemeColor4,
      fontSize: 15,
      fontWeight: FontWeight.w800

  );
  static const TextStyle subTitleDark = const  TextStyle(
      color: CustomTheme.Colors.appthemeColor,
      fontSize: 15,
      fontWeight: FontWeight.w800

  );

  static const TextStyle bigsubTitle = const  TextStyle(
      color: CustomTheme.Colors.appthemeColor4,
      fontSize: 20,
      fontWeight: FontWeight.w800

  );

  static const TextStyle subTitledanger = const  TextStyle(
      color: CustomTheme.Colors.appthemeColor8,
      fontSize: 15,
      fontWeight: FontWeight.w800

  );


  static const TextStyle customTextStyleBlue = TextStyle(
      fontFamily: "Gotik",
      color: CustomTheme.Colors.appthemeColor2,
      fontWeight: FontWeight.w700,
      fontSize: 15.0);

  static const TextStyle customTextStyleBlack = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 15.0);

  static const TextStyle customTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: "Gotik",
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle customTextStyleWhite = TextStyle(
    color: Colors.white,
    fontFamily: "Gotik",
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );


  static const TextStyle subHeaderCustomStyle = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w700,
      fontFamily: "Gotik",
      fontSize: 16.0);

  static const TextStyle detailText = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black54,
      letterSpacing: 0.3,
      wordSpacing: 0.5);

  static const txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 23.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  /// Custom Text Description for Dialog after user succes payment
  static const  txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );

  static const  txtCustomSubWhite = TextStyle(
    color: Colors.white,
    fontSize: 15.0,
    fontWeight: FontWeight.w800,
    fontFamily: "Gotik",
  );
}