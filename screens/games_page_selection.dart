// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/screens/gameTaskDetailScreen.dart';
import 'package:friendfit_ready/screens/recipe_detail.dart';
import 'package:friendfit_ready/screens/recipesearch.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants.dart';
import '../size_config.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
//import 'package:flutter_icons/flutter_icons.dart';

class GamesPageSelect extends StatefulWidget {
  final DietGameViewModel? gameModel;
  final DietTaskViewModel? model; // = serviceLocator<DietTaskViewModel>();
  final DateTime? day;
  List<DietGame>? dietGames;
  GamesPageSelect({Key? key, this.gameModel, this.model, this.day})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GamesPageSelectState();
  }
}

class _GamesPageSelectState extends State<GamesPageSelect> {
  List<String> selectedTasks = [];
  DietTaskViewModel taskModel = serviceLocator<DietTaskViewModel>();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    // TODO: implement initState

    /* DietGame addGame = DietGame(id: "1");
    widget.dietGames = [];
    widget.dietGames.add(addGame);
    widget.gameModel.games.forEach((element) { widget.dietGames.add(element);});*/
  }
  @override
  void dispose() {
    // TODO: implement dispose
    //var a="okan";
    super.dispose();
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      firstDay: widget.gameModel!.startTime,
      lastDay: widget.gameModel!.endTime,
      //eventLoader: _getEventsfromDay,

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
        outsideDaysVisible: false,
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
        formatButtonVisible: false,
      ),
      /*selectedDayPredicate: (DateTime date) {
         return isSameDay(_selectedDay, date);
        },*/
      //eventLoader: _getEventsfromDay,
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          return /* FadeTransition(
              opacity:
                  Tween(begin: 0.0, end: 1.0).animate(_animationController!),
              child: */
              Container(
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
        /*markerBuilder: (context, date, events) {
            Widget children = Container();

            if (events.isNotEmpty) {
              children = Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              );
            }

            return children;
          },*/
      ),
      onDaySelected: (selectedDay, focusedDay) {
        // _onDaySelected(selectedDay, focusedDay);
      },
      /* onDaySelected: (date, events, holidays) {
          _onDaySelected(date, events, holidays);
          _animationController!.forward(from: 0.0);
        },*/

      //onVisibleDaysChanged: _onVisibleDaysChanged,
      //onCalendarCreated: _onCalendarCreated,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Diet Planları",
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kRed),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: kIconColor),
            onPressed: () {
              /* widget.gameModel.dietId=selectedTasks.first;
              widget.gameModel.selectedDiet =widget.model.tasks.firstWhere((element) => element.id==selectedTasks.first);*/
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Color(0xFF545D68)),
              onPressed: () {
                showSearch(context: context, delegate: RecipeSearch());
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: widget.gameModel!.getGames(currentUser!.id!),
            // initialData: InitialData,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // Uncompleted State
                case ConnectionState.none:
                case ConnectionState.waiting:
                /* return Center(child: CircularProgressIndicator());
                          break;*/
                default:
                  // Completed with error
                  if (snapshot.hasError)
                    return Container(child: Text(snapshot.error.toString()));

                  // Completed with data

                  return ListView(
                    children: <Widget>[
                      // _buildTableCalendarWithBuilders(),
                      SizedBox(height: 15.0),
                      Container(
                          color: AppColors.kBackground,
                          width: MediaQuery.of(context).size.width - 30.0,
                          height: MediaQuery.of(context).size.height - 50.0,
                          child:

                              /* GridView.builder(
              itemCount: widget.gameModel.games.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                                  
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 1.0,
                                    childAspectRatio: 0.8,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GridViewItem(
                                            widget.gameModel.games[index],
                                            //selectedTasks.contains(iconData.id)
                                                );
              },
            ),*/

                              GridView.count(
                            crossAxisCount: 2,
                            primary: false,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 1.0,
                            childAspectRatio: 0.8,
                            children: widget.gameModel!.games.map((iconData) {
                              return GestureDetector(
                                onTap: () async {
                                  iconData.id == "1"
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  GameTaskDetailScreen(
                                                    gameModel: widget.gameModel,
                                                  )
                                              /*GameTaskDetailScreen(
                        gameModel: this.gameModel,
                      ),*/
                                              ),
                                        )
                                      : null;
                                  // await  widget.model.getTaskTodos(currentUser!.id, iconData.id);
                                  //await widget.model.getTaskIcons(iconData.iconIds);
                                  // widget.model.setTask(iconData);
                                  // widget.model.selectedDailyPlanTask[this.dateFormat.format(widget.day)]=widget.model.selectedTaskPlan;//iconData;
                                  //widget.model.selectedDailyPlanTodos[this.dateFormat.format(widget.day)]=widget.model.todos2;

                                  //print(this.dateFormat.format());
                                  //widget.model.selectedTask=iconData;
                                  //Navigator.pop(context);
                                  /* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>                                                
                                                  GameTaskDetailScreen(//gameModel: widget.gameModel,
                                                  model: model,
                                                      task: iconData),
                                            ),
                                          );*/
                                },
                                child: GridViewItem(
                                  iconData,
                                  //selectedTasks.contains(iconData.id)
                                ),
                              );
                            }).toList(),
                          )),
                      // SizedBox(height: 15.0)
                    ],
                  );
              }
            }));
  }
}

class GridViewItem extends StatelessWidget {
  final DietGame task;
  final bool? isSelected;
  int diffDays = 0;

