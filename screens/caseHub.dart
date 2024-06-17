// ignore_for_file: prefer_const_constructors_in_immutables, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/case%20.dart';
import 'package:friendfit_ready/screens/case2.dart';
import 'package:friendfit_ready/screens/deneme.dart';
import 'package:friendfit_ready/services/service_locator.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class CaseHub extends StatefulWidget {
  final DietGame? game;
  final DietGameViewModel? gameModelUsed;
  CaseHub({Key? key, this.game, this.gameModelUsed}) : super(key: key);

  @override
  _CaseHubState createState() => _CaseHubState();
}

class _CaseHubState extends State<CaseHub> with TickerProviderStateMixin {
  // final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        children: [
          Case(gameModelUsed: widget.gameModelUsed),
          PositionedTiles(w: widget.gameModelUsed),
        ],
      ),
    );
  }
}
