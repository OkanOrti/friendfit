// ignore_for_file: file_names, prefer_const_constructors, prefer_if_null_operators, use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:friendfit_ready/data/hero_id_model.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:friendfit_ready/screens/diets_page_selection.dart';
import 'package:friendfit_ready/screens/gameSummary.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/screens/addTaskScreenForGame.dart';
import 'package:flutter/rendering.dart';
import 'package:friendfit_ready/screens/custom_expansion_tile.dart' as custom;
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as reorder;

class GameTaskDetailScreen extends StatefulWidget {
  final DietGameViewModel? gameModel;
  final DietTaskViewModel? model;
  final String? taskId;
  final HeroId? heroIds;
  final DietTask? task;
  final DietToDos? todo;

  final Key? key;
  const GameTaskDetailScreen(
      {this.key,
      this.taskId,
      this.heroIds,
      this.task,
      this.todo,
      this.gameModel,
      this.model});

  @override
  State<StatefulWidget> createState() {
    return _GameTaskDetailScreenState();
  }
}

enum DraggingMode {
  iOS,
  Android,
}

class _GameTaskDetailScreenState extends State<GameTaskDetailScreen>
    with TickerProviderStateMixin {
  DietTaskViewModel? taskmodel;
  //CalendarController _calendarController = new CalendarController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  Map<DateTime, List>? _events;
  DateTime? _selectedDay;
  List? _selectedEvents;
  AnimationController? _animationController;
  AnimationController? _controller;
  Animation<Offset>? _animation;
  Color? taskColor;
  IconData? taskIcon;
  String? newTask;
  String? title;
  List<Choice>? iconsList;
  List? selectedTasks;
  final ImagePicker _picker = ImagePicker();

  XFile? file;
  bool isUploading = false;
  String postId = Uuid().generateV4();
  ChoiceImage selectedIconData = ChoiceImage(id: '1', image: null);

  int? indexCount;
  //DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  TextEditingController? _editingController;
  ScrollController _scrollController =
      ScrollController(); // set controller on scrolling
  bool _show = true;
  bool _enabled = true;
  AnimationController? _hideFabAnimController;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Map dailyPlanTask = {};
  Map dailyPlanTodos = {};

  int newDayRank = 1;
  @override
  void initState() {
    taskmodel = widget.model ?? serviceLocator<DietTaskViewModel>();
    _selectedDay = DateTime.now();
    taskmodel?.selectedDay = DateTime.now();
    //selectedTasks = [];
    indexCount = 0;
    // newTask = '';
    title = ""; //widget.task.title??"";
    taskColor = Colors.blueGrey; // ColorUtils.defaultColors[1];
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

    //_events = {}; //widget.gameModel.gameEvents;

    //////
    ///

    //_selectedEvents = _events[_selectedDay] ?? [];
    //_calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _controller!.dispose();
    _hideFabAnimController!.dispose();
    _editingController!.dispose();
    _animationController!.dispose();
    //_calendarController.dispose();

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
        // hideFloationButton();
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
            content: Text("6 adetten fazla icon seçemezsiniz.."),
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

  void _showDialogIcon(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Uyarı"),
            content: Text("Icon u listenizden silmek mi istiyorsunuz ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Sil"),
                onPressed: () {
                  setState(() {
                    //  model.iconsList.removeAt(index);
                    Navigator.of(context).pop();
                  });
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
          //controller: _scrollController,
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
                  // ignore: avoid_unnecessary_containers
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

  handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  List<DietToDos> _getEventsfromDay(DateTime date) {
    return taskmodel!
            .dailyEventsModify[DateTime(date.year, date.month, date.day)] ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    _controller!.forward();
    selectedTasks = [];

    //Task _task;

    /*  try {
      _task = _tasks.firstWhere((it) => it.id == widget.taskId);
    } catch (e) {
      return Container(
        color: Colors.white,
      );
    }*/

    //var _todos = taskmodel == null ? [] : taskmodel.selectedTodos;
    //.todos2; //_todos2.where((it) => it.parent == widget.taskId).toList();
    // var _hero = widget.heroIds;
    var _color =
        kIconColor; //Colors.red;//ColorUtils.getColorFrom(id: _task.color);
    var _icon =
        Icons.work; // IconData(_task.codePoint, fontFamily: 'MaterialIcons');

    void onDaySelected(DateTime day, List events, List holidays) {
      print('CALLBACK: _onDaySelected');
      _selectedDay = day;
      taskmodel!.selectedDay = day;
      setState(() {
        _selectedEvents = events;
        taskmodel!.isEdited = false;
        taskmodel!.toogle = false;
        //this.taskmodel.selectedDailyPlanTodos[this.dateFormat.format(day)]=  this.taskmodel.copy(taskmodel.todosFirst);
        //  taskmodel.selectedDailyPlanTodosModify[dateFormat.format(day)] = null;
        // taskmodel.savedDailyPlanTodosModify[dateFormat.format(day)] = null;

        _hideFabAnimController!.forward();
        //showFloationButton();

        //this._show=true;
        //this.taskmodel.selectedTask = dailyPlanTask[_selectedDay.day];
        //this.taskmodel.selectedTodos = dailyPlanTodos[_selectedDay.day];

        //taskmodel.todos2 =[];
      });
    }

    void _onDaySelected(DateTime day, DateTime focusedDay) {
      print('CALLBACK: _onDaySelected');
      _selectedDay = day;
      taskmodel!.selectedDay = day;
      setState(() {
        // _selectedEvents = events;
        /*  taskmodel.isEdited = false;
        taskmodel.toogle = false;
        //this.taskmodel.selectedDailyPlanTodos[this.dateFormat.format(day)]=  this.taskmodel.copy(taskmodel.todosFirst);
        taskmodel.selectedDailyPlanTodosModify[dateFormat.format(day)] = null;
        taskmodel.savedDailyPlanTodosModify[dateFormat.format(day)] = null;
*/
        _hideFabAnimController!.forward();
        taskmodel!.toogle = false;
        //showFloationButton();

        //this._show=true;
        //this.taskmodel.selectedTask = dailyPlanTask[_selectedDay.day];
        //this.taskmodel.selectedTodos = dailyPlanTodos[_selectedDay.day];

        //taskmodel.todos2 =[];
      });
    }

    void _onVisibleDaysChanged(
        DateTime first, DateTime last, CalendarFormat format) {
      print('CALLBACK: _onVisibleDaysChanged');
    }

    void _onCalendarCreated(
        DateTime first, DateTime last, CalendarFormat format) {
      print('CALLBACK: _onCalendarCreated');
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

    prepareGamePlan(DietGameViewModel gameModel, DietTaskViewModel taskModel) {
      bool error = true;
      List<DateTime> days = [];
      List<String> errorDays = [];

      for (int i = 0;
          i <= gameModel.endTime.difference(gameModel.startTime).inDays;
          i++) {
        days.add((DateTime(gameModel.startTime.year, gameModel.startTime.month,
            gameModel.startTime.day + i)));
      }

      Map<dynamic, List<DietToDos>?> preparedPlan = {};
      for (var element in days) {
        taskModel.dailyEventsModify[element] == null
            ? errorDays.add(dateFormat.format(element))
            : null;
      }

      /*days.forEach((element) {
        if (taskmodel.savedDailyPlanTodos.containsKey(element) &&
            taskmodel.savedDailyPlanTodos[element] != null) {
          preparedPlan[element] = taskmodel.savedDailyPlanTodos[element];
        } else if (taskmodel.selectedDailyPlanTodos.containsKey(element) &&
            taskmodel.selectedDailyPlanTodos[element] != null) {
          preparedPlan[element] = taskmodel.selectedDailyPlanTodos[element];
        } else {
          errorDays.add(element);
        }
      });*/
      errorDays.isEmpty ? error = false : error = true;
      return error;
    }

    void _showCopyDayDialog() {
      var genderOptions = [];
      Map<int, DateTime> genderOptionsMap = {};
      DateFormat dateFormat = DateFormat('dd-MM');

      for (var element in taskmodel!.dailyEvents.keys) {
        if (_selectedDay!.day != element.day) {
          genderOptions.add(element.day);
          genderOptionsMap[element.day] = element;
        }
        genderOptions.sort();
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Bilgi"),
              content: Builder(
                  builder: (context) =>
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        FormBuilderDropdown(
                          //dropdownColor: Colors.blue,
                          // menuMaxHeight: 50,
                          name: 'days',
                          decoration: const InputDecoration(
                              // labelText: 'Gender',
                              ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: const Text('Gün No'),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          items: genderOptions
                              .map((newDayRank) => DropdownMenuItem(
                                    onTap: () {
                                      this.newDayRank = newDayRank;
                                    },
                                    value: newDayRank,
                                    child: Text('$newDayRank'),
                                  ))
                              .toList(),
                        ),
                      ])),
              actions: <Widget>[
                FlatButton(
                  child: Text("Uygula", style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    taskmodel!.copyDayForGame(
                        _selectedDay!, genderOptionsMap[newDayRank]!);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Vazgeç",
                      style: TextStyle(color: AppColors.kRipple)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
//check day availability

      /*int maxDay = taskmodel.selectedValue!.toInt();

      List<int> x = [];
      for (int i = 1; i <= maxDay; i++) {
        x.add(i);
      }
      x.remove(_selectedDay!.day.toInt());
      x.sort();
      /* var genderOptions = [];

    for (var element in widget.model!.dayItems.keys) {
      if (_selectedDay!.day != element) {
        genderOptions.add(element);
      }
      genderOptions.sort();
    }*/

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Bilgi", style: TextStyle(color: AppColors.kRipple)),
              content: Builder(
                  builder: (context) =>
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        FormBuilderDropdown(
                          //dropdownColor: Colors.blue,
                          // menuMaxHeight: 50,
                          name: 'days',
                          decoration: const InputDecoration(
                              // labelText: 'Gender',
                              ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: const Text('Sıra No'),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          items: x
                              .map((newDayRank) => DropdownMenuItem(
                                    onTap: () {
                                      this.newDayRank = newDayRank;
                                    },
                                    value: newDayRank,
                                    child: Text('$newDayRank'),
                                  ))
                              .toList(),
                        ),
                      ])),
              actions: <Widget>[
                FlatButton(
                  child: Text("Uygula", style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    taskmodel.copyDay(_selectedDay!, newDayRank);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Vazgeç",
                      style: TextStyle(color: AppColors.kRipple)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });*/
    }

    void _showDayDialog() {
      /*DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    var a = [];
  

    taskmodel.dailyEvents.forEach((key, value) {
      a.add(dateFormat.format(key));
    });*/
      var genderOptions = [];
      Map<int, DateTime> genderOptionsMap = {};
      DateFormat dateFormat = DateFormat('dd-MM');

      for (var element in taskmodel!.dailyEvents.keys) {
        if (_selectedDay!.day != element.day) {
          genderOptions.add(element.day);
          genderOptionsMap[element.day] = element;
        }
        genderOptions.sort();
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Bilgi"),
              content: Builder(
                  builder: (context) =>
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        FormBuilderDropdown(
                          //dropdownColor: Colors.blue,
                          // menuMaxHeight: 50,
                          name: 'days',
                          decoration: const InputDecoration(
                              // labelText: 'Gender',
                              ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: const Text('Gün No'),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          items: genderOptions
                              .map((newDayRank) => DropdownMenuItem(
                                    onTap: () {
                                      this.newDayRank = newDayRank;
                                    },
                                    value: newDayRank,
                                    child: Text('$newDayRank'),
                                  ))
                              .toList(),
                        ),
                      ])),
              actions: <Widget>[
                FlatButton(
                  child: Text("Uygula", style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    taskmodel!.changeDayRankForGame(
                        _selectedDay!, genderOptionsMap[newDayRank]!);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Vazgeç",
                      style: TextStyle(color: AppColors.kRipple)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    void _showDayChoiceDialog(DateTime date) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              actionsOverflowDirection: VerticalDirection.up,
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: Text("Bilgi", style: TextStyle(color: AppColors.kRipple)),
              // content: Text("Üzgünüm, 5 adetten fazla seçemezsiniz."),
              content: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Sırasını değiştir",
                            style: TextStyle(color: AppColors.kFont)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showDayDialog();

                          //  widget.model!.changeDayRank(widget.task!, date);
                          // Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Kopyala",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          // widget.model!.deleteDay(widget.task!, _selectedDay!);
                          Navigator.of(context).pop();
                          _showCopyDayDialog();
                        },
                      ),
                      FlatButton(
                        child: Text("Sil",
                            style: TextStyle(color: AppColors.kRed)),
                        onPressed: () {
                          taskmodel!.deleteDay(widget.task!, _selectedDay!);
                          Navigator.of(context).pop();
                        },
                      )
                    ]),
              ),
            );
          });
    }

    Widget _buildTableCalendarWithBuilders() {
      return TableCalendar(
        firstDay: widget.gameModel!.startTime,
        lastDay: widget.gameModel!.endTime,
        eventLoader: _getEventsfromDay,

        locale: 'tr_TR',
        //calendarController: _calendarController,
        // events: this.taskmodel.dailyEvents, // _events,
        focusedDay: widget.gameModel!.startTime,
        //startDay: DateTime.now(),
        //holidays: _holidays,
        calendarFormat: CalendarFormat.twoWeeks,
        //formatAnimation: FormatAnimation.slide,
        //startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.all,
        availableCalendarFormats: const {
          CalendarFormat.twoWeeks: '',
          CalendarFormat.week: ''
        },
        calendarStyle: CalendarStyle(
          markerSize: 10,
          markersMaxCount: 1,
          markerDecoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          outsideTextStyle: TextStyle(color: Colors.black),
        ),
        //daysOfWeekStyle: DaysOfWeekStyle(        weekendStyle: TextStyle().copyWith(color: Colors.blue[600])),

        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        selectedDayPredicate: (DateTime date) {
          return isSameDay(_selectedDay, date);
        },
        //eventLoader: _getEventsfromDay,
        calendarBuilders: CalendarBuilders(
          withinRangeBuilder: (context, day, focusedDay) => Container(
            //margin: const EdgeInsets.all(4.0),
            //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.transparent, //Colors.amber[400],
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${day}',
                style:
                    TextStyle().copyWith(fontSize: 16.0, color: Colors.green),
              ),
            ),
          ),
          selectedBuilder: (context, date, _) {
            return FadeTransition(
              opacity:
                  Tween(begin: 0.0, end: 1.0).animate(_animationController!),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kRipple.withOpacity(0.6),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin: const EdgeInsets.all(8.0),
                //padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                //color: AppColors.kRipple, // Colors.deepOrange[300],
                width: 100,
                height: 100,
                child: GestureDetector(
                  onLongPress: () {
                    taskmodel!.isEdited &
                            taskmodel!.checkHavingEventForGame(date)
                        ? _showDayChoiceDialog(date)
                        : null;
                  },
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(fontSize: 16.0),
                    ),
                  ),
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
                  style:
                      TextStyle().copyWith(fontSize: 16.0, color: Colors.black),
                ),
              ),
            );
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          _onDaySelected(selectedDay, focusedDay);
        },
      );
    }

    Widget _buildTableCalendarWithBuilders2() {
      return TableCalendar(
        firstDay: widget.gameModel!.startTime,
        lastDay: widget.gameModel!.endTime,
        eventLoader: _getEventsfromDay,

        locale: 'tr_TR',
        //calendarController: _calendarController,
        // events: this.taskmodel.dailyEvents, // _events,
        focusedDay: widget.gameModel!.startTime,
        //startDay: DateTime.now(),
        //holidays: _holidays,
        calendarFormat: CalendarFormat.twoWeeks,
        //formatAnimation: FormatAnimation.slide,
        //startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.all,
        availableCalendarFormats: const {
          CalendarFormat.twoWeeks: '',
          CalendarFormat.week: ''
        },
      );
    }

    return ChangeNotifierProvider<DietTaskViewModel>.value(
        // create: (context) => taskmodel!,
        //value: task,
        value: taskmodel!,
        child: Consumer<DietTaskViewModel>(
            builder: (context, model, child) => Scaffold(
                key: scaffoldKey,
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  actions: taskmodel!.dailyEventsModify[DateTime(
                              _selectedDay!.year,
                              _selectedDay!.month,
                              _selectedDay!.day)] ==
                          null
                      ? []
                      : [
                          taskmodel!.isEdited
                              ? IconButton(
                                  icon: Icon(Icons.undo,
                                      color: AppColors.kFont, size: 20),
                                  onPressed: () async {
                                    taskmodel!.isEdited = false;
                                    taskmodel!.isFirstOpen = 2;
                                    taskmodel!.undoMap();
                                    taskmodel!.toogle = false;
                                    taskmodel!.refresh();
                                  })
                              : SizedBox(),
                          taskmodel!.isSaved
                              ? IconButton(
                                  icon: Icon(Icons.edit,
                                      color: AppColors.kFont, size: 20),
                                  onPressed: () {
                                    taskmodel!.isEditControl("", "",
                                        day: _selectedDay!);
                                    taskmodel!.isEdited = true;
                                    taskmodel!.isSaved = false;
                                    taskmodel!.isFirstOpen = 2;
                                    taskmodel!.refresh();
                                  })
                              : IconButton(
                                  icon: Icon(
                                    Icons.save,
                                    color: kIconColor,
                                  ),
                                  onPressed: () {
                                    taskmodel!.copyMap();
                                    if (prepareGamePlan(
                                            widget.gameModel!, taskmodel!) ==
                                        true) {
                                      _showDayErrorDialog();
                                    } else {
                                      taskmodel!.isSaved = true;
                                      taskmodel!.isEdited = false;
                                      taskmodel!.isFirstOpen = 2;
                                      taskmodel!.refresh();
                                    }
                                    widget.gameModel!.savePlan(taskmodel);
                                    //widget.gameModel.saveGame();
                                    //Navigator.pop(context);
                                    //Navigator.pop(context);
                                  },
                                )
                        ],
                  title: Text("Diet Planı",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: AppColors.kRipple,
                          fontSize: 20)),
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
                  iconTheme: IconThemeData(color: Colors.blueGrey),
                  brightness: Brightness.light,
                  backgroundColor: Colors.white,
                ),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTableCalendarWithBuilders(),
                      //ß_buildTableCalendarWithBuilders2(),
                      Divider(height: 2, color: Colors.blueGrey),
                      SizedBox(height: 20),
                      taskmodel!.dailyEventsModify[DateTime(_selectedDay!.year,
                                  _selectedDay!.month, _selectedDay!.day)] ==
                              null
                          ? Container()
                          : Expanded(
                              //color: Colors.blue,
                              child: PlanCard(
                                  taskModel: taskmodel,
                                  gameModel: widget.gameModel,
                                  day: _selectedDay!,
                                  scrollController2: _scrollController),
                            ),
                    ]),
                floatingActionButtonLocation: !taskmodel!.isSaved
                    ? null
                    : FloatingActionButtonLocation.miniCenterFloat,
                floatingActionButton: !taskmodel!.isSaved
                    ? SpeedDial(
                        //Speed dial menu
                        //  marginBottom: 10, //margin bottom
                        icon: Icons.add, //icon on Floating action button
                        activeIcon:
                            Icons.close, //icon when menu is expanded on button
                        backgroundColor:
                            AppColors.kRipple, //background color of button
                        foregroundColor:
                            Colors.white, //font color, icon color in button
                        activeBackgroundColor: AppColors
                            .kRipple, //background color when menu is expanded
                        activeForegroundColor: Colors.white,
                        // buttonSize: 56.0, //button size
                        visible: true,
                        closeManually: false,
                        curve: Curves.bounceIn,
                        overlayColor: Colors.black,
                        overlayOpacity: 0.5,
                        onOpen: () =>
                            print('OPENING DIAL'), // action when menu opens
                        onClose: () =>
                            print('DIAL CLOSED'), //action when menu closes

                        elevation: 8.0, //shadow elevation of button
                        shape: CircleBorder(), //shape of button

                        children: [
                          SpeedDialChild(
                            //speed dial child
                            child: Icon(Icons.list),
                            backgroundColor: AppColors.kRippleLight2,
                            foregroundColor: Colors.white,
                            label: 'Diet Listesi ekle',
                            labelStyle: TextStyle(fontSize: 18.0),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DietsPageSelect(
                                    gameModel: widget.gameModel!,
                                    model: taskmodel,
                                    day: _selectedDay!,
                                  ),
                                )),
                          ),
                          SpeedDialChild(
                            child: Icon(Icons.timelapse),
                            backgroundColor: AppColors.kRippleLight2,
                            foregroundColor: Colors.white,
                            label: 'Öğün ekle',
                            labelStyle: TextStyle(fontSize: 18.0),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddTaskScreenForGame(
                                        todoModel: taskmodel,
                                      ) /*DietsPageSelect(
                                          gameModel: widget.gameModel,
                                          model: taskmodel,
                                          day: this._selectedDay,
                                        ),*/
                                  ),
                            ),
                          ),
                          /*SpeedDialChild(
                        child: Icon(Icons.keyboard_voice),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        label: 'Third Menu Child',
                        labelStyle: TextStyle(fontSize: 18.0),
                        onTap: () => print('THIRD CHILD'),
                        onLongPress: () => print('THIRD CHILD LONG PRESS'),
                      ),*/

                          //add more menu item childs here
                        ],
                      )
                    : FadeTransition(
                        opacity: _hideFabAnimController!,
                        child: ScaleTransition(
                            alignment: Alignment.bottomCenter,
                            scale: _hideFabAnimController!,
                            child: SizedBox(
                              width: 130,
                              child: FloatingActionButton.extended(
                                heroTag: 'fab_new_task',
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            GameSummaryBeforeSending(
                                          gameModel: widget.gameModel!,
                                          taskModel: taskmodel,
                                        ),
                                      ));
                                },
                                tooltip: '',
                                backgroundColor: AppColors.kRipple,
                                foregroundColor: Colors.white,
                                label: Text("Devam"),
                              ),
                            ))

                        /*model.isEdited &&
                          model.selectedDailyPlanTask[
                                  dateFormat.format(_selectedDay!)] !=
                              null
                      ? FadeTransition(
                          opacity: _hideFabAnimController!,
                          child: ScaleTransition(
                              scale: _hideFabAnimController!,
                              child: FloatingActionButton.extended(
                                  heroTag: 'fab_new_task',
                                  onPressed: () {
                                    // widget.model.isSaved = false;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AddTaskScreenForGame(
                                                todoModel: taskmodel,
                                              ) /*DietsPageSelect(
                                          gameModel: widget.gameModel,
                                          model: taskmodel,
                                          day: this._selectedDay,
                                        ),*/
                                          ),
                                    );
                                  },
                                  tooltip: '',
                                  backgroundColor: AppColors.kRipple,
                                  foregroundColor: Colors.white,
                                  label: Text("Öğün ekle"),
                                  icon: Icon(Icons.add))))
                      : FadeTransition(
                          opacity: _hideFabAnimController!,
                          child: ScaleTransition(
                              scale: _hideFabAnimController!,
                              child: SizedBox(
                                width: 130,
                                child: FloatingActionButton.extended(
                                  heroTag: 'fab_new_task',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        !taskmodel.isSaved
                                            ? MaterialPageRoute(
                                                builder: (_) => DietsPageSelect(
                                                  gameModel: widget.gameModel!,
                                                  model: taskmodel,
                                                  day: _selectedDay!,
                                                ),
                                              )
                                            : MaterialPageRoute(
                                                builder: (_) =>
                                                    GameSummaryBeforeSending(
                                                  gameModel: widget.gameModel!,
                                                  taskModel: taskmodel,
                                                ),
                                              ));
                                  },
                                  tooltip: '',
                                  backgroundColor: AppColors.kRipple,
                                  foregroundColor: Colors.white,
                                  label: taskmodel.dailyEvents[DateTime(
                                              _selectedDay!.year,
                                              _selectedDay!.month,
                                              _selectedDay!.day)] ==
                                          null
                                      ? Text("Ekle")
                                      : !taskmodel.isSaved
                                          ? Text("Liste Değiştir")
                                          : Text("Devam"),
                                ),
                              )),
                        ),*/
                        ))));
  }
}

