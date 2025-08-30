import 'package:flutter/material.dart';
import '../../../shared/widgets/red_card_widget.dart';

class PanicButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const PanicButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RedCardWidget(
        title: 'PANIC BUTTON',
        isFullWidth: true,
        height: 60,
        onTap: onPressed,
      ),
    );
  }
}
