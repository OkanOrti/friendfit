import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/component/iconpicker/icon_picker_builder.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:friendfit_ready/data/hero_id_model.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:friendfit_ready/screens/deneme.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:friendfit_ready/screens/addTaskScreen.dart';
import 'package:friendfit_ready/screens/addTaskScreenForGame.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:friendfit_ready/widgets/circular_clipper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:io';
import 'dart:async';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as reorder;
import 'package:friendfit_ready/screens/custom_expansion_tile.dart' as custom;

class DetailScreen extends StatefulWidget {
  final String? taskId;
  final HeroId? heroIds;
  final DietTask? task;
  final DietToDos? todo;
  // ignore: use_key_in_widget_constructors
  const DetailScreen(
      {Key? key, this.taskId, this.heroIds, this.task, this.todo});

  @override
  State<StatefulWidget> createState() {
    return _DetailScreenState();
  }
}

enum DraggingMode {
  iOS,
  Android,
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  final DietTaskViewModel model = serviceLocator<DietTaskViewModel>();
  AnimationController? _controller;
  Animation<Offset>? _animation;
  Color? taskColor;
  IconData? taskIcon;
  String? newTask;
  String? title;
  List<Choice>? iconsList;
  XFile? file;
  bool isUploading = false;
  //final CalendarController ctrlr =  CalendarController();
  String postId = Uuid().generateV4();
  ChoiceImage? selectedIconData = ChoiceImage(id: '1', image: null);

  final ImagePicker _picker = ImagePicker();

