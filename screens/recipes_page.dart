import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/RecipeViewModel.dart';
import 'package:friendfit_ready/models/recipe.dart';
import 'package:friendfit_ready/screens/recipe_detail.dart';
import 'package:friendfit_ready/screens/recipesearch.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../size_config.dart';

class RecipesPage extends StatelessWidget {
  final RecipeViewModel? model = serviceLocator<RecipeViewModel>();
  RecipesPage({
    Key? key,
    //this.model
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "Tarifler",
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kRed),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF545D68)),
              onPressed: () {
                showSearch(context: context, delegate: RecipeSearch());
              },
            )
          ],
        ),
        backgroundColor: AppColors.kBackground,
        body: ChangeNotifierProvider<RecipeViewModel>(
            create: (context) => model!,
            child: Consumer<RecipeViewModel>(
                builder: (context, model, child) => FutureBuilder(
                    future: model.getRecipes(adminId),
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
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }

                          // Completed with data

                          return ListView(
                            children: <Widget>[
                              const SizedBox(height: 15.0),
                              Container(
                                  color: AppColors.kBackground,
                                  width:
                                      MediaQuery.of(context).size.width - 30.0,
                                  height:
                                      MediaQuery.of(context).size.height - 50.0,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    primary: false,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 1.0,
                                    childAspectRatio: 0.8,
                                    children: <Widget>[
                                      ...List.generate(
                                        model.recipes.length,
                                        (index) => _buildCard(
                                            model.recipes[index], context),
                                      ),
                                    ],
                                  )),
                              // SizedBox(height: 15.0)
                            ],
                          );
                      }
                    }))));
  }

  Widget _buildCard(Recipe recipe, context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 0.0),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipePage(recipe: recipe),
              ),
            );
            model!.loadRecipes(adminId);
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(recipe.imageTitleUrl!),
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
                    borderRadius: const BorderRadius.only(
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const VerticalSpacing(of: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 20,
                              color: AppColors.kRed,
                            ),
                            const SizedBox(width: 5),
                            Text(recipe.likesCount.toString(),
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
          ),
        ));
  }
}
