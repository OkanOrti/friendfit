// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
import 'package:lottie/lottie.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:friendfit_ready/screens/addTaskScreen.dart';
import 'package:friendfit_ready/screens/addTaskScreenForGame.dart';
import 'package:flutter/rendering.dart';
import 'package:friendfit_ready/screens/custom_expansion_tile.dart' as custom;
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:friendfit_ready/screens/custom_expansion_tile.dart' as custom;
import 'package:friendfit_ready/screens/detail_screen.dart' as detail;
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:friendfit_ready/ViewModels/NotificationViewModel.dart';
import 'package:friendfit_ready/models/todoNotify.dart';
import 'package:friendfit_ready/task_progress_indicator.dart';

class DietPlanReview extends StatefulWidget {
  final DietGame? game;
  final String? dietPlanId;
  bool? enabled;
  //final DietGameViewModel gameModel;
  //final DietTaskViewModel model;
  final String? taskId;
  final HeroId? heroIds;
  final DietTask? task;
  final DietToDos? todo;
  DietPlanReview(
      {this.taskId,
      this.heroIds,
      this.task,
      this.todo,
      this.game,
      this.enabled,
      this.dietPlanId
      //  this.gameModel,
      //this.model
      });
  @override
  State<StatefulWidget> createState() {
    return _DietPlanReviewState();
  }
}

