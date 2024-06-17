// ignore_for_file: file_names, prefer_const_constructors, use_key_in_widget_constructors

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/gradient_background.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/utils/color_utils.dart';
import 'package:friendfit_ready/widgets/date_time_picker_widget.dart';
import 'package:friendfit_ready/widgets/dropdown.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/widgets/time_picker_widget.dart';
import 'dart:async';

class AddTaskScreen extends StatefulWidget {
  final DietTaskViewModel? todoModel;
  final DietToDos? todom;
  final int? day;
  const AddTaskScreen({this.todoModel, this.todom, this.day});

  @override
  State<StatefulWidget> createState() {
    return _AddTaskScreenState();
  }
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  List<dynamic>? periodPhrases;
  String? periodPhrase;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color? taskColor;
  IconData? taskIcon;
  String? periodName = '';
  DateTime periodTime = DateTime.now();
  final now = DateTime.now();
  TextEditingController? _editingController;
  TextEditingController? _editingControllerTitle;
  String? dropdownInitialValue;
  bool _enabled = true;
  bool _enabled2 = true;

  ScrollController? _scrollerController;
  int? day;

  double? time2D;

  double? time1D;
  TimeOfDay? time1;
  TimeOfDay? time2;

  String? error;

  SnackBar? snackBar;

