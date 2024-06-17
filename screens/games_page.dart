// ignore_for_file: duplicate_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/filterscreen.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/detailGameForMember.dart';
import 'package:friendfit_ready/screens/gameSearch.dart';
import 'package:friendfit_ready/screens/recipesearch.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/cards/game_card.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../constants.dart';
import '../size_config.dart';

class GamesPage extends StatefulWidget {
  final DietGameViewModel? model;

  const GamesPage({Key? key, this.model}) : super(key: key);
  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  List<String> result = [];
  List<DietGame> test = [];
  @override
  Widget build(BuildContext context) {
    var model2 = Provider.of<DietGameViewModel>(context, listen: true);
    //final b = context.watch<DietGameViewModel>().isFiltered;
    test = result.isNotEmpty
        ? widget.model!.filterGames(result, type: true)
        : widget.model!.games;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "Yarışmalarım",
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
                showSearch(context: context, delegate: GameSearch());
              },
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Color(0xFF545D68)),
              onPressed: () async {
                result = await Navigator.of(context).push(MaterialPageRoute(
                    settings: const RouteSettings(name: "Filter"),
                    builder: (context) =>
                        FilterScreen() //MyFormPage(), // CreateGame2( gameModel: gameModel,
                    ));
                //setState(() {});
                widget.model!.refresh();
                //setState(() {
                // widget.model!.filterGames(result, type: true);
                //    });

                //showSearch(context: context, delegate: GameSearch());
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ChangeNotifierProvider<DietGameViewModel>.value(
            value: widget.model!,
            child: ListView(
              children: <Widget>[
                Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width - 30.0,
                    height: MediaQuery.of(context).size.height - 50.0,
                    child: GridView.count(
                      crossAxisCount: 2,
                      primary: false,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 1.0,
                      childAspectRatio: 0.9,
                      children: <Widget>[
                        ...List.generate(
                            test
                                .where((element) => element.id != '1')
                                .toList()
                                .length,
                            (index) => _buildCard(
                                test
                                    .where((element) => element.id != '1')
                                    .toList()[index],
                                context) /*_buildCard(
                                      widget.model.games3
                                          .where((element) => element.id != '1')
                                          .toList()[index],
                                      context),*/
                            ),
                      ],
                    )),
                // SizedBox(height: 15.0)
              ],
            )));
  }

  Widget _buildCard(DietGame game, context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 5.0, bottom: 0.0, left: 0.0, right: 0.0),
        child: InkWell(
          onTap: () async {
            /* await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GamesPage(widget.model: recipe),
              ),
            );*/
            //   widget.model!.loadRecipes(adminId);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailGameForMember(game: game)
                /*DetailGame(
                                                game: widget
                                                    .widget.model.games[index+1])*/
                ,
              ),
            );
          },
          /* Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CookieDetail(
                      assetPath: game.image,
                      cookieprice: "",
                      cookiename: game.name)));*/

          child: SizedBox(
            //width: getProportionateScreenWidth(120),
            child: Column(
              children: [
                Container(
                    width: getProportionateScreenWidth(170),
                    height: getProportionateScreenHeight(100),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: game.imageTitleUrl != null
                            ? FadeInImage.memoryNetwork(
                                fit: BoxFit.cover,
                                image: game.imageTitleUrl!,
                                placeholder: kTransparentImage,
                              )
                            : const Image(
                                image: AssetImage("assets/images/diet.jpg")))
                    /* image: DecorationImage(
                        image: CachedNetworkImageProvider(game.imageTitleUrl!),
                        fit: BoxFit.cover),*/
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
                        game.title!,
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
                            Text(game.status2!,
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    color: Colors.blueGrey)),
                            // Image(width:15,height:15,image: AssetImage("assets/images/yellowCircle.png")),
                            //ClipOval(child: Material(elevation:5,shadowColor: Colors.black26, child: Container(width:10,height:10,color: game.isActive ? Colors.green:Colors.blueGrey))),

                            const Spacer(),
                            Icon(
                              Icons.people,
                              size: 20,
                              color: AppColors.kRipple.withOpacity(0.7),
                            ),
                            const SizedBox(width: 5),
                            Text((game.memberIds!.length + 1).toString(),
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    color: AppColors.kFont))
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
