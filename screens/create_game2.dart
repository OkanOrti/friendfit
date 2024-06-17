// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/screens/MultiItem.dart';
import 'package:friendfit_ready/screens/gameTaskDetailScreen.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/screens/multipleGridItem.dart';
import 'package:flutter/rendering.dart';
import 'package:friendfit_ready/screens/gameSummary.dart';
import 'package:health/health.dart';

HealthFactory health = HealthFactory();

class CreateGame2 extends StatefulWidget {
  const CreateGame2({Key? key, this.gameModel}) : super(key: key);
  final DietGameViewModel? gameModel;

  @override
  _CreateNewTaskPage2State createState() => _CreateNewTaskPage2State();
}

class _CreateNewTaskPage2State extends State<CreateGame2>
    with TickerProviderStateMixin {
  //final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
  final DietTaskViewModel model = serviceLocator<DietTaskViewModel>();
  List<ItemMulti> itemList = [];
  List<ItemMulti> selectedList = [];
  final ScrollController _scrollController = ScrollController();
  AnimationController? _hideFabAnimController;

  List<String> selectedReportList = [];

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

  Future<void> fetchUserOrder() {
    // Imagine that this function is fetching user info from another service or database.
    return Future.delayed(
        const Duration(seconds: 2), () => print('Large Latte'));
  }

  void _showDialog() async {
    await showDialog(
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
    loadList();
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

  @override
  Widget build(BuildContext context) {
    //widget.gameModel.trackKPIs=[];

    return ChangeNotifierProvider<DietGameViewModel>.value(
        //create: (context) => widget.gameModel,
        value: widget.gameModel!,
        child: Consumer<DietGameViewModel>(
            builder: (context, model, child) => Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Oyun Kategori Seçimi',
                    style: TextStyle(color: AppColors.kFont),
                  ),
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //SizedBox(height: 40),
                          GridItemMulti(itemList[0], (bool value) {
                            setState(() {
                              if (value) {
                                selectedList.add(itemList[0]);
                                widget.gameModel!.trackKPIs
                                    .add(itemList[0].rank.toString());
                                widget.gameModel!.trackKPI_Names
                                    .add(itemList[0].title.toString());
                              } else {
                                selectedList.remove(itemList[0]);
                                //selectedList.forEach((element) {widget.gameModel.trackKPIs.add( element.rank);});
                                widget.gameModel!.trackKPIs
                                    .remove(itemList[0].rank.toString());
                                widget.gameModel!.trackKPI_Names
                                    .remove(itemList[0].title.toString());
                              }
                            });
                          }, Key(itemList[0].rank.toString())),
                          SizedBox(height: 50),
                          GridItemMulti(itemList[1], (bool value) {
                            setState(() {
                              if (value) {
                                selectedList.add(itemList[1]);
                                widget.gameModel!.trackKPIs
                                    .add(itemList[1].rank.toString());
                                widget.gameModel!.trackKPI_Names
                                    .add(itemList[1].title.toString());
                              } else {
                                selectedList.remove(itemList[1]);
                                //selectedList.forEach((element) {widget.gameModel.trackKPIs.add( element.rank);});
                                widget.gameModel!.trackKPIs
                                    .remove(itemList[1].rank.toString());
                                widget.gameModel!.trackKPI_Names
                                    .remove(itemList[1].title.toString());
                              }
                            });
                          }, Key(itemList[1].rank.toString())),
                          SizedBox(height: 100)

                          /*Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height:
                                MediaQuery.of(context).size.height / 2 - 100,
                            color: Colors.yellow,
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height:
                                MediaQuery.of(context).size.height / 2 - 100,
                            color: Colors.yellow,
                          ),*/

                          /*  Expanded(
                              //width: 300,height:300,
                              child: GridView.builder(
                                  controller: _scrollController,
                                  itemCount: itemList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          //childAspectRatio: 0.8,
                                          //crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemBuilder: (context, index) {
                                    return GridItemMulti(itemList[index],
                                        (bool value) {
                                      setState(() {
                                        if (value) {
                                          selectedList.add(itemList[index]);
                                          widget.gameModel!.trackKPIs
                                              .add(itemList[index].rank.toString());
                                          widget.gameModel!.trackKPI_Names
                                              .add(itemList[index].title.toString());
                                        } else {
                                          selectedList.remove(itemList[index]);
                                          //selectedList.forEach((element) {widget.gameModel.trackKPIs.add( element.rank);});
                                          widget.gameModel!.trackKPIs.remove(
                                              itemList[index].rank.toString());
                                          widget.gameModel!.trackKPI_Names.remove(
                                              itemList[index].title.toString());
                                        }
                                      });
                                      print("$index : $value");
                                    }, Key(itemList[index].rank.toString()));
                                  }),
                            ),*/
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Builder(
                  builder: (BuildContext context) {
                    return FadeTransition(
                        opacity: _hideFabAnimController!,
                        child: ScaleTransition(
                            scale: _hideFabAnimController!,
                            child: Container(
                              width: 120,
                              child: FloatingActionButton.extended(
                                heroTag: 'fab_new_card',
                                // icon: Icon(Icons.send_sharp),
                                backgroundColor:
                                    widget.gameModel!.trackKPIs.isEmpty
                                        ? Colors.grey
                                        : AppColors.kRipple, //taskColor,
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
                                          : widget.gameModel!.trackKPIs
                                                          .length ==
                                                      1 &&
                                                  widget.gameModel!.trackKPIs
                                                      .contains("2")
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          GameSummaryBeforeSending(
                                                            gameModel: widget
                                                                .gameModel!,
                                                            // model: model,
                                                          )
                                                      /*GameTaskDetailScreen(
                        gameModel: widget.gameModel,
                      ),*/
                                                      ),
                                                )
                                              : null;

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
                ))));
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

typedef Callback = void Function();