  @override
  void initState() {
    time1 = widget.todom == null
        ? TimeOfDay(hour: 7, minute: 30)
        : TimeOfDay.fromDateTime(widget.todom!.startDate!.toDate());
    time1D = toDouble(time1!);

    time2 = widget.todom == null
        ? TimeOfDay(hour: 8, minute: 30) //null
        : TimeOfDay.fromDateTime(widget.todom!.endDate!.toDate());
    time2D = toDouble(time2!);

    Map reversePeriodNames = {
      'Sabah': '1',
      'Öğlen': '2',
      'Akşam': '3',
      'Ara Öğün': '4',
      'Gece': '5'
    };
    super.initState();
    day = widget.day;
    _scrollerController = ScrollController(initialScrollOffset: 0.0);
    // ScrollController _scrollerController=ScrollController();
    _editingControllerTitle = TextEditingController(text: "");

    _editingController = TextEditingController(
        text: widget.todom == null ? '' : widget.todom!.phrase);
    taskColor = ColorUtils.defaultColors[0];
    dropdownInitialValue =
        widget.todom == null ? null : reversePeriodNames[widget.todom!.title];
    // periodPhrase = widget.todom == null ? null : widget.todom.phrase;
    //periodPhrases = widget.todom == null ? null : widget.todom.phrases;
    periodName = widget.todom == null ? null : widget.todom!.title;
    periodName = periodName ?? "Sabah";
    widget.todoModel!.copyTodoPhrases =
        widget.todom == null ? [] : List.from(widget.todom!.phrases!);
    //widget.todoModel.copyTodoPhrases.add("a");

    /*  setState(() {
      periodPhrase = widget.todom == null ?'':widget.todom.phrase;
      taskColor = ColorUtils.defaultColors[0];
      
    });*/
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollerController!.dispose();
    _editingController!.dispose();
    _editingControllerTitle!.dispose();
  }
  /*void showTitleDialog(int index,String todo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var newTodo;
          return AlertDialog(
            //title: Text("Başlık Giriniz"),
            content:  
            
            Column(mainAxisSize: MainAxisSize.min, children: [
            Container(height:80,
                    decoration: BoxDecoration(
                        color: AppColors.kRipple.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 0),
                      child: TextField(
                        
                        controller: _editingControllerTitle,
                        onChanged: (text) {
                      setState(() {
                          newTodo=text;
                           newTodo.isNotEmpty
                      ? widget.todoModel.showAlert = false
                      : widget.todoModel.showAlert = true;
                       //   widget.taskModel.selectedTaskPlan.title=text;
                        });
                          
                        },
                        minLines: 2,
                        //maxLength: 50,
                        maxLines: 4,
                        //cursorColor: taskColor,
                        autofocus: false,//true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                           /* hintText: 'Öğün içeriğini giriniz...',
                            hintStyle: TextStyle(
                                color: Colors.black26,
                                fontFamily: "Poppins",
                                fontSize: 18)*/),
                        style: TextStyle(
                            color: AppColors.kFont.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                    ),
                  ),

 widget.todoModel.showAlert
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
                child: Text("Tamam"),
                onPressed: () {
                 setState(() {
                   widget.todoModel.copyTodoPhrases[index]=newTodo;
                   newTodo.isNotEmpty
                      ? widget.todoModel.showAlert = false
                      : widget.todoModel.showAlert = true;
                     FocusScope.of(context).unfocus();

                 });
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
  }*/

  @override
  Widget build(BuildContext context) {
    Map periodNames = {
      '1': 'Sabah',
      '2': 'Öğlen',
      '3': 'Akşam',
      '4': "Ara Öğün",
      '5': 'Gece'
    };

    //widget.todoModel.copyTodoPhrases = [];

    return ChangeNotifierProvider<DietTaskViewModel>.value(
        value: widget.todoModel!,
        child: Consumer<DietTaskViewModel>(
            builder: (context, model, child) => GradientBackground(
                color: taskColor!,
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    key: _scaffoldKey,
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      title: Text(
                        'Yeni Beslenme Menüsü',
                        style: TextStyle(color: AppColors.kFont),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.kFont,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        SimpleAlertDialog(
                          () {
                            debugPrint("Hello");

                            widget.todoModel!
                                .removeToDoFromTodos(widget.todom!.id!);
                            Navigator.pop(context);
                          },
                          color: AppColors.kFont,
                        )
                      ],
                      centerTitle: true,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black54),
                      brightness: Brightness.light,
                      backgroundColor: Colors.white,
                    ),
                    body: Container(
                      constraints: BoxConstraints.expand(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Row(
                children: [
                  ColorPickerBuilder(
                      color: taskColor,
                      onColorChanged: (newColor) =>
                          setState(() => taskColor = newColor)),
                  Container(
                    width: 22.0,
                  ),
                  IconPickerBuilder(
                      iconData: taskIcon,
                      highlightColor: taskColor,
                      action: (newIcon) => setState(() => taskIcon = newIcon)),
                ],
              ),*/

                          Row(children: [
                            Text(
                              'Öğün periyodu',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColors.kFont.withOpacity(0.7),
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red.withOpacity(0.7),
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ]),
                          SizedBox(height: 10),
                          DropDownButton((value) {
                            // setState(() {
                            periodName = periodNames[value];
                            //   });
                            setState(() {
                              dropdownInitialValue = value;
                            });

                            //dropdownInitialValue = value;widget.todoModel.refresh();

                            print("$periodName");
                          }, initialValue: dropdownInitialValue ?? "1"),
                          SizedBox(height: 10),
                          Row(children: [
                            Text(
                              'Öğün saat aralığı',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColors.kFont.withOpacity(0.7),
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '*',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red.withOpacity(0.7),
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ]),
                          SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TimePickerWidget(
                                  type: "1",
                                  initialValue: time1!,
                                  onValueChange: (value) {
                                    widget.todoModel!.startTime = value;
                                    time1D = toDouble(value);
                                  },
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "-",
                                  style: TextStyle(
                                      color: AppColors.kFont, fontSize: 16),
                                ),
                                SizedBox(width: 5),
                                TimePickerWidget(
                                  type: "2",
                                  initialValue: time2,
                                  onValueChange: (value) {
                                    time2D = toDouble(value);
                                    // ignore: prefer_if_null_operators

                                    widget.todoModel!.endTime = value;
                                  },
                                )
                              ]),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          TextField(
                            controller: _editingController,
                            onChanged: (text) {
                              periodPhrase = text;
                            },
                            keyboardType: TextInputType.multiline,
                            //  textInputAction: TextInputAction.done,
                            // minLines: 3,
                            // maxLength: 100,
                            // maxLines: 7,
                            cursorColor: taskColor,
                            autofocus: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Öğün içeriğini giriniz...',
                                hintStyle: TextStyle(
                                    color: Colors.black26,
                                    fontFamily: "Poppins",
                                    fontSize: 18)),
                            style: TextStyle(
                                color: AppColors.kFont.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                          ),
                          Center(
                              child: Builder(builder: (BuildContext context) {
                            return RaisedButton(
                                disabledColor: Colors.grey,
                                padding: EdgeInsets.zero,
                                color: AppColors.kRipple,
                                elevation: 4.0,
                                child: Text(
                                  "Ekle",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: _enabled == false
                                    ? null
                                    : () {
                                        if (periodPhrase == null ||
                                            periodName == null ||
                                            (periodPhrase != null &&
                                                periodPhrase!.trim().isEmpty)) {
                                          setState(() => _enabled = false);
                                          FocusScope.of(context).unfocus();

                                          snackBar = SnackBar(
                                            content: Text(
                                                'Periyod adı, saat aralığı ve içerik alanlarını doldurmalısınız.'),
                                            backgroundColor: taskColor,
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar!);

                                          Timer(
                                              Duration(seconds: 4),
                                              () => setState(
                                                  () => _enabled = true));
                                          // _scaffoldKey.currentState.showSnackBar(snackBar);

                                        } else {
                                          _editingController!.clear();

                                          FocusScope.of(context).unfocus();
                                          widget.todoModel!.addToDoPhrase(
                                              phrase: periodPhrase);

                                          periodPhrase = null;
                                        }
                                      },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)));
                          })),
                          Divider(),
                          widget.todoModel!.copyTodoPhrases.isNotEmpty
                              ? Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 0.0, bottom: 40),
                                    child: Scrollbar(
                                      isAlwaysShown: true,
                                      controller: _scrollerController,
                                      radius: Radius.circular(1),
                                      child: ListView.builder(
                                        controller: _scrollerController,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index ==
                                              widget.todoModel!.copyTodoPhrases
                                                  .length) {
                                            return SizedBox(
                                              height: 56, // size of FAB
                                            );
                                          }
                                          var todo = widget.todoModel!
                                              .copyTodoPhrases[index];
                                          return Container(
                                            padding: EdgeInsets.only(
                                                left: 22.0, right: 22.0),
                                            child: ListTile(
                                              /*onTap: () => model.updateTodo(todo.copy(
                                isCompleted: todo.isCompleted == 1 ? 0 : 1)),*/
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0.0),
                                              leading: Checkbox(
                                                  activeColor:
                                                      AppColors.kRipple,
                                                  onChanged: (value) {},
                                                  /* onChanged: (value) => model.updateTodo(
                                      todo.copy(isCompleted: value ? 1 : 0)),*/
                                                  value:
                                                      false //todo.isCompleted == 1 ? true : false
                                                  ),
                                              trailing: IconButton(
                                                icon:
                                                    Icon(Icons.delete_outline),
                                                onPressed: () {
                                                  widget.todoModel!
                                                      .removeToDoPhrase(index);
                                                },
                                                //onPressed: () => model.removeTodo(todo),
                                              ),
                                              title: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return ShowTitleDialog(
                                                          model:
                                                              widget.todoModel!,
                                                          todo: todo,
                                                          index: index,
                                                        );
                                                      });
                                                },
                                                child: Text(
                                                  todo,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey,
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
                                        itemCount: widget.todoModel!
                                                .copyTodoPhrases.length +
                                            1,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: Builder(
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 40,
                          child: FloatingActionButton.extended(
                              heroTag: 'fab_new_card',
                              /*icon: Icon(
                              Icons.arrow_left_sharp,
                              color: Colors.white,
                            ),*/

                              backgroundColor: AppColors.kRipple, //taskColor,
                              label: Text('Tamam',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                if (check()) {
                                  Scaffold.of(context).hideCurrentSnackBar();

                                  showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          // title: Text('Öğünü kaldırmak mı istiyorsunuz ?'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: <Widget>[
                                                Text(error!),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Kapat',
                                                  style: TextStyle(
                                                      color: Colors.blue)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  widget.todoModel!.addTodoToTask(
                                      todom: widget.todom,
                                      taskId: widget.todom == null
                                          ? null
                                          : widget.todom!.id,
                                      periodName: periodName,
                                      day: widget.day
                                      /*periodPhrase:periodPhrase,periodTime:periodTime*/
                                      );
                                  widget.todoModel!.togglePlanUpdate = true;

                                  Navigator.pop(context);
                                }
                              } /*_enabled2 == false
                                ? null
                                : () {
                                    /*if (periodPhrase == null ||
                                  this.periodName == null) {
                                final snackBar = SnackBar(
                                  content: Text(
                                      'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                                  backgroundColor: taskColor,
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                                // _scaffoldKey.currentState.showSnackBar(snackBar);
                              } else {*/

                                    // öğün kalemi eklenmişmi kontrol et

                                    // ignore: curly_braces_in_flow_control_structures

                                    if (check()) {
                                      setState(() => _enabled2 = false);
                                      var snackBar = SnackBar(
                                        content: Text(error ?? ""),
                                        backgroundColor: taskColor,
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);

                                      Timer(
                                          Duration(seconds: 4),
                                          () =>
                                              setState(() => _enabled2 = true));
                                    } else {
                                      widget.todoModel!.addTodoToTask(
                                          todom: widget.todom,
                                          taskId: widget.todom == null
                                              ? null
                                              : widget.todom!.id,
                                          periodName: periodName,
                                          day: widget.day
                                          /*periodPhrase:periodPhrase,periodTime:periodTime*/
                                          );
                                      widget.todoModel!.togglePlanUpdate = true;

                                      Navigator.pop(context);
                                    }*/

                              ),
                        );
                      },
                    )))));
  }

  bool check() {
    bool alert = false;

    if ((time1D! > time2D!) && (widget.todoModel!.copyTodoPhrases.isEmpty)) {
      alert = true;
      error =
          "Öğün bitiş saati başlangıçtan sonra olmalı.\n Öğün içeriği dolu olmalıdır.";
    } else if (time1D! > time2D!) {
      error = 'Öğün bitiş saati başlangıçtan sonra olmalıdır.';
      alert = true;
    } else if (widget.todoModel!.copyTodoPhrases.isEmpty) {
      error = "Lütfen öğün içeriğini doldurunuz.";
      alert = true;
    }
    return alert;
  }
}

