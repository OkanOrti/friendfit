// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/RecipeViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/screens/detail_screen_copy.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/widgets/progress.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:friendfit_ready/screens/detail_screen.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class DietSearch extends SearchDelegate<String> {
  Future<QuerySnapshot>? searchResultsFuture;
  final DietTaskViewModel? model;

  DietSearch(this.model);
  //DietTaskViewModel model = serviceLocator<DietTaskViewModel>();
  // var a= Provider.of<DietTaskViewModel>(context);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
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
        future: model!.searchDiets(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          return ListView(
            children: <Widget>[
              const SizedBox(height: 15.0),
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
                        (snapshot.data as List<DietTask>).length,
                        (index) => _buildCard(
                            (snapshot.data as List<DietTask>)[index], context),
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
        children: const <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                  "Arayacağınız sözcük iki karakterden fazla olmalıdır.",
                  style:
                      TextStyle(color: AppColors.kRipple, fontFamily: "Poppins")
                  // "Search term must be longer than two letters.",
                  ),
            ),
          )
        ],
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text(""),
    );
  }

  Widget _buildCard(DietTask task, context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 0.0),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen_(
                  task: task,
                  model: model!,
                ),
              ),
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
                    decoration: const BoxDecoration(
                        //color: Colors.green,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: task.backgroundId != null
                            ? FadeInImage.memoryNetwork(
                                fit: BoxFit.cover,
                                image: task.backgroundId!,
                                placeholder: kTransparentImage,
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Container(
                                  // width: 100,
                                  //height: 100,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              )
                            : const Image(
                                image: AssetImage("assets/images/diet.jpg")))),
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
                        task.title!,
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
                            Text(
                                task.likesCount == null || task.likesCount == 0
                                    ? ""
                                    : task.likesCount.toString(),
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
