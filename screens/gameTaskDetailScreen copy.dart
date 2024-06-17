/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_v2/business_logic/models/DietGameViewModel.dart';
import 'package:friendfit_v2/business_logic/models/DietTaskViewModel.dart';
import 'package:friendfit_v2/component/iconpicker/icon_picker_builder.dart';
import 'package:friendfit_v2/constants.dart';
import 'package:friendfit_v2/data/choice_card.dart';
import 'package:friendfit_v2/data/image_card.dart';
import 'package:friendfit_v2/data/hero_id_model.dart';
import 'package:friendfit_v2/models/dietTask.dart';
import 'package:friendfit_v2/pages/detail_screen.dart';
import 'package:friendfit_v2/models/dietTodos.dart';
import 'package:friendfit_v2/pages/diets_page_selection.dart';
import 'package:friendfit_v2/pages/home.dart';
import 'package:friendfit_v2/services/service_locator.dart';
import 'package:friendfit_v2/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:friendfit_v2/pages/addTaskScreen.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:friendfit_v2/widgets/circular_clipper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:io';
import 'dart:async';
import 'package:friendfit_v2/utils/uuid.dart';

class GameTaskDetailScreenCopy extends StatefulWidget {
  final DietGameViewModel gameModel;
  final DietTaskViewModel model;
  final String taskId;
  final HeroId heroIds;
  final DietTask task;
  final DietToDos todo;
  GameTaskDetailScreenCopy(
      {this.taskId,
      this.heroIds,
      this.task,
      this.todo,
      this.gameModel,
      this.model});
  @override
  State<StatefulWidget> createState() {
    return _GameTaskDetailScreenCopyState();
  }
}