typedef void Callback();

class SimpleAlertDialog extends StatelessWidget {
  final Color? color;
  final Callback onActionPressed;

  const SimpleAlertDialog(
    this.onActionPressed, {
    @required this.color,
    // @required this.onActionPressed,
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
              title: Text('Öğünü kaldırmak mı istiyorsunuz ?',
                  style: TextStyle(color: AppColors.kFont)),
              content: SingleChildScrollView(
                child: ListBody(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    //  Text(                        'Öğünü kaldırdıktan sonra işlemi geri alamayacaksınız.'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child:
                      Text('Sil', style: TextStyle(color: AppColors.kRipple)),
                  onPressed: () {
                    Navigator.of(context).pop();

                    onActionPressed();
                  },
                ),
                FlatButton(
                  child: Text(
                    'Vazgeç',
                    style: TextStyle(color: Colors.blue),
                  ),
                  // textColor: Colors.grey,
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

class ShowTitleDialog extends StatefulWidget {
  final DietTaskViewModel? model;
  String? todo;
  int? index;
  ShowTitleDialog({this.model, this.todo, this.index});

  @override
  _ShowTitleDialogState createState() => _ShowTitleDialogState();
}

class _ShowTitleDialogState extends State<ShowTitleDialog> {
  TextEditingController? editingController;

  @override
  void initState() {
    editingController = TextEditingController(text: widget.todo);
    // TODO: implement initState
    widget.model!.newTodo = widget.todo;
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
      //title: Text("Başlık Giriniz",style: TextStyle(fontFamily: "Poppins",fontSize: 16)),
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
                  widget.model!.newTodo = text;
                  widget.model!.newTodo!.isNotEmpty
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
              });

              widget.model!.copyTodoPhrases[widget.index!] =
                  widget.model!.newTodo;
              editingController!.clear();
              widget.model!.refresh();
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            }
          },
        ),
        FlatButton(
          child: Text("Vazgeç",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: AppColors.kRipple,
              )),
          onPressed: () {
            editingController!.clear();
            Navigator.of(context).pop();
            setState(() {
              // widget.model.titleModified = null;
              widget.model!.showAlert = false;
            });

            // Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
