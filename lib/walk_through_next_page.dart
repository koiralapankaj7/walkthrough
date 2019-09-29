import 'package:anim_page_view/image_reveal.dart';
import 'package:anim_page_view/page_dragger.dart';
import 'package:anim_page_view/page_reveal.dart';
import 'package:anim_page_view/walk_through_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WalkThroughNextPage extends StatefulWidget {
  //

  final WalkThroughModel model;
  final double slidePercent;
  final SlideDirection slideDirection;
  final int activeIndex;
  final int nextPageIndex;

  WalkThroughNextPage({
    Key key,
    this.model,
    this.slidePercent,
    this.slideDirection,
    this.activeIndex,
    this.nextPageIndex,
  }) : super(key: key);

  @override
  _WalkThroughNextPageState createState() => _WalkThroughNextPageState();
}

class _WalkThroughNextPageState extends State<WalkThroughNextPage> {
  PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //

    MediaQueryData mediaQuery = MediaQuery.of(context);
    final double deviceHeight = mediaQuery.size.height;
    final double deviceWidth = mediaQuery.size.width;
    final double imageHeight = deviceHeight * 0.50;
    final double imageTop = deviceHeight * 0.13;

    print('Percent visible ${widget.slidePercent}');

    double textTransform;
    //double imageTransform = (deviceHeight * 0.13) * (1 - this.slidePercent);
    // double imageTransform = -(imageHeight + imageTop);
    double imageTransform;

    if (widget.slidePercent == 0.0) {
      imageTransform = imageTop;
    } else {
      // If current index go top
      // If next index come down
      imageTransform = imageTop * (1 - this.widget.slidePercent);
    }

    if (this.widget.slideDirection == SlideDirection.leftToRight) {
      textTransform = (deviceWidth / 2) * (1 + this.widget.slidePercent);
      pageController.animateToPage(
        widget.nextPageIndex,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
      );
    } else if (this.widget.slideDirection == SlideDirection.rightToLeft) {
      textTransform = (deviceWidth / 2) * (1 - this.widget.slidePercent);
      pageController.animateToPage(
        widget.nextPageIndex,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 400),
      );
    } else if (this.widget.slideDirection == SlideDirection.none) {
      textTransform = (deviceWidth / 2) * (-this.widget.slidePercent);
    }

    return Container(
      color: widget.model.backgroundColor,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          //
          // Image
          Opacity(
            opacity: (1 - this.widget.slidePercent),
            child: Transform(
              transform: Matrix4.translationValues(
                0.0,
                0.0,
                0.0,
              ),
              child: Container(
                height: deviceHeight * 0.50,
                width: deviceWidth * 0.90,
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   // fit: BoxFit.cover,
                    //   image: AssetImage(widget.model.image),
                    // ),
                    ),
                child: IndexedStack(
                  //index: widget.activeIndex,
                  children: <Widget>[
                    _currentImage(pages[widget.activeIndex].image, imageTransform),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: imageTop, bottom: imageTop),
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                pageSnapping: false,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  WalkThroughModel model = pages[index];
                  return Opacity(
                    opacity: (1 - this.widget.slidePercent),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(model.heading),
                          SizedBox(height: 32.0),
                          Text(model.description),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          //
          //
        ],
      ),
    );
  }

  Widget _currentImage(String name, double imageTransform) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        imageTransform,
        0.0,
      ),
      child: Image.asset(name),
    );
  }

  Widget _nextImage(String image, double slidePercent, double imageTransform) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        -imageTransform,
        0.0,
      ),
      child: Container(
        color: Colors.brown,
        //child: Image.asset(image),
      ),
    );
  }
}