  int? indexCount;
  //DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  TextEditingController? _editingController;
  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;
  bool _enabled = true;
  AnimationController? _hideFabAnimController;
  final DateFormat dateFormat = DateFormat('HH:mm');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // List<ItemData> _items;
  /*DetailScreenState() {
    _items = List();
    for (int i = 0; i < 10; ++i) {
      String label = "List item $i";
      if (i == 5) {
        label += ". This item has a long label and will be wrapped.";
      }
      _items.add(ItemData(label, ValueKey(i)));
    }}
*/
  @override
  void initState() {
    indexCount = 0;
    newTask = '';
    title = widget.task!.title!;
    taskColor = Colors.grey; // ColorUtils.defaultColors[1];
    taskIcon = Icons.add;
    iconsList = [];
    _editingController = TextEditingController(text: title);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0.0, 0.0))
        .animate(_controller!);
    handleScroll();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
    model.getTaskTodos(currentUser!.id!, widget.task!.id!);
    model.getTaskIcons(widget.task!.iconIds!);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _controller!.dispose();
    _hideFabAnimController!.dispose();
    _editingController!.dispose();

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

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bilgi"),
            content: Text("Üzgünüm, 5 adetten fazla seçemezsiniz."),
            actions: <Widget>[
              FlatButton(
                child:
                    Text("Kapat", style: TextStyle(color: AppColors.kRipple)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _showDialogIcon(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Uyarı"),
            content: Text("Icon u listenizden silmek mi istiyorsunuz ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Sil", style: TextStyle(color: AppColors.kRipple)),
                onPressed: () {
                  setState(() {
                    model.iconsList.removeAt(index);
                    Navigator.of(context).pop();
                  });
                },
              ),
              FlatButton(
                child:
                    Text("Vazgeç", style: TextStyle(color: AppColors.kRipple)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  /* selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Menüne özel resim ekle"),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("FriendFit galerisinden seç "), onPressed: handleTakePhoto(parentContext)),
            SimpleDialogOption(
                child: Text("Kendi galerinden seç "),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text("İptal"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }*/
  void _showImageDialog() {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(20),
      title: Text(
        'Menüye kapak resmi ekleyin',
        style: TextStyle(fontSize: 18, color: AppColors.kFont),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Close",
            style: TextStyle(color: AppColors.kRipple),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
      content: SingleChildScrollView(
          child: Container(
        width: 300,
        height: 260.0,
        child: GridView.builder(
          itemBuilder: (BuildContext context, int index) {
            var iconData = choicesImages[index]; // widget.icons[index];
            return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedIconData = iconData;
                    });
                  },
                  //borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                      //padding: EdgeInsets.all(8.0),
                      child: Image(image: iconData.image!, fit: BoxFit.cover)),
                ));
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 0.9,
          ),
          itemCount: choicesImages.length,
        ),
      )),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  /*void reorderData(int oldindex, int newindex){
    setState(() {
      if(newindex>oldindex){
        newindex-=1;
      }
      final items =widget.item.removeAt(oldindex);
      widget.item.insert(newindex, items);
    });
  }

  void sorting(){
    setState(() {
      widget.item.sort();
    });
  }*/

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return this.model.items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = this.model.items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      this.model.items.removeAt(draggingIndex);
      this.model.items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = this.model.items[_indexOfKey(item)];

    //debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.Android;

  @override
  Widget build(BuildContext context) {
    _controller!.forward();

    //Task _task;

    /*  try {
      _task = _tasks.firstWhere((it) => it.id == widget.taskId);
    } catch (e) {
      return Container(
        color: Colors.white,
      );
    }*/

    return ChangeNotifierProvider<DietTaskViewModel>(
        create: (context) => model,
        child: Consumer<DietTaskViewModel>(
            builder: (context, model, child) => Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                shadow: const Shadow(
                                    blurRadius: 10.0,
                                    color: AppColors.kBackground),
                                child: Image(
                                    height: 180.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    image: selectedIconData?.image == null
                                        ? choicesImages
                                            .where((ChoiceImage a) =>
                                                a.id ==
                                                widget.task!.backgroundId)
                                            .first
                                            .image as ImageProvider
                                        : selectedIconData?.image
                                            as ImageProvider // selectedIconData.image//AssetImage("assets/images/diet.jpg"),
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 20.0,
                              right: 0.0,
                              child: !model.isEdited
                                  ? Container()
                                  : IconButton(
                                      tooltip: "Resim değiştir",
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      onPressed: () =>
                                          _showImageDialog(), //Navigator.pop(context),
                                      icon: const Icon(Icons.edit),
                                      iconSize: 20.0,
                                      color: AppColors.kFont,
                                    )),
                          Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              child: Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.only(left: 10.0),
                                    onPressed: () => Navigator.pop(context),
                                    icon: Icon(Icons.arrow_back_rounded),
                                    iconSize: 25.0,
                                    color: AppColors.kFont,
                                  ),
                                ],
                              )),
                          /*  Positioned(
                              bottom: 0.0,
                              left: 60.0,
                              child: !model.isEdited
                                  ? Container()
                                  : Text("Vazgeç",style: TextStyle(color: Colors.blue))),
                        
                        */

                          Positioned(
                            bottom: 0.0,
                            right: 80.0,
                            child: !model.isEdited
                                ? Container()
                                : IconButton(
                                    onPressed: () {
                                      model.isEdited = false;
                                      model.giveUp();
                                    },
                                    icon: Icon(Icons.undo),
                                    iconSize: 20.0,
                                    color: AppColors.kFont,
                                  ),
                          ),
                          Positioned(
                              bottom: 0.0,
                              right: 20.0,
                              child: !model.isEdited
                                  ? IconButton(
                                      tooltip: "",
                                      icon: Icon(Icons.edit),
                                      iconSize: 20,
                                      color: AppColors.kFont,
                                      onPressed: () {
                                        model.isEditControl(
                                            widget.task!.id!, currentUser!.id!);
                                      })
                                  : Container()),
                          Positioned(
                              bottom: 0.0,
                              right: 40.0,
                              child: !model.isEdited
                                  ? Container()
                                  : IconButton(
                                      tooltip: "",
                                      icon: const Icon(Icons.save_rounded),
                                      color: AppColors.kFont,
                                      onPressed: () {
                                        model.modifyTask(
                                          newTask!.isEmpty
                                              ? widget.task!.title!
                                              : newTask!,
                                          currentUser!.id!,
                                          selectedIconData?.image == null
                                              ? widget.task!.backgroundId!
                                              : selectedIconData!.id!,
                                          task: widget.task,
                                        );
                                      },
                                    )),
                          !model.isEdited
                              ? Container()
                              : Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child:
                                      /*IconButton(
                                iconSize: 30,
                                icon: Icon(Icons.share_rounded,
                                    color: AppColors.kFont),
                                onPressed: () {},
                              )*/
                                      SimpleAlertDialog(
                                          color: AppColors.kFont,
                                          onActionPressed: () {
                                            model.removeTask(widget.task!.id!);
                                            Navigator.pop(context);
                                          }),
                                ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: !model.isEdited
                            ? Text(title!,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColors.kFont,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24.0))
                            : TextField(
                                maxLines: 2,
                                controller: _editingController,
                                textAlign: TextAlign.center,
                                onChanged: (text) {
                                  setState(() {
                                    newTask = text;
                                    title = text;
                                  });
                                },
                                cursorColor: Colors.black, //taskColor,
                                autofocus: false, //true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  //labelText: title,
                                  //hintText: title,
                                  /*hintStyle: TextStyle(
                                                  color: Colors.black26,
                                                )*/
                                ),
                                style: const TextStyle(
                                    color: AppColors.kFont,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 26.0),
                              ),
                      ),
                      const SizedBox(height: 5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          height: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: model.iconsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == model.iconsList.length) {
                                      return SizedBox(
                                        height: 5, // size of FAB
                                      );
                                    }
                                    var choice = model.iconsList[index];
                                    indexCount = index;
                                    return GestureDetector(
                                      onTap: () {
                                        model.isEdited
                                            ? _showDialogIcon(index)
                                            : null;
                                      },
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: choice.image),
                                    );
                                  }),
                              model.isEdited
                                  ? IconPickerBuilder(
                                      preIconsList: model.iconsList,
                                      iconData: Choice(
                                          id: '1',
                                          image: Image(
                                              width: 35,
                                              height: 35,
                                              image: AssetImage(
                                                  'assets/images/nutrition_icons/clock.png'))), //taskIcon,
                                      highlightColor: AppColors.kRipple,
                                      action: (newIcon) {
                                        setState(() {
                                          //  choices.forEach((element) {element.isSelected=0;});
                                          //newIcon.isSelected=1;
                                          /*if(model.iconsList.length>3){
                                                    _showDialog();
                                                  } */

                                          if (newIcon.isSelected == 1 &&
                                              model.iconsList.length + 1 < 6) {
                                            model.iconsList.add(newIcon);
                                          } else if (newIcon.isSelected == 1 &&
                                              model.iconsList.length + 1 >= 6) {
                                            newIcon.isSelected = 0;
                                            _showDialog();
                                            //model.iconsList.add(newIcon);
                                          } else if (newIcon.isSelected == 0) {
                                            model.iconsList.remove(newIcon);
                                          }

                                          //model.iconsList.length>3?_showDialog():null;

                                          /*(newIcon.isSelected==1&& indexCount < 5)
                                                          ?  model.iconsList.add(newIcon)
                                                          : _showDialog();*/
                                        });
                                      })
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                          flex: 4,
                          child: !model.isEdited
                              ? CustomScrollView(
                                  controller: this._scrollController,
                                  // cacheExtent: 3000,
                                  slivers: <Widget>[
                                    SliverPadding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .padding
                                                .bottom),
                                        sliver: SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              return ItemStatic(
                                                data: this.model.items[index],
                                                // first and last attributes affect border drawn during dragging
                                                isFirst: index == 0,
                                                isLast: index ==
                                                    this.model.items.length - 1,
                                                //draggingMode: _draggingMode,
                                              );
                                            },
                                            childCount: this.model.items.length,
                                          ),
                                        )),
                                    // SizedBox(height:20)
                                  ],
                                )
                              : reorder.ReorderableList(
                                  onReorder: this._reorderCallback,
                                  onReorderDone: this._reorderDone,
                                  child: CustomScrollView(
                                    controller: _scrollController,
                                    // cacheExtent: 3000,
                                    slivers: <Widget>[
                                      SliverPadding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .padding
                                                  .bottom),
                                          sliver: SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                              (BuildContext context,
                                                  int index) {
                                                return Item(
                                                  model: this.model,
                                                  data: this.model.items[index],
                                                  // first and last attributes affect border drawn during dragging
                                                  isFirst: index == 0,
                                                  isLast: index ==
                                                      this.model.items.length -
                                                          1,
                                                  draggingMode: _draggingMode,
                                                );
                                              },
                                              childCount:
                                                  this.model.items.length,
                                            ),
                                          )),
                                    ],
                                  ),
                                ))
                    ]),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniCenterFloat,
                floatingActionButton: FadeTransition(
                  opacity: _hideFabAnimController!,
                  child: ScaleTransition(
                    scale: _hideFabAnimController!,
                    child: FloatingActionButton.extended(
                      heroTag: 'fab_new_task',
                      onPressed: () async {
                        if (model.isEdited) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddTaskScreen(todoModel: model),
                            ),
                          );
                        } else {
                          final snackBar = SnackBar(
                            content: Text(
                                'Değişiklik yapmak için lütfen önce değiştir simgesine tıklayınız..'),
                            backgroundColor: taskColor,
                          );
                          _scaffoldKey.currentState!.showSnackBar(snackBar);
                        }
                      },
                      tooltip: 'Öğün ekle',
                      backgroundColor:
                          model.isEdited ? AppColors.kRipple : Colors.grey,
                      foregroundColor: Colors.white,
                      label: Text("Öğün ekle"),
                      icon: Icon(Icons.add),
                    ),
                  ),
                ))));
  }
}

