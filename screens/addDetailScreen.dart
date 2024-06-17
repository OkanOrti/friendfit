// ignore_for_file: file_names, prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables, must_be_immutable, unused_element

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
import 'package:friendfit_ready/screens/taskSummary.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:friendfit_ready/screens/addTaskScreen.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:friendfit_ready/widgets/circular_clipper.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as reorder;
import 'package:friendfit_ready/screens/custom_expansion_tile.dart' as custom;
//import 'package:friendfit_ready/screens/addTaskScreenForGame.dart';

class AddDetailScreen extends StatefulWidget {
  final String? taskId;
  final HeroId? heroIds;
  final DietTaskViewModel? model;
  final DietTask? task;
  final int? days;
  const AddDetailScreen(
      {this.taskId, this.heroIds, this.model, this.task, this.days});

  @override
  State<StatefulWidget> createState() {
    return _AddDetailScreenState();
  }
}

enum DraggingMode {
  iOS,
  Android,
}

class _AddDetailScreenState extends State<AddDetailScreen>
    with TickerProviderStateMixin {
  //final DietTaskViewModel model = serviceLocator<DietTaskViewModel>();
  AnimationController? _controller;
  Animation<Offset>? _animation;
  Color? taskColor;
  IconData? taskIcon;
  String? title;
  String? newTask;
  List<Choice>? iconsList;
  ChoiceImage selectedIconData =
      ChoiceImage(id: '1', image: AssetImage('assets/images/diet.jpg'));
  int? indexCount;
  //DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  // ignore: prefer_final_fields
  ScrollController _scrollController =
      ScrollController(); // set controller on scrolling
  bool _show = true;
  AnimationController? _hideFabAnimController;
  final DateFormat dateFormat = DateFormat('HH:mm');
  DateTime? _selectedDay = DateTime.utc(2020, 11, 1);
  CalendarFormat _calendarFormat = CalendarFormat.week;
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
    setCalendarFormat(widget.days!);
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
  }

  setCalendarFormat(int days) {
    if (days < 8) {
      _calendarFormat = CalendarFormat.week;
    } else if (days > 7 && days < 15) {
      _calendarFormat = CalendarFormat.twoWeeks;
    } else if (days > 14 && days < 22) {
      _calendarFormat = CalendarFormat.threeWeeks;
    } else if (days > 21 && days < 29) {
      _calendarFormat = CalendarFormat.fourWeeks;
    } else {
      _calendarFormat = CalendarFormat.month;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _controller?.dispose();
    _hideFabAnimController?.dispose();

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
        _hideFabAnimController?.reverse();
        //hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _hideFabAnimController?.forward();
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
          child: SizedBox(
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
                    widget.model!.iconsList.removeAt(index);
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

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return widget.model!.items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = widget.model!.items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      widget.model!.items.removeAt(draggingIndex);
      widget.model!.items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = widget.model!.items[_indexOfKey(item)];
    //debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  DraggingMode _draggingMode = DraggingMode.Android;

  @override
  Widget build(BuildContext context) {
    _controller?.forward();

    Task _task;

    /*  try {
      _task = _tasks.firstWhere((it) => it.id == widget.taskId);
    } catch (e) {
      return Container(
        color: Colors.white,
      );
    }*/

    var _todos = widget.model!
        .todos2; //_todos2.where((it) => it.parent == widget.taskId).toList();
    // var _hero = widget.heroIds;
    var _color =
        kIconColor; //Colors.red;//ColorUtils.getColorFrom(id: _task.color);
    var _icon =
        Icons.work; // IconData(_task.codePoint, fontFamily: 'MaterialIcons');

    dailyButtons(int range) {
      List<DialKey> a = [];
      for (int i = 0; i < range; i++) {
        a.add(DialKey(number: (i + 1).toString()));
      }
      return a;
    }

    return ChangeNotifierProvider<DietTaskViewModel>.value(
        value: widget.model!,
        child: Consumer<DietTaskViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      '',
                      style: TextStyle(color: AppColors.kFont),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    actions: [
                      model.isSaved || model.isEdited
                          ? SimpleAlertDialog(
                              () {},
                              color: AppColors.kFont,
                              //onActionPressed:(){}
                              //null // () => model.removeToDo(model.taskId, todoId),
                            )
                          : Container(),
                      /*IconButton(
                          tooltip: "Değiştir ",
                          icon: Icon(
                            Icons.undo,
                            size: 20,
                          ),
                          color: AppColors.kFont,
                          onPressed: () {
                            //model.isSaved = false;
                            model.refresh();
                          }),*/
                      !model.isSaved
                          ? IconButton(
                              tooltip: "Kaydet",
                              icon: Icon(Icons.save_rounded),
                              color: AppColors.kFont,
                              onPressed: () {
                                if (!widget.model!
                                    .checkSaveCondition(model, widget.days!)) {
                                  model.isEdited = false;
                                  model.isSaved = true;

                                  model.createdTaskId == null
                                      ? model.addTask(
                                          newTask!,
                                          currentUser!.id!,
                                          iconsList!,
                                          selectedIconData.id!)
                                      : model.modifyTask(
                                          newTask!,
                                          currentUser!.id!,
                                          selectedIconData.id!);
                                  widget.model!.refresh();
                                } else {
                                  _showDayErrorDialog();
                                }
                              },
                            )
                          : IconButton(
                              tooltip: "Değiştir ",
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                              ),
                              color: AppColors.kFont,
                              onPressed: () {
                                model.isSaved = false;

                                model.refresh();
                              })
                    ],
                  ),
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Günler",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.kRipple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 10),
                          Divider(height: 1),

                          /* Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(Icons.arrow_back),
                                          Spacer(),
                                          const Text("Günler",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: AppColors.kRipple,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                          Spacer(),
                                          SimpleAlertDialog(
                                            () {},
                                            color: AppColors.kFont,
                                            //onActionPressed:(){}
                                            //null // () => model.removeToDo(model.taskId, todoId),
                                          ),
                                          !model.isSaved
                                              ? IconButton(
                                                  tooltip: "Kaydet",
                                                  icon: Icon(Icons.save_rounded),
                                                  color: AppColors.kFont,
                                                  onPressed: () {
                                                    model.isEdited = false;
                                                    model.isSaved = true;
                                                    model.createdTaskId == null
                                                        ? model.addTask(
                                                            newTask!,
                                                            currentUser!.id!,
                                                            iconsList!,
                                                            selectedIconData.id!)
                                                        : model.modifyTask(
                                                            newTask!,
                                                            currentUser!.id!,
                                                            selectedIconData.id!);
                                                  },
                                                )
                                              : IconButton(
                                                  tooltip: "Değiştir ",
                                                  icon: Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                  ),
                                                  color: AppColors.kFont,
                                                  onPressed: () {
                                                    model.isSaved = false;
                                                    model.refresh();
                                                  })
                                        ]),
                                    SizedBox(height: 5),*/
                          Container(child: _buildTableCalendarWithBuilders()),
                          Divider(
                            height: 1,
                            //color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: Container(
                                //height: 200,
                                //ıwsxhjhjhjcolor: Colors.yellow,
                                child: model.isEdited
                                    ? CustomScrollView(
                                        shrinkWrap: true,
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
                                                    return ItemStatic(
                                                      data: widget
                                                          .model!.items[index],
                                                      // first and last attributes affect border drawn during dragging
                                                      isFirst: index == 0,
                                                      isLast: index ==
                                                          widget.model!.items
                                                                  .length -
                                                              1,
                                                      //draggingMode: _draggingMode,
                                                    );
                                                  },
                                                  childCount: widget
                                                      .model!.items.length,
                                                ),
                                              )),
                                          // SizedBox(height:20)
                                        ],
                                      )
                                    : reorder.ReorderableList(
                                        onReorder: _reorderCallback,
                                        onReorderDone: _reorderDone,
                                        child: CustomScrollView(
                                          controller: _scrollController,
                                          // cacheExtent: 3000,
                                          slivers: <Widget>[
                                            SliverPadding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .padding
                                                            .bottom),
                                                sliver: SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                        int index) {
                                                      return Item(
                                                          //key: UniqueKey(),
                                                          model: widget.model!,
                                                          data: widget.model!
                                                                      .dayItems[
                                                                  _selectedDay!
                                                                      .day
                                                                      .toInt()]![
                                                              index],
                                                          // first and last attributes affect border drawn during dragging
                                                          isFirst: index == 0,
                                                          isLast: index ==
                                                              widget
                                                                      .model!
                                                                      .dayItems[_selectedDay!
                                                                          .day
                                                                          .toInt()]!
                                                                      .length -
                                                                  1,
                                                          draggingMode:
                                                              _draggingMode,
                                                          day: _selectedDay!.day
                                                              .toInt());
                                                    },
                                                    childCount: model.dayItems[
                                                                _selectedDay!
                                                                    .day
                                                                    .toInt()] ==
                                                            null
                                                        ? 0
                                                        : model
                                                            .dayItems[
                                                                _selectedDay!
                                                                    .day
                                                                    .toInt()]!
                                                            .length,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      )),
                          ),
                        ]),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterFloat,
                  floatingActionButton: FadeTransition(
                    opacity: _hideFabAnimController!,
                    child: ScaleTransition(
                      scale: _hideFabAnimController!,
                      child: FloatingActionButton.extended(
                        heroTag: 'fab_new_task',
                        onPressed: () async {
                          if (!model.isSaved) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTaskScreen(
                                  todoModel: model,
                                  day: _selectedDay!.day.toInt(),
                                ),
                              ),
                            );
                          } else if (model.isSaved) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskSummary(
                                  taskModel: model,
                                  days: widget.days,

                                  //todoModel: model,
                                  //day: _selectedDay!.day.toInt(),
                                ),
                              ),
                            );
                          }
                        },
                        tooltip: '',
                        backgroundColor: AppColors.kRipple,
                        //!model.isSaved ? AppColors.kRipple : Colors.grey,
                        foregroundColor: Colors.white,
                        label:
                            !model.isSaved ? Text("Öğün ekle") : Text("Devam"),
                        // icon: Icon(Icons.add),
                      ),
                    ),
                  ),
                )));
  }

  void _showDayErrorDialog() {
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(20),
        title: Text(
          'Uyarı',
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Kapat",
              style: TextStyle(color: AppColors.kRipple),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
        content: Text("Lütfen eksik günleri tamamlayınız."));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        /* color: _calendarController.isSelected(date)
              ? Colors.green[300]
              : _calendarController.isToday(date)
                  ? Colors.green[300]
                  : Colors.green[400],*/
      ),
      width: 15.0,
      height: 15.0,
      child: Center(
        child: Text(
          '',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    print('CALLBACK: _onDaySelected');
    _selectedDay = day;
    //  taskmodel.selectedDay = day;
    setState(() {
      // _selectedEvents = events;
      /*  taskmodel.isEdited = false;
        taskmodel.toogle = false;
        //this.taskmodel.selectedDailyPlanTodos[this.dateFormat.format(day)]=  this.taskmodel.copy(taskmodel.todosFirst);
        taskmodel.selectedDailyPlanTodosModify[dateFormat.format(day)] = null;
        taskmodel.savedDailyPlanTodosModify[dateFormat.format(day)] = null;
*/
      _hideFabAnimController!.forward();
      showFloationButton();

      _show = true;
      //this.taskmodel.selectedTask = dailyPlanTask[_selectedDay.day];
      //this.taskmodel.selectedTodos = dailyPlanTodos[_selectedDay.day];

      //taskmodel.todos2 =[];
    });
  }

  List<ItemData> _getEventsfromDay(DateTime date) {
    /*List<DietToDos> b = [];
    //  return
    if (taskmodel.dailyEvents[DateTime(date.year, date.month, date.day)] ==
        null) {
      return [];
    } else {
      List<DietToDos>? a =
          taskmodel.dailyEvents[DateTime(date.year, date.month, date.day)];
      b.add(a!.first);
      return b;
    }*/
    return widget.model!.dayItems[date.day.toInt()] ?? [];
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      // shouldFillViewport: true,
      // rowHeight: 100,
      daysOfWeekVisible: false,
      headerVisible: false,
      firstDay: DateTime.utc(2021, 11, 1),
      lastDay: DateTime.utc(2021, 11, widget.days!),
      eventLoader: _getEventsfromDay,

      locale: 'tr_TR',
      //calendarController: _calendarController,
      //events: this.model.dayItems, // _events,
      focusedDay: DateTime.utc(2021, 11, 1),

      //currentDay: DateTime.utc(2020, 11, 1),
      //holidays: _holidays,
      calendarFormat: _calendarFormat,

      startingDayOfWeek: StartingDayOfWeek.monday,
      //availableGestures: AvailableGestures.all,

      /*availableCalendarFormats: const {
          CalendarFormat.twoWeeks: "",
          CalendarFormat.week: "",
          CalendarFormat.month: ""
        },*/
      /*onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() => _calendarFormat = format);
          }
        },*/
      calendarStyle: CalendarStyle(
        //rowDecoration:BoxDecoration(boxShadow: ) ,
        markerSize: 10,
        markersMaxCount: 1,
        markerDecoration:
            BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        weekendTextStyle: TextStyle(color: Colors.black),
        defaultTextStyle: TextStyle(color: Colors.black),
        disabledTextStyle: TextStyle(color: Colors.white),

        /* selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
            //weekendStyle: TextStyle().copyWith(color: Colors.black),
            // holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
          */
      ),
      //daysOfWeekStyle: DaysOfWeekStyle(        weekendStyle: TextStyle().copyWith(color: Colors.blue[600])),

      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: true,
      ),
      selectedDayPredicate: (DateTime date) {
        return isSameDay(_selectedDay, date);
      },
      //eventLoader: _getEventsfromDay,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.kRipple.withOpacity(0.2),
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(5.0),
            ),
            margin: const EdgeInsets.all(8.0),
            //padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            //color: AppColors.kRipple, // Colors.deepOrange[300],
            width: 80,
            height: 80,
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        selectedBuilder: (context, date, _) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.kRipple.withOpacity(0.6),
              shape: BoxShape.circle,
              //borderRadius: BorderRadius.circular(5.0),
            ),
            margin: const EdgeInsets.all(8.0),
            //padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            //color: AppColors.kRipple, // Colors.deepOrange[300],
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayBuilder: (context, date, _) {
          return Container(
            //margin: const EdgeInsets.all(4.0),
            //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.transparent, //Colors.amber[400],
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle()
                    .copyWith(fontSize: 16.0, color: Colors.redAccent),
              ),
            ),
          );
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        _onDaySelected(selectedDay, focusedDay);
      },
      /* onDaySelected: (date, events, holidays) {
            _onDaySelected(date, events, holidays);
            _animationController!.forward(from: 0.0);
          },*/

      //onVisibleDaysChanged: _onVisibleDaysChanged,
      //onCalendarCreated: _onCalendarCreated,
    );
  }
}

