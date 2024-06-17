// ignore_for_file: avoid_print, prefer_const_constructors, file_names, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:friendfit_ready/screens/MultiItem.dart';
import 'package:friendfit_ready/screens/friends.dart';
import 'package:friendfit_ready/screens/gameTaskDetailScreen.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/participants.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:friendfit_ready/widgets/my_friends.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/screens/multipleGridItem.dart';
import 'package:flutter/rendering.dart';
import 'package:friendfit_ready/screens/gameSummary.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class GameTiles extends StatefulWidget {
  const GameTiles({Key? key, this.gameModel, this.taskModel}) : super(key: key);
  final DietGameViewModel? gameModel;
  final DietTaskViewModel? taskModel;

  @override
  _GameTilesState createState() => _GameTilesState();
}

class _GameTilesState extends State<GameTiles> with TickerProviderStateMixin {
  //final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
  //final DietTaskViewModel model = serviceLocator<DietTaskViewModel>();
  List<ItemMulti> itemList = [];
  List<ItemMulti> selectedList = [];
  final ScrollController _scrollController = ScrollController();
  AnimationController? _hideFabAnimController;
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;
  bool successfull = false;
  String postId = Uuid().generateV4();
  ChoiceImage selectedIconData = ChoiceImage(id: '1', image: null);

  List<String> selectedReportList = [];
  bool _show = true;
  bool _enabled = true;

  XFile? _image;
  File? compressedImageFile;
  bool? _switchValue = false;

  AnimationController? lottieController;

  // ignore: non_constant_identifier_names