TimelineTile _buildTimelineTile(
    {_IconIndicator? indicator,
    BuildContext? context,
    DietTaskViewModel? model,
    DietToDos? todom,
    String? hour,
    String? name,
    String? phrase,
    DietToDos? todo,
    bool isLast = false,
    bool isFirst = false}) {
  return TimelineTile(
    alignment: TimelineAlign.manual,
    lineXY: 0.3,
    beforeLineStyle: LineStyle(
        color: !model!.isEdited
            ? AppColors.kRipple.withOpacity(0.5)
            : AppColors.kRipple),
    indicatorStyle: IndicatorStyle(
      //color: !model.isEdited? Colors.grey: AppColors.kRipple ,
      indicatorXY: 0.3,
      drawGap: true,
      width: 20,
      height: 20,
      indicator: indicator,
    ),
    isLast: isLast,
    isFirst: isFirst,
    startChild: Center(
      child: Container(
        alignment: const Alignment(0.0, -0.50),
        child: Text(
          hour!,
          style: TextStyle(
            fontSize: 16,
            // fontFamily: "Poppins",
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
    endChild: GestureDetector(
      onTap: !model.isEdited
          ? null
          : () async {
              await Navigator.push(
                context!,
                MaterialPageRoute(
                  builder: (context) =>
                      AddTaskScreen(todom: todom, todoModel: model),
                ),
              );
              model.getTaskTodos(currentUser!.id!, todom!.parentId!);
            },
      child: Container(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name!,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    !model.isEdited
                        ? Container()
                        : Icon(Icons.edit, size: 16, color: AppColors.kFont),
                    /* Checkbox(
                          value: todo?.isCompleted == 1 ? true : false,
                          onChanged: null)*/
                  ]),
              const SizedBox(height: 8),
              Text(
                phrase!,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Poppins"),
              )
            ],
          ),
        ),
      ),
    ),
  );
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
              title: Text('Diet listesini silmek mi istiyorsunuz ?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Listeyi sildikten sonra işlemi geri alamayacaksınız.'),
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

