import 'package:flutter/material.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/activityfeed.dart';
import 'package:friendfit_ready/screens/profile.dart';
import 'package:friendfit_ready/screens/create_game.dart';
import 'package:friendfit_ready/screens/create_game2.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => Home());
      case activityFeedRoute:
        return MaterialPageRoute(builder: (_) => ActivityFeed());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => Profile());
      case createGameStep1Route:
        return MaterialPageRoute(builder: (_) => CreateGamePage());
      /* case createGameStep2Route:
        return MaterialPageRoute(builder: (_) => CreateNewTaskPage2());*/

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Ters giden birşeyler oldu'),
            ),
          ),
        );
    }
  }
}

const String homeRoute = '/';
const String activityFeedRoute = '/ActivityFeed';
const String profileRoute = '/Profile';
const String createGameStep1Route = '/GameStep1';
const String createGameStep2Route = '/GameStep2';