class PlanCard extends StatefulWidget {
  final DietTaskViewModel? taskModel;
  final DietGameViewModel? gameModel;
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
    this.gameModel,
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
      for (var element in widget.taskModel!.items) {
        itemsReordered.add(element.todo);
      }

      /*  widget.taskModel!.savedDailyPlanTodos[
                  dateFormat.format(widget.taskModel!.selectedDay!)] ==
              null
          ? widget.taskModel!.selectedDailyPlanTodosModify[dateFormat
              .format(widget.taskModel!.selectedDay!)] = itemsReordered
          : widget.taskModel!.savedDailyPlanTodosModify[dateFormat
              .format(widget.taskModel!.selectedDay!)] = itemsReordered;*/

      widget.taskModel!.dailyEventsModify[DateTime(
          widget.taskModel!.selectedDay!.year,
          widget.taskModel!.selectedDay!.month,
          widget.taskModel!.selectedDay!.day)] = itemsReordered;
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
    /* titleSelected = widget.taskModel!
                .selectedTaskTitleModify[dateFormat.format(widget.day!)] ==
            null
        ? widget
            .taskModel!.selectedTaskTitleCopy![dateFormat.format(widget.day!)]
        : widget
            .taskModel!.selectedTaskTitleModify[dateFormat.format(widget.day!)];

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
*/
    title = widget.taskModel!.dailyEventsTitleModify[
        DateTime(widget.day!.year, widget.day!.month, widget.day!.day)];

