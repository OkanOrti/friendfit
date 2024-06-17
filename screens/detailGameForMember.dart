// ignore: file_names
// ignore_for_file: file_names, unused_field, unnecessary_this, prefer_const_constructors, missing_required_param, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/deneme_timeLine.dart';
import 'package:friendfit_ready/screens/dietPlanTiles.dart';
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
import 'package:friendfit_ready/screens/dietPlanReview.dart';
import 'package:friendfit_ready/screens/memberStatusReview.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:friendfit_ready/screens/scoreBoard.dart';

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class DetailGameForMember extends StatefulWidget {
  final DietGame? game;
  final DietGameViewModel? gameModel;
  DetailGameForMember({Key? key, this.game, this.gameModel}) : super(key: key);

  @override
  _DetailGameForMemberState createState() => _DetailGameForMemberState();
}

class _DetailGameForMemberState extends State<DetailGameForMember>
    with TickerProviderStateMixin {
  //final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();

  //final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm a');
  String? gameTitle;
  String? gamePhrase;
  File? _image;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  final now = DateTime.now();
  TextEditingController? _editingController;
  String postId = Uuid().generateV4();
  bool isUploading = false;
  final ScrollController _scrollController =
      ScrollController(); // set controller on scrolling
  bool _show = true;
  AnimationController? _hideFabAnimController;
  AnimationController? _controller;
  Animation<Offset>? _animation;
  List<dynamic> reportList = [];
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  Future? myFuture;

  @override
  void initState() {
    gameTitle = '';
    gamePhrase = '';
    reportList = widget.game!.trackKPIs!;
    myFuture = widget.gameModel!.getMemberStatus(
        widget.game!.memberIds!, widget.game!.id!, widget.game!.gameOwnerId!);

    handleScroll();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
    // getMember();
    super.initState();
  }

  getMember() async {
    await widget.gameModel!.getMemberStatus(
        widget.game!.memberIds!, widget.game!.id!, widget.game!.gameOwnerId!);
    setState(() {});
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
    Map trackNames = {
      '1': 'Diyet Planı',
      '2': 'Adım',
      '3': 'Şeker',
      '4': 'Fast food',
      '5': 'Gluten',
      '6': '2L Su',
    };
    return GestureDetector(
      onTap: () {
        label == "1"
            ? /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DietPlanReview(
                    game: widget.game!,
                    enabled: false,
                  ),
                ),
              )*/
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DietPlanTiles(
                          gameModel: widget.gameModel!,
                          game: widget.game,
                        )))
            : null;
      },
      child: Chip(
        labelPadding: EdgeInsets.all(2.0),
        /* avatar: CircleAvatar(
          backgroundColor: Colors.white70,
          child: Text(label[0].toUpperCase(),style: TextStyle(color:Colors.grey),),
        ),*/
        label: Text(
          trackNames[label],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      ),
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
    return Consumer<DietGameViewModel>(
        builder: (context, model, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Column(children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              //color: Colors.blue,
                              transform:
                                  Matrix4.translationValues(0.0, -40.0, 0.0),
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
                                      image: widget.game!.imageTitleUrl ?? "",
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
                                  icon: Icon(Icons.arrow_back_ios_new),
                                  iconSize: 25.0,
                                  color: AppColors.kFont,
                                )),
                            Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                child: SimpleAlertDialog(
                                  game: widget.game,
                                  onActionPressed: () async {
                                    await widget.gameModel!.cancelGame(
                                        widget.game!.id!, currentUser!.id!);
                                    Navigator.pop(context);
                                  },
                                  color: AppColors.kFont,
                                )),

                            /* Positioned(
                                    bottom: 0.0,
                                    right: 0.0,
                                    child: IconButton(
                                        //tooltip: "Değiştir ",
                                        icon: Icon(Icons.delete),
                                        color: AppColors.kFont,
                                        onPressed: () {})),*/
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: /*AbsorbPointer(
                                absorbing:
                                    widget.game!.status == "Waiting" ? true : false,
                                child:*/
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Center(
                                    child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: _editingController,
                                  //textAlign: TextAlign.center,
                                  onSubmitted: (text) {
                                    setState(() {
                                      widget.gameModel!.gameTitle = text;
                                    });
                                  },
                                  cursorColor: Colors.black, //taskColor,
                                  autofocus: false,
                                  enabled: false, //true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: widget.game?.title ??= "",
                                      hintStyle: TextStyle(
                                          color: AppColors.kFont,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Poppins",
                                          fontSize: 24)),
                                  style: TextStyle(
                                      color: AppColors.kFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 40.0),
                                )),
                                /* Container(
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
                                            this.gameModel.gameTitle = text;
                                          });
                                        },
                                        cursorColor: Colors.black, //taskColor,
                                        autofocus: false,
                                        enabled: false, //true,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: widget.game?.title ??= "",
                                            hintStyle: TextStyle(
                                                color: AppColors.kFont,
                                                fontFamily: "Poppins",
                                                fontSize: 18)),
                                        style: TextStyle(
                                            color: AppColors.kFont,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 40.0),
                                      )),
                                    )),*/
                                const SizedBox(height: 5),

                                widget.game!.phrase!.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: const Text('Açıklama',
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              color: AppColors.kFont,
                                              fontWeight: FontWeight.w500,
                                            )),
                                      )
                                    : SizedBox(),
                                SizedBox(height: 5),
                                widget.game!.phrase != null
                                    ? Text(widget.game!.phrase ?? "",
                                        style: TextStyle(
                                            color: AppColors.kFont
                                                .withOpacity(0.5),
                                            fontFamily: "Poppins",
                                            fontSize: 14))
                                    : SizedBox(),
                                SizedBox(height: 5),
                                Divider(),
                                SizedBox(height: 5),
                                const Text('Oyun Durumu',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      color: AppColors.kFont,
                                      fontWeight: FontWeight.w500,
                                    )),
                                SizedBox(height: 5),
                                Text(
                                    widget.gameModel!
                                        .getStatusGameAsString(widget.game!),
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      color: AppColors.kFont.withOpacity(0.5),
                                      //fontWeight: FontWeight.w500,
                                    )),

                                SizedBox(height: 10),
                                Divider(),
                                SizedBox(height: 10),

                                widget.game!.dayProtection != null
                                    ? Column(children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(children: [
                                            Text(
                                              'Gün Koruması:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.kFont,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Spacer(),
                                            CupertinoSwitch(
                                                value:
                                                    widget.game!.dayProtection!,
                                                onChanged: null)
                                          ]),
                                        ),
                                        SizedBox(height: 10),
                                        Divider(),
                                        SizedBox(height: 10),
                                      ])
                                    : SizedBox(),

                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Tarih Aralığı',
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16,
                                            color: AppColors.kFont,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      SizedBox(height: 5),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.calendar_today,
                                                size: 16,
                                                color: AppColors.kRipple),
                                            const SizedBox(width: 10),
                                            const InkWell(
                                                child: Text("Başlangıç",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        color: AppColors.kFont,
                                                        fontSize: 14))),
                                            const Spacer(),
                                            Text(
                                                this
                                                    .dateFormat
                                                    .format(widget
                                                        .game!.startDate!
                                                        .toDate())
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: AppColors.kFont,
                                                    fontSize: 14))

                                            //DateTimePickerWidget()
                                          ]),
                                      const SizedBox(height: 5),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.calendar_today,
                                                size: 16,
                                                color: AppColors.kRipple),
                                            const SizedBox(width: 10),
                                            const InkWell(
                                                child: Text("Bitiş",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        color: AppColors.kFont,
                                                        fontSize: 14))),
                                            const Spacer(),
                                            Text(
                                                this
                                                    .dateFormat
                                                    .format(widget
                                                        .game!.endDate!
                                                        .toDate())
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: AppColors.kFont,
                                                    fontSize: 14))
                                          ]),
                                    ]),

                                SizedBox(height: 8),
                                Divider(),
                                SizedBox(height: 8),

                                FutureBuilder(
                                    future: myFuture,
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SpinKitThreeBounce(
                                                color: AppColors.kRipple,
                                                size: 20),
                                          ],
                                        );
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Katılım Durumu',
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 16,
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            MemberStatusReview(
                                                          gameModel:
                                                              widget.gameModel!,
                                                          game: widget.game!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Tümü',
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 14,
                                                        color: AppColors.kFont,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                //IconButton(icon: Icon(FontAwesome.arrow_right,color: Colors.blueGrey,size: 14,), onPressed: () {  },
                                              ]),
                                          SizedBox(height: 10),
                                          Row(children: [
                                            Text(
                                              "Kabul (${widget.gameModel!.usersApproved.length.toString()})",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "Red (${widget.gameModel!.usersDenied.length.toString()})",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "Yanıtsız (${widget.gameModel!.usersNoResponse.length.toString()})",
                                              style: TextStyle(
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ])
                                        ]);
                                      } else {
                                        return Text(
                                            'State: ${snapshot.connectionState}');
                                      }
                                    }),
                                /* FutureBuilder(
                                                  future: /*this.gameModel.getGameMembers(
                                              widget.game!.memberIds!),*/
                                                      gameModel.getMemberStatus(
                                                    widget.game!.memberIds!,
                                                    widget.game!.id!,
                                                    widget.game!.gameOwnerId!,
                                                    //gameModel.gameMembers
                                                  ),
                                                  // initialData: InitialData,
                                                  builder: (context, snapshot) {
                                                    switch (
                                                        snapshot.connectionState) {
                                                      // Uncompleted State
                                                      case ConnectionState.none:
                                                      case ConnectionState.waiting:
                                                        return Center(
                                                            child:
                                                                SpinKitThreeBounce(
                                                                    color: AppColors
                                                                        .kRipple,
                                                                    size: 20));
                                                      default:
                                                        // Completed with error
                                                        /* if (snapshot.hasError)
                                                  return Text(snapshot.error
                                                      .toString());*/
                                      
                                                        // Completed with data
                                      
                                                        return Row(children: [
                                                          Chip(
                                                            labelPadding:
                                                                EdgeInsets.all(2.0),
                                                            label: Text(
                                                              "Kabul (${gameModel.usersApproved.length.toString()})",
                                                              style: TextStyle(
                                                                color: Colors.green,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 2.0,
                                                            shadowColor:
                                                                Colors.grey[60],
                                                            padding:
                                                                EdgeInsets.all(8.0),
                                                          ),
                                                          Spacer(),
                                                          Chip(
                                                            labelPadding:
                                                                EdgeInsets.all(2.0),
                                                            label: Text(
                                                              "Red (${gameModel.usersDenied.length.toString()})",
                                                              style: TextStyle(
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 2.0,
                                                            shadowColor:
                                                                Colors.grey[60],
                                                            padding:
                                                                EdgeInsets.all(8.0),
                                                          ),
                                                          Spacer(),
                                                          Chip(
                                                            labelPadding:
                                                                EdgeInsets.all(2.0),
                                                            label: Text(
                                                              "Yanıtsız (${gameModel.usersNoResponse.length.toString()})",
                                                              style: TextStyle(
                                                                color: Colors.lime,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 6.0,
                                                            shadowColor:
                                                                Colors.grey[60],
                                                            padding:
                                                                EdgeInsets.all(8.0),
                                                          ),
                                                        ]);
                                      
                                                      /*SingleChildScrollView(
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
                                                    ]));*/
                                                    }
                                                  }),*/
                                /*SingleChildScrollView(
                                                  clipBehavior: Clip.none,
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(children: [
                                                    ...List.generate(
                                                        gameModel.usersApproved
                                                            .length, // 4,//myFriends.length,
                                                        (index) => Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: getProportionateScreenWidth(
                                                                      kDefaultPadding)),
                                                              child: FriendsCard(
                                                                gameModel
                                                                        .usersApproved[
                                                                    index],
                                                                press: () {},
                                                              ),
                                                            ))
                                                  ]))*/

                                SizedBox(height: 8),
                                Divider(),
                                SizedBox(height: 8),

                                const Text(
                                  'Kategori',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.kFont,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                chipList(),
                                SizedBox(height: 10),
                                Divider(),
                                SizedBox(height: 10),

                                /*  MultiSelectedChip(
                                      reportList,
                                      _options_Icon,
                                    ),*/

                                /* const SizedBox(height: 30),

                                    //widget.game.trackKPIs.contains("1")?

                                    model.getStatusGameAsString(widget.game!) ==
                                            "Başladı"
                                        ? Center(
                                            child: GestureDetector(
                                              onTap: () async {
                                                final value =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ShowcaseScoreBoardTimeline(
                                                            game: widget.game!,
                                                          )),
                                                );
                                                setState(() {
                                                  SystemChrome.setSystemUIOverlayStyle(
                                                      const SystemUiOverlayStyle(
                                                          statusBarColor:
                                                              Colors.white,
                                                          statusBarIconBrightness:
                                                              Brightness.dark));
                                                });

                                                /*Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => DietPlanReview(
                                                      game: widget.game,
                                                    ),
                                                  ),
                                                );*/
                                              },
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  final value =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            ShowcaseScoreBoardTimeline(
                                                              game:
                                                                  widget.game!,
                                                            )),
                                                  );
                                                  setState(() {
                                                    SystemChrome.setSystemUIOverlayStyle(
                                                        const SystemUiOverlayStyle(
                                                            statusBarColor:
                                                                Colors.white,
                                                            statusBarIconBrightness:
                                                                Brightness
                                                                    .dark));
                                                  });

                                                  /*Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => DietPlanReview(
                                                      game: widget.game,
                                                    ),
                                                  ),
                                                );*/
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: const Text(
                                                    'Skor durumunu göster !',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Poppins",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    primary: AppColors.kRipple,
                                                    //   fixedSize: const Size(300, 100),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                              ), /*Chip(
                                          labelPadding: EdgeInsets.all(4.0),
                                          label: Text(
                                            "Skor durumu icin tıklayınız !",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                          elevation: 6.0,
                                          shadowColor: Colors.grey[60],
                                          padding: EdgeInsets.all(8.0),
                                        ),*/

                                              /*  const Text(
                                          ' Anlık skor durumunu görüntülemek için tıklayınız.',
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontSize: 16,
                                            color: AppColors.kRipple,
                                          ),
                                        ),*/
                                            ),
                                          )
                                        : SizedBox(),*/
                                //    : Container(),
                                //const SizedBox(height: 100),
                              ]),
                          //),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 80,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    child: model.getStatusGameAsString(widget.game!) ==
                            "Başladı"
                        ? Center(
                            child: GestureDetector(
                                onTap: () async {
                                  final value = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ShowcaseScoreBoardTimeline(
                                              game: widget.game!,
                                            )),
                                  );
                                  setState(() {
                                    SystemChrome.setSystemUIOverlayStyle(
                                        const SystemUiOverlayStyle(
                                            statusBarColor: Colors.white,
                                            statusBarIconBrightness:
                                                Brightness.dark));
                                  });

                                  /*Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => DietPlanReview(
                                                      game: widget.game,
                                                    ),
                                                  ),
                                                );*/
                                },
                                child: ElevatedButton(
                                  onPressed: () {
                                    widget.game!.trackKPIs!.contains("1")
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => DietPlanTiles(
                                                      gameModel:
                                                          widget.gameModel!,
                                                      game: widget.game,
                                                    )))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => // DenemeTimeLine()
                                                    ShowcaseScoreBoardTimeline(
                                                      game: widget.game!,
                                                      //dietPlanId: planId,
                                                    )),
                                          );
                                    /* final value = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => // DenemeTimeLine()
                                                  ShowcaseScoreBoardTimeline(
                                                    game: widget.game!,
                                                  )),
                                        );
                                        setState(() {
                                          SystemChrome.setSystemUIOverlayStyle(
                                              const SystemUiOverlayStyle(
                                                  statusBarColor:
                                                      Colors.transparent,
                                                  statusBarIconBrightness:
                                                      Brightness.dark));
                                        });*/
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text(
                                      'Oyunu Görüntüle !',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: AppColors.kRipple,
                                      //   fixedSize: const Size(300, 100),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                )),
                          )
                        : SizedBox())
              ]),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterFloat,
              floatingActionButton: (widget.game!.gameOwnerId! ==
                      currentUser!.id)
                  ? FadeTransition(
                      opacity: _hideFabAnimController!,
                      child: ScaleTransition(
                        scale: _hideFabAnimController!,
                        child: Visibility(
                          visible: widget.gameModel!
                                      .getStatusGameAsString(widget.game!) ==
                                  "Bekliyor"
                              ? true
                              : false,
                          /*DateUtils.dateOnly(
                                              widget.game!.startDate!.toDate())
                                          .compareTo(DateUtils.dateOnly(
                                              DateTime.now())) !=
                                      -1
                                  ? true
                                  : false,*/
                          child: FloatingActionButton.extended(
                            heroTag: 'fab_new_task',
                            onPressed: () async {
                              widget.gameModel!.startGame(
                                  widget.game!.id!, widget.game!.gameOwnerId!);
                              await widget.gameModel!
                                  .getGames(currentUser!.id!);
                              //    widget.gameModel!.refresh();
                              Navigator.of(context).pop();
                            },
                            // tooltip: 'Öğün ekle',
                            backgroundColor: DateUtils.dateOnly(
                                            widget.game!.startDate!.toDate())
                                        .compareTo(DateUtils.dateOnly(
                                            DateTime.now())) !=
                                    1
                                ? AppColors.kRipple
                                : AppColors.kRipple, //Colors.grey,
                            foregroundColor: Colors.white,
                            label: const Text("Oyunu Başlat !"),
                            icon: const Icon(Icons.gamepad),
                          ),
                        ),
                      ),
                    )
                  : null,
            ));
  }
}

