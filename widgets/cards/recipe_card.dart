import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/models/recipe.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

import '../../constants.dart';
import '../../size_config.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    @required this.recipe,
    this.isFullCard = false,
    @required this.press,
  }) : super(key: key);

  final Recipe? recipe;
  final bool? isFullCard;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: getProportionateScreenWidth(150),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.4,
              child: Hero(
                tag: recipe!.imageTitleUrl!,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(recipe!.imageTitleUrl!),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Container(
              width: getProportionateScreenWidth(150),
              padding: EdgeInsets.all(
                getProportionateScreenWidth(kDefaultPadding / 2),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kDefualtShadow2, kDefualtShadow3],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    recipe!.title!,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isFullCard! ? 17 : 12,
                    ),
                  ),
                  VerticalSpacing(of: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      Icons.favorite,
                      size: 16,
                      color: AppColors.kRed,
                    ),
                    SizedBox(width: 5),
                    Text(recipe!.likesCount.toString(),
                        style: TextStyle(
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

class AddNewRecipeCard extends StatelessWidget {
  const AddNewRecipeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Container(
          width: 50,
          height: 50,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Icon(Icons.add, size: 20, color: AppColors.kRed)),
    );
  }
}
