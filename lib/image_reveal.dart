import 'dart:math';

import 'package:flutter/material.dart';

class ImageReveal extends StatelessWidget {
  //

  final double revealPercent;
  final Widget child;

  const ImageReveal({
    Key key,
    this.revealPercent,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircleRevealClipper(this.revealPercent),
      child: this.child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  const CircleRevealClipper(this.revealPercent);

  @override
  Rect getClip(Size size) {
    // Epicenter is where our circle start which is from bottom of the screen in our case.
    final Offset epicenter = Offset(size.width / 2, size.height / 2);

    // final Offset epicenter = Offset(size.height / 2, size.width * 0.90);

    // Calculate distance epicenter to the top left corner to make sure we fill the screen
    // Why we need to check either top left or top right is reveal will be circle and it wont touch left or right side of the screen when it does touch top center of the screen. That is why we need to check from cornor side.
    double theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCorner = epicenter.dy / cos(theta);

    // Distance to the corner is tha maximum redius that we want to create
    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    return Rect.fromLTWH(
      epicenter.dx - radius,
      epicenter.dy - radius,
      diameter,
      diameter,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
