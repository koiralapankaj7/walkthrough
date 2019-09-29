import 'package:anim_page_view/page_dragger.dart';
import 'package:anim_page_view/walk_through_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WalkThroughPage extends StatelessWidget {
  //

  final WalkThroughModel model;
  final double slidePercent;
  final SlideDirection slideDirection;
  final int activeIndex;
  final int nextPageIndex;

  const WalkThroughPage({
    Key key,
    this.model,
    this.slidePercent,
    this.slideDirection,
    this.activeIndex,
    this.nextPageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final double deviceHeight = mediaQuery.size.height;
    final double deviceWidth = mediaQuery.size.width;
    final double imageHeight = deviceHeight * 0.50;
    final double imageTop = deviceHeight * 0.13;

    print('Percent visible $slidePercent');

    double textTransform;
    //double imageTransform = (deviceHeight * 0.13) * (1 - this.slidePercent);
    // double imageTransform = -(imageHeight + imageTop);
    double imageTransform;

    if (slidePercent == 0.0) {
      imageTransform = imageTop;
    } else {
      // If current index go top
      // If next index come down
      imageTransform = imageTop * (1 - this.slidePercent);
    }

    if (this.slideDirection == SlideDirection.leftToRight) {
      textTransform = (deviceWidth / 2) * (this.slidePercent);
    } else if (this.slideDirection == SlideDirection.rightToLeft) {
      textTransform = (deviceWidth / 2) * (-this.slidePercent);
    } else if (this.slideDirection == SlideDirection.none) {
      textTransform = 0.0;
    }

    return Container(
      color: model.backgroundColor,
      width: double.infinity,
      child: Opacity(
        opacity: (1 - this.slidePercent),
        child: Column(
          children: <Widget>[
            // Image
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                imageTransform,
                0.0,
              ),
              child: Container(
                height: deviceHeight * 0.50,
                width: deviceWidth * 0.90,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    // fit: BoxFit.cover,
                    image: AssetImage(model.image),
                  ),
                ),
              ),
            ),

            // Heading
            Transform(
              transform: Matrix4.translationValues(
                textTransform,
                deviceHeight * 0.20,
                0.0,
              ),
              child: Text(model.heading),
            ),

            // Description
            Transform(
              transform: Matrix4.translationValues(
                textTransform,
                deviceHeight * 0.25,
                0.0,
              ),
              child: Text(model.description),
            ),

            //
            //
          ],
        ),
      ),
    );
  }
}
