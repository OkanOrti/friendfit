import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/ArticleViewModel.dart';
import 'package:friendfit_ready/screens/blogs_page.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import '../constants.dart';
import '../size_config.dart';

class SectionTitle extends StatelessWidget {
  final ArticleViewModel? model;
  SectionTitle({
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
          const Spacer(),
          GestureDetector(
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BlogsPage()));
              await model!.loadArticles(adminId);
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