    widget.taskModel!.editedTitle = title;

    !widget.taskModel!.toogle
        ? widget.taskModel!.setToDoKeys(widget.taskModel!.dailyEventsModify[
            DateTime(widget.day!.year, widget.day!.month, widget.day!.day)]!)
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
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return ShowTitleDialog(
                                    model: widget.taskModel!);
                              });
                        },
                        child: Container(
                          // height: 10,
                          //width: 10,
                          // color: Colors.green,
                          child: Row(
                            //mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title ?? "",
                                softWrap: true,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins"),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.edit,
                                  size: 16, color: AppColors.kFont),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Text(
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
            ]),
        SizedBox(height: 15),
        Expanded(
            child: (widget.taskModel!.isEdited ||
                    widget.taskModel!.isFirstOpen == 1)
                ? reorder.ReorderableList(
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
                                  return ItemForGame(
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
                : CustomScrollView(
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
                  ))
      ]),
    );
  }
}

class ShowTitleDialog extends StatefulWidget {
  final DietTaskViewModel? model;
  ShowTitleDialog({this.model});

  @override
  _ShowTitleDialogState createState() => _ShowTitleDialogState();
}

class _ShowTitleDialogState extends State<ShowTitleDialog> {
  TextEditingController? editingController;

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    editingController =
        new TextEditingController(text: widget.model!.editedTitle);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    editingController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Başlık Giriniz",
          style: TextStyle(fontFamily: "Poppins", fontSize: 16)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
              color: AppColors.kRipple.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            child: TextField(
              controller: editingController,
              onChanged: (text) {
                setState(() {
                  widget.model!.titleModified = text;
                  widget.model!.titleModified!.isNotEmpty
                      ? widget.model!.showAlert = false
                      : widget.model!.showAlert = true;
                });
              },
              minLines: 2,
              //maxLength: 50,
              maxLines: 4,
              //cursorColor: taskColor,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                /* hintText: 'Öğün içeriğini giriniz...',
                              hintStyle: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: "Poppins",
                                  fontSize: 18)*/
              ),
              style: TextStyle(
                  color: AppColors.kFont.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
          ),
        ),
        widget.model!.showAlert
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text("(!) Lüften giriş yapınız.",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.red)))
            : Container(),
      ]),
      actions: <Widget>[
        FlatButton(
          child: Text("Tamam",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: AppColors.kRipple)),
          onPressed: () {
            if (editingController!.text.isEmpty) {
              setState(() {
                widget.model!.showAlert = true;
              });

              /*  final snackBar = SnackBar(
                          content: Text(
                              'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                          backgroundColor: Colors.blueGrey, duration: Duration(seconds: 3)
                        );
                         Scaffold.of(context2).showSnackBar(snackBar,);
                        //key.currentState.showSnackBar(snackBar);
                        */
            } else {
              setState(() {
                widget.model!.showAlert = false;
                widget.model!.selectedTaskTitleModify[
                        dateFormat.format(widget.model!.selectedDay!)] =
                    widget.model!.titleModified!;
                widget.model!.savedTaskTitleModify![
                        dateFormat.format(widget.model!.selectedDay!)] =
                    widget.model!.titleModified!;
              });

              editingController!.clear();
              widget.model!.refresh();
              Navigator.of(context).pop();
            }
          },
        ),
        FlatButton(
          child: Text("Vazgeç",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Colors.blue,
              )),
          onPressed: () {
            editingController!.clear();
            Navigator.of(context).pop();
            setState(() {
              widget.model!.selectedTaskTitleCopy[
                      dateFormat.format(widget.model!.selectedDay!)] =
                  widget.model!.titleCopy!;
              widget.model!.titleModified = "";
              widget.model!.showAlert = false;
            });

            // Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

typedef void Callback();

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
  final DateFormat dateFormat = DateFormat('HH:mm');
  Widget build(BuildContext context) {
    BoxDecoration? decoration;

    return Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
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
                                      Icon(Icons.timelapse,
                                          color: AppColors.kFont, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                          dateFormat.format(
                                              data!.todo.startDate?.toDate() ??
                                                  DateTime.now()),
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              color: AppColors.kFont)),
                                      Text(" - "),

                                      // Icon(Icons.flag,color: Colors.red,),
                                      Text(
                                          data!.todo.endDate == null
                                              ? ""
                                              : dateFormat.format(
                                                  data!.todo.endDate!.toDate()),
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              color: AppColors.kFont)),
                                    ])),
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
                                        return Container(
                                          padding: EdgeInsets.only(
                                              left: 22.0, right: 22.0),
                                          child: ListTile(
                                              /*onTap: () => model.updateTodo(todo.copy(
                                      isCompleted: todo.isCompleted == 1 ? 0 : 1)),*/
                                              contentPadding: EdgeInsets.zero,
                                              leading: Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  unselectedWidgetColor:
                                                      AppColors.kFont,
                                                ),
                                                child: Transform.scale(
                                                  scale: 0.8,
                                                  child: Checkbox(
                                                      activeColor: Colors.blue,
                                                      onChanged: (value) {},
                                                      /* onChanged: (value) => model.updateTodo(
                                            todo.copy(isCompleted: value ? 1 : 0)),*/
                                                      value:
                                                          false //todo.isCompleted == 1 ? true : false
                                                      ),
                                                ),
                                              ),
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
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              )),
                                        );
                                      },
                                      itemCount: data!.todo.phrases!.length + 1,
                                    ),
                                  )),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemForGame extends StatelessWidget {
  ItemForGame({
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
                                        Icon(Icons.timelapse,
                                            color: AppColors.kFont, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                            dateFormat.format(data!
                                                    .todo.startDate
                                                    ?.toDate() ??
                                                DateTime.now()),
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                color: AppColors.kFont)),
                                        Text(" - "),

                                        // Icon(Icons.flag,color: Colors.red,),
                                        Text(
                                            dateFormat.format(
                                                data!.todo.endDate?.toDate() ??
                                                    DateTime.now()),
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
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
                                                            value:
                                                                false //todo.isCompleted == 1 ? true : false
                                                            ),
                                                      )),
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
                                        },
                                        itemCount:
                                            data!.todo.phrases!.length + 1,
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
                            builder: (context) => AddTaskScreenForGame(
                              todom: data!.todo,
                              todoModel: model,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          color: Colors.transparent,
                          child: Icon(Icons.edit,
                              size: 18, color: AppColors.kFont)))
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

class okan {
  Function? onTap;
}