  Future<void> _showDialog2() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bilgi"),
            content: Text("En az bir kategori seçmelisiniz."),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    "Tamam",
                    style: TextStyle(color: AppColors.kRipple),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bilgi"),
            content: Text("Lütfen bir beslenme planı oluşturunuz."),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Tamam",
                  style: TextStyle(color: AppColors.kRipple),
                ),
                onPressed: () async {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => /* GamesPageSelect(
                              gameModel: widget.gameModel!,
                              model: model,
                            )*/
                              GameTaskDetailScreen(
                        gameModel: widget.gameModel,
                      ),
                    ),
                  );

                  /*await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DietsPageSelect(gameModel: widget.gameModel,),
                    ),
                  );
                   Navigator.of(context).pop();
                   widget.gameModel.isRefreshedControl();*/
                },
              ),
              FlatButton(
                child: Text(
                  "Kapat",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    // loadList();
    handleScroll();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
    lottieController = AnimationController(
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});

    _hideFabAnimController?.dispose();

    super.dispose();
  }

  void showFloationButton() {
    setState(() {});
  }

  void hideFloationButton() {
    setState(() {});
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

  loadList() {
    itemList = [];
    // List();
    selectedList = [];
    // List();
    widget.gameModel!.trackKPI_Names = [];
    widget.gameModel!.trackKPIs = [];
    itemList.add(ItemMulti("assets/lottie/doctor.json", 1, "Diet Planı"));
    itemList.add(ItemMulti("assets/lottie/running.json", 2, "Adım Yarışı"));
    /* itemList.add(ItemMulti("assets/lottie/water.json", 3, "Günde 2L su"));
    itemList.add(ItemMulti("assets/images/no-sugar.png", 8, "Şeker Yok"));
    itemList.add(ItemMulti("assets/images/lactose-free.png", 7, "Laktoz Yok"));
    itemList.add(ItemMulti("assets/images/gluten-free.png", 4, "Gluten Yok"));
    itemList.add(ItemMulti("assets/images/no-meat.png", 5, "Et Yok"));
    itemList
        .add(ItemMulti("assets/images/no-junk-food.png", 6, "Fast Food Yok"));*/
    //itemList.add(ItemMulti__("assets/images/vegan.png", 9,"Vegan"));

    //itemList.add(ItemMulti__("assets/lottie/run.json", 4,"Koşu"));
  }

  handleSubmit() async {
    lottieController!.duration = const Duration(seconds: 3);
    lottieController!.forward(from: 0);

    setState(() {
      isUploading = true;
      //successfull = false;
    });

    if (!widget.gameModel!.fromFitGallery) {
      await compressImage();
      postId = Uuid().generateV4();
      String mediaUrl = await uploadImage(compressedImageFile);
      if (mediaUrl.isNotEmpty) widget.gameModel!.imageUrl = mediaUrl;
    }
  }

  Future<String> uploadImage(imageFile) async {
    firebase_storage.UploadTask uploadTask;
    uploadTask = storageRef.child("post_$postId.jpg").putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    var file = File(widget.gameModel!.imageBeforeSave!.path);
    Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());
    compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
  }

  @override
  Widget build(BuildContext context) {
    //widget.gameModel.trackKPIs=[];

    return ChangeNotifierProvider<DietGameViewModel>.value(
        //create: (context) => widget.gameModel,
        value: widget.gameModel!,
        child: Consumer<DietGameViewModel>(
            builder: (context, model, child) => Stack(children: [
                  Scaffold(
                    appBar: AppBar(
                      /* title: const Text(
                    'Oyun Kategori Seçimi',
                    style: TextStyle(color: AppColors.kFont),
                  ),*/
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
                      iconTheme: IconThemeData(color: Colors.black54),
                      brightness: Brightness.light,
                      backgroundColor: Colors.white,
                    ),
                    backgroundColor: Colors.white,
                    body: Padding(
                      padding: EdgeInsets.only(
                          right: 20, left: 20, top: 0, bottom: 70),
                      child: SingleChildScrollView(
                          //controller: widget.scrollController2,
                          // cacheExtent: 3000,
                          child: Column(
                        children: [
                          /* GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GameTaskDetailScreen(
                                      gameModel: widget.gameModel,

                                      //day: _selectedDay!,
                                    ),
                                  ));
                            },
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: Icon(
                                  Icons.add_circle,
                                  color: AppColors.kRipple,
                                ),
                                title: Text(
                                  "Yeni Diet Planı ekle",
                                  style: (TextStyle(color: AppColors.kRipple)),
                                ),
                              ),
                            ),
                          ),*/
                          SizedBox(height: 10),
                          ...List.generate(
                            widget.gameModel!.dietPlansList
                                .length, // 4,//myFriends.length,
                            (index) => ItemForGameTile(
                              gameModel: widget.gameModel,
                              taskModel: widget.gameModel!.dietPlansList[index],
                              index: index,
                            ),
                          ),
                        ],
                      )),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: Visibility(
                        visible: isUploading ? false : true,
                        child: FadeTransition(
                            opacity: _hideFabAnimController!,
                            child: ScaleTransition(
                                scale: _hideFabAnimController!,
                                child: FloatingActionButton.extended(
                                    heroTag: 'fab_new_task',
                                    onPressed: () async {
                                      await handleSubmit();

                                      widget.gameModel!.gameDuration = widget
                                              .gameModel!.endTime
                                              .difference(
                                                  widget.gameModel!.startTime)
                                              .inDays +
                                          1;
                                      widget.gameModel!.gameOwnerId =
                                          currentUser!.id!;
                                      widget.gameModel!.status = "Waiting";
                                      //  print(widget.taskModel.savedTaskTitle);

                                      await widget.gameModel!.saveGame(
                                          dayProtection: _switchValue,
                                          savedTaskTitle:
                                              widget.taskModel != null
                                                  ? widget.taskModel!
                                                      .dailyEventsTitle
                                                  : {},
                                          savedDailyPlanTodos:
                                              widget.taskModel != null
                                                  ? widget
                                                      .taskModel!.dailyEvents
                                                  : {});
                                      _image = null;

                                      //Future.delayed(const Duration(seconds: 12), () {
                                      isUploading = false;
                                      // });
                                      /*Navigator.of(context).popUntil(
                                    ModalRoute.withName("CreateGame"));*/
                                      while (Navigator.canPop(context)) {
                                        // Navigator.canPop return true if can pop
                                        Navigator.pop(context);
                                      }
                                    },
                                    tooltip: '',
                                    backgroundColor: AppColors.kRipple,
                                    foregroundColor: Colors.white,
                                    label: const Text("Daveti Gönder"),
                                    icon: const Icon(
                                      Icons.send,
                                      size: 18,
                                    ))))),
                    /*floatingActionButton: Builder(
                  builder: (BuildContext context) {
                    return FadeTransition(
                        opacity: _hideFabAnimController!,
                        child: ScaleTransition(
                            scale: _hideFabAnimController!,
                            child: SizedBox(
                              width: 120,
                              child: FloatingActionButton.extended(
                                heroTag: 'fab_new_card',
                                // icon: Icon(Icons.send_sharp),
                                backgroundColor:
                                    /* widget.gameModel!.trackKPIs.isEmpty
                                        ? Colors.grey
                                        :*/
                                    AppColors.kRipple, //taskColor,
                                label: const Text(
                                  'Devam',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white),
                                ), //icon: Icon(Icons.send),
                                onPressed: /* (widget.gameModel!.trackKPIs.isEmpty)
                                    ? null
                                    : */
                                    () async {
                                  widget.gameModel!.trackKPIs.isEmpty
                                      ? await _showDialog2()
                                      : null;
                                  // widget.gameModel.saveGame();
                                  // Navigator.pop(context);
                                  widget.gameModel!.trackKPIs.contains("1") &&
                                          widget.gameModel!.dietId.isEmpty
                                      ? _showDialog()
                                      :
//Navigator.pushNamed(context, '/oyunOzet',arguments:widget.gameModel);
                                      widget.gameModel!.trackKPIs.isEmpty
                                          ? null
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      GameSummaryBeforeSending(
                                                        gameModel:
                                                            widget.gameModel!,
                                                        // model: model,
                                                      )
                                                  /*GameTaskDetailScreen(
                        gameModel: widget.gameModel,
                      ),*/
                                                  ),
                                            );

                                  /* if ((widget.gameModel.trackKPIs
                                      .contains("Diyet Planı") &&
                                  widget.gameModel.dietId.isNotEmpty) ||
                              !widget.gameModel.trackKPIs
                                  .contains("Diyet Planı"))
                            widget.gameModel.saveGame();*/

                                  /* if (periodPhrase.isEmpty) {
                        final snackBar = SnackBar(
                          content: Text(
                              'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                          backgroundColor: taskColor,
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        // _scaffoldKey.currentState.showSnackBar(snackBar);
                      } else {
                        widget.todoModel.addTodoToTask(taskId: widget.todom ==null ?null:widget.todom.id,periodName:periodName,periodPhrase:periodPhrase,periodTime:periodTime);
                        Navigator.pop(context);
                      }*/
                                },
                              ),
                            )));
                  },
                )*/
                  ),
                  Center(
                      child: isUploading
                          ? Loader(
                              child: Lottie.asset(
                                  "assets/lottie/bouncing-fruits.json",
                                  repeat: false,
                                  controller:
                                      lottieController)) /*Lottie.asset(
                            "assets/lottie/bouncing-fruits.json",
                            width: 300,
                            height: 300,*/

                          : const SizedBox()),
                ])));
  }

  selectDietDialog(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Lüftene Diet listenizi seçiniz."),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Favorilerimden ekle"), onPressed: () {}),
            SimpleDialogOption(
                child: Text("Yeni Diet listesi oluştur"), onPressed: () {}),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}

