import 'dart:ui';

import 'package:flutter/material.dart';

class ChoiceImage {
  const ChoiceImage({this.id, this.image, this.path});

  final String? id;
  final AssetImage? image;
  final String? path;
}

List<ChoiceImage> choicesImages = const <ChoiceImage>[
  ChoiceImage(
      id: '1',
      image: AssetImage('assets/images/diet.jpg'),
      path: 'assets/images/diet.jpg'),
  ChoiceImage(
      id: '2',
      image: AssetImage('assets/images/diet2.jpg'),
      path: 'assets/images/diet2.jpg'),
  ChoiceImage(
      id: '3',
      image: AssetImage('assets/images/diet3.jpg'),
      path: 'assets/images/diet3.jpg'),
  ChoiceImage(
      id: '4',
      image: AssetImage('assets/images/diet4.jpg'),
      path: 'assets/images/diet4.jpg'),
  ChoiceImage(
      id: '5',
      image: AssetImage('assets/images/healthy2.jpg'),
      path: 'assets/images/healthy2.jpg'),
];
