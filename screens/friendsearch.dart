import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/user_controller.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/profile.dart';
import 'package:friendfit_ready/screens/router.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/progress.dart';

class FriendSearch extends SearchDelegate<String> {
  final String? type;
  final DietGameViewModel? gameModel;
  final bool? isFriendSearch;

  FriendSearch({this.type, this.gameModel, this.isFriendSearch});
  Future<QuerySnapshot>? searchResultsFuture;

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
            showSuggestions(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            color: const Color(0xFF545D68),
            progress: transitionAnimation),
        onPressed: () {
          close(context, "");
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation:
            type == "2" ? FloatingActionButtonLocation.centerFloat : null,
        floatingActionButton: type == "2"
            ? FloatingActionButton.extended(
                heroTag: 'fab_new_task',
                onPressed: () async {
                  /*Navigator.pushNamed(context, '/oyunOzet',
                      arguments: gameModel);*/
                  gameModel!.addMembers();
                  Navigator.pop(context);
                },
                tooltip: '',
                backgroundColor: AppColors.kRipple,
                foregroundColor: Colors.white,
                label: const Text("Tamam"))
            : null,
        backgroundColor:
            Colors.white, //AppColors.kBackground,//  Color(0xFFE1E2EA),
        body: FutureBuilder(
          future: isFriendSearch!
              ? UserController.searchInFriends(query,
                  type: type, gameModel: gameModel)
              : UserController.searchUsers(query,
                  type: type, gameModel: gameModel),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SpinKitThreeBounce(
                  color: AppColors.kRipple, size: 20);
            } else {
              return Theme(
                data: ThemeData(primaryColor: Colors.white),
                child: ListView(
                  children: (snapshot.data) as List<UserResult>,
                ),
              );
            }
          },
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text(""),
    );
  }
}

class UserResult extends StatefulWidget {
  final User user;
  final String? type;
  final DietGameViewModel? gameModel;

  UserResult(this.user, {this.type, this.gameModel});

  @override
  UserResultState createState() => UserResultState();
}

class UserResultState extends State<UserResult> {
  final bool _value = false;

  Future<Object?>? myFuture;
  Function? okann;
  int? a;

  checkUser(User user, bool value) {
    if (value &
        !widget.gameModel!.selectedUsers
            .map((e) => e!.id)
            .contains(widget.user.id)) {
      widget.gameModel!.selectedUsers.add(user);
    } else if (value ==
        false &
            widget.gameModel!.selectedUsers
                .map((e) => e!.id)
                .contains(widget.user.id)) {
      widget.gameModel!.selectedUsers
          .removeWhere((element) => element!.id == user.id);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: widget.type == "2"
            ? Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child:
                            //model.friends[index],
                            Card(
                          child: CheckboxListTile(
                            title: Text(
                              widget.user.displayName!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.kFont,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              widget.user.username!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.kFont),
                            ),
                            secondary: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.user.photoUrl!),
                              radius: 20,
                            ),
                            autofocus: false,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            selected: widget.gameModel!.selectedUsers
                                    .map((e) => e!.id)
                                    .contains(widget.user.id)
                                ? true
                                : false,
                            dense: true,
                            value: widget.gameModel!.selectedUsers
                                    .map((e) => e!.id)
                                    .contains(widget.user.id)
                                ? true
                                : false,
                            onChanged: (bool? value) {
                              setState(() {
                                checkUser(widget.user, value!);
                              });
                            },
                          ), //CheckboxListTile
                        ))
                  ])
            : Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () =>
                        showProfile(context, profileId: widget.user.id!),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(widget.user.photoUrl!),
                      ),
                      title: Text(
                        widget.user.displayName!,
                        style: const TextStyle(
                            color: AppColors.kFont,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        widget.user.username!,
                        style: const TextStyle(color: AppColors.kFont),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 2.0,
                    color: Colors.white54,
                  ),
                ],
              ));
  }
}

showProfile(BuildContext context, {String? profileId}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Profile(
        isMain: false,
        profileId: profileId,
      ),
    ),
  );
}
