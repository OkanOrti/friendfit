// ignore_for_file: avoid_print, file_names

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/models/article.dart';
import 'package:friendfit_ready/screens/blog_detail.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/BlogRequest/BlogRequestService.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

class ArticleViewModel extends ChangeNotifier {
  final BlogRequestService _blogRequestService =
      serviceLocator<BlogRequestService>();
  List<Article> articles = [];
  bool isLoaded = false;
  bool isLiked = false;
  int likeCount = 0;

  Future<void> getArticles(String ownerId) async {
    final articlesDocs = await _blogRequestService.getArticles(ownerId);
    articles = [];
    articlesDocs.forEach((doc) {
      Article article = Article.fromDocument(doc);

      articles.add(article);
    });
    debugPrint('gets articles finished');
  }

  Future<void> loadArticles(String ownerId) async {
    await getArticles(ownerId);

    isLoaded = true;
    debugPrint('load articles finished');
    notifyListeners();
  }

  Future<void> setArticlesIndexes() async {
    final articlesDocsforIndexes =
        await _blogRequestService.getArticles(adminId);
    List<String> indexes = [];
    articlesDocsforIndexes.forEach((doc) async {
      Article article = Article.fromDocument(doc);

      var title = article.title;
      if (title != null) {
        for (int i = 1; i <= title.length; i++) {
          String subString = article.title!.substring(0, i).toLowerCase();
          indexes.add(subString);
        }
      } else {}
      await postsRef
          .doc(adminId)
          .collection('userPosts')
          .doc(article.id)
          .update({"indexes": indexes});
    });
  }

  Future<List<Article>> searchArticles(String query) async {
    var title = "";
    print("Searching");
    var val = await postsRef
        .doc(adminId)
        .collection('userPosts')
        .where("indexes", arrayContains: query.toLowerCase())
        .get();

    List<Article> searchResults = [];
    val.docs.forEach((doc) {
      Article article = Article.fromDocument(doc);
      title = article.title ?? "";
      // BuildCard blog = BuildCard(article);

      searchResults.add(article);
    });
    final suggestionList = searchResults
        .where((p) => title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return suggestionList;
  }

  Future<void> isLikedControl(String postId, String currentUserId) async {
    Map likes = await _blogRequestService.isLikeControl(postId, currentUserId);

    if (likes.isEmpty) {
      isLiked = false;
    } else if (likes.containsKey(currentUserId)) {
      isLiked = likes[currentUserId];
    } else
      isLiked = false;

    notifyListeners();
  }

  handleLikePost(String postId, String currentUserId, String ownerId) async {
    //Map likes = await _blogRequestService.getArticleLikes(postId);
    likeCount = await _blogRequestService.getArticleLikesCount(postId);

    if (isLiked) {
      await postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': false});

      likeCount -= 1;
      isLiked = false;

      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likesCount': likeCount});
    } else if (!isLiked) {
      await postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': true});

      likeCount += 1;
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likesCount': likeCount});
      isLiked = true;
    }
    notifyListeners();
  }
}

class BuildCard extends StatelessWidget {
  final Article blog;

  BuildCard(this.blog);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlogPage(blog: blog),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(blog.imageTitleUrl ?? ""),
                ),
                title: Text(
                  blog.title ?? "",
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