class _DietPlanReviewState extends State<DietPlanReview>
    with TickerProviderStateMixin {
  final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
  //CalendarController _calendarController =  CalendarController();
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
  bool? enabled;

  File? file;
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
  AnimationController? lottieController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Map dailyPlanTask = {};
  Map dailyPlanTodos = {};
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //   gameModel.getGameTodos(widget.game!.gameOwnerId, widget.game!.id);
    gameModel.getDietPlanTodos(widget.game!.gameOwnerId, widget.game!,
        planId: widget.dietPlanId);

    // gameModel.checkPhrases(widget.game.gameOwnerId, widget.game.id);
    _selectedDay = widget.game!.startDate!.toDate(); //DateTime.now();
    //this.taskmodel.selectedDay = DateTime.now();
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
//    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController!.forward();

    lottieController = AnimationController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _controller!.dispose();
    _hideFabAnimController!.dispose();
    _editingController!.dispose();
    _animationController!.dispose();
    lottieController!.dispose();
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

  @override
  Widget build(BuildContext context) {
    enabled = gameModel.isCheckable(widget.game!, _selectedDay!);
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

    void _onDaySelected(DateTime day, DateTime focusedDay) {
      print('CALLBACK: _onDaySelected');
      _selectedDay = day;
      //this.taskmodel.selectedDay = day;
      setState(() {
        //  _selectedEvents = events;
        // this.taskmodel.isEdited = false;
        //this.taskmodel.toogle = false;
        //this.taskmodel.selectedDailyPlanTodos[this.dateFormat.format(day)]=  this.taskmodel.copy(taskmodel.todosFirst);
        /*this
            .taskmodel
            .selectedDailyPlanTodosModify[this.dateFormat.format(day)] = null;
        this.taskmodel.savedDailyPlanTodosModify[this.dateFormat.format(day)] =
            null;
*/
        _hideFabAnimController!.forward();
        //showFloationButton();

        //this._show=true;
        //this.taskmodel.selectedTask = dailyPlanTask[_selectedDay.day];
        //this.taskmodel.selectedTodos = dailyPlanTodos[_selectedDay.day];

        //taskmodel.todos2 =[];
      });
      //   this.gameModel.refresh();
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
          color: Colors.green[400],
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
        firstDay: widget.game!.startDate!.toDate(),
        lastDay: widget.game!.endDate!.toDate(),
        locale: 'tr_TR',
        //calendarController: _calendarController,
        //events: this.taskmodel.dailyEvents, // _events,
        focusedDay: widget.game!.startDate!.toDate(),
        //startDay: DateTime.now(),
        //holidays: _holidays,
        calendarFormat: CalendarFormat.twoWeeks,
        //formatAnimation: FormatAnimation.slide,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableGestures: AvailableGestures.all,
        availableCalendarFormats: const {
          CalendarFormat.twoWeeks: '',
          CalendarFormat.week: ''
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          //  weekendStyle: TextStyle().copyWith(color: Colors.green),
          //weekdayTextStyle: TextStyle().copyWith(color: Colors.black),
          outsideTextStyle: TextStyle().copyWith(color: Colors.red),
          todayTextStyle: TextStyle().copyWith(color: Colors.green),
          holidayTextStyle: TextStyle().copyWith(color: Colors.red),
          // holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
        ),
        // daysOfWeekStyle: DaysOfWeekStyle(        weekendStyle: TextStyle().copyWith(color: Colors.blue[600])),

        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        selectedDayPredicate: (DateTime date) {
          return isSameDay(_selectedDay, date);
        },
        calendarBuilders: CalendarBuilders(
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
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(fontSize: 16.0),
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

          /* markerBuilder: (context, date, events, holidays) {
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
        */

          // onVisibleDaysChanged: _onVisibleDaysChanged,
          //  onCalendarCreated: _onCalendarCreated,
        ),

        onDaySelected: (selectedDay, focusedDay) {
          _onDaySelected(selectedDay, focusedDay);
        },
      );
    }

    return ChangeNotifierProvider<DietGameViewModel>(
        create: (context) => gameModel,
        //value: task,
        child: Consumer<DietGameViewModel>(
            builder: (context, model, child) => Stack(children: [
                  Scaffold(
                      key: scaffoldKey,
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        /* actions: [this.taskmodel.isSaved ?
                      IconButton(
                          icon: Icon(
                            FontAwesome5.edit,
                            color: kIconColor,
                            size:20
            
                          ),
                          onPressed: () {
                          this.taskmodel.isSaved=false;
                          this.taskmodel.refresh();
                          })
                        :IconButton(
                          icon: Icon(
                            Icons.save,
                            color: kIconColor,
                          ),
                          onPressed: () {
                           /* widget.gameModel.gamePlanTask =
                                this.taskmodel.savedDailyPlanTask;
                            widget.gameModel.gamePlanTodos =
                                this.taskmodel.savedDailyPlanTodos;
                                this.taskmodel.isSaved=true;
                                this.taskmodel.refresh();*/
                            //widget.gameModel.saveGame();
                            //Navigator.pop(context);
                            //Navigator.pop(context);
                          },
                        ),
                      ],*/
                        title: Text("Diet Planı",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: AppColors.kFont,
                                fontSize: 20)),
                        leading: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: kIconColor,
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
                            Divider(height: 2, color: Colors.blueGrey),
                            SizedBox(height: 20),
                            gameModel.planTodos.isEmpty
                                ? Center(
                                    child: SpinKitThreeBounce(
                                        color: AppColors.kRipple, size: 20),
                                  )
                                : Expanded(
                                    //color: Colors.blue,
                                    child: PlanCard(
                                        enabled: widget.enabled,
                                        flutterLocalNotificationsPlugin:
                                            flutterLocalNotificationsPlugin!,
                                        game: widget.game!,
                                        gameModel: gameModel,
                                        day: _selectedDay!,
                                        scrollController2: _scrollController),
                                  ),
                          ]),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.miniCenterFloat,
                      floatingActionButton: FadeTransition(
                          opacity: _hideFabAnimController!,
                          child: ScaleTransition(
                              scale: _hideFabAnimController!,
                              child: Visibility(
                                visible: enabled == false ? false : true,
                                child: FloatingActionButton.extended(
                                  heroTag: 'fab_new_task',
                                  onPressed: () async {
                                    await gameModel.sendScore(widget.game!,
                                        currentUser!.id!, widget.dietPlanId);
                                    print("skor gönderildi");
                                    // Navigator.pop(context);
                                  },
                                  tooltip: '',
                                  backgroundColor: AppColors.kRipple,
                                  foregroundColor: Colors.white,
                                  label: Text("Skorunu Gönder"),
                                  icon: Icon(Icons.send, size: 16),
                                ),
                              )))),
                  Center(
                      child: gameModel.isLoadingLottie
                          ? Loader(
                              child: Lottie.asset(
                                'assets/lottie/send_score.json',
                                controller: lottieController,
                                onLoaded: (composition) {
                                  lottieController!
                                    ..duration = composition.duration
                                    ..forward().whenComplete(() {
                                      gameModel.isSendingScore = false;

                                      Navigator.pop(context);
                                    });
                                },
                              ),
                            )
                          : SizedBox()),
                  Center(
                      child: gameModel.isSendingScore
                          ? Loader(
                              child: SpinKitThreeBounce(
                                  color: AppColors.kRipple, size: 20))

                          /*Loader(
                              child: Lottie.asset(
                                'assets/lottie/send_score.json',
                                controller: lottieController,
                                onLoaded: (composition) {
                                  lottieController!
                                    ..duration = composition.duration
                                    ..forward().whenComplete(() {
                                      gameModel.isSendingScore = false;

                                      Navigator.pop(context);
                                    });
                                },
                              ),
                            )*/
                          /*Loader(
                              imageUrl:
                                  "assets/lottie/send_score.json")*/ /*Lottie.asset(
                            "assets/lottie/bouncing-fruits.json",
                            width: 300,
                            height: 300,*/

                          : const SizedBox()),
                ])));
  }
}