class MultiSelectedChip extends StatefulWidget {
  final List<dynamic> reportList;
  final List<String> iconList;
  final Map _options_Icon2 = {
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
    //List();

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
  final DietGame? game;

  SimpleAlertDialog(
      {@required this.color, @required this.onActionPressed, this.game});

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
              title: currentUser!.id == game!.gameOwnerId
                  ? Text('Oyunu sonlandırmak mı istiyorsunuz ?')
                  : Text('Oyundan ayrılmak mı istiyorsunuz ?'),
              content: SingleChildScrollView(
                child: ListBody(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    currentUser!.id == game!.gameOwnerId
                        ? Text(
                            'Oyunu sonlandırdıktan sonra işlemi geri alamayacksınız.')
                        : Text(
                            'Oyundan ayrıldıktan sonra işlemi geri alamayacksınız.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Evet',
                    style: TextStyle(color: AppColors.kRipple),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();

                    onActionPressed!();
                  },
                ),
                FlatButton(
                  child: Text('Vazgeç', style: TextStyle(color: Colors.blue)),
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

class SimpleAlertDialogGame extends StatelessWidget {
  final Color? color;
  final Callback? onActionPressed;

  const SimpleAlertDialogGame({
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
              title: Text('Diet listesini silmek mi istiyorsunuz ?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Builder(builder: (context) {
                      return Text(
                          'Listeyi sildikten sonra işlemi geri alamayacaksınız.');
                    }),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  //color: Colors.orange,
                  child: Text(
                    'Sil',
                    style: TextStyle(color: AppColors.kRipple),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();

                    onActionPressed!();
                  },
                ),
                FlatButton(
                  //color: Colors.orange,
                  child: Text(
                    'Vazgeç',
                    style: TextStyle(color: AppColors.kRipple),
                  ),
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
