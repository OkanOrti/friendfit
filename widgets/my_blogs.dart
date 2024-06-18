import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/ArticleViewModel.dart';
import 'package:friendfit_ready/screens/blog_detail.dart';
import 'package:friendfit_ready/widgets/section_title.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:provider/provider.dart';
import 'cards/blog_card.dart';

class MyBlogsSection extends StatefulWidget {
  final ArticleViewModel model;
  MyBlogsSection(this.model);

  @override
  _MyBlogsSectionState createState() => _MyBlogsSectionState();
}

class _MyBlogsSectionState extends State<MyBlogsSection> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArticleViewModel>(
        create: (context) => widget.model,
        child: Consumer<ArticleViewModel>(
            builder: (context, model, child) => FutureBuilder(
                future: widget.model.getArticles(adminId),
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

                      return Column(
                        children: [
                          SectionTitle(
                            model: model,
                            title: "Faydalı Bilgiler",
                            press: () {},
                          ),
                          VerticalSpacing(of: 20),
                          Container(
                            //height:150,
                            child: SingleChildScrollView(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // AddNewGameCard(),
                                  ...List.generate(
                                    widget.model.articles.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(
                                          left: getProportionateScreenWidth(
                                              kDefaultPadding)),
                                      child: GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => BlogPage(
                                                  blog: widget
                                                      .model.articles[index]),
                                            ),
                                          );
                                          widget.model.loadArticles(adminId);
                                        },
                                        child: BlogCard(
                                          blog: widget.model.articles[index],
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
                          ),
                        ],
                      );
                  }
                })));
  }
}
