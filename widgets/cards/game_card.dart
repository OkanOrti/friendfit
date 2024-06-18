import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/create_game.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:transparent_image/transparent_image.dart';
//import 'package:flutter_icons/flutter_icons.dart';

import '../../constants.dart';
import '../../size_config.dart';

class GameCard extends StatelessWidget {
  const GameCard(
      {Key? key,
      @required this.game,
      this.isFullCard = false,
      @required this.press,
      this.model})
      : super(key: key);

  final DietGame? game;
  final bool isFullCard;
  final GestureTapCallback? press;
  final DietGameViewModel? model;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: getProportionateScreenWidth(170),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.8,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    // image:DecorationImage(image: CachedNetworkImageProvider(game.imageTitleUrl??""), fit: BoxFit.cover),
                  ),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: game!.imageTitleUrl != null
                          ? FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              image: game!.imageTitleUrl!,
                              placeholder: kTransparentImage,
                            )
                          : const Image(
                              image: AssetImage("assets/images/diet.jpg")))),
            ),
            Container(
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenWidth(170),
              padding: EdgeInsets.all(
                getProportionateScreenWidth(10),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kDefualtShadow2, kDefualtShadow3],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      game!.title ??= "",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: AppColors.kFont,
                        fontWeight: FontWeight.w600,
                        fontSize: isFullCard ? 17 : 12,
                      ),
                    ),
                    const VerticalSpacing(of: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(game!.status2!,
                          style: const TextStyle(
                              overflow: TextOverflow.fade,
                              fontFamily: "Poppins",
                              fontSize: 10,
                              color: Colors.green)),
                      // Image(width:15,height:15,image: AssetImage("assets/images/yellowCircle.png")),
                      //ClipOval(child: Material(elevation:5,shadowColor: Colors.black26, child: Container(width:10,height:10,color: game.isActive ? Colors.green:Colors.blueGrey))),

                      const Spacer(),
                      Icon(
                        Icons.people,
                        size: 20,
                        color: AppColors.kRipple.withOpacity(0.7),
                      ),
                      const SizedBox(width: 5),
                      game!.memberIds != null
                          ? Text((game!.memberIds!.length + 1).toString(),
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: AppColors.kFont))
                          : SizedBox()
                    ]),

                    /* Travelers(
                        users: travelSport.users,
                      ),*/
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget setGameStatus(DietGame? game) {
    if (game!.status != "İnaktif" && game.status == "Waiting") {
      return const Text("Bekliyor",
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 12, color: Colors.blueGrey));
    } else if (game.status != "İnaktif" && game.status == "Started") {
      return const Text("Başladı",
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 12, color: Colors.green));
    } else if (game.startDate!.toDate().compareTo(DateTime.now()) > 0 &&
        game.status == "İnaktif") {
      return const Text("İnaktif",
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 12, color: Colors.blueGrey));
    } else {
      return const SizedBox();
    }
  }
}

class AddNewGameCard extends StatelessWidget {
  final DietGameViewModel? game;
  const AddNewGameCard({Key? key, this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: GestureDetector(
        child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [kDefualtShadow2, kDefualtShadow3]),
            child: const Icon(Icons.add, size: 20, color: AppColors.kRed)),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateGamePage(),
            ),
          );
          await game!.getGames(currentUser!.id!);
          await game!.refresh();
        },
      ),
    );
  }
}
