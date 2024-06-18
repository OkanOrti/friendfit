// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/models/UserTest.dart';
import 'package:friendfit_ready/models/article.dart';
import 'package:friendfit_ready/models/blog.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:friendfit_ready/models/game.dart';
import '../../constants.dart';
import '../../size_config.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    Key? key,
    @required this.blog,
    this.isFullCard = false,
    @required this.press,
  }) : super(key: key);

  final Article? blog;
  final bool? isFullCard;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: getProportionateScreenWidth(150),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.4,
              child: Hero(
                tag: blog!.imageTitleUrl!,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(blog!.imageTitleUrl!),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Container(
              width: getProportionateScreenWidth(150),
              padding: EdgeInsets.all(
                getProportionateScreenWidth(kDefaultPadding / 2),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kDefualtShadow2, kDefualtShadow3],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    blog!.title!,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isFullCard! ? 17 : 12,
                    ),
                  ),
                  VerticalSpacing(of: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      Icons.favorite,
                      size: 16,
                      color: AppColors.kRed,
                    ),
                    SizedBox(width: 5),
                    Text(blog!.likesCount.toString(),
                        style: TextStyle(
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
      );
    });
  }
}

class AddNewBlogCard extends StatelessWidget {
  const AddNewBlogCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Container(
          width: 50,
          height: 50,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Icon(Icons.add, size: 20, color: AppColors.kRed)),
    );
  }
}
