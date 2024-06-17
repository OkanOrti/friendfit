import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/RecipeViewModel.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/widgets/progress.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:friendfit_ready/models/recipe.dart';
import 'package:friendfit_ready/screens/recipe_detail.dart';

class RecipeSearch extends SearchDelegate<String> {
  Future<QuerySnapshot>? searchResultsFuture;
  RecipeViewModel model = serviceLocator<RecipeViewModel>();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
            showSuggestions(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            color: Color(0xFF545D68),
            progress: transitionAnimation),
        onPressed: () {
          close(context, "");
        });
  }

  @override
  buildResults(BuildContext context) {
    if (query.length > 2) {
      return FutureBuilder(
        future: model.searchRecipes(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          /*return ListView(
          children: snapshot.data,
        );*/

          return ListView(
            children: <Widget>[
              SizedBox(height: 15.0),
              Container(
                  color: AppColors.kBackground,
                  width: MediaQuery.of(context).size.width - 30.0,
                  height: MediaQuery.of(context).size.height - 50.0,
                  child: GridView.count(
                    crossAxisCount: 2,
                    primary: false,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 1.0,
                    childAspectRatio: 0.8,
                    children: <Widget>[
                      ...List.generate(
                        ((snapshot.data) as List<Recipe>).length,
                        (index) => _buildCard(
                            ((snapshot.data) as List<Recipe>)[index], context),
                      ),
                    ],
                  )),
              // SizedBox(height: 15.0)
            ],
          );
        },
      );
    } else {
      return Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Text("Arayacağınız sözcük iki karakterden fazla olmalıdır.",
                style:
                    TextStyle(color: AppColors.kRipple, fontFamily: "Poppins")
                // "Search term must be longer than two letters.",
                ),
          )
        ],
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(""),
    );
  }
}

Widget _buildCard(Recipe recipe, context) {
  return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 0.0),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RecipePage(recipe: recipe)),
          );
          /* await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipePage(recipe: recipe),
              ),
            );
            model.loadTasks(adminId);*/
        },
        /* Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CookieDetail(
                      assetPath: game.image,
                      cookieprice: "",
                      cookiename: game.name)));*/

        child: SizedBox(
          width: getProportionateScreenWidth(137),
          child: Column(
            children: [
              Container(
                width: getProportionateScreenWidth(170),
                height: getProportionateScreenHeight(130),
                decoration: BoxDecoration(
                  //color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(recipe.imageTitleUrl!),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                width: getProportionateScreenWidth(170),
                padding: EdgeInsets.all(
                  getProportionateScreenWidth(kDefaultPadding),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [kDefualtShadow],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      recipe.title!,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    VerticalSpacing(of: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Icon(
                        Icons.favorite,
                        size: 20,
                        color: AppColors.kRed,
                      ),
                      SizedBox(width: 5),
                      Text(recipe.likesCount.toString(),
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
        ),
      ));
}
