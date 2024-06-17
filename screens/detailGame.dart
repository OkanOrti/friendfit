// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers, file_names, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/circular_clipper.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/widgets/my_friends.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../size_config.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/rendering.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/data/image_card.dart';

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class DetailGame extends StatefulWidget {
  final DietGame? game;

  DetailGame({Key? key, this.game}) : super(key: key);

  @override
  _DetailGameState createState() => _DetailGameState();
}

class _DetailGameState extends State<DetailGame> with TickerProviderStateMixin {
  final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm a');
  String? gameTitle;
  String? gamePhrase;
  File? _image;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  final now = new DateTime.now();
  TextEditingController? _editingController;
  String postId = Uuid().generateV4();
  bool isUploading = false;
  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;
  AnimationController? _hideFabAnimController;
  AnimationController? _controller;
  Animation<Offset>? _animation;
  List<String> _options_Icon = [
    'assets/images/nutrition_icons/diet-list.png',
    'assets/images/foot_blue.png',
    'assets/images/nutrition_icons/no-sugar.png',
    'assets/images/nutrition_icons/no-junk-food.png',
    'assets/images/nutrition_icons/no-gluten.png',
    'assets/images/nutrition_icons/water.png'
  ];
  List<dynamic> reportList = [];

  @override
  void initState() {
    gameTitle = '';
    gamePhrase = '';
    reportList = widget.game!.trackKPIs!;

    handleScroll();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});

    _hideFabAnimController!.dispose();
    //_editingController.dispose();

    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _hideFabAnimController!.reverse();
        //hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _hideFabAnimController!.forward();
        //showFloationButton();
      }
    });
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      /* avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase(),style: TextStyle(color:Colors.grey),),
      ),*/
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  chipList() {
    List<Widget> chipList2 = [];
    List<Color> colors = [
      Color(0xFFff6666),
      Color(0xFF007f5c),
      Color(0xFF5f65d3),
      Color(0xFF19ca21),
      Color(0xFF60230b),
      AppColors.kRipple,
      Colors.lightBlue,
      Colors.purple
    ];
    widget.game!.trackKPIs!.asMap().forEach((i, value) {
      chipList2.add(_buildChip(value, colors[i]));
    });
    return Wrap(spacing: 6.0, runSpacing: 6.0, children: chipList2);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DietGameViewModel>(
        create: (context) => gameModel,
        child: Consumer<DietGameViewModel>(
            builder: (context, model, child) => Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              // color: Colors.blue,
                              transform:
                                  Matrix4.translationValues(0.0, -30.0, 0.0),
                              child: Hero(
                                tag: "", //widget.blog.imageTitleUrl,
                                child: ClipShadowPath(
                                    clipper: CircularClipper(),
                                    shadow: Shadow(
                                        blurRadius: 10.0,
                                        color: AppColors.kBackground),
                                    child: FadeInImage.memoryNetwork(
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      image: widget.game?.imageTitleUrl ?? "",
                                      placeholder: kTransparentImage,
                                    ) /*Image(
                                      height: 180.0,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      image: AssetImage("assets/images/diet.jpg"),
                                      ),*/
                                    ),
                              ),
                            ),
                            Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                child: IconButton(
                                  padding: EdgeInsets.only(left: 10.0),
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(Icons.arrow_back_rounded),
                                  iconSize: 25.0,
                                  color: AppColors.kFont,
                                )),
                            Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                child: IconButton(
                                    //tooltip: "Değiştir ",
                                    icon: Icon(Icons.delete),
                                    color: AppColors.kFont,
                                    onPressed: () {})),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                              child: Column(children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: AppColors.kRipple.withOpacity(0.3),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Center(
                                      child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: _editingController,
                                    //textAlign: TextAlign.center,
                                    onSubmitted: (text) {
                                      setState(() {
                                        gameModel.gameTitle = text;
                                      });
                                    },
                                    cursorColor: Colors.black, //taskColor,
                                    autofocus: false,
                                    enabled: false, //true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: widget.game?.title ??= "",
                                        hintStyle: TextStyle(
                                            color: Colors.black26,
                                            fontFamily: "Poppins",
                                            fontSize: 18)),
                                    style: TextStyle(
                                        color: AppColors.kFont,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30.0),
                                  )),
                                )),
                            SizedBox(height: 20),
                            Container(
                                decoration: BoxDecoration(
                                    color: AppColors.kRipple.withOpacity(0.3),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Center(
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      enabled: false,
                                      controller: _editingController,
                                      onChanged: (text) {
                                        setState(() {
                                          gameModel.gamePhrase = text;
                                        });
                                      },
                                      minLines: 2,
                                      maxLength: 100,
                                      maxLines: 3,
                                      //cursorColor: taskColor,
                                      autofocus: false, //true,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: widget.game!.phrase,
                                          hintStyle: TextStyle(
                                              color: Colors.black26,
                                              fontFamily: "Poppins",
                                              fontSize: 18)),
                                      style: TextStyle(
                                          color:
                                              AppColors.kFont.withOpacity(0.9),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                )),
                            SizedBox(height: 20),
                            Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.calendar_today,
                                            color: AppColors.kRipple),
                                        SizedBox(width: 10),
                                        InkWell(
                                            child: Text("Başlangıç:",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 15))),
                                        Spacer(),
                                        Text(
                                            dateFormat
                                                .format(widget.game!.startDate!
                                                    .toDate())
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 15))

                                        //DateTimePickerWidget()
                                      ]),
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.calendar_today,
                                            color: AppColors.kRipple),
                                        SizedBox(width: 10),
                                        InkWell(
                                            child: Text("Bitiş:",
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 15))),
                                        Spacer(),
                                        Text(
                                            dateFormat
                                                .format(widget.game!.endDate!
                                                    .toDate())
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 15))
                                      ]),
                                  SizedBox(height: 20),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Katılımcılar:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  FutureBuilder(
                                      future: gameModel.getGameMembers(
                                          widget.game!.memberIds!),
                                      // initialData: InitialData,
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          // Uncompleted State
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                            break;
                                          default:
                                            // Completed with error
                                            if (snapshot.hasError)
                                              return Container(
                                                  child: Text(snapshot.error
                                                      .toString()));

                                            // Completed with data

                                            return SingleChildScrollView(
                                                clipBehavior: Clip.none,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(children: [
                                                  ...List.generate(
                                                      widget.game!.memberIds!
                                                          .length, // 4,//myFriends.length,
                                                      (index) => Padding(
                                                            padding: EdgeInsets.only(
                                                                left: getProportionateScreenWidth(
                                                                    kDefaultPadding)),
                                                            child: FriendsCard(
                                                              gameModel
                                                                      .gameMembers[
                                                                  index],
                                                              press: () {},
                                                            ),
                                                          ))
                                                ]));
                                        }
                                      }),
                                  SizedBox(height: 20),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Takip Kriterleri:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  MultiSelectedChip(
                                    reportList,
                                    _options_Icon,
                                  ),
                                  SizedBox(height: 20),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Diyet Planı:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  FutureBuilder(
                                      future: gameModel
                                          .getGameDiet(widget.game!.dietId!),
                                      // initialData: InitialData,
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          // Uncompleted State
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                            break;
                                          default:
                                            // Completed with error
                                            if (snapshot.hasError)
                                              return Container(
                                                  child: Text(snapshot.error
                                                      .toString()));

                                            // Completed with data

                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  left: 0.0,
                                                  right: 0.0),
                                              child: Container(
                                                width:
                                                    getProportionateScreenWidth(
                                                        157),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                )),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              170),
                                                      height:
                                                          getProportionateScreenHeight(
                                                              130),
                                                      decoration: BoxDecoration(
                                                        //border: Border.all(color: isSelected ? Colors.green:Colors.transparent) ,
                                                        //color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                        image: DecorationImage(
                                                            image: choicesImages
                                                                .where((ChoiceImage
                                                                        a) =>
                                                                    a.id ==
                                                                    gameModel
                                                                        .selectedTask
                                                                        .backgroundId)
                                                                .first
                                                                .image as ImageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              170),
                                                      padding: EdgeInsets.all(
                                                        getProportionateScreenWidth(
                                                            kDefaultPadding),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        // border: Border.all(color: isSelected ? Colors.green:Colors.transparent),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          kDefualtShadow
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            gameModel
                                                                    .selectedTask
                                                                    .title ??
                                                                "",
                                                            softWrap: false,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          VerticalSpacing(
                                                              of: 10),

                                                          /* Travelers(
                      users: travelSport.users,
                    ),*/
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ])),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterFloat,
                  floatingActionButton: FadeTransition(
                    opacity: _hideFabAnimController!,
                    child: ScaleTransition(
                      scale: _hideFabAnimController!,
                      child: FloatingActionButton.extended(
                        heroTag: 'fab_new_task',
                        onPressed: () {},
                        // tooltip: 'Öğün ekle',
                        backgroundColor: AppColors.kRipple,
                        foregroundColor: Colors.white,
                        label: Text("Oyunu Başlat !"),
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ),
                )));
  }
}

