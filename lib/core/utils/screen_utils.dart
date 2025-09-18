import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Utility class for getting screen dimensions
class ScreenUtils {
  /// Get full screen height
  static double get fullHeight => ScreenUtil().screenHeight;

  /// Get half screen height
  static double get halfHeight => ScreenUtil().screenHeight * 0.5;

  /// Get quarter screen height
  static double get quarterHeight => ScreenUtil().screenHeight * 0.25;

  /// Get three quarter screen height
  static double get threeQuarterHeight => ScreenUtil().screenHeight * 0.75;

  /// Get full screen width
  static double get fullWidth => ScreenUtil().screenWidth;

  /// Get half screen width
  static double get halfWidth => ScreenUtil().screenWidth * 0.5;

  /// Get quarter screen width
  static double get quarterWidth => ScreenUtil().screenWidth * 0.25;

  /// Get three quarter screen width
  static double get threeQuarterWidth => ScreenUtil().screenWidth * 0.75;

  /// Get custom height percentage (0.0 to 1.0)
  static double heightPercent(double percent) =>
      ScreenUtil().screenHeight * percent;

  /// Get custom width percentage (0.0 to 1.0)
  static double widthPercent(double percent) =>
      ScreenUtil().screenWidth * percent;

  /// Get safe area height (excluding status bar and navigation bar)
  static double safeHeight(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return fullHeight - mediaQuery.padding.top - mediaQuery.padding.bottom;
  }

  /// Get safe area width (excluding system insets)
  static double safeWidth(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return fullWidth - mediaQuery.padding.left - mediaQuery.padding.right;
  }

  /// Check if device is in landscape mode
  static bool get isLandscape => fullWidth > fullHeight;

  /// Check if device is in portrait mode
  static bool get isPortrait => fullHeight > fullWidth;

  /// Get responsive font size based on screen width
  static double responsiveFontSize(double baseSize) {
    // Adjust font size based on screen width
    // Base calculation for 375px width (iPhone 6/7/8 width)
    return baseSize * (fullWidth / 375.0);
  }

  /// Get device type based on screen width
  static DeviceType get deviceType {
    if (fullWidth < 600) {
      return DeviceType.mobile;
    } else if (fullWidth < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }
}

/// Enum for device types
enum DeviceType {
  mobile,
  tablet,
  desktop,
}