class _IconIndicator extends StatelessWidget {
  _IconIndicator({Key? key, this.iconData, this.size, this.color})
      : super(key: key);

  final IconData? iconData;
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                iconData,
                size: size,
                color: Color(0xFF9E3773).withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Item extends StatelessWidget {
  Item({
    this.model,
    this.data,
    this.isFirst,
    this.isLast,
    this.draggingMode,
  });
  DietTaskViewModel? model;
  final ItemData? data;
  //final DietToDos data;
  final bool? isFirst;
  final bool? isLast;
  final DraggingMode? draggingMode;
  final DateFormat dateFormat = DateFormat('HH:mm');

  ScrollController _scrollerController =
      ScrollController(initialScrollOffset: 0.0);

  Widget _buildChild(BuildContext context, reorder.ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == reorder.ReorderableItemState.dragProxy ||
        state == reorder.ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == reorder.ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst! && !placeholder
                  ? BorderSide.none // Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast! && placeholder
                  ? BorderSide.none //
                  : BorderSide.none //Divider.createBorderSide(context)
              ),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.Android
        ? reorder.ReorderableListener(
            child: Container(
              padding: EdgeInsets.only(right: 18.0, left: 18.0),
              color: Colors.yellow,
              child: Center(
                child: Icon(Icons.reorder, color: Color(0xFF888888)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity:
                state == reorder.ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.kRipple.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: custom.ExpansionTile(
                              initiallyExpanded: false,
                              headerBackgroundColor: Colors.transparent,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 22.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        /*Image(
        width: 45,
        height: 45,
        image: AssetImage('assets/images/raceFlag.png')),*/
                                        // Icon(Icons.flag,color: Colors.green,),
                                        Icon(Icons.timelapse,
                                            color: AppColors.kFont, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                            this.dateFormat.format(data
                                                    ?.todo.startDate
                                                    ?.toDate() ??
                                                DateTime.now()),
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                color: AppColors.kFont)),
                                        Text(" - "),

                                        // Icon(Icons.flag,color: Colors.red,),
                                        Text(
                                            this.dateFormat.format(
                                                data?.todo.endDate?.toDate() ??
                                                    DateTime.now() //""
                                                ),
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                color: AppColors.kFont)),
                                      ]),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    height: data!.todo.phrases!.length > 2
                                        ? 200
                                        : 100,
                                    child: Scrollbar(
                                      isAlwaysShown: true,
                                      controller: _scrollerController,
                                      radius: Radius.circular(5),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        controller: _scrollerController,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index ==
                                              data!.todo.phrases!.length) {
                                            return SizedBox(
                                              height: 56, // size of FAB
                                            );
                                          }
                                          var todo = data!.todo.phrases![index];
                                          return Padding(
                                            padding: EdgeInsets.only(top: 0.0),
                                            child: Container(
                                              //color: Colors.green,
                                              padding: EdgeInsets.only(
                                                  left: 22.0, right: 22.0),
                                              child: ListTile(
                                                  /*onTap: () => model.updateTodo(todo.copy(
                                          isCompleted: todo.isCompleted == 1 ? 0 : 1)),*/
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  leading: Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        unselectedWidgetColor:
                                                            AppColors.kFont,
                                                      ),
                                                      child: Transform.scale(
                                                        scale: 0.8,
                                                        child: Checkbox(
                                                            activeColor:
                                                                Colors.blue,
                                                            onChanged:
                                                                (value) {},
                                                            /* onChanged: (value) => model.updateTodo(
                                                todo.copy(isCompleted: value ? 1 : 0)),*/
                                                            value:
                                                                false //todo.isCompleted == 1 ? true : false
                                                            ),
                                                      )),
                                                  /*  trailing: IconButton(
                                                        icon: Icon(Icons.delete_outline),
                                                        onPressed: () {
                                                          //widget.todoModel.removeToDoPhrase(index);
                                                        },
                                                        //onPressed: () => model.removeTodo(todo),
                                                      ),*/
                                                  title: Transform(
                                                    transform: Matrix4
                                                        .translationValues(
                                                            -15, 0.0, 0.0),
                                                    child: Text(
                                                      todo,
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              AppColors.kFont,
                                                          /*todo.isCompleted == 1
                                                ? Colors.grey
                                                : Colors.black54,*/
                                                          decoration: TextDecoration
                                                              .none /* todo.isCompleted == 1
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,*/
                                                          ),
                                                    ),
                                                  )),
                                            ),
                                          );

                                          /* Container(
                                            padding: EdgeInsets.only(
                                                left: 22.0, right: 22.0),
                                            child: ListTile(
                                              /*onTap: () => model.updateTodo(todo.copy(
                                      isCompleted: todo.isCompleted == 1 ? 0 : 1)),*/
                                              contentPadding: EdgeInsets.zero,
                                              leading: Theme(
                                                data: Theme.of(context).copyWith(
                                                  unselectedWidgetColor:
                                                      AppColors.kFont,
                                                ),
                                                child: Checkbox(
                                                    activeColor: Colors.blue,
                                                    onChanged: (value) {},
                                                    /* onChanged: (value) => model.updateTodo(
                                            todo.copy(isCompleted: value ? 1 : 0)),*/
                                                    value:
                                                        false //todo.isCompleted == 1 ? true : false
                                                    ),
                                              ),
                                              /*  trailing: IconButton(
                                                    icon: Icon(Icons.delete_outline),
                                                    onPressed: () {
                                                      //widget.todoModel.removeToDoPhrase(index);
                                                    },
                                                    //onPressed: () => model.removeTodo(todo),
                                                  ),*/
                                              title: Text(
                                                todo,
                                                style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.normal,
                                                    color: AppColors.kFont,
                                                    /*todo.isCompleted == 1
                                            ? Colors.grey
                                            : Colors.black54,*/
                                                    decoration: TextDecoration
                                                        .none /* todo.isCompleted == 1
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,*/
                                                    ),
                                              ),
                                            ),
                                          );*/
                                        },
                                        itemCount:
                                            data!.todo.phrases!.length + 1,

                                        /* Text(data.todo.phrase,
                              style: Theme.of(context).textTheme.subtitle1),*/
                                      ),
                                    ),
                                  ),
                                )
                              ],
                              title: Center(
                                child: Text(data!.todo.title!,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 18,
                                        color: AppColors.kFont,
                                        fontWeight: FontWeight.w500)),
                              ))),
                    ),
                    // Triggers the reordering
                  ),
                  SizedBox(width: 5), //dragHandle,
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskScreen(
                              todom: data!.todo,
                              todoModel: this.model,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          color: Colors.transparent,
                          child: Icon(Icons.edit,
                              size: 18, color: Colors.black54)))
                  //IconButton(icon:Icon( FontAwesome5.edit),iconSize: 16, onPressed: () {  },)
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = reorder.DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return reorder.ReorderableItem(
        key: data!.key, //
        childBuilder: _buildChild);
  }
}
////
///

