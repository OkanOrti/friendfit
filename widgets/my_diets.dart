import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/screens/detail_screen_copy.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/section_title_diets.dart';
import 'package:provider/provider.dart';
import 'cards/diet_card.dart';

class MyDietsSection extends StatefulWidget {
  final DietTaskViewModel model;
  const MyDietsSection(this.model, {Key? key}) : super(key: key);

  @override
  _MyDietsSectionState createState() => _MyDietsSectionState();
}

class _MyDietsSectionState extends State<MyDietsSection> {
  Future<void>? future;
  @override
  void initState() {
    super.initState();
    future = deneme2();
  }

  Future<void> deneme2() async {
    await widget.model.getTasks(currentUser!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DietTaskViewModel>.value(
        value: widget.model,
        child: Consumer<DietTaskViewModel>(
            builder: (context, model, child) => FutureBuilder(
                future: future, //widget.model.getTasks(currentUser!.id!),
                // initialData: InitialData,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    // Uncompleted State
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                          child: SpinKitThreeBounce(
                              color: AppColors.kRipple, size: 20));
                    default:
                      // Completed with error
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      // Completed with data

                      return Column(
                        children: [
                          SectionTitleDiet(
                            model: model,
                            title: "Diet Planları",
                            press: () {},
                          ),
                          const VerticalSpacing(of: 20),
                          SingleChildScrollView(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: AddNewDietCard(
                                    model: widget.model,
                                  ),
                                ),
                                ...List.generate(
                                  widget.model.tasks.length > 5
                                      ? 5
                                      : widget.model.tasks.length,
                                  (index) => Padding(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenWidth(
                                            kDefaultPadding)),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DetailScreen_(
                                                model: widget.model,
                                                task:
                                                    widget.model.tasks[index]),
                                          ),
                                        );
                                        //        await widget.model.loadTasks(adminId);
                                      },
                                      child: DietCard(
                                        diet: widget.model.tasks[index],
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
                        ],
                      );
                  }
                })));
  }
}
