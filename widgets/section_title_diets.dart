import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import '../constants.dart';
import '../size_config.dart';
import 'package:friendfit_ready/screens/diets_page.dart';

class SectionTitleDiet extends StatelessWidget {
  final DietTaskViewModel? model;
  SectionTitleDiet({
    Key? key,
    @required this.title,
    @required this.model,
    @required this.press,
  }) : super(key: key);

  final String? title;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(kDefaultPadding),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                title!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.kFont,
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              //Icon(Icons.supervised_user_circle,color: Colors.black,)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DietsPage(
                            model: model,
                          )));
              //  model!.loadTasks(currentUser!.id!);
            },
            child: Text(
              "Tümü",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.kFont,
                fontSize: getProportionateScreenWidth(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