class ItemStatic extends StatelessWidget {
  ItemStatic({
    this.data,
    this.isFirst,
    this.isLast,
  });

  final ItemData? data;
  final bool? isFirst;
  final bool? isLast;
  final DateFormat dateFormat = DateFormat('HH:mm');
  ScrollController _scrollerController =
      ScrollController(initialScrollOffset: 0.0);
  Widget build(BuildContext context) {
    BoxDecoration? decoration;

    return Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.kRipple.withOpacity(0.3),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: custom.ExpansionTile(
                          initiallyExpanded: false,
                          headerBackgroundColor: Colors.transparent,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 22.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /*Image(
        width: 45,
        height: 45,
        image: AssetImage('assets/images/raceFlag.png')),*/
                                    // Icon(Icons.flag,color: Colors.green,),
                                    Icon(Icons.timelapse,
                                        color: AppColors.kFont, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                        this.dateFormat.format(
                                            data?.todo.startDate?.toDate() ??
                                                DateTime.now()),
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 15,
                                            color: AppColors.kFont)),
                                    Text(" - "),

                                    // Icon(Icons.flag,color: Colors.red,),
                                    Text(
                                        this.dateFormat.format(
                                            data?.todo.endDate?.toDate() ??
                                                DateTime.now()),
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 15,
                                            color: AppColors.kFont)),
                                  ]),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: Container(
                                //color: Colors.yellow,
                                height:
                                    data!.todo.phrases!.length > 2 ? 200 : 100,
                                child: Scrollbar(
                                  isAlwaysShown: true,
                                  controller: _scrollerController,
                                  radius: Radius.circular(5),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    controller: _scrollerController,
                                    //shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == data!.todo.phrases!.length) {
                                        return SizedBox(
                                          height: 56, // size of FAB
                                        );
                                      }
                                      var todo = data!.todo.phrases![index];
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: 0.0, left: 0, right: 0),
                                        child: Container(
                                          //color: Colors.green,
                                          padding: EdgeInsets.only(
                                              left: 22.0, right: 22.0, top: 0),
                                          child: ListTile(
                                              /*onTap: () => model.updateTodo(todo.copy(
                                          isCompleted: todo.isCompleted == 1 ? 0 : 1)),*/
                                              contentPadding: EdgeInsets.zero,
                                              leading: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    unselectedWidgetColor:
                                                        AppColors.kFont,
                                                  ),
                                                  child: Transform.scale(
                                                    scale: 0.8,
                                                    child: Checkbox(
                                                        activeColor:
                                                            Colors.blue,
                                                        onChanged: (value) {},
                                                        /* onChanged: (value) => model.updateTodo(
                                                todo.copy(isCompleted: value ? 1 : 0)),*/
                                                        value:
                                                            false //todo.isCompleted == 1 ? true : false
                                                        ),
                                                  )),
                                              /*  trailing: IconButton(
                                                        icon: Icon(Icons.delete_outline),
                                                        onPressed: () {
                                                          //widget.todoModel.removeToDoPhrase(index);
                                                        },
                                                        //onPressed: () => model.removeTodo(todo),
                                                      ),*/
                                              title: Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        -15, 0.0, 0.0),
                                                child: Text(
                                                  todo,
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: AppColors.kFont,
                                                      /*todo.isCompleted == 1
                                                ? Colors.grey
                                                : Colors.black54,*/
                                                      decoration: TextDecoration
                                                          .none /* todo.isCompleted == 1
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,*/
                                                      ),
                                                ),
                                              )),
                                        ),
                                      );
                                    },
                                    itemCount: data!.todo.phrases!.length + 1,

                                    /* Text(data.todo.phrase,
                                    style: Theme.of(context).textTheme.subtitle1),*/
                                  ),
                                ),
                              ),
                            ),
                            /*
                             Padding(
                               padding:  EdgeInsets.symmetric (horizontal:22.0,vertical:8),
                               child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text("Toplam kalori:",style:
                                TextStyle(color: AppColors.kFont,fontFamily: "Poppins",fontWeight: FontWeight.w500,fontSize: 14)),
                                Text(" 300 kal.",style:
                                TextStyle(color: AppColors.kFont,fontFamily: "Poppins",fontWeight: FontWeight.normal,fontSize: 14))
                                  ]   )
                          )
                          */
                          ],
                          title: Center(
                            child: Text(data!.todo.title!,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    color: AppColors.kFont,
                                    fontWeight: FontWeight.w500)),
                          ))),
                ),
              ),
              // Triggers the reordering
            ) //dragHandle,
          ],
        ),
      ),
    );
  }
}
