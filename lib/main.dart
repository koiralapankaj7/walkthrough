import 'dart:async';

import 'package:anim_page_view/page_dragger.dart';
import 'package:anim_page_view/page_reveal.dart';
import 'package:anim_page_view/pager_indicator.dart';
import 'package:anim_page_view/walk_through_model.dart';
import 'package:anim_page_view/walk_through_next_page.dart';
import 'package:anim_page_view/walk_through_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  //

  StreamController slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;
  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  @override
  void initState() {
    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((event) {
      SlideUpdate slideUpdate = event;
      setState(() {
        if (slideUpdate.updateType == UpdateType.dragging) {
          this.slideDirection = slideUpdate.direction;
          this.slidePercent = slideUpdate.slidePercent;

          if (this.slideDirection == SlideDirection.leftToRight) {
            this.nextPageIndex = this.activeIndex - 1;
          } else if (this.slideDirection == SlideDirection.rightToLeft) {
            this.nextPageIndex = this.activeIndex + 1;
          } else {
            this.nextPageIndex = this.activeIndex;
          }

          //this.nextPageIndex.clamp(0.0, pages.length - 1);
        } else if (slideUpdate.updateType == UpdateType.doneDragging) {
          if (this.slidePercent > 0.5) {
            this.animatedPageDragger = AnimatedPageDragger(
              slideDirection: this.slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: this.slidePercent,
              slideUpdateStream: this.slideUpdateStream,
              vsync: this,
            );
          } else {
            this.animatedPageDragger = AnimatedPageDragger(
              slideDirection: this.slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: this.slidePercent,
              slideUpdateStream: this.slideUpdateStream,
              vsync: this,
            );

            this.nextPageIndex = this.activeIndex;
          }

          animatedPageDragger.run();
        } else if (slideUpdate.updateType == UpdateType.animating) {
          this.slideDirection = slideUpdate.direction;
          this.slidePercent = slideUpdate.slidePercent;
        } else if (slideUpdate.updateType == UpdateType.doneAnimating) {
          this.activeIndex = this.nextPageIndex;
          this.slideDirection = SlideDirection.none;
          this.slidePercent = 0.0;

          animatedPageDragger.dispose();
        }

        //
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    slideUpdateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //
          // WalkThroughPage(
          //   model: pages[this.activeIndex],
          //   slidePercent: this.slidePercent,
          //   activeIndex: this.activeIndex,
          //   nextPageIndex: this.nextPageIndex,
          //   slideDirection: this.slideDirection,
          // ),

          //
          WalkThroughNextPage(
            model: pages[activeIndex],
            slidePercent: this.slidePercent,
            activeIndex: this.activeIndex,
            nextPageIndex: this.nextPageIndex,
            slideDirection: this.slideDirection,
          ),

          // PageReveal(
          //   revealPercent: this.slidePercent,
          //   child: WalkThroughPage(
          //     model: pages[nextPageIndex],
          //     slidePercent: this.slidePercent,
          //     activeIndex: this.activeIndex,
          //     nextPageIndex: this.nextPageIndex,
          //     slideDirection: this.slideDirection,
          //   ),
          // ),

          // Indicator
          PageIndicator(
            pages: pages,
            activeIndex: this.activeIndex,
            slideDirection: this.slideDirection,
            slidePercent: this.slidePercent,
          ),

          //
          PageDragger(
            canDragLeftToRight: this.activeIndex > 0,
            canDragRightToLeft: this.activeIndex < pages.length - 1,
            slideUpdateStream: this.slideUpdateStream,
          ),

          //
        ],
      ),
    );
  }
}
