import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
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

class MyGamesSection extends StatefulWidget {
  final DietGameViewModel? model;
  const MyGamesSection({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  _MyGamesSectionState createState() => _MyGamesSectionState();
}

class _MyGamesSectionState extends State<MyGamesSection> {
  // DietGameViewModel widget.model! = serviceLocator<DietGameViewModel>();
  Future<void>? deneme;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    deneme = widget.model!.getGames(currentUser!.id!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  super.build(context);
    return FutureBuilder(
        future: deneme, // widget.model!.getGames(adminId),
        // initialData: InitialData,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // Uncompleted State
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                  child:
                      SpinKitThreeBounce(color: AppColors.kRipple, size: 20));
            default:
              // Completed with error
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              // Completed with data

              return Column(
                children: [
                  SectionTitleGame(
                    title: "Oyunlar",
                    press: () {},
                    model: widget.model!,
                  ),
                  const VerticalSpacing(of: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: widget.model!.games.isNotEmpty
                          ? Row(
                              children: [
                                AddNewGameCard(game: widget.model!),
                                ...List.generate(
                                  widget.model!.games.length - 1,
                                  (index) => Padding(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenWidth(
                                            kDefaultPadding)),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DetailGameForMember(
                                                gameModel: widget.model,
                                                game: widget
                                                    .model!.games[index + 1])
                                            /*DetailGame(
                                                game: widget
                                                    .model.games[index+1])*/
                                            ,
                                          ),
                                        );
                                        /*   await widget.model!
                                            .getGames(currentUser!.id!);*/
                                      },
                                      child: GameCard(
                                        game: widget.model!.games[index + 1],
                                        press: () {},
                                        model: widget.model!,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(
                                      kDefaultPadding),
                                ),
                              ],
                            )
                          : const AddNewGameCard(),
                    ),
                  ),
                ],
              );
          }
        });
  }
}
