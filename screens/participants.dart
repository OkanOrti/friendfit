import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/screens/friends.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/screens/friendsearch.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/MainPageViewModel.dart';
import 'package:friendfit_ready/widgets/my_participants.dart';
import '../constants.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import '../size_config.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/widgets/my_friends.dart';
import 'package:provider/provider.dart';

class Participants extends StatefulWidget {
  final DietGameViewModel? gameModel;
  final DietTaskViewModel? taskModel;
  Participants({Key? key, this.gameModel, this.taskModel}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Participants> with TickerProviderStateMixin {
  //final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
  final MainPageViewModel mainModel = serviceLocator<MainPageViewModel>();
  AnimationController? _hideFabAnimController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //model2.getFriends(currentUser.id);
    // TODO: implement initState
    super.initState();
    handleScroll();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
  }

  handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _hideFabAnimController!.reverse();
        // hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _hideFabAnimController!.forward();
        //showFloationButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Katılımcılar',
            style: TextStyle(color: AppColors.kFont),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: FriendSearch(
                        type: "2",
                        gameModel: widget.gameModel,
                        isFriendSearch: true));
              },
            )
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.kFont,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Friends(
                            1,
                            gameModel: widget.gameModel!,
                          )));
                },
                child: const SizedBox(
                  child: Card(
                    elevation: 1,
                    //shadowColor: AppColors.kRipple,
                    child: ListTile(
                      leading: Icon(
                        Icons.add,
                        color: AppColors.kRipple,
                      ),
                      // tileColor: AppColors.kRipple,
                      title: Text(
                        "Yeni Katılımcı",
                        style: (TextStyle(color: AppColors.kRipple)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MyParticipantsSection(mainModel,
                  type: "3", gameModel: widget.gameModel!),
            ]),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: SizedBox(
          width: 100,
          child: FadeTransition(
              opacity: _hideFabAnimController!,
              child: ScaleTransition(
                  scale: _hideFabAnimController!,
                  child: FloatingActionButton.extended(
                    heroTag: 'fab_new_task',
                    onPressed: () async {
                      widget.gameModel!.addMembers2();
                      Navigator.pop(context);
                    },
                    tooltip: '',
                    backgroundColor: AppColors.kRipple,
                    foregroundColor: Colors.white,
                    label: const Text("Tamam"),
                    /*icon: const Icon(
                        Icons.send,
                        size: 18,
                      )*/
                  ))),
        ));
  }
}

void doNothing(BuildContext context) {}
