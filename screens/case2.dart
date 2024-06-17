import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/deneme_timeLine.dart';
import 'package:friendfit_ready/screens/dietPlanTiles.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/circular_clipper.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/widgets/my_friends.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../size_config.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/rendering.dart';
import 'package:friendfit_ready/screens/dietPlanReview.dart';
import 'package:friendfit_ready/screens/memberStatusReview.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:friendfit_ready/screens/scoreBoard.dart';

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class Case2 extends StatefulWidget {
  final DietGame? game;
  final DietGameViewModel? gameModelUsed;
  Case2({Key? key, this.game, this.gameModelUsed}) : super(key: key);

  @override
  _Case2State createState() => _Case2State();
}

class _Case2State extends State<Case2> with TickerProviderStateMixin {
  //final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
          child: TextButton(
              onPressed: () {
                widget.gameModelUsed!.count += 1;
                widget.gameModelUsed!.refresh();
                Navigator.of(context).pop();
              },
              child: const Text("Arttır"))),
    );
  }
}
