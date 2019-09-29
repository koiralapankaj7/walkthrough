import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class PageDragger extends StatefulWidget {
  //

  final StreamController slideUpdateStream;
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;

  const PageDragger({
    Key key,
    this.slideUpdateStream,
    this.canDragLeftToRight,
    this.canDragRightToLeft,
  }) : super(key: key);

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  //

  static const FULL_TRANSITION_PX = 300.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      Offset newPosition = details.globalPosition;
      double dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (this.slideDirection != SlideDirection.none) {
        // dx can be -ve so use absolute value. What if user slide by more than 300 px (FULL_TRANSITION_PX) ?  That is why we are using clamp. So that slide percent always remain between 0,0 to 1.0
        this.slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        this.slidePercent = 0.0;
      }

      widget.slideUpdateStream.add(SlideUpdate(
        updateType: UpdateType.dragging,
        direction: slideDirection,
        slidePercent: slidePercent,
      ));
    }
  }

  onDragEnd(DragEndDetails details) {
    // Clean up
    dragStart = null;

    widget.slideUpdateStream.add(SlideUpdate(
      updateType: UpdateType.doneDragging,
      direction: SlideDirection.none,
      slidePercent: 0.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;
  final SlideDirection slideDirection;
  final TransitionGoal transitionGoal;
  AnimationController completeAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final double startSlidePercent = slidePercent;
    double endSlidePercent;
    Duration duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      double slideRemaining = 1.0 - slidePercent;
      duration = Duration(milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round());
    } else {
      endSlidePercent = 0.0;
      duration = Duration(milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round());
    }

    completeAnimationController = AnimationController(
      duration: duration,
      vsync: vsync,
    )
      ..addListener(() {
        slidePercent = lerpDouble(
          startSlidePercent,
          endSlidePercent,
          completeAnimationController.value,
        );

        slideUpdateStream.add(SlideUpdate(
          direction: slideDirection,
          slidePercent: slidePercent,
          updateType: UpdateType.animating,
        ));
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(SlideUpdate(
            direction: slideDirection,
            slidePercent: endSlidePercent,
            updateType: UpdateType.doneAnimating,
          ));
        }
      });
  }

  run() {
    completeAnimationController.forward(from: 0.0);
  }

  dispose() {
    completeAnimationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

/// [SliderDirection] is an enum
enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class SlideUpdate {
  final UpdateType updateType;
  final SlideDirection direction;
  final double slidePercent;

  SlideUpdate({
    @required this.updateType,
    @required this.direction,
    @required this.slidePercent,
  });
}
