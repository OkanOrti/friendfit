// ignore_for_file: avoid_function_literals_in_foreach_calls, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/screens/profile.dart';

class MemberStatusReview extends StatefulWidget {
  final DietGame? game;
  final DietGameViewModel? gameModel;
  const MemberStatusReview({Key? key, this.game, this.gameModel})
      : super(key: key);

  @override
  _MemberStatusReviewState createState() => _MemberStatusReviewState();
}

class _MemberStatusReviewState extends State<MemberStatusReview>
    with SingleTickerProviderStateMixin {
  final DietGameViewModel gameModelNew = serviceLocator<DietGameViewModel>();

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    /*gameModelNew.getMemberStatus(
        widget.game!.memberIds!, widget.game!.id!, widget.game!.gameOwnerId!,
        gameMembers: widget.gameModel!.gameMembers);*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DietGameViewModel>.value(
        //create: (context) => gameModelNew,
        value: widget.gameModel!,
        child: Consumer<DietGameViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.kFont,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: const Text("Katılım Durumu",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            color: AppColors.kFont)),
                    bottom: TabBar(
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.amber,
                      tabs: [
                        Tab(
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                              "Kabul ",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: AppColors.kRipple),
                            ),
                            Text(
                              "(" +
                                  widget.gameModel!.usersApproved.length
                                      .toString() +
                                  ")",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: AppColors.kRipple),
                            ),
                          ]),
                        ),
                        Tab(
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                              "Red ",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: AppColors.kRipple),
                            ),
                            Text(
                              "(" +
                                  widget.gameModel!.usersDenied.length
                                      .toString() +
                                  ")",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  color: AppColors.kRipple),
                            ),
                          ]),
                        ),
                        Tab(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(
                                "Yanıt Yok ",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: AppColors.kRipple),
                              ),
                              Text(
                                "(" +
                                    widget.gameModel!.usersNoResponse.length
                                        .toString() +
                                    ")",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: AppColors.kRipple),
                              ),
                            ]),
                          ),
                        ),
                      ],
                      controller: _tabController,
                      indicatorColor: AppColors.kRipple,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    bottomOpacity: 1,
                  ),
                  backgroundColor: Colors.white,
                  body: TabBarView(
                    children: [
                      ListView(
                        children:
                            buildApprovals(widget.gameModel!.usersApproved),
                      ),
                      // new Text("This is call Tab View"),
                      ListView(
                        children: buildApprovals(widget.gameModel!.usersDenied),
                      ),
                      ListView(
                        children:
                            buildApprovals(widget.gameModel!.usersNoResponse),
                      ),
                    ],
                    controller: _tabController,
                  ),
                )));
  }

  List<UserResult> buildApprovals(List<User> usersApproved) {
    List<UserResult> results = [];
    usersApproved.forEach((element) {
      UserResult result = UserResult(element);
      results.add(result);
    });
    return results;
  }
}

class UserResult extends StatelessWidget {
  final User user;

  const UserResult(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id!),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(user.photoUrl ?? "-"),
                ),
                title: Text(
                  user.displayName ?? "",
                  style: TextStyle(
                      color: AppColors.kFont, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user.username ?? "",
                  style: TextStyle(color: AppColors.kFont),
                ),
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
}
