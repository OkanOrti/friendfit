// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as reorder;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/screens/addDetailScreen.dart';
import 'package:friendfit_ready/screens/addTaskScreen.dart';
import 'package:friendfit_ready/screens/formPage.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/test.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/date_time_picker_widget.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:friendfit_ready/data/image_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:transparent_image/transparent_image.dart';

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class CreatePlanPage extends StatefulWidget {
  CreatePlanPage({Key? key}) : super(key: key);
  DietTask? task;

  @override
  _CreateGamePageState createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreatePlanPage>
    with TickerProviderStateMixin {
  final DietTaskViewModel taskModel = serviceLocator<DietTaskViewModel>();
  //final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
  String? gameTitle;
  String? gamePhrase;
  File? _image;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  final now = DateTime.now();
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _phraseEditingController =
      TextEditingController();
  String postId = Uuid().generateV4();
  bool isUploading = false;
  AnimationController? _hideFabAnimController;
  AnimationController? lottieController;
  ChoiceImage selectedIconData =
      const ChoiceImage(id: '1', image: AssetImage('assets/images/diet.jpg'));
  final _formKey = GlobalKey<FormBuilderState>();
  bool _titleHasError = true;
  bool _descHasError = false;
  bool _dateRangeHasError = true;
  double selectedValue = 1;
  int newDayRank = 1;
  TextEditingController? controllerText;
  TextEditingController? controllerDescText;

  final ImagePicker _picker = ImagePicker();

  bool _enabled = true;
  bool toggleFuture = true;

  TabController? _controller2;
  DateTime? _selectedDay = DateTime.utc(2020, 11, 1);
  ScrollController _scrollController = ScrollController();

  List<Widget> list = [
    const Tab(
        icon: Icon(
      Icons.note,
      color: AppColors.kRipple,
    )),
    const Tab(
        icon: Icon(
      Icons.calendar_today_rounded,
      color: AppColors.kRipple,
    )),
  ];

  bool _show = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Future<Object>? future;

  String randomImageUrl = "";

  @override
  void initState() {
    future = taskModel.randomImage();
    gameTitle = '';
    gamePhrase = '';
    taskModel.isEdited = true;
    controllerText = TextEditingController(text: "");

    controllerDescText = TextEditingController(text: "");
    //controllerDescText?.text = widget.task!.desc ?? "";
    // randomImage().then((value) => null);
    _controller2 = TabController(length: list.length, vsync: this);
    _controller2!.addListener(() {
      FocusManager.instance.primaryFocus?.unfocus();
      taskModel.refresh();
    });
    lottieController = AnimationController(
      vsync: this,
    );
    taskModel.createTask();
    super.initState();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );
    lottieController!.addStatusListener((status) async {
      if (status == AnimationStatus.completed && isUploading == false) {
        setState(() {});
        // Navigator.pop(context);
        // lottieController!.stop();
        //lottieController!.reset();

        // widget.gameModel!.isLoadingLottie = false;
        // widget.gameModel!.refresh();
      } else if (status == AnimationStatus.completed && isUploading == true) {
        //  lottieController!.reset();
        lottieController!.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _phraseEditingController.dispose();
    _hideFabAnimController?.dispose();
    super.dispose();
  }

  CalendarFormat setCalendarFormat(int days) {
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
    return _calendarFormat;
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

  _imgFromCamera() async {
    taskModel.fromFitGallery = false;
    taskModel.fromRandFuture = false;
    taskModel.fromPhoneCamera = true;
    taskModel.fromPhoneGallery = false;

    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      taskModel.imageBeforeSave = image;
      randomImageUrl = "";
    }
  }

  _imgFromGallery() async {
    taskModel.fromFitGallery = false;
    taskModel.fromRandFuture = false;
    taskModel.fromPhoneCamera = false;
    taskModel.fromPhoneGallery = true;

    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      taskModel.imageBeforeSave = image;
      randomImageUrl = "";
    }
  }

  clearImage() {
    setState(() {
      _image = null;
    });
  }

  Future<String> uploadImage(imageFile) async {
    firebase_storage.UploadTask uploadTask;
    uploadTask = storageRef.child("post_$postId.jpg").putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(File(_image!.path).readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      _image = compressedImageFile;
    });
  }

  handleSubmit() async {
    /* setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(_image);

    setState(() {
      _image = null;
      isUploading = false;
      postId = Uuid().generateV4();
    });
    taskModel.imageUrl = mediaUrl;
    lottieController!.duration = const Duration(seconds: 3);
    lottieController!.forward(from: 0);
    debugPrint("hobba");
    await delay3Seconds();*/
    setState(() {
      isUploading = true;
      //successfull = false;
    });
    lottieController!.duration = const Duration(seconds: 3);
    lottieController!.forward(from: 0);

    await delay3Seconds();
  }

  convertToFile(String a) async {
    var rng = Random();
    var bytes = await rootBundle.load(a);
    String tempPath = (await getTemporaryDirectory()).path;
    XFile file = XFile(tempPath + (rng.nextInt(100)).toString() + '.png');
    await File(file.path).writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    setState(() {
      _image = File(file.path);
    });
  }

  Future<void> _showImageDialog() async {
    ScrollController sc = ScrollController(initialScrollOffset: 2.0);
    AlertDialog alert = AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        /* title: const Text(
        'Kapak resmi seçiniz.',
        style: TextStyle(fontSize: 18),
      ),*/
        /*  actions: <Widget>[
        TextButton(
          child: const Text(
            "Close",
            style: TextStyle(color: AppColors.kRipple),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            // setState(() {});
          },
        )
      ],*/
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400.0),
          child: FutureBuilder(
              future: Provider.of<DietGameViewModel>(context, listen: false)
                  .getDietCoverImages(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  // Uncompleted State
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    // Completed with error
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    return Scrollbar(
                      isAlwaysShown: true, //always show scrollbar
                      thickness: 5, //width of scrollbar
                      radius: Radius.circular(20), //corner radius of scrollbar
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: SingleChildScrollView(
                          controller: sc,
                          physics: const ScrollPhysics(),
                          child: SizedBox(
                            width: 300.0,
                            height: 400.0,
                            child: GridView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                var iconData = Provider.of<DietGameViewModel>(
                                        context,
                                        listen: false)
                                    .listUrls[index]; // widget.icons[index];
                                return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () async {
                                          //  setState(() async {
                                          // _image = iconData.image;

                                          //await convertToFile(iconData.path!);

                                          setState(() {
                                            taskModel.imageUrl = iconData;

                                            taskModel.imageBeforeSave = null;
                                            taskModel.fromFitGallery = true;
                                            taskModel.fromRandFuture = false;
                                            taskModel.fromPhoneCamera = false;
                                            taskModel.fromPhoneGallery = false;
                                          });

                                          Navigator.of(context).pop();
                                          // setState(() {});
                                          // });
                                        },
                                        //borderRadius: BorderRadius.circular(50.0),
                                        child: FadeInImage.memoryNetwork(
                                          fit: BoxFit.cover,
                                          image: iconData,
                                          placeholder: kTransparentImage,
                                        )

                                        /*Image(
                                          image: CachedNetworkImageProvider(
                                              iconData ?? ""),
                                          fit: BoxFit.cover),*/
                                        ));
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 0.9,
                              ),
                              itemCount: Provider.of<DietGameViewModel>(context,
                                      listen: false)
                                  .listUrls
                                  .length,
                            ),
                          )),
                    );
                }
              }),
        ));
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> randomImage() async {
    /*var length = choicesImages.length;
    Random random = Random();
    int randomNumber = random.nextInt(length);
    var iconData = choicesImages[randomNumber];
    var rng = Random();
    var bytes = await rootBundle.load(iconData.path!);
    String tempPath = (await getTemporaryDirectory()).path;
    XFile file = XFile(tempPath + (rng.nextInt(100)).toString() + '.png');

    await File(file.path).writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    _image = File(file.path);*/

    await taskModel.getDietCoverImages();
    var length = taskModel.listUrls.length;
    Random random = Random();
    int randomNumber = random.nextInt(length);

    randomImageUrl = taskModel.listUrls[randomNumber];

    taskModel.fromRandFuture = false;
    //taskModel.imageBeforeSave = file;

    return randomImageUrl;
  }

  Future<void> _confirmDialog() async {
    switch (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('True or false'),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          );
        })) {
      case true:
        print('Confirmed');
        break;

      case false:
        print('Canceled');
        break;

      default:
        print('Canceled');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: SizedBox(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('FriendFit Gallery'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        //_confirmDialog();
                        await _showImageDialog();
                        //FocusScope.of(context).unfocus();
                        //  Navigator.of(context).pop();
                      }),
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
    debugPrint("Okan");
    //_showImageDialog();
  }

  DraggingMode _draggingMode = DraggingMode.Android;

  void _showDayErrorDialog() {
    String titleError = "Lütfen kurallara uygun başlık giriniz.";
    String dayError = "Lütfen eksik günleri tamamlayınız";
    String titleDayError =
        "Lütfen kurallara uygun başlık giriniz ve takviminize gün girişi yapınız..";
    var errorDesc = "";

    if (taskModel.titleError! && taskModel.dayError!) {
      errorDesc = titleDayError;
    } else if (taskModel.titleError!) {
      errorDesc = titleError;
    } else if (taskModel.dayError!) {
      errorDesc = dayError;
    } else {
      errorDesc = "";
    }

    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.all(20),
        title: Text(
          'Uyarı',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Tamam",
              style: TextStyle(color: AppColors.kFont),
            ),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).pop();
            },
          )
        ],
        content: Text(errorDesc));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> delay3Seconds() async {
    await Future.delayed(Duration(seconds: 3));
  }

  void _showSaveSelectionDialog() {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(20),
      title: Text(
        'Bilgi',
        style: TextStyle(fontSize: 18),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Kaydet",
            style: TextStyle(color: AppColors.kRipple),
          ),
          onPressed: () {
            taskModel.modifyTaskNew(
                task: taskModel.createdTask,
                days: taskModel.createdTask!.days!);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
            child: Text(
              "Farklı Kaydet",
              style: TextStyle(color: AppColors.kRipple),
            ),
            onPressed: () {
              taskModel.addTaskNew_(task: taskModel.createdTask);
              Navigator.of(context).pop();
            })
      ],
      //content: Text("Lütfen eksik günleri tamamlayınız.")
    );
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

    setState(() {
      _hideFabAnimController!.forward();
      showFloationButton();

      _show = true;
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

    return taskModel.dayItems[date.day.toInt()] ?? [];
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
                      child:
                          Text("Sil", style: TextStyle(color: AppColors.kRed)),
                      onPressed: () {
                        taskModel.deleteDay(widget.task!, _selectedDay!);
                        Navigator.of(context).pop();
                      },
                    )
                  ]),
            ),
          );
        });
  }

  void _showCopyDayDialog() {
//check day availability

    int maxDay = taskModel.selectedValue!.toInt();

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
                  taskModel.copyDay(_selectedDay!, newDayRank);
                  Navigator.of(context).pop();
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

  void _showDayDialog() {
    var genderOptions = [];

    taskModel.dayItems.keys.forEach((element) {
      if (_selectedDay!.day != element) {
        genderOptions.add(element);
      }
      genderOptions.sort();
    });

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
                        hint: const Text('Sıra No'),
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
                child:
                    Text("Uygula", style: TextStyle(color: AppColors.kRipple)),
                onPressed: () {
                  taskModel.changeDayRank(_selectedDay!, newDayRank);
                  Navigator.of(context).pop();
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

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      // shouldFillViewport: true,
      // rowHeight: 100,
      daysOfWeekVisible: false,
      headerVisible: false,
      firstDay: DateTime.utc(2020, 11, 1),
      lastDay: DateTime.utc(
          2020,
          11,
          taskModel.isEdited
              ? taskModel.selectedValue!.toInt()
              : taskModel.returnDay(task: taskModel.createdTask)),
      eventLoader: _getEventsfromDay,

      locale: 'tr_TR',
      //calendarController: _calendarController,
      //events: this.model.dayItems, // _events,
      focusedDay: DateTime.utc(2020, 11, 1),

      //currentDay: DateTime.utc(2020, 11, 1),
      //holidays: _holidays,
      calendarFormat: setCalendarFormat(!taskModel.isEdited
          ? taskModel.createdTask!.days ?? 1
          : taskModel.selectedValue!.toInt()),

      //startingDayOfWeek: StartingDayOfWeek.sunday,
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
          debugPrint('${date.day}');
          return GestureDetector(
            onLongPress: () {
              taskModel.isEdited & taskModel.checkHavingEvent(date)
                  ? _showDayChoiceDialog(date)
                  : null;
            },
            child: Container(
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

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem =
        taskModel.dayItems[_selectedDay!.day.toInt()]![draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      taskModel.dayItems[_selectedDay!.day.toInt()]!.removeAt(draggingIndex);
      taskModel.dayItems[_selectedDay!.day.toInt()]!
          .insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = taskModel.items[_indexOfKey(item)];
    //debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return taskModel.dayItems[_selectedDay!.day.toInt()]!
        .indexWhere((ItemData d) => d.key == key);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(Localizations.localeOf(context).toString());

    setCalendarFormat(
      !taskModel.isEdited
          ? taskModel.createdTask!.days ?? 1
          : taskModel.selectedValue!.toInt(),
    );

    return ChangeNotifierProvider<DietTaskViewModel>(
      create: (context) => taskModel,
      child: Consumer<DietTaskViewModel>(
          builder: (context, model, child) => Stack(children: [
                Scaffold(
                  appBar: AppBar(
                    bottom: TabBar(
                      onTap: (index) {
                        //
                        // Should not used it as it only called when tab options are clicked,
                        // not when user swapped
                      },
                      controller: _controller2,
                      tabs: list,
                    ),
                    title: const Text(
                      'Yeni Plan',
                      style: TextStyle(color: AppColors.kFont),
                    ),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        // color: kIconColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        //  taskModel.refresh();
                      },
                    ),
                    actions: [
                      taskModel.isEdited
                          ? IconButton(
                              // iconSize: 20,
                              icon: Icon(
                                Icons.undo,
                                color: AppColors.kFont,
                              ),
                              onPressed: () {
                                taskModel.isSaved = false;
                                taskModel.isEdited = false;
                                controllerText!.text = "";
                                controllerDescText!.text = "";
                                taskModel.todos2 = [];
                                taskModel.items = [];
                                taskModel.dayItems = {};
                                taskModel.selectedValue = 1.0;
                                taskModel.createdTask!.days = 1;
                                taskModel.createdTask!.title = null;
                                taskModel.createdTask!.desc = null;

                                /* if (taskModel.copiedTask != null) {
                                  controllerText!.text =
                                      taskModel.copiedTask!.title ?? "";
                                  taskModel.selectedValue =
                                      taskModel.copiedTask!.days!.toDouble();
                                }*/

                                //    taskModel.copyDayItems(taskModel.dayItemsCopied);
                                taskModel.fromFitGallery = false;
                                taskModel.fromRandFuture = true;
                                taskModel.fromPhoneCamera = false;
                                taskModel.fromPhoneGallery = false;

                                //taskModel.dayItemsCopied = taskModel.dayItems;
                                taskModel.refresh();
                              },
                            )
                          : SizedBox(),

                      /*IconButton(
                                tooltip: "Değiştir ",
                                icon: Icon(
                                  Icons.undo,
                                  size: 20,
                                ),
                                color: AppColors.kFont,
                                onPressed: () {
                                  //taskModel.isSaved = false;
                                  taskModel.refresh();
                                }),*/
                      taskModel.isEdited
                          ? IconButton(
                              iconSize: 20,
                              tooltip: "Kaydet",
                              icon: Icon(Icons.save_rounded),
                              color: AppColors.kFont,
                              onPressed: () async {
                                /*  taskModel.isEdited = false;
                                      taskModel.isSaved = true;*/

                                //  widget.task!.title = controllerText!.text;

                                if (!taskModel.checkSaveCondition(taskModel,
                                    taskModel.selectedValue!.toInt())) {
                                  taskModel.isEdited = false;
                                  taskModel.isSaved = true;

                                  taskModel.createdTask!.days =
                                      taskModel.selectedValue!.toInt();
                                  taskModel.checkSliderDay();
                                  taskModel.addTaskNew(
                                      task: taskModel.createdTask);

                                  //taskModel.modifyPlan(widget.task);
                                  // taskModel.refresh();
                                  await handleSubmit();
                                  isUploading = false;
                                  Navigator.of(context).pop();

                                  /*taskModel.createdTaskId == null
                                            ? taskModel.addTask(
                                                newTask!,
                                                currentUser!.id!,
                                                iconsList!,
                                                selectedIconData.id!)
                                            : taskModel.modifyTask(
                                                newTask!,
                                                currentUser!.id!,
                                                selectedIconData.id!);*/
                                  //_showSaveSelectionDialog();
                                } else {
                                  _showDayErrorDialog();
                                }
                              },
                            )
                          : IconButton(
                              iconSize: 20,
                              tooltip: "Değiştir ",
                              icon: Icon(
                                Icons.edit_rounded,
                              ),
                              color: AppColors.kFont,
                              onPressed: () {
                                taskModel.isSaved = false;
                                taskModel.isEdited = true;
                                taskModel.copyNewTask();
                                // taskModel.copyDayItemsCopied(taskModel.dayItems);
                                // taskModel.copiedTaskLength = widget.task!.days;

                                taskModel.refresh();
                              }),
                      !taskModel.isEdited
                          ? SimpleAlertDialog(
                              () {},
                              color: AppColors.kFont,
                              //onActionPressed:(){}
                              //null // () => taskModel.removeToDo(taskModel.taskId, todoId),
                            )
                          : Container(),
                    ],
                    centerTitle: true,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: AppColors.kFont),
                    brightness: Brightness.light,
                    backgroundColor: Colors.white,
                  ),
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  body: TabBarView(controller: _controller2, children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 4,
                                    child: SingleChildScrollView(
                                      child: SizedBox(
                                        // color: Colors.yellow,
                                        child: Column(children: [
                                          const SizedBox(height: 10),
                                          Container(
                                              decoration: const BoxDecoration(
                                                  // color: AppColors.kRipple.withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 10),
                                                child: Center(
                                                  child: FormBuilderTextField(
                                                    controller: controllerText,
                                                    enabled: taskModel.isEdited
                                                        ? true
                                                        : false,
                                                    maxLines: 2,
                                                    minLines: 1,
                                                    autovalidateMode:
                                                        AutovalidateMode.always,
                                                    name: 'title',
                                                    decoration: InputDecoration(
                                                      //  errorText: "Lütfen başlık giriniz.",
                                                      labelText: 'Başlık',
                                                      suffixIcon: taskModel
                                                              .isEdited
                                                          ? (_titleHasError
                                                              ? const Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red)
                                                              : const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green))
                                                          : null,
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _titleHasError = !(_formKey
                                                                .currentState
                                                                ?.fields[
                                                                    'title']
                                                                ?.validate() ??
                                                            false);
                                                      });
                                                      taskModel.planTitle =
                                                          val!;
                                                      taskModel.createdTask!
                                                          .title = val;
                                                    },
                                                    //valueTransformer: (text) => num.tryParse(text),
                                                    validator:
                                                        FormBuilderValidators
                                                            .compose([
                                                      FormBuilderValidators
                                                          .required(context,
                                                              errorText:
                                                                  "Lütfen başlık giriniz."),
                                                      // FormBuilderValidators.numeric(context),
                                                      FormBuilderValidators
                                                          .maxLength(
                                                              context, 50,
                                                              errorText:
                                                                  "En fazla 50 karakter girebilirsiniz."),
                                                      FormBuilderValidators
                                                          .minLength(context, 3,
                                                              errorText:
                                                                  "En az 3 karakter girmelisiniz.")
                                                    ]),
                                                    // initialValue: '12',
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                  ), /*TextField(
                                          textAlign: TextAlign.center,
                                          controller: _titleEditingController,
                                          //textAlign: TextAlign.center,
                                          onChanged: (text) {
                                            setState(() {
                                              this.taskModel.gameTitle = text;
                                            });
                                          },
                                          minLines: 1,
                                          maxLines: 2,
                                          cursorColor: Colors.black, //taskColor,
                                          autofocus: false,
                                          maxLength: 50, //true,
                                          decoration: InputDecoration(
                                              counterStyle: TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              hintText: 'Başlık giriniz',
                                              hintStyle: TextStyle(
                                                  color: Colors.black26,
                                                  fontFamily: "Poppins",
                                                  fontSize: 16)),
                                          style: TextStyle(
                                              color: AppColors.kFont,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 26.0),
                                        )
                                        */
                                                ),
                                              )),
                                          const SizedBox(height: 20),
                                          Container(
                                              decoration: const BoxDecoration(
                                                  //  color: AppColors.kRipple.withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 10),

                                                  //color: Colors.green,
                                                  child: FormBuilderTextField(
                                                    maxLines: 2,
                                                    minLines: 1,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    name: 'desc',
                                                    controller:
                                                        controllerDescText,
                                                    enabled: taskModel.isEdited
                                                        ? true
                                                        : false,
                                                    decoration: InputDecoration(
                                                      //  errorText: "Lütfen başlık giriniz.",
                                                      labelText: 'Açıklama',
                                                      //hintText: "Aç",
                                                      suffixIcon: taskModel
                                                              .isEdited
                                                          ? (_descHasError
                                                              ? const Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red)
                                                              : null)
                                                          : null,
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _descHasError = !(_formKey
                                                                .currentState
                                                                ?.fields['desc']
                                                                ?.validate() ??
                                                            false);
                                                      });
                                                      taskModel.desc = val;
                                                      taskModel.createdTask!
                                                          .desc = val;
                                                    },
                                                    //valueTransformer: (text) => num.tryParse(text),
                                                    validator:
                                                        FormBuilderValidators
                                                            .compose([
                                                      /* FormBuilderValidators.required(context,
                                                errorText:
                                                    "İsterseniz açıklama girebilirsiniz."),*/
                                                      // FormBuilderValidators.numeric(context),
                                                      FormBuilderValidators
                                                          .maxLength(
                                                              context, 100,
                                                              errorText:
                                                                  "En fazla 100 karakter girebilirsiniz.")
                                                    ]),
                                                    // initialValue: '12',
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                  ))),
                                          const SizedBox(height: 30),
                                          const SizedBox(height: 30),
                                          const SizedBox(height: 20),
                                          /*GestureDetector(
                                              onTap: () {
                                                FocusManager.instance.primaryFocus
                                                    ?.unfocus();
                                                /*   FocusScopeNode currentFocus =
                                        FocusScope.of(context);
              
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }*/
                                                taskModel.isEdited
                                                    ? _showPicker(context)
                                                    : null;
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 170,
                                                    height: 170,
                                                    decoration: BoxDecoration(
                                                        color: AppColors.kRipple
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(20),
                                                        )),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      child: taskModel
                                                              .fromFitGallery
                                                          ? FadeInImage
                                                              .memoryNetwork(
                                                              fit: BoxFit.cover,
                                                              image: taskModel
                                                                  .imageUrl,
                                                              placeholder:
                                                                  kTransparentImage,
                                                            )
                                                          : taskModel.fromFile
                                                              ? Image.file(
                                                                  File(_image!
                                                                      .path),
                                                                  //width: 300,
                                                                  //height: 200,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : FadeInImage
                                                                  .memoryNetwork(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: widget
                                                                      .task!
                                                                      .backgroundId!,
                                                                  placeholder:
                                                                      kTransparentImage,
                                                                  imageErrorBuilder: (context,
                                                                          error,
                                                                          stackTrace) =>
                                                                      Container(
                                                                          color: AppColors
                                                                              .kRipple
                                                                              .withOpacity(0.3)),
                                                                ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    child: Icon(Icons.camera_alt,
                                                        size: 35,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )),*/

                                          GestureDetector(
                                              onTap: () {
                                                if (taskModel.isEdited) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();

                                                  _showPicker(context);
                                                }
                                              },
                                              child: taskModel.imageWidget(
                                                  future: future, image: _image)

                                              /* if (taskModel.fromRandFuture)
                                                      {FutureBuilder<Object>(
                                                          future: future,
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      dynamic>
                                                                  snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                              // If we got an error
                                                              if (snapshot
                                                                  .hasError) {
                                                                return Center(
                                                                  child: Text(
                                                                    '${snapshot.error} occurred',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                );

                                                                // if we got our data
                                                              } else if (snapshot
                                                                  .hasData) {
                                                                return Stack(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          170,
                                                                      height:
                                                                          170,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors.kRipple.withOpacity(0.3),
                                                                          borderRadius: const BorderRadius.all(
                                                                            Radius.circular(20),
                                                                          )),
                                                                      child: ClipRRect(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                                          child: FadeInImage.memoryNetwork(
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            image:
                                                                                snapshot.data,
                                                                            placeholder:
                                                                                kTransparentImage,
                                                                          )),
                                                                    ),
                                                                    const Positioned(
                                                                      right: 0,
                                                                      top: 0,
                                                                      left: 0,
                                                                      bottom: 0,
                                                                      child: Icon(
                                                                          Icons
                                                                              .camera_alt,
                                                                          size:
                                                                              35,
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  ],
                                                                );
                                                              }
                                                            }
                                                            return Center(
                                                                child: SpinKitThreeBounce(
                                                                    color: AppColors
                                                                        .kRipple,
                                                                    size: 20));
                                                          })}

                                                      else if Stack(
                                                          children: [
                                                            Container(
                                                              width: 170,
                                                              height: 170,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: AppColors
                                                                          .kRipple
                                                                          .withOpacity(
                                                                              0.3),
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            20),
                                                                      )),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20)),
                                                                child: !taskModel
                                                                        .fromFitGallery
                                                                    ? Image
                                                                        .file(
                                                                        File(_image!
                                                                            .path),
                                                                        //width: 300,
                                                                        //height: 200,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : FadeInImage
                                                                        .memoryNetwork(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: taskModel
                                                                            .imageUrl,
                                                                        placeholder:
                                                                            kTransparentImage,
                                                                        imageErrorBuilder: (context,
                                                                                error,
                                                                                stackTrace) =>
                                                                            Container(color: Colors.grey.withOpacity(0.2)),
                                                                      ),
                                                              ),
                                                            ),
                                                            const Positioned(
                                                              right: 0,
                                                              top: 0,
                                                              left: 0,
                                                              bottom: 0,
                                                              child: Icon(
                                                                  Icons
                                                                      .camera_alt,
                                                                  size: 35,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
                                                        )*/

                                              ),
                                        ]),
                                      ),
                                    )),
                                //SizedBox(height:100)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    (SafeArea(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Divider(height: 1),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                      !taskModel.isEdited
                                          ? "Gün Sayısı: ${taskModel.returnDay()}"
                                          : "Gün Sayısı: ${taskModel.selectedValue?.toInt()}",
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    width: 200,
                                    child: SliderTheme(
                                      data: SliderThemeData(),
                                      child: CupertinoSlider(
                                        value: !taskModel.isEdited
                                            ? taskModel.createdTask!.days!
                                                .toDouble()
                                            : taskModel.selectedValue!,
                                        min: 1,
                                        max: 30,
                                        divisions: 29,
                                        activeColor: AppColors.kRipple,
                                        onChanged: taskModel.isEdited
                                            ? (value) {
                                                //if (taskModel.isEdited) {
                                                taskModel.selectedValue = value;
                                                /*taskModel.createdTask!.days =
                                                    value.toInt();*/
                                                //}

                                                setState(() {});
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1),
                            SizedBox(height: 30),
                            Text("Günler",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: AppColors.kRipple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 10),
                            Divider(height: 1),
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
                                  child: !taskModel.isEdited
                                      ? CustomScrollView(
                                          shrinkWrap: true,
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
                                                      return ItemStatic(
                                                        data: taskModel
                                                                    .dayItems[
                                                                _selectedDay!
                                                                    .day
                                                                    .toInt()]![
                                                            index],
                                                        // first and last attributes affect border drawn during dragging
                                                        isFirst: index == 0,
                                                        isLast: index ==
                                                            taskModel
                                                                    .dayItems[
                                                                        _selectedDay!
                                                                            .day
                                                                            .toInt()]!
                                                                    .length -
                                                                1,
                                                        //draggingMode: _draggingMode,
                                                      );
                                                    },
                                                    childCount: taskModel
                                                                    .dayItems[
                                                                _selectedDay!
                                                                    .day
                                                                    .toInt()] ==
                                                            null
                                                        ? 0
                                                        : taskModel
                                                            .dayItems[
                                                                _selectedDay!
                                                                    .day
                                                                    .toInt()]!
                                                            .length,
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
                                                            key: UniqueKey(),
                                                            model: taskModel,
                                                            data: taskModel
                                                                        .dayItems[
                                                                    _selectedDay!
                                                                        .day
                                                                        .toInt()]![
                                                                index],
                                                            // first and last attributes affect border drawn during dragging
                                                            isFirst: index == 0,
                                                            isLast: index ==
                                                                taskModel
                                                                        .dayItems[_selectedDay!
                                                                            .day
                                                                            .toInt()]!
                                                                        .length -
                                                                    1,
                                                            draggingMode:
                                                                _draggingMode,
                                                            day: _selectedDay!
                                                                .day
                                                                .toInt());
                                                      },
                                                      childCount: taskModel
                                                                      .dayItems[
                                                                  _selectedDay!
                                                                      .day
                                                                      .toInt()] ==
                                                              null
                                                          ? 0
                                                          : taskModel
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
                    ))
                  ]),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterFloat,
                  floatingActionButton: Visibility(
                    visible: (_controller2!.index == 1 && taskModel.isEdited)
                        ? true
                        : false,
                    child: FadeTransition(
                      opacity: _hideFabAnimController!,
                      child: ScaleTransition(
                        scale: _hideFabAnimController!,
                        child: FloatingActionButton.extended(
                            heroTag: 'fab_new_task',
                            onPressed: () async {
                              if (!taskModel.isSaved) {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddTaskScreen(
                                      todoModel: taskModel,
                                      day: _selectedDay!.day.toInt(),
                                    ),
                                  ),
                                );
                              }
                            },
                            tooltip: '',
                            backgroundColor: AppColors.kRipple,
                            //!model.isSaved ? AppColors.kRipple : Colors.grey,
                            foregroundColor: Colors.white,
                            label: Text("Öğün ekle")

                            // icon: Icon(Icons.add),
                            ),
                      ),
                    ),
                  ),
                ),
                Center(
                    child: isUploading
                        ? Loader(
                            child: Lottie.asset("assets/lottie/successful.json",
                                repeat: false,
                                controller:
                                    lottieController)) /*Lottie.asset(
                            "assets/lottie/bouncing-fruits.json",
                            width: 300,
                            height: 300,*/

                        : const SizedBox())
              ])),
    );
  }

  String? Function(double? value)? slideCheck<T>(
    BuildContext context,
    num min, {
    bool inclusive = true,
    String? errorText,
  }) {
    return (double? valueCandidate) {
      var valueCandidate_ = valueCandidate;
      if (valueCandidate_ != null) {
        errorText =
            valueCandidate_ < min ? "En az 1 günlük süre seçiniz" : null;
      } else {
        return "En az 1 günlük süre seçiniz.";
      }
    };
  }

  String? Function(DateTimeRange? value) rangeCheck<T>(
      BuildContext context, num max,
      {bool inclusive = true, String? errorText, String? blabala}) {
    return (DateTimeRange? valueCandidate) {
      var valueCandidate_ = valueCandidate?.duration.inDays;
      if (valueCandidate_ != null) {
        _dateRangeHasError = false;
        assert(valueCandidate_ is num || valueCandidate_ is String);
        final number = valueCandidate_ is num
            ? valueCandidate_
            : num.tryParse(valueCandidate_.toString());

        if (number != null && (inclusive ? number > max : number >= max)) {
          _dateRangeHasError = true;
          return errorText ?? "Süresi 1 aydan fazla oyun oluşturamazsınız."
              //FormBuilderLocalizations.of(context).minErrorText(min)

              ;
        } else {
          taskModel.startTime = TimeOfDay.fromDateTime(valueCandidate!.start);
          taskModel.endTime = TimeOfDay.fromDateTime(valueCandidate.end);
        }
      } else if (valueCandidate_ == null) {
        _dateRangeHasError = true;
        return errorText ?? "En az bir günlük süre aralığı giriniz."
            //FormBuilderLocalizations.of(context).minErrorText(min)

            ;
      } else {
        _dateRangeHasError = false;

        return null;
      }
    };
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
      iconSize: 20,
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
                  children: const <Widget>[
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
