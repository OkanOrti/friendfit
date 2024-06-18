// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/ViewModels/MainPageViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:friendfit_ready/screens/friendsearch.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/section_title.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyParticipantsSection extends StatefulWidget {
  final MainPageViewModel model;
  final DietGameViewModel? gameModel;
  final String? type;
  final String? id;
  const MyParticipantsSection(this.model,
      {Key? key, this.id, this.type, this.gameModel})
      : super(key: key);

  @override
  _MyParticipantsSectionState createState() => _MyParticipantsSectionState();
}

class _MyParticipantsSectionState extends State<MyParticipantsSection> {
  final bool _value = false;

  Future<Object?>? myFuture;
  Function? okann;
  int? a;

  checkUser(User user, bool value) {
    if (value &
        !widget.gameModel!.selectedUsers.map((e) => e!.id).contains(user.id)) {
      widget.gameModel!.selectedUsers.add(user);
    } else if (value ==
        false &
            widget.gameModel!.selectedUsers
                .map((e) => e!.id)
                .contains(user.id)) {
      widget.gameModel!.selectedUsers
          .removeWhere((element) => element!.id == user.id);
    }
  }

  checkUserForSaved(User user, bool value) {
    if (value &
        !widget.gameModel!.selectedMembers.map((e) => e.id).contains(user.id)) {
      widget.gameModel!.selectedMembers.add(user);
    } else if (value ==
        false &
            widget.gameModel!.selectedMembers
                .map((e) => e.id)
                .contains(user.id)) {
      widget.gameModel!.selectedMembers
          .removeWhere((element) => element.id == user.id);
    }
  }

  removeUser(User user) {
    if (widget.gameModel!.members.map((e) => e.id).contains(user.id)) {
      widget.gameModel!.members.removeWhere((element) => element.id == user.id);
      var a = 5;
    }
    if (widget.gameModel!.selectedMembers.map((e) => e.id).contains(user.id)) {
      var c = 6;
      widget.gameModel!.selectedMembers
          .removeWhere((element) => element.id == user.id);
    }
    if (widget.gameModel!.selectedUsers.map((e) => e!.id).contains(user.id)) {
      var c = 6;
      widget.gameModel!.selectedUsers
          .removeWhere((element) => element!.id == user.id);
    }
    var b = 5;
  }

  Future<void> fetchData() async {
    await widget.model.loadMainPage(currentUser!.id!);
    /*  await Future.delayed(const Duration(seconds: 10), () {
      // 5 seconds over, navigate to Page2.
    });*/
  }

