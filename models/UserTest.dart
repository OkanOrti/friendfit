import 'package:flutter/material.dart';

class UserTest {
  final String? name, image;

  UserTest({@required this.name, @required this.image});
}

// Demo List of Top Travelers
List<UserTest> myFriends = [
  user1,
  user2,
  user3,
  user4,
  user5,
  user6,
  user7,
  user8
];

// demo UserTest
UserTest user1 = UserTest(name: "James", image: "assets/images/james.png");
UserTest user2 = UserTest(name: "John", image: "assets/images/John.png");
UserTest user3 = UserTest(name: "Marry", image: "assets/images/marry.png");
UserTest user4 = UserTest(name: "Rosy", image: "assets/images/rosy.png");
UserTest user5 = UserTest(name: "James", image: "assets/images/james.png");
UserTest user6 = UserTest(name: "John", image: "assets/images/John.png");
UserTest user7 = UserTest(name: "Marry", image: "assets/images/marry.png");
UserTest user8 = UserTest(name: "Rosy", image: "assets/images/rosy.png");
