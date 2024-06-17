import 'package:flutter/material.dart';
import 'package:friendfit_ready/models/UserTest.dart';

class Blog {
  final String? name, image;
  final DateTime? date;
  final List<UserTest>? users;

  Blog({
    @required this.users,
    @required this.name,
    @required this.image,
    @required this.date,
  });
}

List<Blog> blogs = [
  Blog(
    users: users..shuffle(),
    name: "Sağlıklı Yaşam",
    image: "assets/images/healthy.jpg",
    date: DateTime(2020, 10, 15),
  ),
  Blog(
    users: users..shuffle(),
    name: "Etkili Kilo Verme",
    image: "assets/images/healthy2.jpg",
    date: DateTime(2020, 3, 10),
  ),
  Blog(
    users: users..shuffle(),
    name: "Nasıl hızlı kilo veririm ?",
    image: "assets/images/healthy3.jpg",
    date: DateTime(2020, 10, 15),
  ),
  Blog(
    users: users..shuffle(),
    name: "Sağlıkta Son Trendler",
    image: "assets/images/healthy4.jpg",
    date: DateTime(2020, 3, 10),
  ),
  Blog(
    users: users..shuffle(),
    name: "Yararlı İpuçları",
    image: "assets/images/healthy5.jpg",
    date: DateTime(2020, 10, 15),
  ),
];

List<UserTest> users = [user1, user2, user3, user4, user5, user6, user7, user8];
