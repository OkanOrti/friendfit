import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/screens/friendsearch.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/MainPageViewModel.dart';
import '../constants.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import '../size_config.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/widgets/my_friends.dart';
import 'package:provider/provider.dart';

class Friends extends StatefulWidget {
  final DietGameViewModel? gameModel;
  int searchButtonOpen = 0;
  Friends(this.searchButtonOpen, {Key? key, this.gameModel}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with TickerProviderStateMixin {
  //final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
  final MainPageViewModel mainModel = serviceLocator<MainPageViewModel>();
  AnimationController? _hideFabAnimController;
  final ScrollController _scrollController = ScrollController();

  int? friendCount = 0;
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
            'Arkadaşlarım',
            style: TextStyle(color: AppColors.kFont),
          ),
          actions: [
            //widget.searchButtonOpen == 0
            //  ?
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: FriendSearch(
                        type: "2",
                        isFriendSearch: true,
                        gameModel: widget.gameModel));
              },
            )
            //: const SizedBox()
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
              const SizedBox(height: 10),
              MyFriendsSection(mainModel, callback: (value) {
                friendCount = value;
                setState(() {});
              }, type: "1", gameModel: widget.gameModel!),
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
                        widget.gameModel!.addMembers();
                        Navigator.pop(context);
                      },
                      tooltip: '',
                      backgroundColor: AppColors.kRipple,
                      foregroundColor: Colors.white,
                      label: Text(
                          "Tamam") //friendCount! > 0 ? Text("Ekle") : Text("Geri"),
                      /*icon: const Icon(
                        Icons.send,
                        size: 18,
                      )*/
                      ))),
        ));
  }
}