// ignore: must_be_immutable
class PlanCard extends StatefulWidget {
  final DietGameViewModel? gameModel;
  final DietTaskViewModel taskModel = serviceLocator<DietTaskViewModel>();
  //final DietTask selectedTask;
  //final List<DietToDos> selectedTodos;
  final DateTime? day;
  final DietGame? game;
  Map? events;
  ScrollController? scrollController2;
  BuildContext? context;
  bool? enabled;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  PlanCard(
      {Key? key,
      this.enabled,
      //this.selectedTask,
      //this.selectedTodos,
      this.game,
      this.gameModel,
      this.day,
      this.events,
      this.scrollController2,
      this.flutterLocalNotificationsPlugin})
      : super(key: key);

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
  List<DietToDos> savedTodos = [];
  bool? enabled;
  @override
  void initState() {
    titleSelected = "";
    titleSaved = "";
    // _editingController = new TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    enabled = widget.gameModel!.isCheckable(widget.game!, widget.day!);
    viewedTodos =
        widget.gameModel!.gamePlanTodos[dateFormat.format(widget.day!)];
    title = widget.gameModel!.gameTaskTitle[dateFormat.format(widget.day!)];
    widget.gameModel!.gamePlanTodos.isNotEmpty
        ? widget.taskModel.setToDoKeys(viewedTodos!)
        : null;

    return ChangeNotifierProvider<DietGameViewModel>.value(
        //create: (context) => ,
        value: widget.gameModel!,
        child: Consumer<DietGameViewModel>(
            builder: (context, model, child) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title ?? "",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins"),
                    ),
                    Expanded(
                      child: CustomScrollView(
                        controller: widget.scrollController2,
                        // cacheExtent: 3000,
                        slivers: <Widget>[
                          SliverPadding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).padding.bottom),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    // widget.gameModel.createPhraseObjetsFromTodos(widget.taskModel.items[index].todo);
                                    return ItemStatic(
                                      enabled: enabled,
                                      flutterLocalNotificationsPlugin: widget
                                          .flutterLocalNotificationsPlugin!,
                                      key: UniqueKey(),
                                      model: widget.gameModel!,
                                      data: widget.taskModel.items[index],
                                      taskModel: widget.taskModel,
                                      game: widget.game!,
                                      index: index,
                                      day: widget.day!,
                                      // first and last attributes affect border drawn during dragging
                                      isFirst: index == 0,
                                      isLast: index ==
                                          widget.taskModel.items.length - 1,
                                      //draggingMode: _draggingMode,
                                    );
                                  },
                                  childCount: widget.taskModel.items.length,
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ))));
  }
}

class ItemStatic extends StatefulWidget {
  ItemStatic(
      {this.data,
      this.isFirst,
      this.isLast,
      this.model,
      this.game,
      this.index,
      this.taskModel,
      this.flutterLocalNotificationsPlugin,
      this.day,
      this.enabled,
      key})
      : super(key: key);
  final int? index;
  final bool? enabled;
  final ItemData? data;
  final bool? isFirst;
  final bool? isLast;
  final DietGameViewModel? model;
  final DietTaskViewModel? taskModel;
  final DietGame? game;
  final FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final DateTime? day;
  //bool isCompleted =false;
  final DateFormat dateFormat = DateFormat('HH:mm');
  final ScrollController _scrollerController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  _ItemStaticState createState() => _ItemStaticState();
}

