import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/ProfileViewModel.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/screens/scoreBoard.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/progress.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String? profileId;
  final bool? isMain;

  Profile({this.profileId, this.isMain});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileViewModel model = serviceLocator<ProfileViewModel>();
  final String currentUserId = currentUser!.id!;

  @override
  void initState() {
    model.loadProfilePage(currentUserId, widget.profileId!);

    super.initState();
  }

  buildProfileHeader(ProfileViewModel model) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              model.profileUser!.photoUrl != null
                  ? CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                          model.profileUser!.photoUrl!),
                    )
                  : SizedBox(),
              /*CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                    ),*/
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildCountColumn("followers", 0),
                        //Spacer(),
                        buildCountColumn(
                            "Friend Requests", model.friendRequestCount!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildProfileButton(model),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              model.profileUser!.username!,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                color: AppColors.kFont,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              model.profileUser!.displayName!,
              style: const TextStyle(
                fontFamily: "Poppins",
                color: AppColors.kFont,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 2.0),
            child: Text(
              model.profileUser!.bio!,
            ),
          ),
        ],
      ),
    );
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Container buildButton({String? text, Function? function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: () {
          if (model.isFriendRequested! || model.isProfileOwner) {
            print("Zaten istek gönderilmiş yada profil kendisine ait!");
          } else if (model.isFriend!) {
            model.unfollowUser(currentUser!, widget.profileId!);
          } //arkadaşlığı bırak
          else if (!model.isFriend! && !model.isFriendRequested!) {
            model.followUser(currentUser!, widget.profileId!);
          }
        },
        child: Container(
          width: 200.0,
          height: 27.0,
          child: Text(
            text!,
            style: TextStyle(
              color: model.isFriendRequested! ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: model.isProfileOwner
                ? AppColors.kRipple
                : (model.isFriendRequested! ? Colors.white : Colors.blue),
            border: Border.all(
              color: model.isProfileOwner
                  ? Colors.white
                  : (model.isFriendRequested! ? Colors.grey : Colors.blue),
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton(ProfileViewModel model) {
    // viewing your own profile - should show edit profile button

    if (model.isProfileOwner) {
      return buildButton(
        text: "Edit Profile",
        function: editProfile,
      );
    } else if (model.isFriendRequested!) {
      return buildButton(
        text: "İstek gönderildi",
        //function: model.unfollowUser(currentUser, widget.profileId),
      );
    } else if (model.isFriend!) {
      return buildButton(
        text: "Takibi bırak",
        //function: model.unfollowUser(currentUser, widget.profileId),
      );
    } else if (!model.isFriendRequested! || !model.isFriend!) {
      return buildButton(
        text: "İstek gönder",
        //function: model.followUser(currentUser, widget.profileId),
      );
    }
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Text("")
            //null //(context) => EditProfile(currentUserId: currentUserId)
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
        create: (context) => model,
        child: Consumer<ProfileViewModel>(
            builder: (context, model, child) => model.isLoaded
                ? (widget.isMain!
                    ? Material(
                        color: Colors.white,
                        child: ListView(children: <Widget>[
                          buildProfileHeader(model),
                          buildFriendRequestList(model),
                          Container(
                            padding: EdgeInsets.only(top: 2.0),
                            child: FlatButton(
                              onPressed: () {
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ShowcaseScoreBoardTimeline()),
                                );*/
                                /*   if (model.isFriendRequested || model.isProfileOwner) {
            print("Zaten istek gönderilmiş yada profil kendisine ait!");
          } else if (model.isFriend) {
            model.unfollowUser(currentUser, widget.profileId);
          } //arkadaşlığı bırak
          else if (!model.isFriend && !model.isFriendRequested) {
            model.followUser(currentUser, widget.profileId);
          }
          */
                              },
                              child: Container(
                                width: 200.0,
                                height: 40.0,
                                child: Text(
                                  "Skorboard u görüntüle",
                                  style: TextStyle(
                                    color: model.isFriendRequested!
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: model.isProfileOwner
                                      ? AppColors.kRipple
                                      : (model.isFriendRequested!
                                          ? Colors.white
                                          : Colors.blue),
                                  border: Border.all(
                                    color: model.isProfileOwner
                                        ? Colors.white
                                        : (model.isFriendRequested!
                                            ? Colors.grey
                                            : Colors.blue),
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          )
                        ]),
                      )
                    : Scaffold(
                        //backgroundColor: Colors.green,
                        appBar: AppBar(
                          backgroundColor: Colors.white,
                          leading: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF545D68),
                            ),
                            onPressed: () => (Navigator.of(context).pop(true)),
                          ),
                          title: model.isLoaded
                              ? Text(
                                  model.profileUser!.displayName!,
                                  style: TextStyle(color: AppColors.kFont),
                                )
                              : Text(""),
                          centerTitle: false,
                        ),
                        body: ListView(children: <Widget>[
                          buildProfileHeader(model),
                          buildFriendRequestList(model),
                        ]),
                      ))
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: circularProgress())));
  }

  buildFriendRequestList(ProfileViewModel model) {
    return !model.isProfileOwner
        ? Container(width: 0, height: 0)
        : ListView.builder(
            shrinkWrap: true,
            itemCount: model.searchResults.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                          model.searchResults[index].photoUrl!),
                    ),
                    title: Text(model.searchResults[index].displayName!),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: () {
                              model.addFriend(model.searchResults[index].id!,
                                  currentUser!.id!, index);
                              //model.addfriend
                            },
                            child: Container(
                              width: 60.0,
                              height: 30.0,
                              child: const Text(
                                "Kabul et",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              model.deleteFriend(model.searchResults[index].id!,
                                  currentUser!.id!, index);
                            },
                            child: Container(
                              width: 60.0,
                              height: 30.0,
                              child: const Text(
                                "Sil",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ])),
              );
            },
          ); // Container(width:0, height:0,color: Colors.grey,);
  }
}
