import 'package:flutter/material.dart';

class WalkThroughModel {
  final String heading;
  final String description;
  final String image;
  final Color backgroundColor;
  final Color indicatorColor;
  final IconData indicatorIcon;

  WalkThroughModel({
    this.heading,
    this.description,
    this.image,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorIcon,
  });
}

List<WalkThroughModel> pages = [
  WalkThroughModel(
    heading: 'Heading 1',
    description: 'Description 1',
    image: 'assets/images/wt1.png',
    backgroundColor: Colors.white,
    indicatorColor: Colors.black,
    indicatorIcon: Icons.done,
  ),
  WalkThroughModel(
    heading: 'Heading 2',
    description: 'Description 2',
    image: 'assets/images/wt2.png',
    backgroundColor: Colors.white,
    indicatorColor: Colors.green,
    indicatorIcon: Icons.add,
  ),
  WalkThroughModel(
    heading: 'Heading 3',
    description: 'Description 3',
    image: 'assets/images/wt3.png',
    backgroundColor: Colors.white,
    indicatorColor: Colors.blue,
    indicatorIcon: Icons.remove,
  ),
  WalkThroughModel(
    heading: 'Heading 4',
    description: 'Description 4',
    image: 'assets/images/wt4.png',
    backgroundColor: Colors.white,
    indicatorColor: Colors.cyan,
    indicatorIcon: Icons.lock_outline,
  ),
  WalkThroughModel(
    heading: 'Heading 5',
    description: 'Description 5',
    image: 'assets/images/wt5.png',
    backgroundColor: Colors.white,
    indicatorColor: Colors.indigo,
    indicatorIcon: Icons.mode_edit,
  ),
];