class _GameTaskDetailScreenCopyState extends State<GameTaskDetailScreenCopy>
    with TickerProviderStateMixin {
  final DietTaskViewModel taskmodel = serviceLocator<DietTaskViewModel>();
  CalendarController _calendarController = new CalendarController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  Map<DateTime, List> _events;
  DateTime _selectedDay;
  List _selectedEvents;
  AnimationController _animationController;
  AnimationController _controller;
  Animation<Offset> _animation;
  Color taskColor;
  IconData taskIcon;
  String newTask;
  String title;
  List<Choice> iconsList;
  List selectedTasks;
  XFile file;
  bool isUploading = false;
  String postId = Uuid().generateV4();
  ChoiceImage selectedIconData = ChoiceImage(id: '1', image: null);
  final ImagePicker _picker = ImagePicker();
  int indexCount;
  //DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  TextEditingController _editingController;
  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;
  bool _enabled = true;
  AnimationController _hideFabAnimController;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map dailyPlanTask = {};
  Map dailyPlanTodos = {};
  @override
  void initState() {
    _selectedDay = DateTime.now();
    //selectedTasks = [];
    indexCount = 0;
    // newTask = '';
    title = ""; //widget.task.title??"";
    taskColor = Colors.grey; // ColorUtils.defaultColors[1];
    taskIcon = Icons.add;
    iconsList = [];
    _editingController = TextEditingController(text: title);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0.0, 0.0))
        .animate(_controller);
    handleScroll();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );

    //_events = {}; //widget.gameModel.gameEvents;
    print(widget.task);

    //////
    ///
    /*_events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): [
        'Event A4',
        'Event B4',
        'Event C4'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };*/

    //_selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _controller.dispose();
    _hideFabAnimController.dispose();
    _editingController.dispose();
    _animationController.dispose();
    _calendarController.dispose();

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
        _hideFabAnimController.reverse();
        //hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _hideFabAnimController.forward();
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
                      child: Image(image: iconData.image, fit: BoxFit.cover)),
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
    XFile file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
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

    void _onDaySelected(DateTime day, List events, List holidays) {
      print('CALLBACK: _onDaySelected');
      _selectedDay = day;
      setState(() {
        _selectedEvents = events;
        this.taskmodel.isEdited = false;
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
          color: _calendarController.isSelected(date)
              ? Colors.green[300]
              : _calendarController.isToday(date)
                  ? Colors.green[300]
                  : Colors.green[400],
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

    Widget _buildTableCalendarWithBuilders() {
      return TableCalendar(
        locale: 'tr_TR',
        calendarController: _calendarController,
        events: this.taskmodel.dailyEvents, // _events,
        initialSelectedDay: DateTime.now(),
        startDay: DateTime.now(),
        //holidays: _holidays,
        initialCalendarFormat: CalendarFormat.twoWeeks,
        formatAnimation: FormatAnimation.slide,
        //startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.all,
        availableCalendarFormats: const {
          CalendarFormat.twoWeeks: '',
          CalendarFormat.week: ''
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendStyle: TextStyle().copyWith(color: Colors.black),
          // holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
        ),
        //daysOfWeekStyle: DaysOfWeekStyle(        weekendStyle: TextStyle().copyWith(color: Colors.blue[600])),

        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonVisible: false,
        ),
        builders: CalendarBuilders(
          selectedDayBuilder: (context, date, _) {
            return FadeTransition(
              opacity:
                  Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                color: AppColors.kRipple, // Colors.deepOrange[300],
                width: 100,
                height: 100,
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(fontSize: 16.0),
                ),
              ),
            );
          },
          todayDayBuilder: (context, date, _) {
            return Container(
              //margin: const EdgeInsets.all(4.0),
              //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.transparent, //Colors.amber[400],
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
          markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];

            if (events.isNotEmpty) {
              children.add(
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: _buildEventsMarker(date, events),
                ),
              );
            }

            return children;
          },
        ),
        onDaySelected: (date, events, holidays) {
          _onDaySelected(date, events, holidays);
          _animationController.forward(from: 0.0);
        },
        onVisibleDaysChanged: _onVisibleDaysChanged,
        onCalendarCreated: _onCalendarCreated,
      );
    }

    return ChangeNotifierProvider<DietTaskViewModel>(
        create: (context) => this.taskmodel,
        //value: task,
        child: Consumer<DietTaskViewModel>(
            builder: (context, model, child) => Scaffold(
                  key: _scaffoldKey,
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text("Diet Planı",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: AppColors.kFont,
                            fontSize: 20)),
                    leading: IconButton(
                      icon: Icon(
                        FontAwesome5.arrow_alt_circle_left,
                        color: kIconColor,
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
                  body: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        //color: Colors.blue,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          _buildTableCalendarWithBuilders(),
                          Divider(height: 2, color: Colors.grey),
                          SizedBox(height: 20),
                          this.taskmodel.selectedDailyPlanTask[
                                      this.dateFormat.format(_selectedDay)] ==
                                  null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: PlanCard(
                                      taskModel: this.taskmodel,
                                      day: this._selectedDay),
                                ),
                          /*Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      this.taskmodel.selectedTask == null
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () async {
                                                await taskmodel.isEditControl(
                                                    "", "");
                                              },
                                              child: Text("Düzenle",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14.0)),
                                            ),

                                      //Spacer(),
                                      !this.taskmodel.isEdited
                                          ? Text(
                                              this.taskmodel.selectedTask ==
                                                      null
                                                  ? ""
                                                  : this
                                                      .taskmodel
                                                      .selectedTask
                                                      .title,
                                              style: TextStyle(
                                                  color: AppColors.kFont,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 24.0))
                                          : Container(
                                              //color:Colors.green,
                                              width: 150,
                                              child: TextField(
                                                controller: _editingController,
                                                textAlign: TextAlign.center,
                                                onSubmitted: (text) {
                                                  setState(() {
                                                    newTask = text;
                                                    title = text;
                                                  });
                                                },
                                                cursorColor:
                                                    Colors.black, //taskColor,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  //labelText: title,
                                                  //hintText: title,
                                                  /*hintStyle: TextStyle(
                                                    color: Colors.black26,
                                                  )*/
                                                ),
                                                style: TextStyle(
                                                    color: AppColors.kFont,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 30.0),
                                              ),
                                            ),
                                      this.taskmodel.selectedTask == null
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                selectedTasks.add(this
                                                    .taskmodel
                                                    .selectedTask
                                                    .id);
                                                _events[_selectedDay] =
                                                    selectedTasks;
                                                dailyPlanTask[_selectedDay.day] =
                                                   newTask;// this.taskmodel.selectedTask;
                                                 dailyPlanTodos[_selectedDay.day] =
                                                    this.taskmodel.selectedTodos;
                                                
                                                this.taskmodel.modifyTask(
                                                    newTask.length == 0
                                                        ? this
                                                            .taskmodel
                                                            .selectedTask
                                                            .title
                                                        : newTask,
                                                    currentUser.id,
                                                    this.taskmodel.selectedTask, 
                                              },
                                              child: Text("Günü kaydet",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14.0)),
                                            ),

                                      /*     GestureDetector(
                                              onTap: () => this
                                                  .taskmodel
                                                  .isEditControl("", ""),
                                              child: this.taskmodel.isEdited ?Icon(Icons.edit,
                                                  size: 18,
                                                  color: Colors.black38):Container())
                                        ,
                                      Spacer(),
                                      Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                this.taskmodel.isEdited
                                                    ? Icon(Icons.save_rounded)
                                                    : Container()
                                              ]
                                              
                                              
                                              ))*/
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                _todos==null?Container():
                                Container(
                                  //color: Colors.yellow,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    //controller: _scrollController,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == _todos.length) {
                                        return SizedBox(
                                          height: 10, // size of FAB
                                        );
                                      }
                                      //var todom =  this.taskmodel.selectedTodos == null? _todos[index]: this.taskmodel.selectedTodos[index] ;
