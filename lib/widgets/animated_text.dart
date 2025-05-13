import 'package:flutter/material.dart';
import 'package:maps_app/models/models.dart';

/// A widget that animates the display of a child widget
/// based on whether an address is present.
class AnimatedText extends StatelessWidget {
  final AddressModel? address;
  final Widget? text;

  const AnimatedText({
    super.key,
    this.address, 
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500), 
      // If `address` is not null, show the text widget with an animation
      child: address != null 
        ? text
        : SizedBox.shrink(), 
    );
  }
}
