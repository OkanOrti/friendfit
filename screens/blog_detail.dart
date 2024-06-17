import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/ArticleViewModel.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/models/article.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/circular_clipper.dart';
import 'package:friendfit_ready/widgets/content_scroll.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_icons/flutter_icons.dart';

import 'home.dart';

class BlogPage extends StatefulWidget {
  final Article? blog;

  BlogPage({this.blog});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  ArticleViewModel model = serviceLocator<ArticleViewModel>();
  final String currentUserId = currentUser!.id!;

  @override
  void initState() {
    model.isLikedControl(widget.blog!.id!, currentUserId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      //color set to transperent or set your own color
    ));*/
    return ChangeNotifierProvider<ArticleViewModel>(
        create: (context) => model,
        child: Consumer<ArticleViewModel>(
            builder: (context, model, child) => Scaffold(
                  /*  appBar: AppBar(
                      backgroundColor: Colors.transparent,
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
                            model.handleLikePost(
                                widget.blog.id, currentUserId, adminId);
                          },
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.share_rounded, color: Color(0xFF545D68)),
                          onPressed: () {},
                        )
                      ],
                      /*title: Text(
                        widget.blog.title,
                        style: TextStyle(color: AppColors.kFont),
                      ),*/
                      centerTitle: false,
                    ),*/
                  backgroundColor: Colors.white,
                  body: ListView(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            // color: Colors.blue,
                            transform:
                                Matrix4.translationValues(0.0, -30.0, 0.0),
                            child: Hero(
                              tag: widget.blog!.imageTitleUrl!,
                              child: ClipShadowPath(
                                clipper: CircularClipper(),
                                shadow: Shadow(
                                    blurRadius: 10.0,
                                    color: AppColors.kBackground),
                                child: Image(
                                  height: 200.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(widget.blog!
                                      .imageTitleUrl!), // AssetImage(widget.blog.imageTitleUrl),
                                ),
                              ),
                            ),
                          ),
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
                              IconButton(
                                iconSize: 25,
                                icon: model.isLiked
                                    ? Icon(Icons.favorite,
                                        color: AppColors.kRed)
                                    : Icon(Icons.favorite_border,
                                        color: AppColors.kFont),
                                onPressed: () {
                                  model.handleLikePost(
                                      widget.blog!.id!, currentUserId, adminId);
                                },
                              )
                            ]),
                          ),
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
                              widget.blog!.title!.toUpperCase(),
                              style: TextStyle(
                                  color: AppColors.kFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: "Poppins"),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              //height: 120.0,
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      widget.blog!.descTitle1 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.descTitle1!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: AppColors.kFont,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog?.desc1 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc1!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog!.descImageUrl1 == null
                                          ? SizedBox(height: 0)
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl1!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle2 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle2!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog?.desc2 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc2!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog?.descImageUrl2 == null
                                          ? SizedBox(height: 0)
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl2!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle3 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle3!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog?.desc3 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc3!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog!.descImageUrl3 == null
                                          ? SizedBox(height: 0)
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl3!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle4 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle4!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog?.desc4 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc4!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog!.descImageUrl4 == null
                                          ? SizedBox(height: 0)
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl4!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle5 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle5!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog?.desc5 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc5!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog?.descImageUrl5 == null
                                          ? SizedBox(height: 0)
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl5!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle6 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle6!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog!.desc6 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc6!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog?.descImageUrl6 == null
                                          ? SizedBox(height: 0)
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl6!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle7 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle7!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog?.desc7 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc7!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog?.descImageUrl7 == null
                                          ? Container()
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl7!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle8 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle8!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog?.desc8 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc8!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog!.descImageUrl8 == null
                                          ? Container()
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl8!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle9 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle9!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog?.desc9 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc9!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog?.descImageUrl9 == null
                                          ? Container()
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl9!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.descTitle10 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.descTitle10!,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                      widget.blog?.desc10 == null
                                          ? SizedBox(height: 0) //Text("")
                                          : Text(
                                              "   " + widget.blog!.desc10!,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: "Poppins"),
                                            ),
                                      widget.blog?.descImageUrl10 == null
                                          ? Container()
                                          : ContentScroll(
                                              images:
                                                  widget.blog!.descImageUrl10!,
                                              title: 'Screenshots',
                                              imageHeight: 200.0,
                                              imageWidth: 250.0,
                                            ),
                                      widget.blog?.sourceDesc == null
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                "   " +
                                                    widget.blog!.sourceDesc!,
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
                  ),
                )));
  }
}
