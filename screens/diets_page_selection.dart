// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/screens/recipesearch.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:transparent_image/transparent_image.dart';
import '../constants.dart';
import '../size_config.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_icons/flutter_icons.dart';

class DietsPageSelect extends StatefulWidget {
  final DietGameViewModel? gameModel;
  final DietTaskViewModel? model; // = serviceLocator<DietTaskViewModel>();
  final DateTime? day;
  const DietsPageSelect({Key? key, this.gameModel, this.model, this.day})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DietsPageSelectState();
  }
}

class _DietsPageSelectState extends State<DietsPageSelect>
    with TickerProviderStateMixin {
  TabController? _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    const Tab(
        icon: Icon(
      Icons.favorite,
      color: AppColors.kRipple,
    )),
    const Tab(
        icon: Icon(
      Icons.star,
      color: AppColors.kRipple,
    )),
  ];

  Future<void> _showDayErrorDialog() async {
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(20),
        title: Text(
          'Uyarı',
          style: TextStyle(fontSize: 18, color: Colors.red),
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
        content:
            Text("Plan gün sayısı oyun gün sayısından büyük olmamalıdır."));
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  initState() {
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller!.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
      print("Selected Index: " + _controller!.index.toString());
    });
  }

  @override
  dispose() {
    //   debugPrint("*********Task ViewModel dispose*******");
    super.dispose();
  }

  List<String> selectedTasks = [];
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            onTap: (index) {
              // Should not used it as it only called when tab options are clicked,
              // not when user swapped
            },
            controller: _controller,
            tabs: list,
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            "Diet Planları",
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kRed),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.kFont,
            ),
            onPressed: () {
              /* widget.gameModel.dietId=selectedTasks.first;
              widget.gameModel.selectedDiet =widget.model.tasks.firstWhere((element) => element.id==selectedTasks.first);*/
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF545D68)),
              onPressed: () {
                showSearch(context: context, delegate: RecipeSearch());
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: TabBarView(controller: this._controller, children: [
          FutureBuilder(
              future: widget.model!.getTasks(adminId),
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
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    // Completed with data

                    return ListView(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        Container(
                            color: AppColors.kBackground,
                            width: MediaQuery.of(context).size.width - 30.0,
                            height: MediaQuery.of(context).size.height - 50.0,
                            child: GridView.count(
                              crossAxisCount: 2,
                              primary: false,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 1.0,
                              childAspectRatio: 0.8,
                              children: widget.model!.tasks.map((iconData) {
                                return GestureDetector(
                                  onTap: () async {
                                    var gameDays = widget.model!
                                        .getDaysInBetween(
                                            widget.gameModel!.startTime,
                                            widget.gameModel!.endTime);
                                    if (iconData.days! > gameDays.length) {
                                      await _showDayErrorDialog();
                                    } else {
                                      var range = await showDateRangePicker(
                                          currentDate:
                                              widget.model!.selectedDay,
                                          context: context,
                                          firstDate:
                                              widget.gameModel!.startTime,
                                          lastDate: widget.gameModel!.endTime);

                                      /*var checkResult = await widget.model!
                                        .checkPlanCriteria(
                                            range!, iconData.days!);
                                    checkResult == false
                                        ? await _showDayErrorDialog()
                                        : null;
*/
                                      range != null
                                          ? await widget.model!
                                              .setPlanToGame(range, iconData)
                                          : null;
                                      Navigator.pop(context);
                                    }
                                    /*await widget.model!.getTaskTodos(
                                        currentUser!.id!, iconData.id!);
                                    //await widget.model.getTaskIcons(iconData.iconIds);
                                    widget.model!.titleModified = null;
                                    widget.model!.setTask(iconData);
                                    widget.model!.selectedDailyPlanTask[
                                            dateFormat.format(widget.day!)] =
                                        widget.model!
                                            .selectedTaskPlan!; //iconData;

                                    widget.model!.selectedTaskTitleCopy![
                                            dateFormat.format(widget.day!)] =
                                        widget.model!.titleCopy!;
                                    widget.model!.selectedTaskTitleModify![
                                            dateFormat.format(widget.day!)] =
                                        widget.model!.titleCopy!;
                                    widget.model!.savedTaskTitleCopy?[
                                        dateFormat.format(widget.day!)] = "";
                                    widget.model!.savedTaskTitleModify?[
                                        dateFormat.format(widget.day!)] = "";

                                    widget.model!.selectedDailyPlanTodosModify[
                                            dateFormat.format(widget.day!)] =
                                        widget.model!
                                            .copy(widget.model!.todos2);
                                    widget.model!.selectedDailyPlanTodos[
                                            dateFormat.format(widget.day!)] =
                                        List.from(widget.model!.todos2);
                                    widget.model!.selectedDailyPlanTodosCopy[
                                            dateFormat.format(widget.day!)] =
                                        widget.model!
                                            .copy(widget.model!.todos2);
                                    //     widget.model.todos2.forEach((element) {element.phrases.add(["b"]);element.title="c";});
                                    //     widget.model.selectedDailyPlanTodosModify[dateFormat.format(widget.day)] == widget.model.selectedDailyPlanTodosCopy[dateFormat.format(widget.day)]?print("Evet"):print("hayır");

                                    widget.model!.dailyEvents[DateTime(
                                            widget.day!.year,
                                            widget.day!.month,
                                            widget.day!.day)] =
                                        List.from(widget.model!.todos2); //[];

                                    widget.model!.dailyEventsTitle[DateTime(
                                            widget.day!.year,
                                            widget.day!.month,
                                            widget.day!.day)] =
                                        widget.model!.titleCopy;

                                    widget.model!.savedDailyPlanTodosCopy[
                                        dateFormat.format(widget.day!)] = null;
                                    widget.model!.savedDailyPlanTodosModify[
                                        dateFormat.format(widget.day!)] = null;
                                    widget.model!.savedDailyPlanTodos[
                                        dateFormat.format(widget.day!)] = null;
                                        */
                                    //     Navigator.pop(context);
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
                                  child: GridViewItem(iconData,
                                      selectedTasks.contains(iconData.id)),
                                );
                              }).toList(),
                            )),
                        // SizedBox(height: 15.0)
                      ],
                    );
                }
              }),
          Container()
        ]));
  }
}

class GridViewItem extends StatelessWidget {
  final DietTask task;
  final bool isSelected;

  const GridViewItem(this.task, this.isSelected);

  @override
  Widget build(BuildContext context) {
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
                width: getProportionateScreenWidth(180),
                height: getProportionateScreenHeight(130),
                decoration: BoxDecoration(
                    //border: Border.all(color: isSelected ? Colors.green:Colors.transparent) ,
                    //color: Colors.green,
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    image: task.backgroundId!,
                    placeholder: kTransparentImage,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Container(
                      // width: 100,
                      //height: 100,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                )),
            Container(
              width: getProportionateScreenWidth(180),
              padding: EdgeInsets.all(
                getProportionateScreenWidth(kDefaultPadding),
              ),
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
                    task.title!,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.kFont),
                  ),
                  VerticalSpacing(of: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    //Container()
                    Icon(
                      Icons.favorite,
                      size: 18,
                      color: AppColors.kRed,
                    ),
                    SizedBox(width: 5),
                    task.likesCount != null && task.likesCount != 0
                        ? Text(task.likesCount.toString(),
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: AppColors.kRed))
                        : SizedBox(),
                    Spacer(),
                    Text("Gün: ",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: AppColors.kFont)),
                    Text("${task.days}",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: AppColors.kFont))
                  ]),

                  /* Travelers(
                      users: travelSport.users,
                    ),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