typedef Callback = void Function();

class SimpleAlertDialog extends StatelessWidget {
  final Color? color;
  final Callback onActionPressed;

  const SimpleAlertDialog(
    this.onActionPressed, {
    @required this.color,
    //@required this.onActionPressed,
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
              title: Text('Planı silmek istiyor musun ?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Planınızdaki tüm günler silinecektir.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Sil'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //Navigator.of(context).pop();
                    onActionPressed();
                  },
                ),
                FlatButton(
                  child: Text('Kapat'),
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

class Item extends StatelessWidget {
  Item(
      {this.data,
      this.isFirst,
      this.isLast,
      this.draggingMode,
      this.model,
      this.day,
      Key? key})
      : super(key: key);
  DietTaskViewModel? model;
  // Key? key;
  final ItemData? data;
  //final DietToDos data;
  final bool? isFirst;
  final bool? isLast;
  final DraggingMode? draggingMode;
  final DateFormat dateFormat = DateFormat('HH:mm');
  final ScrollController _scrollerController =
      ScrollController(initialScrollOffset: 0.0);
  final int? day;

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
              padding: const EdgeInsets.fromLTRB(20, 5, 10, 10),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
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
                                              dateFormat.format(data!
                                                  .todo.startDate!
                                                  .toDate()),
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 15,
                                                  color: AppColors.kFont)),
                                          Text(" - "),

                                          // Icon(Icons.flag,color: Colors.red,),
                                          Text(
                                              dateFormat.format(data!
                                                      .todo.endDate!
                                                      .toDate() //??
                                                  //""
                                                  ),
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 15,
                                                  color: AppColors.kFont)),
                                        ]),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15.0),
                                    child: SizedBox(
                                      height: data!.todo.phrases!.length > 2
                                          ? 200
                                          : 100,
                                      child: Scrollbar(
                                        isAlwaysShown: true,
                                        controller: _scrollerController,
                                        radius: Radius.circular(5),
                                        child: ListView.builder(
                                          controller: _scrollerController,
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index ==
                                                data!.todo.phrases!.length) {
                                              return SizedBox(
                                                height: 56, // size of FAB
                                              );
                                            }
                                            var todo =
                                                data!.todo.phrases![index];
                                            return Container(
                                              padding: EdgeInsets.only(
                                                  left: 22.0, right: 22.0),
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
                                                        //   activeColor: Colors.blue,
                                                        onChanged: (value) {},
                                                        /* onChanged: (value) => model.updateTodo(
                                              todo.copy(isCompleted: value ? 1 : 0)),*/
                                                        value:
                                                            false //todo.isCompleted == 1 ? true : false
                                                        ),
                                                  ),
                                                ),
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
                                                ),
                                              ),
                                            );
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
                                  child: Text(
                                      data!.todo
                                          .title! //+" ("+data.todo.phrases.length.toString()+")"
                                      ,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                          color: AppColors.kFont,
                                          fontWeight: FontWeight.w500)),
                                ))),
                      ),
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
                              todoModel: model!,
                              day: day?.toInt(),
                              //day: sel,
                            ),
                          ),
                        );
                      },
                      child: !model!.isSaved
                          ? Container(
                              color: Colors.transparent,
                              child: Icon(Icons.edit,
                                  size: 18, color: Colors.black54))
                          : Container()) //dragHandle,
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