class _ItemStaticState extends State<ItemStatic> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    //widget.model.createPhraseObjetsFromTodos();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemStatic oldWidget) {
    // TODO: implement didUpdateWidget

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> scheduleNotification(
      DietToDos todo,
      int value,
      FlutterLocalNotificationsPlugin plugin,
      String uniqueNotifiedId,
      String imagePath) async {
    var notifDate = DateTime(
            todo.startDate!.toDate().year,
            todo.startDate!.toDate().month,
            todo.startDate!.toDate().day,
            todo.startDate!.toDate().hour,
            todo.startDate!.toDate().minute,
            todo.startDate!.toDate().second)
        .subtract(Duration(minutes: value));

    final scheduledDate = tz.TZDateTime.from(notifDate, tz.local);

    final String largeIconPath =
        await _downloadAndSaveFile(imagePath, 'largeIcon');

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      // 'repeatDailyAtTime description',
      importance: Importance.max,
      priority: Priority.high,
      color: AppColors.kRipple,
      //sound: 'sound',
      ledColor: AppColors.kRipple,
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
      largeIcon: FilePathAndroidBitmap(largeIconPath),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    /*for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }*/
    /* await widget.flutterLocalNotificationsPlugin.show(
          1,
          this.widget.game.title,
          todo.title+": öğünün başlamasına az kaldı, acele et...",
          //'It is time to take your medicine, according to schedule',
          //Time(19, 05, 0),
          platformChannelSpecifics);
      hour = ogValue;*/
    await plugin.zonedSchedule(
        uniqueNotifiedId.hashCode,
        widget.game!.title,
        todo.title! + ": öğünün başlamasına az kaldı, acele et...",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        // scheduledDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
  //await flutterLocalNotificationsPlugin.cancelAll();

  @override
  Widget build(BuildContext context) {
//widget.model.createPhraseObjetsFromTodos(widget.data.todo);
    BoxDecoration? decoration;
    final NotificationViewModel notifyModel =
        Provider.of<NotificationViewModel>(context);

    return ChangeNotifierProvider<DietGameViewModel>.value(
        //create: (context) => ,
        value: widget.model!,
        child: Consumer<DietGameViewModel>(
            builder: (context, model, child) => Container(
                  decoration: decoration,
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Row(
                        //mainAxisSize: MainAxisSize.max,
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.kRipple.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: custom.ExpansionTile(
                                      initiallyExpanded: false,
                                      headerBackgroundColor: Colors.transparent,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Container(
                                            height: widget
                                                        .model!
                                                        .a[widget
                                                            .data!.todo.id]!
                                                        .length >
                                                    2
                                                ? 200
                                                : 100,
                                            child: Scrollbar(
                                              isAlwaysShown: true,
                                              controller:
                                                  widget._scrollerController,
                                              radius: Radius.circular(5),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                controller:
                                                    widget._scrollerController,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index ==
                                                      widget
                                                          .model!
                                                          .a[widget
                                                              .data!.todo.id]!
                                                          .length) {
                                                    return SizedBox(
                                                      height: 56, // size of FAB
                                                    );
                                                  }
                                                  var todoPhrase =
                                                      widget.model!.a[widget
                                                          .data!
                                                          .todo
                                                          .id]![index];
                                                  //.data.todo.phrases[index];
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                        left: 22.0,
                                                        right: 22.0),
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
                                                          scale: 0.9,
                                                          child: Checkbox(
                                                              activeColor:
                                                                  AppColors
                                                                      .kRipple,
                                                              onChanged:
                                                                  widget.enabled ==
                                                                          false
                                                                      ? null
                                                                      : (value) {
                                                                          widget.model!.setPhraseStatus(
                                                                              todoPhrase,
                                                                              index,
                                                                              value!);

                                                                          //widget.model.refresh();
                                                                          setState(
                                                                              () {});
                                                                        },
                                                              /* onChanged: (value) => model.updateTodo(
                                              todo.copy(isCompleted: value ? 1 : 0)),*/
                                                              value: todoPhrase
                                                                          .isCompleted ==
                                                                      1
                                                                  ? true
                                                                  : false),
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
                                                        transform: Matrix4
                                                            .translationValues(
                                                                -15, 0.0, 0.0),
                                                        child: Text(
                                                          todoPhrase.phrase!,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                AppColors.kFont,
                                                            /*todo.isCompleted == 1
                                              ? Colors.grey
                                              : Colors.black54,*/
                                                            decoration: todoPhrase
                                                                        .isCompleted ==
                                                                    1
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: widget.data!.todo
                                                        .phrases!.length +
                                                    1,

                                                /* Text(data.todo.phrase,
                                style: Theme.of(context).textTheme.subtitle1),*/
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                      title: Center(
                                        child: Column(children: [
                                          Text(widget.data!.todo.title!,
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 18,
                                                  color: AppColors.kFont,
                                                  fontWeight: FontWeight.w500)),
                                          TaskProgressIndicator(
                                              color: Colors.green, //_color,
                                              progress: widget.model!
                                                  .getTaskCompletionPercent(
                                                      widget.game!.id!,
                                                      widget.data!.todo.id!,
                                                      widget.day!,
                                                      widget.data!.todo.title!,
                                                      widget.data!.todo.rank!)

                                              // widget.data.todo.
                                              ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 0.0, top: 10, bottom: 5),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  /*Image(
        width: 45,
        height: 45,
        image: AssetImage('assets/images/raceFlag.png')),*/
                                                  // Icon(Icons.flag,color: Colors.green,),
                                                  const Icon(Icons.timelapse,
                                                      color: AppColors.kFont,
                                                      size: 20),
                                                  SizedBox(width: 8),
                                                  Text(
                                                      widget.dateFormat.format(
                                                          widget.data!.todo
                                                              .startDate!
                                                              .toDate()),
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 14,
                                                          color:
                                                              AppColors.kFont)),
                                                  Text(" - "),

                                                  // Icon(Icons.flag,color: Colors.red,),
                                                  Text(
                                                      widget.dateFormat.format(
                                                          widget.data?.todo
                                                                  .endDate!
                                                                  .toDate() ??
                                                              DateTime.now()),
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 14,
                                                          color:
                                                              AppColors.kFont)),
                                                ]),
                                          ),
                                        ]),
                                      ))),
                            ),
                            // Triggers the reordering
                          ),
                          SizedBox(width: 4),
                          SimpleAlertDialog(
                              todo: widget.data!.todo,
                              index: widget.index!,
                              game: widget.game!,
                              onDeletePressed: (uniqueNotifiedId) {
                                notifyModel.removeTodoNotify(uniqueNotifiedId);
                                Navigator.pop(context);
                              },

                              //color: AppColors.kFont,
                              onCreatePressed: (value) {
                                var a = widget.data!.todo.startDate!.toDate();
                                var b = widget.data!.todo.startDate!.toDate();
                                DateTime c = DateTime(
                                    a.year, a.month, a.day, b.hour, b.minute);

                                //widget.data.todo.startDate =

                                TodoNotify newEntryMedicine = TodoNotify(
                                    //notificationIDs: notificationIDs,
                                    todoName: widget.data!.todo.title,
                                    startNotify: c,
                                    gameName: widget.game!.title,
                                    todoId: widget.data!.todo.id,
                                    //medicineType: medicineType,
                                    interval: value,
                                    startTime:
                                        widget.data!.todo.startDate.toString(),
                                    startNotify2: dateFormat.format(c),
                                    //  isNotified: true,
                                    notifiedId: (widget.game!.id! +
                                            "_" +
                                            dateFormat.format(widget
                                                .data!.todo.startDate!
                                                .toDate()) +
                                            widget.data!.todo.title! +
                                            widget.index.toString()

                                        //+value.toString()
                                        ));

                                notifyModel
                                    .updateTodoNotifyList(newEntryMedicine);

                                notifyModel.scheduleNotification(
                                    newEntryMedicine,
                                    value,
                                    notifyModel.flutterLocalNotificationsPlugin,
                                    widget.game!.id! +
                                        "_" +
                                        dateFormat.format(widget
                                            .data!.todo.startDate!
                                            .toDate()) +
                                        widget.data!.todo.title! +
                                        widget.index.toString(),
                                    widget.game!.imageTitleUrl!);
                                //  model.removeTask(widget.task.id);
                                Navigator.pop(context);
                              }),
                          //dragHandle,
                        ],
                      ),
                    ),
                  ),
                )));
  }
}