  GridViewItem(this.task, {this.isSelected});
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round() == 0
        ? 1
        : (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    diffDays = (task.startDate != null || task.endDate != null)
        ? daysBetween(task.startDate!.toDate(), task.endDate!.toDate())
        : 0;
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 0.0, right: 0.0),
      child: Container(
        //width: getProportionateScreenWidth(157),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
        child: Column(
          children: [
            Container(
              child: task.id == "1"
                  ? Center(
                      child: Icon(Icons.add_circle_outline_rounded,
                          size: 50, color: AppColors.kRipple),
                    )
                  : null,
              width: getProportionateScreenWidth(150),
              height: getProportionateScreenHeight(100),
              decoration: BoxDecoration(
                  //border: Border.all(color: isSelected ? Colors.green:Colors.transparent) ,
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: task.id != "1"
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(
                              task.imageTitleUrl ?? ""),
                          fit: BoxFit.cover)
                      : null
                  /*image: DecorationImage(
                    image: choicesImages
                        .where((a) => a.id == task.imageTitleUrl)
                        .first
                        .image,
                    fit: BoxFit.cover),*/
                  ),
            ),
            Container(
              width: getProportionateScreenWidth(150),
              padding: EdgeInsets.fromLTRB(10, 10, 10,
                  0), //EdgeInsets.all(       getProportionateScreenWidth(10),              ),
              decoration: BoxDecoration(
                // border: Border.all(color: isSelected ? Colors.green:Colors.transparent),
                color: Colors.white,
                boxShadow: [kDefualtShadow],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    task.id == "1" ? "Yeni Plan Oluştur !" : task.title ??= "",
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.kFont,
                      fontSize: 13,
                    ),
                  ),
                  VerticalSpacing(of: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(
                      Icons.favorite,
                      size: 18,
                      color: AppColors.kRed,
                    ),
                    SizedBox(width: 5),
                    Text(
                        /*task.likesCount == null
                                    ? ""
                                    : task.likesCount.toString(),*/
                        "20",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: AppColors.kRed)),
                    Spacer(),
                    Text(
                      task.id == "1" ? "" : "$diffDays gün",
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.kFont,
                        fontSize: 12,
                      ),
                    ),
                    /*Icon(
                      Icons.favorite,
                      size: 20,
                      color: AppColors.kRed,
                    ),
                    SizedBox(width: 5),
                    Text(task.likesCount.toString(),
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: AppColors.kRed)),
                    Spacer(),
                    isSelected
                        ? Icon(
                            Icons.check_circle,
                            size: 25,
                            color: Colors.green,
                          )
                        : Container(),*/
                  ]),

                  /* Travelers(
                      users: travelSport.users,
                    ),*/

                  ElevatedButton(
                      child: Text(
                        "Ekle",
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        minimumSize: Size(getProportionateScreenWidth(60), 10),
                        elevation: 2,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                titlePadding: EdgeInsets.fromLTRB(0, 16, 0, 5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                title: Column(children: <Widget>[
                                  TableCalendar(
                                    firstDay: task.startDate!.toDate(),
                                    lastDay: task.endDate!.toDate(),
                                    //eventLoader: _getEventsfromDay,

                                    locale: 'tr_TR',
                                    //calendarController: _calendarController,
                                    // events: this.taskmodel.dailyEvents, // _events,
                                    focusedDay: task.startDate!.toDate(),
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
                                      markerDecoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle),
                                      outsideDaysVisible: false,
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
                                      formatButtonVisible: false,
                                    ),
                                    /*selectedDayPredicate: (DateTime date) {
                                     return isSameDay(_selectedDay, date);
                                    },*/
                                    //eventLoader: _getEventsfromDay,
                                    calendarBuilders: CalendarBuilders(
                                      selectedBuilder: (context, date, _) {
                                        return /* FadeTransition(
                                          opacity:
                                              Tween(begin: 0.0, end: 1.0).animate(_animationController!),
                                          child: */
                                            Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.kRipple
                                                .withOpacity(0.6),
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          margin: const EdgeInsets.all(8.0),
                                          //padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                          //color: AppColors.kRipple, // Colors.deepOrange[300],
                                          width: 100,
                                          height: 100,
                                          child: Center(
                                            child: Text(
                                              '${date.day}',
                                              style: TextStyle()
                                                  .copyWith(fontSize: 16.0),
                                            ),
                                          ),
                                        );
                                      },
                                      todayBuilder: (context, date, _) {
                                        return Container(
                                          //margin: const EdgeInsets.all(4.0),
                                          //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                                          color: Colors
                                              .transparent, //Colors.amber[400],
                                          width: 100,
                                          height: 100,
                                          child: Center(
                                            child: Text(
                                              '${date.day}',
                                              style: TextStyle().copyWith(
                                                  fontSize: 16.0,
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                        );
                                      },
                                      /*markerBuilder: (context, date, events) {
                                        Widget children = Container();
                            
                                        if (events.isNotEmpty) {
                                          children = Positioned(
                                            right: 1,
                                            bottom: 1,
                                            child: _buildEventsMarker(date, events),
                                          );
                                        }
                            
                                        return children;
                                      },*/
                                    ),
                                    onDaySelected: (selectedDay, focusedDay) {
                                      // _onDaySelected(selectedDay, focusedDay);
                                    },
                                    /* onDaySelected: (date, events, holidays) {
                                      _onDaySelected(date, events, holidays);
                                      _animationController!.forward(from: 0.0);
                                    },*/

                                    //onVisibleDaysChanged: _onVisibleDaysChanged,
                                    //onCalendarCreated: _onCalendarCreated,
                                  ),
                                ])));
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
