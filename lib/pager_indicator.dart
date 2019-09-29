import 'dart:ui';
import 'package:anim_page_view/page_dragger.dart';
import 'package:anim_page_view/walk_through_model.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  //
  final List<WalkThroughModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  /// Accept [PageIndicatorModel] which is required
  const PageIndicator({
    Key key,
    this.pages,
    this.activeIndex,
    this.slideDirection,
    this.slidePercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final int totalPage = pages.length;

    // List which store total indicator
    List<Indicator> indicators = [];

    for (int i = 0; i < totalPage; i++) {
      //
      // Calculating percent active
      double percentActive;

      if (i == this.activeIndex) {
        percentActive = 1.0 - this.slidePercent;
      } else if (i == this.activeIndex - 1 && this.slideDirection == SlideDirection.leftToRight) {
        percentActive = this.slidePercent;
      } else if (i == this.activeIndex + 1 && this.slideDirection == SlideDirection.rightToLeft) {
        percentActive = this.slidePercent;
      } else {
        percentActive = 0.0;
      }

      // Calculation isHollow
      bool isHollow = i > this.activeIndex ||
          (i == this.activeIndex && this.slideDirection == SlideDirection.leftToRight);

      // Indicator information for each page
      WalkThroughModel model = this.pages[i];

      // Adding indicator to the list
      indicators.add(
        Indicator(
          color: model.indicatorColor,
          icon: model.indicatorIcon,
          isHollow: isHollow,
          activePercent: percentActive,
        ),
      );
    }

    // This calculation is made for placing active index always in center of the row.
    final bubbleWidth = 24.0;
    final baseTranslation = ((totalPage * bubbleWidth) / 2) - (bubbleWidth / 2);

    var translation = baseTranslation - (this.activeIndex * bubbleWidth);

    if (this.slideDirection == SlideDirection.leftToRight) {
      translation += bubbleWidth * this.slidePercent;
    } else if (this.slideDirection == SlideDirection.rightToLeft) {
      translation -= bubbleWidth * this.slidePercent;
    }

    // Pager indicator return column which first child is expended so that we can place indicators at the bottom.
    return Column(
      children: <Widget>[
        // Expanded widget to cover height of the screen
        Expanded(child: SizedBox()),

        // Indicators row
        // To place active indicator always in center we are using transform
        Transform(
          transform: Matrix4.translationValues(translation, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // Childern of row is bubbles which is generated already above.
            children: indicators,
          ),
        ),
      ],
    );
  }
}

/// Signle indicator details
class Indicator extends StatelessWidget {
  //
  final IconData icon;
  final Color color;
  final bool isHollow;
  final double activePercent;

  const Indicator({
    Key key,
    this.icon,
    this.color,
    this.isHollow,
    this.activePercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 40.0,
        left: 4.0,
        right: 4.0,
      ),
      height: lerpDouble(15.0, 30.0, this.activePercent),
      width: lerpDouble(15.0, 30.0, this.activePercent),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: this.isHollow
            ? this.color.withAlpha(
                  (0xFF * this.activePercent).round(),
                )
            : this.color,
        border: Border.all(
          color: this.isHollow
              ? this.color.withAlpha(
                    (0xFF * (1.0 - this.activePercent)).round(),
                  )
              : Colors.transparent,
          width: 3.0,
        ),
      ),
      child: Opacity(
        opacity: this.activePercent,
        child: Icon(
          this.icon,
          color: Colors.white,
          size: lerpDouble(10.0, 16.0, this.activePercent),
        ),
      ),
    );
  }
}
