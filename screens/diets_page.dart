import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/screens/detail_screen_copy.dart';
import 'package:friendfit_ready/screens/dietsSearch.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/cards/diet_card.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../constants.dart';
import '../size_config.dart';
import 'package:friendfit_ready/data/image_card.dart';

class DietsPage extends StatelessWidget {
  final DietTaskViewModel? model; // = serviceLocator<DietTaskViewModel>();
  const DietsPage({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "Diet Planları",
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kRed),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kFont),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF545D68)),
              onPressed: () {
                showSearch(context: context, delegate: DietSearch(model));
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ChangeNotifierProvider<DietTaskViewModel>.value(
            value: model!,
            child: Consumer<DietTaskViewModel>(
                builder: (context, model, child) => FutureBuilder(
                    future: model.getTasks(adminId),
                    // initialData: InitialData,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // Uncompleted State
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                            child: SpinKitThreeBounce(
                                color: AppColors.kRipple, size: 20),
                          );
                        default:
                          // Completed with error
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }

                          // Completed with data

                          return ListView(
                            padding: const EdgeInsets.only(bottom: 10),
                            children: <Widget>[
                              //const SizedBox(height: 15.0),
                              GridView.count(
                                // padding: const EdgeInsets.only(bottom: 10),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                primary: false,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 1.0,
                                childAspectRatio: 0.8,
                                children: <Widget>[
                                  ...List.generate(
                                    model.tasks.length,
                                    (index) => /*DietCard(
                                          diet: model.tasks[index],
                                          press: () {},
                                        ),*/
                                        _buildCard(
                                            model.tasks[index], context, model),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 15.0)
                            ],
                          );
                      }
                    }))));
  }

  Widget _buildCard(DietTask task, context, DietTaskViewModel? model) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 0.0),
        child: InkWell(
          onTap: () async {
            /* await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipePage(recipe: recipe),
              ),
            );
            model.loadTasks(adminId);*/

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen_(model: model, task: task),
              ),
            );
            model!.loadTasks(adminId);
          },
          child: SizedBox(
            // width: getProportionateScreenWidth(137),
            child: Column(
              children: [
                Container(
                    width: getProportionateScreenWidth(180),
                    height: getProportionateScreenHeight(130),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),

                      /*image: DecorationImage(
                        image: choicesImages
                            .where((a) => a.id == task.backgroundId)
                            .first
                            .image as ImageProvider,
                        fit: BoxFit.cover),*/
                    ),
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
                  width: getProportionateScreenWidth(180),
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
                                (task.likesCount == null ||
                                        task.likesCount == 0)
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
