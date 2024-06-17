// ignore_for_file: file_names

import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/component/iconpicker/icon_picker_builder.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/data/hero_id_model.dart';
import 'package:friendfit_ready/data/task_model.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:friendfit_ready/screens/addTaskScreen.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:friendfit_ready/widgets/circular_clipper.dart';
import 'package:friendfit_ready/data/image_card.dart';

class AddDetailScreencopy extends StatefulWidget {
  final String? taskId;
  final HeroId? heroIds;
  final DietTaskViewModel? model;
  final DietTask? task;

  AddDetailScreencopy({this.taskId, this.heroIds, this.model, this.task});

  @override
  State<StatefulWidget> createState() {
    return _AddDetailScreencopyState();
  }
}

class _AddDetailScreencopyState extends State<AddDetailScreencopy>
    with TickerProviderStateMixin {
  final DietTaskViewModel model = serviceLocator<DietTaskViewModel>();
  AnimationController? _controller;
  Animation<Offset>? _animation;
  Color? taskColor;
  IconData? taskIcon;
  String newTask = "";
  List<Choice>? iconsList;
  ChoiceImage selectedIconData =
      ChoiceImage(id: '1', image: AssetImage('assets/images/diet.jpg'));
  int? indexCount;
  //DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;
  AnimationController? _hideFabAnimController;
  final DateFormat dateFormat = DateFormat('HH:mm');

  @override
  void initState() {
    indexCount = 0;
    newTask = '';
    taskColor = Colors.grey; // ColorUtils.defaultColors[1];
    taskIcon = Icons.add;
    iconsList = [];
    super.initState();
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
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _controller!.dispose();
    _hideFabAnimController!.dispose();

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
            content: Text("5 adetten fazla icon seçemezsiniz.."),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _showImageDialog() {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(20),
      title: Text(
        'Menüye kapak resmi ekleyin',
        style: TextStyle(fontSize: 18),
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

  @override
  Widget build(BuildContext context) {
    _controller!.forward();

    Task _task;

    /*  try {
      _task = _tasks.firstWhere((it) => it.id == widget.taskId);
    } catch (e) {
      return Container(
        color: Colors.white,
      );
    }*/

    var _todos = model
        .todos2; //_todos2.where((it) => it.parent == widget.taskId).toList();
    // var _hero = widget.heroIds;
    var _color =
        kIconColor; //Colors.red;//ColorUtils.getColorFrom(id: _task.color);
    var _icon =
        Icons.work; // IconData(_task.codePoint, fontFamily: 'MaterialIcons');

    return ChangeNotifierProvider<DietTaskViewModel>(
        create: (context) => model,
        child: Consumer<DietTaskViewModel>(
            builder: (context, model, child) => Scaffold(
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
                                  shadow: Shadow(
                                      blurRadius: 10.0,
                                      color: AppColors.kBackground),
                                  child: Image(
                                      height: 180.0,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      image: selectedIconData
                                          .image! //AssetImage("assets/images/diet.jpg"),
                                      ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 20.0,
                                right: 0.0,
                                child: IconButton(
                                  tooltip: "Resim değiştir",
                                  padding: EdgeInsets.only(left: 10.0),
                                  onPressed: () => _showImageDialog(),
                                  icon: Icon(Icons.edit),
                                  iconSize: 20.0,
                                  color: AppColors.kFont,
                                )),
                            Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                child: IconButton(
                                  padding: EdgeInsets.only(left: 10.0),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.model!.loadTasks(currentUser!.id!);
                                  },
                                  icon: Icon(Icons.arrow_back),
                                  iconSize: 25.0,
                                  color: AppColors.kFont,
                                )),
                            Positioned(
                                bottom: 0.0,
                                right: 40.0,
                                child: !model.isSaved
                                    ? IconButton(
                                        tooltip: "Kaydet",
                                        icon: Icon(Icons.save_rounded),
                                        color: AppColors.kFont,
                                        onPressed: () {
                                          model.addTask(
                                              newTask,
                                              currentUser!.id!,
                                              iconsList!,
                                              selectedIconData.id!);
                                        },
                                      )
                                    : IconButton(
                                        tooltip: "Değiştir ",
                                        icon: Icon(Icons.edit),
                                        color: AppColors.kFont,
                                        onPressed: () {})),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: SimpleAlertDialog(
                                () => {},
                                color: AppColors.kFont,

                                //  null // () => model.removeTask(_task),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Container(
                                //color: Colors.blue,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  TextField(
                                    textAlign: TextAlign.center,
                                    onChanged: (text) {
                                      setState(() => newTask = text);
                                    },
                                    cursorColor: Colors.black, //taskColor,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Diyet Menü Adı...',
                                        hintStyle: TextStyle(
                                          color: Colors.black26,
                                        )),
                                    style: TextStyle(
                                        color: AppColors.kFont,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30.0),
                                  ),

                                  SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      height: 40,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: iconsList!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (index ==
                                                    iconsList!.length) {
                                                  return SizedBox(
                                                    height: 5, // size of FAB
                                                  );
                                                }
                                                var choice = iconsList![index];
                                                indexCount = index;
                                                return Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0,
                                                        right: 10.0),
                                                    child: choice.image);
                                              }),
                                          IconPickerBuilder(
                                              iconData: Choice(
                                                  id: '1',
                                                  image: Image(
                                                      width: 35,
                                                      height: 35,
                                                      image: AssetImage(
                                                          'assets/images/nutrition_icons/clock.png'))), //taskIcon,
                                              highlightColor: AppColors.kRipple,
                                              action: (newIcon) => setState(() {
                                                    indexCount! < 4
                                                        ? iconsList!
                                                            .add(newIcon)
                                                        : _showDialog();
                                                  })),
                                        ],
                                      ),
                                    ),
                                  ),
                                  /*  SizedBox(height: 10),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 4.0),
                                    child: Hero(
                                      tag: "Okan", //_hero.remainingTaskId,
                                      child: Text(
                                        "3 Task",
                                        style: Theme.of(context)
                                            .textTheme
                                            .body1
                                            .copyWith(color: Colors.grey[500]),
                                      ),
                                    ),
                                  ),
*/
                                  // Spacer(),
                                  /*  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 36.0),
                                    child: Hero(
                                      tag: "Okan2", //_hero.progressId,
                                      child: TaskProgressIndicator(
                                          color: AppColors.kRipple,
                                          progress:
                                              5 //getTaskCompletionPercent(_task),
                                          ),
                                    ),
                                  ),*/
                                ])),
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child: Container(
                              //color: Colors.yellow,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                //controller: _scrollController,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == _todos.length) {
                                    return SizedBox(
                                      height: 10, // size of FAB
                                    );
                                  }
                                  var todom = _todos[index];

                                  return Container(
                                      padding: EdgeInsets.only(
                                          left: 22.0, right: 22.0),
                                      child: _buildTimelineTile(
                                        name: todom.title!,
                                        phrase: todom.phrase!,
                                        hour: formatDate(
                                            todom.startDate!.toDate(), [
                                          HH,
                                          ':',
                                          nn
                                        ]), //dateFormat.format(todom.startDateTodo.toDate()),
                                        indicator: const _IconIndicator(
                                          //iconData: Icons.work,
                                          size: 20,
                                        ),
                                        isFirst: index == 0 ? true : false,
                                        isLast: index == _todos.length - 1
                                            ? true
                                            : false,
                                        todo: todom,
                                      ));
                                },
                                itemCount: _todos.length + 1,
                              ),
                            ),
                          ),
                        ),
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
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddTaskScreen(todoModel: model),
                            ),
                          );
                        },
                        tooltip: 'Öğün ekle',
                        backgroundColor: AppColors.kRipple,
                        foregroundColor: Colors.white,
                        label: Text("Öğün ekle"),
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ),
                )));
  }
}

TimelineTile _buildTimelineTile(
    {_IconIndicator? indicator,
    String? hour,
    String? name,
    String? phrase,
    DietToDos? todo,
    bool isLast = false,
    bool isFirst = false}) {
  return TimelineTile(
    alignment: TimelineAlign.manual,
    lineXY: 0.3,
    beforeLineStyle: LineStyle(color: AppColors.kRipple),
    indicatorStyle: IndicatorStyle(
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
    endChild: Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 10),
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
                Checkbox(
                    value: todo?.isCompleted == 1 ? true : false,
                    onChanged: null)
              ]),
          const SizedBox(height: 4),
          const SizedBox(height: 4),
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
  );
}

typedef void Callback();

class SimpleAlertDialog extends StatelessWidget {
  final Color? color;
  final Callback onActionPressed;

  SimpleAlertDialog(
    this.onActionPressed, {
    @required this.color,
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
              title: Text('Delete this card?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'This is a one way street! Deleting this will remove all the task assigned in this card.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    onActionPressed();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.grey,
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
  const _IconIndicator({
    Key? key,
    this.iconData,
    this.size,
  }) : super(key: key);

  final IconData? iconData;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kRipple,
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
                color: const Color(0xFF9E3773).withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
