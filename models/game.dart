import 'package:flutter/material.dart';
import 'package:friendfit_ready/models/UserTest.dart';

class Game {
  final String? name, image;
  final DateTime? date;
  final List<UserTest>? users;

  Game({
    @required this.users,
    @required this.name,
    @required this.image,
    @required this.date,
  });
}

List<Game> games = [
  Game(
    users: users..shuffle(),
    name: "Diet_Adım",
    image: "assets/images/Diet_Step.jpg",
    date: DateTime(2020, 10, 15),
  ),
  Game(
    users: users..shuffle(),
    name: "Diet",
    image: "assets/images/diet.jpg",
    date: DateTime(2020, 3, 10),
  ),
  Game(
    users: users..shuffle(),
    name: "İşte bu!",
    image: "assets/images/diet3.jpg",
    date: DateTime(2020, 10, 15),
  ),
  Game(
    users: users..shuffle(),
    name: "Adım adım",
    image: "assets/images/step2.jpg",
    date: DateTime(2020, 3, 10),
  ),
  Game(
    users: users..shuffle(),
    name: "Vaba özel",
    image: "assets/images/diet4.jpg",
    date: DateTime(2020, 10, 15),
  ),
];

List<UserTest> users = [user1, user2, user3, user4, user5, user6, user7, user8];