  @override
  void initState() {
    myFuture = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(x.currentUser!.id!);
    return //  ChangeNotifierProvider.value

        FutureBuilder(
            future: myFuture,
            // initialData: InitialData,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // Uncompleted State
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return widget.type == "2"
                      ? const Center(child: CircularProgressIndicator())
                      : Flexible(
                          fit: FlexFit.loose,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, __) => Padding(
                                padding: const EdgeInsets.only(bottom: 40.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      width: 48.0,
                                      height: 48.0,
                                      //color: Colors.white,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: 40.0,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              itemCount: 20,
                            ),
                          ),
                        );

                /*Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  //enabled: _enabled,
                  child: ListView.builder(
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 60.0,
                            height: 60.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: 40.0,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    itemCount: 6,
                  ),
                ),
              );*/

                default:
                  // Completed with error
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  /*widget.type == "1"
                      ? widget.gameModel!
                          .getFriendsExceptMembers(widget.model.friends)
                      : null;*/

                  // Completed with data
                  return widget.type == "1"
                      ? Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,s
                          children: [
                              ...List.generate(
                                  widget
                                      .gameModel!
                                      .members // widget.gameModel!.friendsNoMembers
                                      .length, // 4,//myFriends.length,
                                  (index) => Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child:
                                          //widget.model.friends[index],
                                          Card(
                                        child: CheckboxListTile(
                                          title: Text(
                                            widget.gameModel!.members[index]
                                                    .displayName ??
                                                "",
                                            /*widget
                                                .gameModel!
                                                .friendsNoMembers[index]
                                                .displayName!,*/
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: AppColors.kFont,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            widget.gameModel!.members[index]
                                                    .username ??
                                                "",

                                            /*widget
                                                .gameModel!
                                                .friendsNoMembers[index]
                                                .username!,*/
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: AppColors.kFont),
                                          ),
                                          secondary: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    widget
                                                            .gameModel!
                                                            .members[index]
                                                            .photoUrl ??
                                                        ""),
                                            /*CachedNetworkImageProvider(
                                                    widget
                                                        .gameModel!
                                                        .friendsNoMembers[index]
                                                        .photoUrl!),*/
                                            radius: 20,
                                          ),
                                          autofocus: false,
                                          activeColor: Colors.green,
                                          checkColor: Colors.white,
                                          selected: widget
                                                  .gameModel!.selectedMembers
                                                  .map((e) => e.id)
                                                  .contains(widget.gameModel!
                                                      .members[index].id)

                                              /*widget
                                                  .gameModel!.selectedUsers
                                                  .map((e) => e!.id)
                                                  .contains(widget
                                                      .gameModel!
                                                      .friendsNoMembers[index]
                                                      .id)*/
                                              ? true
                                              : false, //_value,
                                          dense: true,
                                          value: widget
                                                  .gameModel!.selectedMembers
                                                  .map((e) => e.id)
                                                  .contains(widget.gameModel!
                                                      .members[index].id)
                                              /*widget.gameModel!.selectedUsers
                                                  .map((e) => e!.id)
                                                  .contains(widget
                                                      .gameModel!
                                                      .friendsNoMembers[index]
                                                      .id)*/

                                              ? true
                                              : false,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              checkUserForSaved(
                                                  widget.gameModel!
                                                      .members[index],

                                                  /* widget.gameModel!
                                                      .friendsNoMembers[index],*/
                                                  value!);
                                            });
                                          },
                                        ), //CheckboxListTile
                                      )))
                            ])
                      : widget.type == "3"
                          ? Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,s
                              children: [
                                  ...List.generate(
                                      widget
                                          .gameModel!
                                          .members // widget.gameModel!.friendsNoMembers
                                          .length, // 4,//myFriends.length,
                                      (index) => Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child:
                                              //widget.model.friends[index],
                                              Slidable(
                                            key: const ValueKey(1),
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              dismissible: DismissiblePane(
                                                  onDismissed: () {
                                                removeUser(widget
                                                    .gameModel!.members[index]);
                                              }),
                                              children: [
                                                SlidableAction(
                                                  onPressed:
                                                      (BuildContext context) {
                                                    setState(() {
                                                      removeUser(widget
                                                          .gameModel!
                                                          .members[index]);
                                                    });
                                                  },
                                                  backgroundColor:
                                                      Color(0xFFFE4A49),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'Delete',
                                                ),
                                              ],
                                            ),
                                            child: Card(
                                              child: ListTile(
                                                title: Text(
                                                  widget
                                                          .gameModel!
                                                          .members[index]
                                                          .displayName ??
                                                      "",
                                                  /*widget
                                                  .gameModel!
                                                  .friendsNoMembers[index]
                                                  .displayName!,*/
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: AppColors.kFont,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  widget
                                                          .gameModel!
                                                          .members[index]
                                                          .username ??
                                                      "",

                                                  /*widget
                                                  .gameModel!
                                                  .friendsNoMembers[index]
                                                  .username!,*/
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: AppColors.kFont),
                                                ),
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          widget
                                                                  .gameModel!
                                                                  .members[
                                                                      index]
                                                                  .photoUrl ??
                                                              ""),
                                                  /*CachedNetworkImageProvider(
                                                      widget
                                                          .gameModel!
                                                          .friendsNoMembers[index]
                                                          .photoUrl!),*/
                                                  radius: 20,
                                                ),
                                                autofocus: false,

                                                selected: widget.gameModel!
                                                        .selectedMembers
                                                        .map((e) => e.id)
                                                        .contains(widget
                                                            .gameModel!
                                                            .members[index]
                                                            .id)

                                                    /*widget
                                                    .gameModel!.selectedUsers
                                                    .map((e) => e!.id)
                                                    .contains(widget
                                                        .gameModel!
                                                        .friendsNoMembers[index]
                                                        .id)*/
                                                    ? true
                                                    : false, //_value,
                                                dense: true,
                                              ), //CheckboxListTile
                                            ),
                                          )))
                                ])

                          //////////////////////////////////
                          : Column(
                              children: [
                                SectionTitle(
                                  title: "Arkadaşlarım (" +
                                      widget.model.friends.length.toString() +
                                      ")",
                                  press: () {},
                                  model: null,
                                ),
                                const VerticalSpacing(of: 20),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: getProportionateScreenWidth(
                                          kDefaultPadding),
                                    ),
                                    // padding: EdgeInsets.all(getProportionateScreenWidth(24)),
                                    // height: getProportionateScreenWidth(143),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      // color: Colors.white,
                                      boxShadow: [kDefualtShadow],
                                    ),
                                    child: SingleChildScrollView(
                                      clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const AddNewFriendCard(),
                                          ...List.generate(
                                              widget.model.friends
                                                  .length, // 4,//myFriends.length,
                                              (index) => Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getProportionateScreenWidth(
                                                            kDefaultPadding)),
                                                    child: FriendsCard(
                                                      user: widget
                                                          .model.friends[index],
                                                      press: () {},
                                                    ),
                                                  ))
                                            ..shuffle(),
                                        ],
                                      ),
                                    ))
                              ],
                            );
              }
            });
  }
}

class FriendsCard extends StatelessWidget {
  const FriendsCard({
    Key? key,
    @required this.user,
    @required this.press,
  }) : super(key: key);

  final User? user;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user!.photoUrl!),
          ),
          const VerticalSpacing(of: 10),
          Text(
            user!.displayName!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class AddNewFriendCard extends StatelessWidget {
  const AddNewFriendCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: GestureDetector(
        onTap: () => {showSearch(context: context, delegate: FriendSearch())},
        child: Column(children: [
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [kDefualtShadow2, kDefualtShadow3]),
              child: const Icon(Icons.add, size: 20, color: AppColors.kRed)),
          const VerticalSpacing(of: 10),
          const Text(
            "",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ]),
      ),
    );
  }
}

void doNothing(BuildContext context, User? user) {}