var todom = _todos[index];
                                      return Container(
                                        padding: EdgeInsets.only(
                                            left: 22.0, right: 22.0),
                                        child: _buildTimelineTile(
                                          context: context,
                                          model: this.taskmodel, // model,
                                          todom: todom,
                                          name: todom.title ?? "",
                                          phrase: todom.phrase,
                                          hour: formatDate(
                                              todom.startDateTodo.toDate(), [
                                            HH,
                                            ':',
                                            nn
                                          ]), //dateFormat.format(todom.startDateTodo.toDate()),
                                          indicator: _IconIndicator(
                                            color: !model.isEdited
                                                ? AppColors.kRipple
                                                    .withOpacity(0.5)
                                                : AppColors.kRipple,
                                            //iconData: Icons.work,
                                            size: 20,
                                          ),
                                          isFirst: index == 0 ? true : false,
                                          isLast: index == _todos.length - 1
                                              ? true
                                              : false,
                                          todo: todom,
                                        ),
                                      );
                                    },
                                    itemCount: _todos.length + 1,
                                  ),
                                )*/
                        ])),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterFloat,
                  floatingActionButton: model.isEdited &&
                          model.selectedDailyPlanTask[
                                  this.dateFormat.format(_selectedDay)] !=
                              null
                      ? FadeTransition(
                          opacity: _hideFabAnimController,
                          child: ScaleTransition(
                              scale: _hideFabAnimController,
                              child: FloatingActionButton.extended(
                                  heroTag: 'fab_new_task',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DietsPageSelect(
                                          gameModel: widget.gameModel,
                                          model: taskmodel,
                                          day: this._selectedDay,
                                        ),
                                      ),
                                    );
                                  },
                                  tooltip: '',
                                  backgroundColor: AppColors.kRipple,
                                  foregroundColor: Colors.white,
                                  label: Text("Öğün ekle"),
                                  icon: Icon(Icons.add))))
                      : FadeTransition(
                          opacity: _hideFabAnimController,
                          child: ScaleTransition(
                              scale: _hideFabAnimController,
                              child: FloatingActionButton.extended(
                                heroTag: 'fab_new_task',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DietsPageSelect(
                                        gameModel: widget.gameModel,
                                        model: taskmodel,
                                        day: this._selectedDay,
                                      ),
                                    ),
                                  );
                                },
                                tooltip: '',
                                backgroundColor: AppColors.kRipple,
                                foregroundColor: Colors.white,
                                label: this.taskmodel.selectedDailyPlanTask[this
                                            .dateFormat
                                            .format(_selectedDay)] ==
                                        null
                                    ? Text("Liste ekle")
                                    : Text("Liste değiştir"),
                                icon: Icon(Icons.add),
                              )

                              /*FloatingActionButton.extended(
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
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                }
                              },
                              tooltip: '',
                              backgroundColor:  AppColors.kRipple,
                                  
                              foregroundColor: Colors.white,
                              label: Text("Liste Değiştir"),
                              icon: Icon(Icons.add),
                            ),*/
                              /* : FloatingActionButton.extended(
                              heroTag: 'fab_new_task',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DietsPageSelect(
                                      gameModel: widget.gameModel,
                                      model: taskmodel,
                                      day: this._selectedDay,
                                    ),
                                  ),
                                );
                                /*if (model.isEdited) {
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
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          }*/
                              },
                              tooltip: 'Öğün ekle',
                              backgroundColor: AppColors.kRipple,
                              foregroundColor: Colors.white,
                              label: this.taskmodel.selectedDailyPlanTask[this
                                          .dateFormat
                                          .format(_selectedDay)] ==
                                      null
                                  ? Text("Liste ekle")
                                  : Text("Liste değiştir"),
                              icon: Icon(Icons.add),
                            ),*/
                              ),
                        ),
                )));
  }
}