class ItemStatic extends StatelessWidget {
  ItemStatic({
    this.data,
    this.isFirst,
    this.isLast,
  });

  final ItemData? data;
  final bool? isFirst;
  final bool? isLast;
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
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: SizedBox(
                                height:
                                    data!.todo.phrases!.length > 2 ? 200 : 100,
                                child: Scrollbar(
                                  isAlwaysShown: true,
                                  controller: _scrollerController,
                                  radius: Radius.circular(5),
                                  child: ListView.builder(
                                    controller: _scrollerController,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == data!.todo.phrases!.length) {
                                        return SizedBox(
                                          height: 56, // size of FAB
                                        );
                                      }
                                      var todo = data!.todo.phrases![index];
                                      return Container(
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
                                      );
                                    },
                                    itemCount: data!.todo.phrases!.length + 1,

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
              ),
              // Triggers the reordering
            ) //dragHandle,
          ],
        ),
      ),
    );
  }
}

class DialKey extends StatelessWidget {
  final String? number;
  final String? letters;

  const DialKey({this.number, this.letters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: FloatingActionButton(
          elevation: 4,
          onPressed: () {},
          backgroundColor: AppColors.kRipple.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$number',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class PlanCard extends StatefulWidget {
  final DietTaskViewModel? taskModel;
  // final DietGameViewModel? gameModel;
  //final DietTask selectedTask;
  //final List<DietToDos> selectedTodos;
  final DateTime? day;
  Map? events;
  ScrollController? scrollController2;
  BuildContext? context;

  PlanCard({
    //this.selectedTask,
    //this.selectedTodos,

    this.taskModel,
    //this.gameModel,
    this.day,
    this.events,
    this.scrollController2,
  });

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  TextEditingController? _editingController;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String? titleSelected;
  String? titleSaved;
  String? title;
  List<DietToDos>? viewedTodos;
  List<DietToDos>? selectedTodos;
  List<DietToDos>? selectedTodosFirst;
  List<DietToDos>? selectedTodosModified;
  List<DietToDos>? savedTodos = [];
  @override
  void initState() {
    // TODO: implement initState

    titleSelected = "";
    titleSaved = "";
    _editingController = new TextEditingController();
    super.initState();
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return widget.taskModel!.items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = widget.taskModel!.items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      widget.taskModel!.items.removeAt(draggingIndex);
      widget.taskModel!.items.insert(newPositionIndex, draggedItem);
      List<DietToDos> itemsReordered = [];
      widget.taskModel!.items.forEach((element) {
        itemsReordered.add(element.todo);
      });

      widget.taskModel!.savedDailyPlanTodos[
                  dateFormat.format(widget.taskModel!.selectedDay!)] ==
              null
          ? widget.taskModel!.selectedDailyPlanTodosModify[dateFormat
              .format(widget.taskModel!.selectedDay!)] = itemsReordered
          : widget.taskModel!.savedDailyPlanTodosModify[dateFormat
              .format(widget.taskModel!.selectedDay!)] = itemsReordered;
      widget.taskModel!.toogle = true;
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = widget.taskModel!.items[_indexOfKey(item)];
    //debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  //DraggingMode _draggingMode = DraggingMode.Android;

  @override
  Widget build(BuildContext context) {
    titleSelected = widget.taskModel!
                .selectedTaskTitleModify?[dateFormat.format(widget.day!)] ==
            null
        ? widget
            .taskModel!.selectedTaskTitleCopy![dateFormat.format(widget.day!)]
        : widget.taskModel!
            .selectedTaskTitleModify![dateFormat.format(widget.day!)];

    titleSaved = widget.taskModel!
                .savedTaskTitleModify?[dateFormat.format(widget.day!)] ==
            null
        ? widget.taskModel!.savedTaskTitleCopy![dateFormat.format(widget.day!)]
        : widget
            .taskModel!.savedTaskTitleModify![dateFormat.format(widget.day!)];
    title = (titleSaved == null || titleSaved!.isEmpty)
        ? titleSelected
        : titleSaved;

    widget.taskModel!.editedTitle = title!;

    selectedTodos = widget.taskModel!
                .selectedDailyPlanTodosModify[dateFormat.format(widget.day!)] ==
            null
        ? widget.taskModel!
            .selectedDailyPlanTodosCopy[dateFormat.format(widget.day!)]
        : widget.taskModel!
            .selectedDailyPlanTodosModify[dateFormat.format(widget.day!)];
    savedTodos = widget.taskModel!
                .savedDailyPlanTodosModify[dateFormat.format(widget.day!)] ==
            null
        ? widget
            .taskModel!.savedDailyPlanTodosCopy[dateFormat.format(widget.day!)]
        : widget.taskModel!
            .savedDailyPlanTodosModify[dateFormat.format(widget.day!)];
    viewedTodos = (savedTodos == null || savedTodos!.isEmpty)
        ? selectedTodos
        : savedTodos;
    !widget.taskModel!.toogle
        ? widget.taskModel!.setToDoKeys(viewedTodos!)
        : null;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.taskModel!.isEdited
                  ? Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          widget.taskModel!.isEdited = false;
                          //widget.taskModel.savedDailyPlanTodos[this.dateFormat.format(widget.day)]= widget.taskModel.copy(widget.taskModel.savedDailyPlanTodosCopy[widget.day]);
                          //widget.taskModel.selectedDailyPlanTodos[this.dateFormat.format(widget.day)]=  widget.taskModel.copy(widget.taskModel.todosFirst);
                          //widget.taskModel.selectedDailyPlanTodos[this.dateFormat.format(widget.day)]=  widget.taskModel.copy(widget.taskModel.selectedDailyPlanTodosCopy[this.dateFormat.format(widget.day)]);

                          //1 widget.taskModel.selectedDailyPlanTodos[this.dateFormat.format(widget.day)]=null;

                          widget.taskModel!.selectedTaskTitleModify?[
                                  dateFormat.format(widget.day!)] =
                              widget.taskModel!.titleCopy!;
                          widget.taskModel!.savedTaskTitleModify?[
                              dateFormat.format(widget.day!)] = "";
                          widget.taskModel!.selectedDailyPlanTodosModify[
                              dateFormat.format(widget.day!)] = null;
                          widget.taskModel!.savedDailyPlanTodosModify[
                              dateFormat.format(widget.day!)] = null;
                          widget.taskModel!.toogle = false;
                          widget.taskModel!.dailyEvents[DateTime(
                                  widget.day!.year,
                                  widget.day!.month,
                                  widget.day!.day)] =
                              widget.taskModel!.savedDailyPlanTodos[
                                          dateFormat.format(widget.day!)] ==
                                      null
                                  ? widget.taskModel!.selectedDailyPlanTodos[
                                      dateFormat.format(widget.day!)] // []
                                  : widget.taskModel!
                                      .savedDailyPlanTodos[dateFormat.format(widget.day!)];

                          widget.taskModel!.dailyEventsTitle[DateTime(
                              widget.day!.year,
                              widget.day!.month,
                              widget.day!.day)] = widget.taskModel!.savedTaskTitle![
                                      dateFormat.format(widget.day!)] ==
                                  null
                              ? widget.taskModel!.selectedTaskTitle![
                                  dateFormat.format(widget.day!)] // []
                              : widget.taskModel!
                                  .savedTaskTitle![dateFormat.format(widget.day!)];

                          widget.taskModel!.refresh();
                        },
                        child: !widget.taskModel!.isSaved
                            ? Text("Vazgeç",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.blue,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0))
                            : Container(),
                      ))
                  : Expanded(flex: 1, child: SizedBox()),

              widget.taskModel!.isEdited
                  ? Expanded(
                      flex: 2,
                      child: Container(
                        // height: 10,
                        //width: 10,
                        // color: Colors.green,
                        child: Row(
                          //mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                  onTap: () {
                                    /* showDialog(
                                        context: context,
                                        builder: (_) {
                                          return ShowTitleDialog(
                                              model: widget.taskModel!);
                                        });*/
                                  },
                                  child: Text(
                                    title ?? "",
                                    softWrap: true,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins"),
                                  )),
                            ),
                            SizedBox(width: 0),
                            Icon(Icons.edit, size: 14, color: AppColors.kFont),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      flex: 2,
                      child: Text(
                        title ?? "",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins"),
                      ),
                    ),
              //Spacer(flex:), //SizedBox(width: 10),
              !widget.taskModel!.isEdited
                  ? Expanded(
                      flex: 1,
                      child: Center(
                          child: Container(
                        alignment: Alignment.centerRight,
                        //width: 10,
                        // color: Colors.pink,
                        child: InkWell(
                            onTap: () async {
                              widget.taskModel!.selectedTaskTitleModify![
                                      dateFormat.format(widget.day!)] =
                                  widget.taskModel!.selectedTaskTitleCopy![
                                      dateFormat.format(widget.day!)]!;

                              widget.taskModel!.savedTaskTitleModify![
                                      dateFormat.format(widget.day!)] =
                                  widget.taskModel!.savedTaskTitleCopy![
                                      dateFormat.format(widget.day!)]!;

                              widget.taskModel!.selectedDailyPlanTodosModify[
                                      dateFormat.format(widget.day!)] =
                                  widget.taskModel!.copy(widget.taskModel!
                                          .selectedDailyPlanTodosCopy[
                                      dateFormat.format(widget.day!)]);
                              widget.taskModel!.savedDailyPlanTodosModify[
                                      dateFormat.format(widget.day!)] =
                                  widget.taskModel!.copy(
                                      widget.taskModel!.savedDailyPlanTodosCopy[
                                          dateFormat.format(widget.day!)]);
                              /* widget.taskModel!.dailyEvents[DateTime(
                                widget.day!.year,
                                widget.day!.month,
                                widget.day!.day)] = [];*/
                              widget.taskModel!
                                  .isEditControl("", "", day: widget.day);
                            },
                            child: !widget.taskModel!.isSaved
                                ? Text("Düzenle",
                                    //softWrap: false,
                                    // maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0))
                                : SizedBox()),
                      )))
                  : Expanded(
                      flex: 1,
                      child: Center(
                          child: Container(
                        alignment: Alignment.centerRight,
                        //width: 10,
                        // color: Colors.pink,
                        child: InkWell(
                          onTap: () async {
                            DateFormat dateFormat2 = DateFormat('yyyy-MM-dd');
                            //widget.taskModel.savedDailyPlanTask[this.dateFormat.format(widget.day)] = widget.taskModel.selectedDailyPlanTask[this.dateFormat.format(widget.day)];
                            widget.taskModel!.savedTaskTitle![
                                dateFormat.format(widget.day!)] = title!;
                            List<DietToDos> todosReordered = [];
                            widget.taskModel!.items.forEach((element) {
                              todosReordered.add(element.todo);
                            });
                            widget.taskModel!.savedDailyPlanTodosCopy[
                                    dateFormat.format(widget.day!)] =
                                widget.taskModel!.copy(todosReordered);

                            widget.taskModel!.savedTaskTitleCopy![
                                    dateFormat.format(widget.day!)] =
                                widget.taskModel!.titleModified ??
                                    widget.taskModel!.editedTitle;

                            widget.taskModel!.savedDailyPlanTodos[dateFormat
                                .format(widget.day!)] = todosReordered;

                            widget.taskModel!.dailyEvents[DateTime(
                                    widget.day!.year,
                                    widget.day!.month,
                                    widget.day!.day)] =
                                widget.taskModel!.savedDailyPlanTodos[
                                    dateFormat.format(widget.day!)];

                            widget.taskModel!.dailyEventsTitle[DateTime(
                                    widget.day!.year,
                                    widget.day!.month,
                                    widget.day!.day)] =
                                widget.taskModel!.savedTaskTitle![
                                    dateFormat.format(widget.day!)];
                            widget.taskModel!.isEdited = false;

                            widget.taskModel!.refresh();
                          },
                          child: Text("Kaydet",
                              //softWrap: false,
                              // maxLines: 1,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0)),
                        ),
                      )))
            ]),
        SizedBox(height: 15),
        Expanded(
            child: !widget.taskModel!.isEdited
                ? CustomScrollView(
                    controller: widget.scrollController2,
                    // cacheExtent: 3000,
                    slivers: <Widget>[
                      SliverPadding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ItemStatic(
                                  data: widget.taskModel!.items[index],
                                  // first and last attributes affect border drawn during dragging
                                  isFirst: index == 0,
                                  isLast: index ==
                                      widget.taskModel!.items.length - 1,
                                  //draggingMode: _draggingMode,
                                );
                              },
                              childCount: widget.taskModel!.items.length,
                            ),
                          )),
                    ],
                  )
                : reorder.ReorderableList(
                    onReorder: _reorderCallback,
                    onReorderDone: _reorderDone,
                    child: CustomScrollView(
                      controller: widget.scrollController2,
                      // cacheExtent: 3000,
                      slivers: <Widget>[
                        SliverPadding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Item(
                                      model: widget.taskModel!,
                                      data: widget.taskModel!.items[index],
                                      // first and last attributes affect border drawn during dragging
                                      isFirst: index == 0,
                                      isLast: index ==
                                          widget.taskModel!.items.length - 1,
                                      draggingMode: DraggingMode.Android);
                                },
                                childCount: widget.taskModel!.items.length,
                              ),
                            )),
                      ],
                    ),
                  )

            /*_buildTimelineTile(
                                          day: widget.day,
                                          context: context,
                                          model: widget.taskModel, // model,
                                          todom: todom,
                                          name: todom.title ?? "",
                                          phrase: todom.phrase,
                                          //dateFormat.format(todom.startDateTodo.toDate()),
                                          indicator: _IconIndicator(
                                            color: widget.taskModel.isEdited
                                                ? AppColors.kRipple
                                                : AppColors.kRipple.withOpacity(0.50),
                        
                                            //iconData: Icons.work,
                                            size: 20,
                                          ),
                                          isFirst: index == 0 ? true : false,
                                          isLast: index ==
                                                  (widget.taskModel.savedDailyPlanTodos[
                                                              this.dateFormat.format(widget.day)] ==
                                                          null
                                                      ? widget
                                                              .taskModel
                                                              .selectedDailyPlanTodos[
                                                                  this.dateFormat.format(widget.day)]
                                                              .length -
                                                          1
                                                      : widget
                                                              .taskModel
                                                              .savedDailyPlanTodos[
                                                                  this.dateFormat.format(widget.day)]
                                                              .length -
                                                          1)
                                              ? true
                                              : false,
                                          todo: todom,
                                        ),*/
            )
      ]),
    );
  }
}
*/