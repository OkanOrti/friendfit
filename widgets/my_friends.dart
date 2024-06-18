// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

typedef StringValue = void Function(int);

class MyFriendsSection extends StatefulWidget {
  final MainPageViewModel model;
  final DietGameViewModel? gameModel;
  final String? type;
  final String? id;
  final StringValue? callback;
  const MyFriendsSection(this.model,
      {Key? key, this.id, this.type, this.gameModel, this.callback})
      : super(key: key);

  @override
  _MyFriendsSectionState createState() => _MyFriendsSectionState();
}

class _MyFriendsSectionState extends State<MyFriendsSection> {
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

  Future<void> fetchData() async {
    await widget.model.loadMainPage(currentUser!.id!);
    widget.callback!(widget.model.friendsCount);
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
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              ...List.generate(
                                  widget
                                      .model
                                      .friends // widget.gameModel!.friendsNoMembers
                                      .length, // 4,//myFriends.length,
                                  (index) => Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child:
                                          //widget.model.friends[index],
                                          Card(
                                        child: CheckboxListTile(
                                          title: Text(
                                            widget.model.friends[index]
                                                    .displayName ??
                                                "-",
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
                                            widget.model.friends[index]
                                                    .username ??
                                                "-",

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
                                                    widget.model.friends[index]
                                                        .photoUrl!),
                                            /*CachedNetworkImageProvider(
                                                    widget
                                                        .gameModel!
                                                        .friendsNoMembers[index]
                                                        .photoUrl!),*/
                                            radius: 20,
                                          ),
                                          autofocus: false,
                                          activeColor: AppColors.kRipple,
                                          checkColor: Colors.white,
                                          selected: widget
                                                  .gameModel!.selectedUsers
                                                  .map((e) => e!.id)
                                                  .contains(widget
                                                      .model.friends[index].id)

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
                                          value: widget.gameModel!.selectedUsers
                                                  .map((e) => e!.id)
                                                  .contains(widget
                                                      .model.friends[index].id)
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
                                              checkUser(
                                                  widget.model.friends[index],

                                                  /* widget.gameModel!
                                                      .friendsNoMembers[index],*/
                                                  value!);
                                            });
                                          },
                                        ), //CheckboxListTile

                                        /* ListTile(
                                      contentPadding: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            CachedNetworkImageProvider(widget
                                                .gameModel!
                                                .friendsNoMembers[index]
                                                .photoUrl!),
                                      ),
                                      title: Text(
                                        widget
                                            .gameModel!
                                            .friendsNoMembers[index]
                                            .displayName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: AppColors.kFont,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        widget.gameModel!
                                            .friendsNoMembers[index].username!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: AppColors.kFont),
                                      ),
                                      trailing: FlatButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            widget.gameModel!.addMember(
                                                widget.model.friends[index]);
                                          });
                                        },
                                        child: Container(
                                          width: 80.0,
                                          height: 30.0,
                                          child: const Text(
                                            "Oyuna ekle",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.kRipple,
                                            border: Border.all(
                                              color: AppColors.kRipple,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                    ),*/
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
                                                    left:
                                                        getProportionateScreenWidth(
                                                            kDefaultPadding)),
                                                child: FriendsCard(
                                                  widget.model.friends[index],
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

class MeCard extends StatelessWidget {
  const MeCard(
    this.user, {
    Key? key,
    //  @required this.user,
    //@required this.press,
  }) : super(key: key);

  final User user;
  // final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null, // press,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl ?? ""),
          ),
          const VerticalSpacing(of: 10),
          Text(
            user.displayName!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class MeCard2 extends StatelessWidget {
  const MeCard2(
    this.user, {
    Key? key,
    //  @required this.user,
    //@required this.press,
  }) : super(key: key);

  final User user;
  // final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null, // press,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey,
            backgroundImage:
                CachedNetworkImageProvider(this.user.photoUrl ?? ""),
          ),
          const VerticalSpacing(of: 10),
          Text(
            user.displayName!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class FriendsCard extends StatelessWidget {
  const FriendsCard(
    this.user, {
    Key? key,
    this.type,
    //  @required this.user,
    @required this.press,
  }) : super(key: key);

  final User user;
  final GestureTapCallback? press;
  final int? type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20, //type == 2 ? 15 : 20.0,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl ?? ""),
          ),
          const VerticalSpacing(of: 10),
          Text(
            user.displayName ?? "-",
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
