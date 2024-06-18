import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:friendfit_ready/screens/friendsearch.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

class UserController {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static User? user;

  static Future<List<UserResult>> searchUsers(String query,
      {String? type, DietGameViewModel? gameModel}) async {
    var val = await fireStore
        .collection("users")
        .where("indexes", arrayContains: query.toLowerCase())
        .get();

    List<UserResult> searchResults = [];
    val.docs.forEach((doc) {
      User user = User.fromDocument(doc);
      UserResult searchResult = UserResult(
        user,
        gameModel: gameModel,
        type: type,
      );
      searchResults.add(searchResult);
    });
    final suggestionList = searchResults
        .where((p) =>
            p.user.displayName!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return suggestionList;
  }

  static Future<List<UserResult>> searchInFriends(String query,
      {String? type, DietGameViewModel? gameModel}) async {
    var val = await fireStore
        .collection("friends")
        .doc("107365145190474931901" /*currentUser!.id*/)
        .collection("userFriends")
        .get();

    List<String> friendsID = [];

    val.docs.forEach((element) {
      friendsID.add(element.id);
    });

    var val2 = await fireStore
        .collection("users")
        .where("id", whereIn: friendsID)
        .where("indexes", arrayContains: query.toLowerCase())
        .get();

    List<UserResult> searchResults = [];
    val2.docs.forEach((doc) {
      User user = User.fromDocument(doc);
      UserResult searchResult = UserResult(
        user,
        gameModel: gameModel,
        type: type,
      );
      searchResults.add(searchResult);
    });
    final suggestionList = searchResults
        .where((p) =>
            p.user.displayName!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return suggestionList;
  }
}
