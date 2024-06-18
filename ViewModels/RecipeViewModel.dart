// ignore_for_file: file_names

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/models/article.dart';
import 'package:friendfit_ready/models/recipe.dart';
import 'package:friendfit_ready/screens/blog_detail.dart';

import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/recipe_detail.dart';

import 'package:friendfit_ready/services/RecipeRequest/RecipeRequestService.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

class RecipeViewModel extends ChangeNotifier {
  final RecipeRequestService _recipeRequestService =
      serviceLocator<RecipeRequestService>();
  List<Recipe> recipes = [];
  bool isLoaded = false;
  bool isLiked = false;
  int likeCount = 0;

  Future<void> getRecipes(String ownerId) async {
    final recipesDocs = await _recipeRequestService.getRecipes(ownerId);
    recipes = [];
    recipesDocs.forEach((doc) {
      Recipe recipe = Recipe.fromDocument(doc);

      recipes.add(recipe);
    });
    debugPrint('gets articles finished');
  }

  Future<void> loadRecipes(String ownerId) async {
    await getRecipes(ownerId);

    isLoaded = true;
    debugPrint('load articles finished');
    notifyListeners();
  }

  Future<void> setRecipesIndexes() async {
    final recipesDocsforIndexes =
        await _recipeRequestService.getRecipes(adminId);
    List<String> indexes = [];
    recipesDocsforIndexes.forEach((doc) async {
      Recipe recipe = Recipe.fromDocument(doc);

      for (int i = 1; i <= recipe.title!.length; i++) {
        String subString = recipe.title!.substring(0, i).toLowerCase();
        indexes.add(subString);
      }

      await recipesRef
          .doc(adminId)
          .collection('userRecipes')
          .doc(recipe.id)
          .update({"indexes": indexes});
    });
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    var val = await recipesRef
        .doc(adminId)
        .collection('userRecipes')
        .where("indexes", arrayContains: query.toLowerCase())
        .get();

    List<Recipe> searchResults = [];
    val.docs.forEach((doc) {
      Recipe recipe = Recipe.fromDocument(doc);
      //BuildCard card = BuildCard(recipe);

      searchResults.add(recipe);
    });
    final suggestionList = searchResults
        .where((p) => p.title!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return suggestionList;
  }

  Future<void> isLikedControl(String postId, String currentUserId) async {
    Map likes =
        await _recipeRequestService.isLikeControl(postId, currentUserId);

    if (likes.isEmpty) {
      isLiked = false;
    } else if (likes.containsKey(currentUserId)) {
      isLiked = likes[currentUserId];
    } else
      isLiked = false;

    notifyListeners();
  }

  handleLikeRecipe(String postId, String currentUserId, String ownerId) async {
    //Map likes = await _RecipeRequestService.getArticleLikes(postId);
    likeCount = await _recipeRequestService.getRecipeLikesCount(postId);

    if (isLiked) {
      await recipesRef
          .doc(ownerId)
          .collection('userRecipes')
          .doc(postId)
          .update({'likes.$currentUserId': false});

      likeCount -= 1;
      isLiked = false;

      recipesRef
          .doc(ownerId)
          .collection('userRecipes')
          .doc(postId)
          .update({'likesCount': likeCount});
    } else if (!isLiked) {
      await recipesRef
          .doc(ownerId)
          .collection('userRecipes')
          .doc(postId)
          .update({'likes.$currentUserId': true});

      likeCount += 1;
      recipesRef
          .doc(ownerId)
          .collection('userRecipes')
          .doc(postId)
          .update({'likesCount': likeCount});
      isLiked = true;
    }
    notifyListeners();
  }
}

class BuildCard extends StatelessWidget {
  final Recipe recipe;

  BuildCard(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        //color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipePage(recipe: recipe),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        CachedNetworkImageProvider(recipe.imageTitleUrl!),
                  ),
                  title: Text(
                    recipe.title!,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
