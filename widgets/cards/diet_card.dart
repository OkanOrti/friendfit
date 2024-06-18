//import 'dart:html';

// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/models/UserTest.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/screens/addDetailScreen.dart';
import 'package:friendfit_ready/screens/create_plan.dart';
import 'package:friendfit_ready/screens/deneme.dart';
import 'package:friendfit_ready/screens/detail_screen.dart';
import 'package:friendfit_ready/screens/newPlan.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:friendfit_ready/models/game.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../constants.dart';
import '../../size_config.dart';

class DietCard extends StatelessWidget {
  const DietCard({
    Key? key,
    @required this.diet,
    this.isFullCard = false,
    @required this.press,
  }) : super(key: key);

  final DietTask? diet;
  final bool isFullCard;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: getProportionateScreenWidth(170),
        child: Column(
          /* ClipRRect(
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
                              image: AssetImage("assets/images/diet.jpg")))) */
          children: [
            AspectRatio(
                aspectRatio: 1.7,
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
                        child: diet!.backgroundId != null
                            ? FadeInImage.memoryNetwork(
                                fit: BoxFit.cover,
                                image: diet!.backgroundId!,
                                placeholder: kTransparentImage,
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Container(
                                  // width: 100,
                                  //height: 100,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              )
                            : const Image(
                                image: AssetImage("assets/images/diet.jpg"))))),
            Container(
              width: getProportionateScreenWidth(170),
              // height: getProportionateScreenWidth(100),
              padding: EdgeInsets.all(
                getProportionateScreenWidth(kDefaultPadding),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kDefualtShadow2, kDefualtShadow3],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    diet!.title!,
                    // softWrap: true,
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isFullCard ? 17 : 12,
                    ),
                  ),
                  const VerticalSpacing(of: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.kRed,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                        diet!.likesCount == null || diet!.likesCount == 0
                            ? ""
                            : diet!.likesCount.toString(),
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: AppColors.kRed))
                  ]),

                  /* Travelers(
                    users: travelSport.users,
                  ),*/
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class AddNewDietCard extends StatelessWidget {
  final DietTaskViewModel? model;
  final DietTaskViewModel model2 = serviceLocator<DietTaskViewModel>();

  AddNewDietCard({
    this.model,
    Key? key,
  }) : super(key: key);

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
            child: Icon(Icons.add, size: 20, color: AppColors.kRed)),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreatePlanPage(),
            ),
          );
          // await model!.loadTasks(adminId);
          ;
        },
      ),
    );
  }
}