class MultiSelectedChip extends StatefulWidget {
  final List<dynamic> reportList;
  final List<String> iconList;
  Map _options_Icon2 = {
    "1": 'assets/images/nutrition_icons/diet-list.png',
    "2": 'assets/images/foot_blue.png',
    "3": 'assets/images/nutrition_icons/no-sugar.png',
    "4": 'assets/images/nutrition_icons/no-junk-food.png',
    "5": 'assets/images/nutrition_icons/no-gluten.png',
    "6": 'assets/images/nutrition_icons/water.png'
  };

  Map reportList2 = {
    "Diyet Planı": "1",
    "Adım": "2",
    'Şeker': "3",
    'Fast food ': "4",
    'Gluten ': "5",
    '2L Su': "6",
  };

  MultiSelectedChip(this.reportList, this.iconList);

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectedChip> {
  _buildChoiceList() {
    List<Widget> choices = [];
    // List();

    for (int i = 0; i < widget.reportList.length; i++) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: RawChip(
          label: Container(
              height: 35,
              width: 45,
              child: Align(
                  child: Text(widget.reportList[i],
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.visible,
                      style: TextStyle(color: Colors.white)))),
          elevation: 10,
          pressElevation: 5,
          shadowColor: Colors.black26,
          backgroundColor: AppColors.kRipple,
          //selectedColor: AppColors.kRipple,
          showCheckmark: false,
          avatar: i == 1
              ? Image(
                  image: AssetImage(widget._options_Icon2[
                      widget.reportList2[widget.reportList[i]]]),
                  width: 25,
                  height: 25)
              : Image(
                  image: AssetImage(widget._options_Icon2[
                      widget.reportList2[widget.reportList[i]]]),
                  width: 35,
                  height: 35),
        ),
      ));
    }

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _buildChoiceList(),
    );
  }
}

typedef void Callback();

class SimpleAlertDialog extends StatelessWidget {
  final Color? color;
  final Callback? onActionPressed;

  SimpleAlertDialog({
    @required this.color,
    @required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      icon: Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Menüyü silmek mi istiyorsunuz ?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Menüyü sildikten sonra işlemi geri alamayacksınız..'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop();

                    onActionPressed!();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  //textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
