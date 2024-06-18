import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/RecipeViewModel.dart';
import 'package:friendfit_ready/screens/blog_detail.dart';
import 'package:friendfit_ready/screens/recipe_detail.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/widgets/section_title.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:friendfit_ready/widgets/section_title_recipe.dart';
import 'package:provider/provider.dart';
import 'cards/blog_card.dart';
import 'cards/recipe_card.dart';

class MyRecipesSection extends StatefulWidget {
  final RecipeViewModel model;
  MyRecipesSection(this.model);

  @override
  _MyRecipesSectionState createState() => _MyRecipesSectionState();
}

class _MyRecipesSectionState extends State<MyRecipesSection> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeViewModel>(
        create: (context) => widget.model,
        child: Consumer<RecipeViewModel>(
            builder: (context, model, child) => FutureBuilder(
                future: widget.model.getRecipes(adminId),
                // initialData: InitialData,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    // Uncompleted State
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                      break;
                    default:
                      // Completed with error
                      if (snapshot.hasError)
                        return Container(
                            child: Text(snapshot.error.toString()));

                      // Completed with data

                      return Column(
                        children: [
                          SectionTitleRecipe(
                            model: model,
                            title: "Güncel Tarifler",
                            press: () {},
                          ),
                          VerticalSpacing(of: 20),
                          Container(
                            //height:150,
                            child: SingleChildScrollView(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // AddNewGameCard(),
                                  ...List.generate(
                                    widget.model.recipes.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(
                                          left: getProportionateScreenWidth(
                                              kDefaultPadding)),
                                      child: GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => RecipePage(
                                                  recipe: widget
                                                      .model.recipes[index]),
                                            ),
                                          );
                                          widget.model.loadRecipes(adminId);
                                        },
                                        child: RecipeCard(
                                          recipe: widget.model.recipes[index],
                                          press: () {},
                                        ),
                                      ),
                                    ),
                                  ), //..shuffle(),
                                  SizedBox(
                                    width: getProportionateScreenWidth(
                                        kDefaultPadding),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                  }
                })));
  }
}