typedef Callback = void Function(int);
typedef Callback_String = void Function(String);

class SimpleAlertDialog extends StatefulWidget {
  Color? color;
  final Callback? onCreatePressed;
  final Callback_String? onDeletePressed;
  DietToDos? todo;
  DietGame? game;
  int? index;

  SimpleAlertDialog(
      {this.todo,
      this.index,
      this.game,
      this.color,
      @required this.onCreatePressed,
      this.onDeletePressed});

  @override
  State<StatefulWidget> createState() {
    return _SimpleAlertDialogState();
  }
}

class _SimpleAlertDialogState extends State<SimpleAlertDialog> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String uniqueNotifiedId = "";

  DateTime? notifyDate2;
  @override
  void initState() {
    super.initState();
    uniqueNotifiedId = widget.game!.id! +
        "_" +
        dateFormat.format(widget.todo!.startDate!.toDate()) +
        widget.todo!.title! +
        widget.index.toString();

    var a = widget.todo!.startDate!.toDate();
    var b = widget.todo!.startDate!.toDate();
    notifyDate2 = DateTime(a.year, a.month, a.day, b.hour, b.minute);
  }

  var _intervals = [5, 15, 30, 45, 60];
  var _selected = 15;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    NotificationViewModel notifyModel =
        Provider.of<NotificationViewModel>(context);

    return StreamBuilder<List<TodoNotify>>(
        stream: notifyModel.medicineList$,
        builder: (context, snapshot) {
          return Container(
            //color: Colors.green,
            child: DateTime.now().isAfter(notifyDate2!)
                ? Icon(Icons.notifications, size: 20, color: Colors.white)
                : GestureDetector(
                    child: Icon(Icons.notifications,
                        size: 20,
                        color: widget.todo != null
                            ? (notifyModel.isNotifiedContol(uniqueNotifiedId)
                                ? AppColors.kRipple
                                : Colors.grey)
                            : Colors.grey),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          _selected = 15;
                          return StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return AlertDialog(
                                title: Text('Hatırlatıcı Oluştur'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Row(children: [
                                        DropdownButton<int>(
                                          iconEnabledColor: AppColors.kRipple,
                                          hint: notifyModel.getNotifiedInterval(
                                                      uniqueNotifiedId) ==
                                                  0
                                              //_selected == 0
                                              ? Text(
                                                  "Seçiniz",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              : Text(notifyModel
                                                  .getNotifiedInterval(
                                                      uniqueNotifiedId)
                                                  .toString()),
                                          elevation: 4,
                                          value: notifyModel
                                                      .getNotifiedInterval(
                                                          uniqueNotifiedId) ==
                                                  0
                                              ? _selected
                                              : notifyModel.getNotifiedInterval(
                                                  uniqueNotifiedId),
                                          items: _intervals.map((int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(
                                                value.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            setState(() {
                                              _selected = newVal!;

                                              //_newEntryBloc.updateInterval(newVal);
                                            });
                                          },
                                        ),
                                        SizedBox(width: 8),
                                        Text('dk önce hatırlat.'),
                                      ]),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    //color: Colors.orange,
                                    child: notifyModel.getNotifiedInterval(
                                                uniqueNotifiedId) >
                                            0
                                        ? Text(
                                            'İptal Et',
                                            style: TextStyle(
                                                color: AppColors.kRipple),
                                          )
                                        : Text("Oluştur",
                                            style: TextStyle(
                                                color: AppColors.kRipple)),
                                    onPressed: () {
                                      var notifDate = DateTime(
                                          widget.todo!.startDate!.toDate().year,
                                          widget.todo!.startDate!
                                              .toDate()
                                              .month,
                                          widget.todo!.startDate!.toDate().day,
                                          widget.todo!.startDate!.toDate().hour,
                                          widget.todo!.startDate!
                                              .toDate()
                                              .minute,
                                          widget.todo!.startDate!
                                              .toDate()
                                              .second);
                                      if (DateTime.now().compareTo(notifDate) >
                                          0) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Uyarı',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.kRipple)),
                                                content: Text(
                                                  'Geçmiş tarihli hatırlatıcı oluşturamazsınız..',
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Kapat',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .kRipple))),
                                                ],
                                              );
                                            });
                                      } else {
                                        // Navigator.of(context).pop();
                                        notifyModel.getNotifiedInterval(
                                                    uniqueNotifiedId) >
                                                0
                                            ? widget.onDeletePressed!(
                                                uniqueNotifiedId)
                                            : widget
                                                .onCreatePressed!(_selected);
                                        widget.color = AppColors.kRipple;
                                      }
                                    },
                                  ),
                                  FlatButton(
                                    //color: Colors.orange,
                                    child: Text(
                                      'Kapat',
                                      style:
                                          TextStyle(color: AppColors.kRipple),
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
                    }),
          );
        });
  }
}

class Loader extends StatelessWidget {
  const Loader(
      {Key? key,
      this.child,
      this.opacity: 0.9,
      this.dismissibles: false,
      this.color: Colors.white,
      this.imageUrl: "",
      this.loadingTxt: 'Loading...'})
      : super(key: key);

  final Widget? child;
  final double opacity;
  final bool dismissibles;
  final Color color;
  final String loadingTxt;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.white),
        ),
        Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 400,
                height: 400,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 10),
                child: child
                //Lottie.asset(imageUrl) //const CircularProgressIndicator(),
                /*decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/spinner.gif"),
                ),
              ),*/
                ),
            /* Container(
              margin: const EdgeInsets.only(top: 5),
              child: Text(loadingTxt,
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
            ),*/
          ],
        )),
      ],
    );
  }
}