class ItemForGameTile extends StatelessWidget {
  DietTaskViewModel? taskModel;
  DietGameViewModel? gameModel;
  int? index;
  ItemForGameTile({this.taskModel, this.gameModel, this.index});
  @override
  Widget build(BuildContext context) {
    var a = taskModel!.dietPlanTitle;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameTaskDetailScreen(
                gameModel: gameModel,
                model: taskModel,
                //day: _selectedDay!,
              ),
            ));
      },
      child: Card(
        elevation: 5,
        child: Column(children: [
          ListTile(
            trailing: Icon(
              Icons.arrow_right,
              color: AppColors.kRipple,
            ),
            leading: Icon(
              Icons.calendar_today_outlined,
              color: AppColors.kRipple,
            ),
            title: Text(
                /*taskModel!.dietPlanTitle == ""
                    ? 'Diet Plan-' + (index! + 1).toString()
                    : taskModel!.dietPlanTitle,*/
                //gameModel!.gameTitle == ""
                gameModel!.dietPlansList.length > 1
                    ? gameModel!.gameTitle + '-' + (index! + 1).toString()
                    : gameModel!.gameTitle,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            //subtitle: Text('Icream is good for health'),
            //trailing: Icon(Icons.food_bank),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(

                  // padding: EdgeInsets.all(getProportionateScreenWidth(24)),
                  // height: getProportionateScreenWidth(143),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors.white,
                    //boxShadow: [kDefualtShadow],
                  ),
                  child: SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Friends(
                                                  1,
                                                  gameModel: gameModel!,
                                                )));
                                  },
                                  child: Column(children: [
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              kDefualtShadow2,
                                              kDefualtShadow3
                                            ],
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Icon(Icons.add,
                                            size: 20, color: AppColors.kRed)),
                                    VerticalSpacing(of: 10),
                                    Text(
                                      "Ekle",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11),
                                    ),
                                  ]),
                                ),
                              ),
                              MeCard2(currentUser!),
                              ...List.generate(
                                  gameModel!
                                      .members.length, // 4,//myFriends.length,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: getProportionateScreenWidth(
                                                kDefaultPadding)),
                                        child: FriendsCard(
                                          gameModel!.members[index],
                                          type: 2,
                                          press: () {},
                                        ),
                                      ))
                            ]),
                      )))),
        ]),
      ),
    );
  }
}

typedef Callback = void Function();
