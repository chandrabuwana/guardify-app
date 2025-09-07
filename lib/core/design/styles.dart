import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guardify_app/core/config/app_config.dart';
import 'package:guardify_app/core/design/colors.dart';

extension BuildContextX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    platform: TargetPlatform.iOS,
    primarySwatch: MaterialColor(primaryColor.hashCode, materialColor),
    fontFamily: AppConfig.fontFamily,
    splashColor: Colors.white54,
    scaffoldBackgroundColor: bgColor,
    textTheme: context.textTheme.apply(bodyColor: appTextColor),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    platform: TargetPlatform.iOS,
    primarySwatch: MaterialColor(primaryDark.hashCode, materialColor),
    fontFamily: AppConfig.fontFamily,
    splashColor: Colors.white54,
    scaffoldBackgroundColor: bgColorDark,
    textTheme: context.textTheme.apply(bodyColor: Colors.white),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
  );
}

class Sizes {
  static double get xs => 8.w;
  static double get sm => 12.w;
  static double get med => 20.w;
  static double get lg => 32.w;
  static double get xl => 48.w;
  static double get xxl => 70.w;
  static double get toolbarHeight => 124.h;
}

class Insets {
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get med => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 32.w;
}

class IconSizes {
  static double get xs => 12.w;
  static double get sm => 20.w;
  static double get med => 28.w;
  static double get lg => 32.w;
  static double get xl => 48.w;
  static double get xxl => 64.w;
}

class Paddings {
  static EdgeInsets get xxs => REdgeInsets.all(2);
  static EdgeInsets get xs => REdgeInsets.all(4);
  static EdgeInsets get sm => REdgeInsets.all(8);
  static EdgeInsets get med => REdgeInsets.all(12);
  static EdgeInsets get lg => REdgeInsets.all(16);
  static EdgeInsets get xl => REdgeInsets.all(20);
  static EdgeInsets get xxl => REdgeInsets.all(32);

  static EdgeInsets hv(double h, double v) =>
      REdgeInsets.symmetric(horizontal: h, vertical: v);
}

class Corners {
  static double get xs => 4.r;
  static double get sm => 8.r;
  static double get med => 12.r;
  static double get lg => 16.r;
  static double get xl => 20.r;
  static double get xxl => 32.r;

  static Radius get xsRadius => Radius.circular(xs);
  static Radius get smRadius => Radius.circular(sm);
  static Radius get medRadius => Radius.circular(med);
  static Radius get lgRadius => Radius.circular(lg);
  static Radius get xlRadius => Radius.circular(xl);
  static Radius get xxlRadius => Radius.circular(xxl);

  static BorderRadius get xsBorder => BorderRadius.all(xsRadius);
  static BorderRadius get smBorder => BorderRadius.all(smRadius);
  static BorderRadius get medBorder => BorderRadius.all(medRadius);
  static BorderRadius get lgBorder => BorderRadius.all(lgRadius);
  static BorderRadius get xlBorder => BorderRadius.all(xlRadius);
  static BorderRadius get xxlBorder => BorderRadius.all(xxlRadius);
}

// Default Material Text Styles
class TS {
  static TextStyle ts = TextStyle(
    fontFamily: AppConfig.fontFamily,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get displayLarge => ts.copyWith(fontSize: 57.sp);
  static TextStyle get displayMedium => ts.copyWith(fontSize: 45.sp);
  static TextStyle get displaySmall => ts.copyWith(fontSize: 44.sp);

  static TextStyle get headlineLarge => ts.copyWith(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineMedium => ts.copyWith(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineSmall => ts.copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleLarge =>
      ts.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700);
  static TextStyle get titleMedium => ts.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: .15,
      );
  static TextStyle get titleSmall => ts.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: .1,
      );

  static TextStyle get title1 => ts.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 17.sp,
        height: 1.15,
        letterSpacing: -0.8,
      );

  static TextStyle get subtitle1 => ts.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
        letterSpacing: -0.15,
      );

  static TextStyle get subtitle2 => ts.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
        letterSpacing: -0.15,
      );

  static TextStyle get labelLarge => ts.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: .1,
      );
  static TextStyle get labelMedium => ts.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: .1,
      );
  static TextStyle get labelSmall => ts.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: .5,
      );

  static TextStyle get bodyLarge => ts.copyWith(
        fontSize: 16.sp,
        letterSpacing: .15,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get bodyMedium => ts.copyWith(
        fontSize: 14.sp,
        letterSpacing: .25,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get bodySmall => ts.copyWith(
        fontSize: 12.sp,
        letterSpacing: .1,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get bodyMini => ts.copyWith(
        fontSize: 10.sp,
        letterSpacing: .4,
      );
  static TextStyle get body1 => ts.copyWith(
        fontSize: 16.sp,
        letterSpacing: 0.1,
      );
  static TextStyle get body2 => ts.copyWith(
        fontSize: 14.sp,
        letterSpacing: 0.1,
      );

  static TextStyle get small1 => ts.copyWith(
        fontSize: 13.sp,
        letterSpacing: 0.1,
      );
  static TextStyle get small2 => ts.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        letterSpacing: 0.1,
      );
  static TextStyle get small3 => ts.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 10.sp,
        letterSpacing: 0.2,
      );

  static TextStyle get caption => ts.copyWith(
        fontSize: 10.sp,
        letterSpacing: .25,
        fontWeight: FontWeight.w600,
      );
}

class Shadows {
  static List<BoxShadow> get universal => [
        const BoxShadow(
          color: Color(0x19202020),
          blurRadius: 13.54,
          offset: Offset(0, 3.85),
        ),
        const BoxShadow(
          color: Color(0x10202020),
          blurRadius: 37.44,
          offset: Offset(0, 10.64),
        ),
        const BoxShadow(
          color: Color(0x0C202020),
          blurRadius: 90.14,
          offset: Offset(0, 25.63),
        ),
        const BoxShadow(
          color: Color(0x08202020),
          blurRadius: 299,
          offset: Offset(0, 85),
        ),
      ];

  static List<BoxShadow> get up => [
        const BoxShadow(
          offset: Offset(0, -5),
          blurRadius: 10,
          spreadRadius: 2,
          color: Color.fromARGB(31, 108, 108, 108),
        ),
      ];

  static List<BoxShadow> get small => [
        const BoxShadow(
          color: Color.fromARGB(24, 126, 126, 126),
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
        const BoxShadow(
          color: Color.fromARGB(16, 141, 141, 141),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
        const BoxShadow(
          color: Color.fromARGB(16, 141, 141, 141),
          blurRadius: 50,
        ),
      ];
}
