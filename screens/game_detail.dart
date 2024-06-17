import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/ArticleViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/models/game.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/circular_clipper.dart';
import 'package:friendfit_ready/widgets/content_scroll.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../size_config.dart';
import 'home.dart';

class GamePage extends StatefulWidget {
  final DietGame? game;

  GamePage({this.game});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  DietGameViewModel model = serviceLocator<DietGameViewModel>();
  final String currentUserId = currentUser!.id!;

  @override
  void initState() {
    // model.isLikedControl(widget.game!.id!, currentUserId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DietGameViewModel>(
        create: (context) => model,
        child: Consumer<DietGameViewModel>(
            builder: (context, model, child) => Scaffold(
                /*appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF545D68),
                      ),
                      onPressed: () => (Navigator.of(context).pop(true)),
                    ),
                    actions: [
                      IconButton(
                        icon: model.isLiked
                            ? Icon(Icons.favorite, color: AppColors.kRed)
                            : Icon(Icons.favorite_border,
                                color: Color(0xFF545D68)),
                        onPressed: () {
                          model.handleLikegame(
                              widget.game.id, currentUserId, adminId);
                        },
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.share_rounded, color: Color(0xFF545D68)),
                        onPressed: () {},
                      )
                    ],
                    title: Text(
                      widget.game.title,
                      style: TextStyle(color: AppColors.kFont),
                    ),
                    centerTitle: false,
                  ),*/
                backgroundColor: Colors.white,
                body:
                    SizedBox() /*ListView(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            transform:
                                Matrix4.translationValues(0.0, -30.0, 0.0),
                            child: Hero(
                              tag: widget.game!.imageTitleUrl!,
                              child: ClipShadowPath(
                                clipper: CircularClipper(),
                                shadow: Shadow(
                                    blurRadius: 10.0,
                                    color: AppColors.kBackground),
                                child: Image(
                                  height: 200.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(widget
                                      .game!
                                      .imageTitleUrl!), // AssetImage(widget.game.imageTitleUrl),
                                ),
                              ),
                            ),
                          ),
                          /* Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.only(left: 10.0),
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.arrow_back),
                                iconSize: 25.0,
                                color: Colors.white,
                              ),
                              //Spacer(),
                            ],
                          ),*/
                          Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              child: Row(children: [
                                IconButton(
                                  padding: EdgeInsets.only(left: 10.0),
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(Icons.arrow_back_rounded),
                                  iconSize: 25.0,
                                  color: AppColors.kFont,
                                ),
                              /*  IconButton(
                                  iconSize: 25,
                                  icon: model.isLiked
                                      ? Icon(Icons.favorite,
                                          color: AppColors.kRed)
                                      : Icon(Icons.favorite_border,
                                          color: AppColors.kFont),
                                  onPressed: () {
                                    model.handleLikegame(widget.game!.id!,
                                        currentUserId, adminId);
                                  },
                                ),*/
                              ])),
                          Positioned(
                              bottom: 0.0,
                              right: 20.0,
                              child: IconButton(
                                iconSize: 25,
                                icon: Icon(Icons.share_rounded,
                                    color: AppColors.kFont),
                                onPressed: () {},
                              )),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.game!.title!.toUpperCase(),
                              style: TextStyle(
                                  color: AppColors.kFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: "Poppins"),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(widget.game!.calorie!,
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.kRed)),
                                    Text("Kalori",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            color: Colors.black))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(widget.game!.serves!,
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.kRed)),
                                    Text("Porsiyon",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            color: Colors.black))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(widget.game!.cookingTime!,
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.kRed)),
                                    Text("Pişirme Süresi",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            color: Colors.black))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              //height: 120.0,
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.game!.ingredientTitle!
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: AppColors.kFont,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            fontFamily: "Poppins"),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),

                                      /*  GridView.count(shrinkWrap: true,
                                    crossAxisCount: 2,
                                    primary: false,
                                    crossAxisSpacing: 20.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio:MediaQuery.of(context).size.height / 200,// 3,
                                    children: <Widget>[
                                        ...List.generate(
                                          widget.game.ingredients.length,
                                          (index) => Padding(
                                            padding: EdgeInsets.only(bottom: 0),
                                            child: IngredientsCard(
                                                ingredient: widget
                                                    .game.ingredients[index]),
                                          ),
                                        )]),*/
                                      ...List.generate(
                                        widget.game!.ingredients!.length,
                                        (index) => Padding(
                                          padding: EdgeInsets.only(bottom: 0),
                                          child: IngredientsCard(
                                              ingredient: widget
                                                  .game!.ingredients![index]),
                                        ),
                                      ),
                                      Divider(height: 1, color: Colors.grey),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.game!.methodTitle1!
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: AppColors.kFont,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: "Poppins"),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      ...List.generate(
                                        widget.game!.method1!.length,
                                        (index) => Padding(
                                          padding: EdgeInsets.only(bottom: 0),
                                          child: MethodCard(
                                              method: widget
                                                  .game!.method1![index]),
                                        ),
                                      ),
                                      widget.game!.sourceDesc == null
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                "   " +
                                                    widget.game!.sourceDesc!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.black54,
                                                    fontSize: 10,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),*/
                )));
  }
}

class IngredientsCard extends StatelessWidget {
  final String? ingredient;
  IngredientsCard({this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color:Colors.blue,
      child: Column(children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start, //mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              size: 15,
              color: AppColors.kRed,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(ingredient!,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                      color: AppColors.kFont,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      fontFamily: "Poppins")),
            ),
          ],
        ),
        SizedBox(height: 5)
      ]),
    );
  }
}

class MethodCard extends StatelessWidget {
  final String? method;
  MethodCard({this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color:Colors.blue,
      child: Column(children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start, //mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_forward_sharp,
              size: 15,
              color: AppColors.kRed,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(method!,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                      color: AppColors.kFont,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      fontFamily: "Poppins")),
            ),
          ],
        ),
        SizedBox(height: 10)
      ]),
    );
  }
}
