// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/gradient_background.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/utils/color_utils.dart';
import 'package:friendfit_ready/widgets/date_time_picker_widget.dart';
import 'package:friendfit_ready/widgets/dropdown.dart';
import '../constants.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/widgets/time_picker_widget.dart';
import 'dart:async';

class AddTaskScreenForGame extends StatefulWidget {
  final DietTaskViewModel? todoModel;
  final DietToDos? todom;
  AddTaskScreenForGame({this.todoModel, this.todom});

  @override
  State<StatefulWidget> createState() {
    return _AddTaskScreenForGameState();
  }
}

class _AddTaskScreenForGameState extends State<AddTaskScreenForGame> {
  String? periodPhrase;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color? taskColor;
  IconData? taskIcon;
  String? periodName = '';
  List<String> phrases = [];
  DateTime periodTime = DateTime.now();
  final now = new DateTime.now();
  TextEditingController? _editingController;
  String? dropdownInitialValue;
  TextEditingController? _editingControllerTitle;
  ScrollController? _scrollerController;
  bool _enabled = true;
  double? time2D;

  double? time1D;
  TimeOfDay? time1;
  TimeOfDay? time2;

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  void initState() {
    Map reverse_PeriodNames = {
      'Sabah': '1',
      'Öğlen': '2',
      'Akşam': '3',
      'Ara Öğün': '4',
      'Gece': '5'
    };
    time1 = widget.todom == null
        ? TimeOfDay(hour: 7, minute: 30)
        : TimeOfDay.fromDateTime(widget.todom!.startDate!.toDate());
    time1D = toDouble(time1!);

    time2 = widget.todom == null
        ? TimeOfDay(hour: 8, minute: 30) //null
        : TimeOfDay.fromDateTime(widget.todom!.endDate!.toDate());
    time2D = toDouble(time2!);
    super.initState();
    _editingController = TextEditingController(
        text: widget.todom == null ? '' : widget.todom!.phrase);
    _scrollerController = ScrollController(initialScrollOffset: 0.0);
    // ScrollController _scrollerController=ScrollController();
    _editingControllerTitle = TextEditingController(text: "");
    taskColor = ColorUtils.defaultColors[0];
    dropdownInitialValue =
        widget.todom == null ? null : reverse_PeriodNames[widget.todom!.title];
    // periodPhrase=widget.todom == null ?null:widget.todom.phrase;
    periodName = widget.todom == null ? "Sabah" : widget.todom!.title;
    // phrases =widget.todom==null?null:widget.todom.phrases;
    widget.todoModel!.copyTodoPhrases =
        widget.todom == null ? [] : List.from(widget.todom!.phrases!);
    /*  setState(() {
      periodPhrase = widget.todom == null ?'':widget.todom.phrase;
      taskColor = ColorUtils.defaultColors[0];
      
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollerController!.dispose();
    _editingController!.dispose();
    _editingControllerTitle!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map periodNames = {
      '1': 'Sabah',
      '2': 'Öğlen',
      '3': 'Akşam',
      '4': "Ara Öğün",
      '5': 'Gece'
    };

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
                      title: const Text(
                        'Yeni Beslenme Menüsü',
                        style: TextStyle(color: AppColors.kFont),
                      ),
                      leading: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: kIconColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        SimpleAlertDialog(
                          () {
                            widget.todoModel
                                ?.removeToDoFromGame(widget.todom!.id!);
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
                      constraints: const BoxConstraints.expand(),
                      padding: const EdgeInsets.symmetric(
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

                          //widget.todom!=null? Text(periodName,style: TextStyle(color: AppColors.kFont, fontFamily: "Poppins",fontSize: 16)):
                          DropDownButton((value) {
                            this.periodName = periodNames[value];
                            setState(() {
                              dropdownInitialValue = value;
                            });

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

                          const SizedBox(height: 10),
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
                                const SizedBox(width: 5),
                                const Text(
                                  "-",
                                  style: TextStyle(
                                      color: AppColors.kFont, fontSize: 16),
                                ),
                                const SizedBox(width: 5),
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
                                            this.periodName == null) {
                                          setState(() => _enabled = false);
                                          final snackBar = SnackBar(
                                            content: Text(
                                                'Üzgünüm, eklemeniz için periyod adı, saat aralığı ve içerik alanlarını doldurmalısınız.'),
                                            backgroundColor: taskColor,
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);

                                          Timer(
                                              Duration(seconds: 4),
                                              () => setState(
                                                  () => _enabled = true));
                                          // _scaffoldKey.currentState.showSnackBar(snackBar);

                                        } else {
                                          _editingController!.clear();

                                          FocusScope.of(context).unfocus();
                                          widget.todoModel!.addToDoPhrase(
                                              phrase: this.periodPhrase);

                                          this.periodPhrase = null;
                                        }
                                      },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(4.0)));
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
                                                  style: const TextStyle(
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
                        return FloatingActionButton.extended(
                          heroTag: 'fab_new_card',
                          icon: const Icon(
                            Icons.arrow_left_sharp,
                            color: Colors.white,
                          ),
                          backgroundColor: AppColors.kRipple, //taskColor,
                          label: widget.todoModel!.copyTodoPhrases.isNotEmpty
                              ? const Text(
                                  'Listene ekle',
                                  style: TextStyle(color: Colors.white),
                                )
                              : const Text('Geri',
                                  style: TextStyle(color: Colors.white)),
                          onPressed: () {
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
                            widget.todoModel!.copyTodoPhrases.isNotEmpty
                                ? widget.todoModel!.addTodoToTaskForGame(
                                    todom: widget.todom,
                                    taskId: widget.todom == null
                                        ? null
                                        : widget.todom!.id,
                                    periodName: periodName,
                                    /*periodPhrase:periodPhrase,periodTime:periodTime*/
                                  )
                                : null;
                            Navigator.pop(context);
                          },
                        );
                      },
                    )))));
  }
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
              title: Text('Öğünü kaldırmak mı istiyorsunuz ?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                        'Öğünü kaldırdıktan sonra işlemi geri alamayacaksınız.'),
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
                  child: Text('Vazgeç',
                      style: TextStyle(color: AppColors.kRipple)),
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
    editingController = new TextEditingController(text: widget.todo);
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

              widget.model!.todoPhrases[widget.index!] = widget.model!.newTodo;
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
