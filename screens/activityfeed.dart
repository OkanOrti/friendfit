// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/screens/detailGameForMember.dart';

class ActivityFeed extends StatelessWidget {
  // final DietGameViewModel modelNew = serviceLocator<DietGameViewModel>();

  final DietGameViewModel? modelUsed;
  const ActivityFeed({Key? key, this.modelUsed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // AppColors.kBackground,
        body: ChangeNotifierProvider<DietGameViewModel>.value(
            value: modelUsed!,
            child: Consumer<DietGameViewModel>(
                builder: (context, model, child) => FutureBuilder(
                    future: model.getChallenges(currentUser!.id!),
                    // initialData: InitialData,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // Uncompleted State
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          // Completed with error
                          if (snapshot.hasError)
                            return Text(snapshot.error.toString());

                          // Completed with data

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Expanded(
                              child: Column(children: [
                                Text(currentUser!.displayName!),
                                ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    ...List.generate(
                                      modelUsed!.invitedGames.length,
                                      (index) => BuildCard(
                                        modelUsed!.invitedGames[index],
                                        gameModel: modelUsed!,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          );
                        // SizedBox(height: 15.0)

                      }
                    }))));
  }
}

class BuildCard extends StatelessWidget {
  final DietGame game;
  final DietGameViewModel? gameModel;

  const BuildCard(this.game, {this.gameModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: GestureDetector(
            onTap: () async {
              // await gameModel.getGameTodos(game.gameOwnerId,game.id);

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailGameForMember(
                        game: game,
                      )));
            },
            child: Card(
              elevation: 5.0,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                isThreeLine: true,
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(game.imageTitleUrl ?? ""),
                ),
                title: Text(
                  game.title ?? "",
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(game.phrase ?? ""),
                trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          gameModel!.gameInvitationStatus(
                              game.gameOwnerId!, game.id!,
                              type: "1");
                        },
                        child: Container(
                          width: 70.0,
                          height: 25.0,
                          child: const Text(
                            "Onayla",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.kRipple,
                            border: Border.all(
                              color: AppColors.kRipple,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          gameModel!.gameInvitationStatus(
                              game.gameOwnerId!, game.id!,
                              type: "2");
                        },
                        child: Container(
                          width: 70.0,
                          height: 25.0,
                          child: Text(
                            "Reddet",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.kRipple,
                            border: Border.all(
                              color: AppColors.kRipple,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      )

                      /* Icon(
                              Icons.favorite,
                              size: 20,
                              color: AppColors.kRed,
                            ),
                            SizedBox(width: 5),
                            Text("",
                              //game.likesCount.toString(),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 15,
                                    color: AppColors.kRed))
                                    */
                    ]),
              ),
            ),
          ),
        ),

        /*   Divider(
          height: 2.0,
          color: Colors.grey,
        ),*/
      ],
    );
  }
}
