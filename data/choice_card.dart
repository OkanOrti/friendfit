import 'dart:ui';

import 'package:flutter/material.dart';

class Choice {
  Choice({this.id, this.image});

  final String? id;
  final Image? image;
  int isSelected = 0;
}

List<Choice> choices = <Choice>[
  Choice(
    id: '1',
    image: Image(
        width: 30,
        height: 30,
        image: AssetImage('assets/images/nutrition_icons/clock.png')),
  ),
  Choice(
      id: '2',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/no_fastfood.png'))),
  Choice(
      id: '3',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/bread.png'))),
  Choice(
      id: '4',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/dairy.png'))),
  Choice(
      id: '5',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/fruits.png'))),
  Choice(
      id: '6',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/no-junk-food.png'))),
  Choice(
      id: '7',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/juice.png'))),
  Choice(
    id: '8',
    image: Image(
        width: 30,
        height: 30,
        image: AssetImage('assets/images/nutrition_icons/no-gluten.png')),
  ),
  Choice(
      id: '9',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/no-meat.png'))),
  Choice(
      id: '10',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/no-nut.png'))),
  Choice(
      id: '11',
      image: Image(
          width: 30,
          height: 30,
          image: AssetImage('assets/images/nutrition_icons/no-sugar.png'))),
];
