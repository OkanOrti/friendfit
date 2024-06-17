import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/ArticleViewModel.dart';
import 'package:friendfit_ready/models/article.dart';
import 'package:friendfit_ready/screens/blogsearch.dart';
import 'package:friendfit_ready/screens/friendsearch.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../size_config.dart';
import 'blog_detail.dart';

class BlogsPage extends StatelessWidget {
  final ArticleViewModel model = serviceLocator<ArticleViewModel>();
  BlogsPage({
    Key? key,
    //this.model
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Yazılar",
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kRed),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Color(0xFF545D68)),
              onPressed: () {
                showSearch(context: context, delegate: BlogSearch());
              },
            )
          ],
        ),
        backgroundColor: AppColors.kBackground,
        body: ChangeNotifierProvider<ArticleViewModel>(
            create: (context) => model,
            child: Consumer<ArticleViewModel>(
                builder: (context, model, child) => FutureBuilder(
                    future: model.getArticles(adminId),
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

                          return ListView(
                            children: <Widget>[
                              SizedBox(height: 15.0),
                              Container(
                                  color: AppColors.kBackground,
                                  width:
                                      MediaQuery.of(context).size.width - 30.0,
                                  height:
                                      MediaQuery.of(context).size.height - 50.0,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    primary: false,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 1.0,
                                    childAspectRatio: 0.8,
                                    children: <Widget>[
                                      ...List.generate(
                                        model.articles.length,
                                        (index) => _buildCard(
                                            model.articles[index], context),
                                      ),
                                    ],
                                  )),
                              // SizedBox(height: 15.0)
                            ],
                          );
                      }
                    }))));
  }

  Widget _buildCard(Article blog, context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 0.0),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlogPage(blog: blog),
              ),
            );
            model.loadArticles(adminId);
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
                  decoration: BoxDecoration(
                    //color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(blog.imageTitleUrl!),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  width: getProportionateScreenWidth(170),
                  padding: EdgeInsets.all(
                    getProportionateScreenWidth(kDefaultPadding),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [kDefualtShadow],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        blog.title!,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      VerticalSpacing(of: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 20,
                              color: AppColors.kRed,
                            ),
                            SizedBox(width: 5),
                            Text(blog.likesCount.toString(),
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
          ),
        ));
  }
}
