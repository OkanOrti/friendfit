import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/screens/case2.dart';
import 'package:friendfit_ready/screens/detailGame.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/detailGameForMember.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/section_title.dart';
import 'package:friendfit_ready/models/game.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:friendfit_ready/widgets/section_title_games.dart';
import 'package:provider/provider.dart';

import 'cards/game_card.dart';

class MyCasesSection extends StatefulWidget {
  final DietGameViewModel? model;
  const MyCasesSection({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  _MyCasesSectionState createState() => _MyCasesSectionState();
}

class _MyCasesSectionState extends State<MyCasesSection> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    //  deneme = widget.model!.getGames(currentUser!.id!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  super.build(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Center(
                child: Row(
                  children: [
                    ...List.generate(
                      3,
                      (index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Case2(gameModelUsed: widget.model)
                              /*DetailGame(
                                                    game: widget
                                                        .model.games[index+1])*/
                              ,
                            ),
                          );
                          /*   await widget.model!
                                                .getGames(currentUser!.id!);*/
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                widget.model!.count.toString()
                                //  widget.gameModelUsed!.refresh();
                                ,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
