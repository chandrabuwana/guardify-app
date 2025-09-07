import 'package:flutter/material.dart';
import '../../core/design/colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool enableScrolling;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;

  const AppScaffold({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.enableScrolling = true,
    this.padding,
    this.safeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = child;

    // Wrap with padding if provided
    if (padding != null) {
      bodyContent = Padding(
        padding: padding!,
        child: bodyContent,
      );
    }

    // Wrap with scrolling if enabled
    if (enableScrolling) {
      bodyContent = SingleChildScrollView(
        child: bodyContent,
      );
    }

    // Wrap with SafeArea if enabled
    if (safeArea) {
      bodyContent = SafeArea(
        child: bodyContent,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? bgColor,
      appBar: appBar,
      body: bodyContent,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