TimelineTile _buildTimelineTile(
    {_IconIndicator indicator,
    BuildContext context,
    DietTaskViewModel model,
    DateTime day,
    DietToDos todom,
    String hour,
    String name,
    String phrase,
    DietToDos todo,
    bool isLast = false,
    bool isFirst = false}) {
  return TimelineTile(
    alignment: TimelineAlign.manual,
    lineXY: 0.3,
    beforeLineStyle: LineStyle(
        color: model.isEdited
            ? AppColors.kRipple
            : AppColors.kRipple.withOpacity(0.50)),
    indicatorStyle: IndicatorStyle(
      color: model.isEdited
          ? AppColors.kRipple
          : AppColors.kRipple.withOpacity(0.50),
      indicatorXY: 0.3,
      drawGap: true,
      width: 15,
      height: 15,
      indicator: indicator,
    ),
    isLast: isLast,
    isFirst: isFirst,
    startChild: Center(
      child: Container(
        alignment: const Alignment(0.0, -0.50),
        child: Text(
          hour,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
    endChild: GestureDetector(
      onTap: !model.isEdited
          ? null
          : () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddTaskScreen(todom: todom, todoModel: model),
                ),
              );
              //model.getTaskTodos(currentUser.id, todom.parentId);
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
                      name,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    !model.isEdited
                        ? Container()
                        : Icon(Icons.edit, size: 14, color: AppColors.kFont),
                    /* Checkbox(
                          value: todo?.isCompleted == 1 ? true : false,
                          onChanged: null)*/
                  ]),
              const SizedBox(height: 8),
              Text(
                phrase,
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

class PlanCard extends StatefulWidget {
  final DietTaskViewModel taskModel;
  //final DietTask selectedTask;
  //final List<DietToDos> selectedTodos;
  final DateTime day;
  Map events;

  PlanCard(
      {
      //this.selectedTask,
      //this.selectedTodos,
      this.taskModel,
      this.day,
      this.events});

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  TextEditingController _editingController;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String title;
  String newTitle;

  @override
  void initState() {
    // TODO: implement initState
    title = "";
    newTitle = "";
    _editingController = new TextEditingController(text: title);
    super.initState();
  }

  void showTitleDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Başlık Giriniz"),
            content: Container(
              height: 80,
              decoration: BoxDecoration(
                  color: AppColors.kRipple.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                child: TextField(
                  controller: _editingController,
                  onChanged: (text) {
                    setState(() {
                      widget.taskModel.selectedTaskPlan.title = text;
                    });
                  },
                  minLines: 2,
                  //maxLength: 50,
                  maxLines: 4,
                  //cursorColor: taskColor,
                  autofocus: false, //true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    /* hintText: 'Öğün içeriğini giriniz...',
                            hintStyle: TextStyle(
                                color: Colors.black26,
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
            actions: <Widget>[
              FlatButton(
                child: Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Vazgeç"),
                onPressed: () {
                  _editingController.clear();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    title = widget.taskModel
                .savedDailyPlanTask[this.dateFormat.format(widget.day)] ==
            null
        ? widget.taskModel
            .selectedDailyPlanTask[this.dateFormat.format(widget.day)].title
        : widget.taskModel
            .savedDailyPlanTask[this.dateFormat.format(widget.day)].title;

    /* if((widget.taskModel.editDay[widget.day.day] ==false||widget.taskModel.editDay[widget.day.day]==null) && (widget.taskModel.modifyDay[widget.day.day]  !=true))
      {  title =widget.taskModel.savedDailyPlanTask[
                        this.dateFormat.format(widget.day)] ==
                    null
                ? widget
                    .taskModel
                    .selectedDailyPlanTask[this.dateFormat.format(widget.day)]
                    .title
                : widget
                    .taskModel
                    .savedDailyPlanTask[this.dateFormat.format(widget.day)]
                    .title;                    
                    }
 else if((widget.taskModel.editDay[widget.day.day] ==false) && (widget.taskModel.modifyDay[widget.day.day]  =true))
      {  title =widget.taskModel.editedTitle; /*taskModel.savedDailyPlanTask[
                        this.dateFormat.format(widget.day)] ==
                    null
                ? widget
                    .taskModel
                    .selectedDailyPlanTask[this.dateFormat.format(widget.day)]
                    .title
                : widget
                    .taskModel
                    .savedDailyPlanTask[this.dateFormat.format(widget.day)]
                    .title;*/                    
                    }




                    else if ((widget.taskModel.editDay[widget.day.day] ==true) &&widget.taskModel.modifyDay[widget.day.day] ==false)   {
                      
                      title=newTitle;
                    
                    
                    }*/

// edit false ismodified false  düzenleye tıklanammış kaydedilmemeiş

// edit true ismodified false  düzenleye tıklanmış kaydedilmemiş

// edit false ismodified true  düzenleye tıklanmış kaydedilmiş

// edi true modified true  düzenlye tıklanmış kaydedilmiş olamaz!!

    //widget.taskModel.editedTitle ==""
    /* widget.taskModel.isEdited ? widget.taskModel.editedTitle
     
     :(widget.taskModel.savedDailyPlanTask[
                        this.dateFormat.format(widget.day)] ==
                    null
                ? widget
                    .taskModel
                    .selectedDailyPlanTask[this.dateFormat.format(widget.day)]
                    .title
                : widget
                    .taskModel
                    .savedDailyPlanTask[this.dateFormat.format(widget.day)]
                    .title);*/

    print(widget.taskModel
        .selectedDailyPlanTask[this.dateFormat.format(widget.day)].title);
    return Column(children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.taskModel.isEdited
                ? InkWell(
                    onTap: () {
                      widget.taskModel.isEdited = false;
                      widget.taskModel.refresh();
                    },
                    child: Text("Vazgeç",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0)),
                  )
                : InkWell(
                    onTap: () async {
                      await widget.taskModel
                          .isEditControl("", "", day: widget.day);
                    },
                    child: Text("Düzenle",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0)),
                  ),
            widget.taskModel.isEdited
                ? GestureDetector(
                    onTap: () {
                      this.showTitleDialog();
                    },
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins"),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.edit_rounded,
                            size: 14, color: AppColors.kFont),
                      ],
                    ),
                  )
                : Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins"),
                  ),
            /*  SizedBox(width:10),
                                      InkWell(
                                     onTap: ()  {
                                       widget.taskModel.editDay[widget.day.day]=false;
                                        widget.taskModel.isEdited=false;
                                        widget.taskModel.refresh();
                                     },
                                     child: Text("Vazgeç",
                                         style: TextStyle(
                                             color: Colors.blue,
                                             fontWeight: FontWeight.normal,
                                             fontSize: 14.0)),
                                   ),*/

            //Spacer(),
            /* widget.taskModel.editDay[widget.day.day] ==null||widget.taskModel.editDay[widget.day.day] ==false?
                                    (/*widget.taskModel.savedDailyPlanTask[
                                               this.dateFormat.format(widget.day)] ==
                                           null
                                       ? Text(widget
                                           .taskModel
                                           .selectedDailyPlanTask[this.dateFormat.format(widget.day)]
                                           .title)
                                       : Text(widget
                                           .taskModel
                                           .savedDailyPlanTask[this.dateFormat.format(widget.day)]
                                           .title)*/
                                           Text(title)
                                           
                                           ):
                     Container(
                                                                     //color:Colors.green,
                                                                     width: 150,
                                                                     child: TextField(
                                                                       controller: _editingController,
                                                                       textAlign: TextAlign.center,
                                                                       onSubmitted: (text) {
                                                                        newTitle=text;
                                                                           title = text;
                                                                        
                                                                       },
                                                                       cursorColor:
                                                                           Colors.black, //taskColor,
                                                                       //autofocus: true,
                                                                       decoration: InputDecoration(
                                                                         border: InputBorder.none,
                                                                         //labelText: title,
                                                                        // hintText: title,
                                                                         /*hintStyle: TextStyle(
                                                                           color: Colors.black26,
                                                                         )*/
                                                                       ),
                                                                       style: TextStyle(
                                                                           color: AppColors.kFont,
                                                                           fontWeight: FontWeight.w500,
                                                                           fontSize: 30.0),
                                                                     ),
                                                                   ),
                     
                                   /*Container(
                                                                     //color:Colors.green,
                                                                     width: 150,
                                                                     child: TextField(
                                                                       controller: editingController,
                                                                       textAlign: TextAlign.center,
                                                                       onSubmitted: (text) {
                                                                         setState(() {
                                                                           /*newTask = text;
                                                                           title = text;*/
                                                                         });
                                                                       },
                                                                       cursorColor:
                                                                           Colors.black, //taskColor,
                                                                       //autofocus: true,
                                                                       decoration: InputDecoration(
                                                                         border: InputBorder.none,
                                                                         //labelText: title,
                                                                         //hintText: title,
                                                                         /*hintStyle: TextStyle(
                                                                           color: Colors.black26,
                                                                         )*/
                                                                       ),
                                                                       style: TextStyle(
                                                                           color: AppColors.kFont,
                                                                           fontWeight: FontWeight.w500,
                                                                           fontSize: 30.0),
                                                                     ),
                                                                   ),*/
                                                                   */
            /* GestureDetector(
                                     onTap: () async { widget.taskModel.modifyTask(
                                       title.length == 0  ? (widget.taskModel.savedDailyPlanTask[
                                               this.dateFormat.format(widget.day)] ==
                                           null
                                       ? Text(widget
                                           .taskModel
                                           .selectedDailyPlanTask[this.dateFormat.format(widget.day)]
                                           .title)
                                       : Text(widget
                                           .taskModel
                                           .savedDailyPlanTask[this.dateFormat.format(widget.day)]
                                           .title)):this.title, 
                                       currentUser.id, 
                                      (widget.taskModel.savedDailyPlanTask[
                                               this.dateFormat.format(widget.day)] ==
                                           null
                                       ? widget
                                           .taskModel
                                           .selectedDailyPlanTask[this.dateFormat.format(widget.day)]
                                           
                                       : widget
                                           .taskModel
                                           .savedDailyPlanTask[this.dateFormat.format(widget.day)]
                                           ),
                                      (widget.taskModel.savedDailyPlanTask[
                                               this.dateFormat.format(widget.day)] ==
                                           null
                                       ? widget
                                           .taskModel
                                           .selectedDailyPlanTask[this.dateFormat.format(widget.day)]
                                           .backgroundId
                                       : widget
                                           .taskModel
                                           .savedDailyPlanTask[this.dateFormat.format(widget.day)]
                                           .backgroundId),
                                           day: widget.day
                                       );
                                       
                                     },
                                     child: Text("Listeyi Kaydet",
                                         style: TextStyle(
                                             color: Colors.blue,
                                             fontWeight: FontWeight.normal,
                                             fontSize: 14.0)),
                                   ),
                                   
                                   SizedBox(width:10),
                                   */
            GestureDetector(
              onTap: () {
                widget.taskModel.savedDailyPlanTask[
                    this
                        .dateFormat
                        .format(widget.day)] = widget.taskModel
                    .selectedDailyPlanTask[this.dateFormat.format(widget.day)];
                widget.taskModel.savedDailyPlanTodos[
                    this
                        .dateFormat
                        .format(widget.day)] = widget.taskModel
                    .selectedDailyPlanTodos[this.dateFormat.format(widget.day)];
                widget.taskModel.selectedEvents.add(widget.taskModel
                    .selectedDailyPlanTask[this.dateFormat.format(widget.day)]);
                widget.taskModel.dailyEvents[widget.day] =
                    widget.taskModel.selectedEvents;

                widget.taskModel.refresh();
              },
              child: Text("Kaydet",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0)),
            ),
          ]),
      SizedBox(height: 15),
      Container(
        //color: Colors.yellow,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          //controller: _scrollController,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index ==
                (widget.taskModel.savedDailyPlanTodos[
                            this.dateFormat.format(widget.day)] ==
                        null
                    ? widget
                        .taskModel
                        .selectedDailyPlanTodos[
                            this.dateFormat.format(widget.day)]
                        .length
                    : widget
                        .taskModel
                        .savedDailyPlanTodos[this.dateFormat.format(widget.day)]
                        .length)) {
              return SizedBox(
                height: 10, // size of FAB
              );
            }
            //var todom =  this.taskmodel.selectedTodos == null? _todos[index]: this.taskmodel.selectedTodos[index] ;
            var todom = widget.taskModel.savedDailyPlanTodos[
                        this.dateFormat.format(widget.day)] ==
                    null
                ? widget.taskModel.selectedDailyPlanTodos[
                    this.dateFormat.format(widget.day)][index]
                : widget.taskModel
                        .savedDailyPlanTodos[this.dateFormat.format(widget.day)]
                    [index];
            return Container(
              padding: EdgeInsets.only(left: 22.0, right: 22.0),
              child: _buildTimelineTile(
                day: widget.day,
                context: context,
                model: widget.taskModel, // model,
                todom: todom,
                name: todom.title ?? "",
                phrase: todom.phrase,
                hour: formatDate(todom.startDate.toDate(), [
                  HH,
                  ':',
                  nn
                ]), //dateFormat.format(todom.startDateTodo.toDate()),
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
              ),
            );
          },
          itemCount: widget.taskModel.savedDailyPlanTodos[
                      this.dateFormat.format(widget.day)] ==
                  null
              ? widget
                      .taskModel
                      .selectedDailyPlanTodos[
                          this.dateFormat.format(widget.day)]
                      .length +
                  1
              : widget
                      .taskModel
                      .savedDailyPlanTodos[this.dateFormat.format(widget.day)]
                      .length +
                  1,
        ),
      )
    ]);
  }
}

class DetailScreen {}

typedef void Callback();

class SimpleAlertDialog extends StatelessWidget {
  final Color color;
  final Callback onActionPressed;

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

                    onActionPressed();
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

class _IconIndicator extends StatelessWidget {
  _IconIndicator({Key key, this.iconData, this.size, this.color})
      : super(key: key);

  final IconData iconData;
  final double size;
  final Color color;
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
*/