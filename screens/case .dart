// ignore_for_file: prefer_const_constructors_in_immutables, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/case2.dart';
import 'package:friendfit_ready/services/service_locator.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:friendfit_ready/widgets/my_cases.dart';

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class Case extends StatefulWidget {
  final DietGameViewModel? gameModelUsed;
  Case({Key? key, this.gameModelUsed}) : super(key: key);

  @override
  _CaseState createState() => _CaseState();
}

class _CaseState extends State<Case> with TickerProviderStateMixin {
  // final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: /* GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Case2(gameModelUsed: widget.gameModelUsed)
                /*DetailGame(
                                                  game: widget
                                                      .model.games[index+1])*/
                ,
              ),
            );
          },
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text(
                widget.gameModelUsed!.count.toString()
                //  widget.gameModelUsed!.refresh();
                ,
              ),
            ),
          ),
        )*/
              //

              //SizedBox(),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 200),
            MyCasesSection(model: widget.gameModelUsed)
          ]),
        ),
      ),
    );
  }
}
