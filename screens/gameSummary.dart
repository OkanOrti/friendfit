// ignore_for_file: file_names, unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:friendfit_ready/screens/gameTiles.dart';
import 'package:friendfit_ready/screens/participants.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import '../size_config.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:friendfit_ready/data/hero_id_model.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/diets_page_selection.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/screens/friends.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/screens/timeline.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:friendfit_ready/screens/addTaskScreen.dart';
import 'package:friendfit_ready/screens/addTaskScreenForGame.dart';
import 'package:friendfit_ready/widgets/my_friends.dart';
import 'package:flutter/rendering.dart';
import 'package:friendfit_ready/screens/custom_expansion_tile.dart' as custom;
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:friendfit_ready/screens/custom_expansion_tile.dart' as custom;
import 'package:friendfit_ready/screens/detail_screen.dart' as detail;
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class GameSummaryBeforeSending extends StatefulWidget {
  final DietGameViewModel? gameModel;
  final DietTaskViewModel? taskModel;
  final String? taskId;
  final HeroId? heroIds;
  final DietTask? task;
  final DietToDos? todo;
  const GameSummaryBeforeSending(
      {Key? key,
      this.taskId,
      this.heroIds,
      this.task,
      this.todo,
      this.gameModel,
      this.taskModel})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _GameSummaryBeforeSendingState();
  }
}

class _GameSummaryBeforeSendingState extends State<GameSummaryBeforeSending>
    with TickerProviderStateMixin {
  // final DietTaskViewModel taskmodel = serviceLocator<DietTaskViewModel>();
  //CalendarController _calendarController = new CalendarController();
  final DateFormat dateFormat = DateFormat('yyyy/MM/dd');
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
  GlobalKey<State> _dialogKey = GlobalKey<State>();

  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;
  bool successfull = false;
  String postId = Uuid().generateV4();
  ChoiceImage selectedIconData = ChoiceImage(id: '1', image: null);
  final _formKey = GlobalKey<FormBuilderState>();
  bool _titleHasError = true;

  int? indexCount;
  //DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  TextEditingController? _editingController;
  final ScrollController _scrollController =
      ScrollController(); // set controller on scrolling
  bool _show = true;
  bool _enabled = true;
  AnimationController? _hideFabAnimController;
  XFile? _image;
  File? compressedImageFile;
  bool? _switchValue = false;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Map dailyPlanTask = {};
  Map dailyPlanTodos = {};
  AnimationController? lottieController;
  @override
  void initState() {
    lottieController = AnimationController(
      vsync: this,
    );
    _selectedDay = DateTime.now();

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

  _imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (image != null) {
      setState(() {
        _image = image;
      });
      widget.gameModel!.imageBeforeSave = image;
    }
  }

  _imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      setState(() {
        _image = image;
      });

      widget.gameModel!.imageBeforeSave = image;
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
    var file = File(widget.gameModel!.imageBeforeSave!.path);
    Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());
    compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
  }

  handleSubmit() async {
    lottieController!.duration = const Duration(seconds: 2);
    lottieController!.forward(from: 0);

    setState(() {
      isUploading = true;
      //successfull = false;
    });

    if (!widget.gameModel!.fromFitGallery) {
      await compressImage();
      postId = Uuid().generateV4();
      String mediaUrl = await uploadImage(compressedImageFile);
      if (mediaUrl.isNotEmpty) widget.gameModel!.imageUrl = mediaUrl;
    }

    /*setState(() {
      _image = null;
      isUploading = false;

    });*/

    /*Future.delayed(
        const Duration(seconds: 3),
        () => setState(() {
              successfull = false;
            }));*/
    // Future.delayed(const Duration(seconds: 5), () => successfull = false);
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
              future: widget.gameModel!.getDietCoverImages(),
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

                    return SingleChildScrollView(
                        controller: sc,
                        physics: const ScrollPhysics(),
                        child: SizedBox(
                          width: 300.0,
                          height: 400.0,
                          child: GridView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              var iconData = widget.gameModel!
                                  .listUrls[index]; // widget.icons[index];
                              return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      //  setState(() async {
                                      // _image = iconData.image;

                                      //await convertToFile(iconData.path!);

                                      setState(() {
                                        widget.gameModel!.imageUrl = iconData;
                                        widget.gameModel!.fromFitGallery = true;
                                      });

                                      Navigator.of(context).pop();
                                      // setState(() {});
                                      // });
                                    },
                                    //borderRadius: BorderRadius.circular(50.0),
                                    child: Image(
                                        image: CachedNetworkImageProvider(
                                            iconData ?? ""),
                                        fit: BoxFit.cover),
                                  ));
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: widget.gameModel!.listUrls.length,
                          ),
                        ));
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('FriendFit Gallery'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      //_confirmDialog();
                      await _showImageDialog();
                      //  Navigator.of(context).pop();
                    }),
                new ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
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

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      /* avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase(),style: TextStyle(color:Colors.grey),),
      ),*/
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  chipList() {
    List<Widget> chipList2 = [];
    List<Color> colors = [
      Color(0xFFff6666),
      Color(0xFF007f5c),
      Color(0xFF5f65d3),
      Color(0xFF19ca21),
      Color(0xFF60230b),
      AppColors.kRipple,
      Colors.lightBlue,
      Colors.purple
    ];
    widget.gameModel!.trackKPI_Names.asMap().forEach((i, value) {
      chipList2.add(_buildChip(value, colors[i]));
    });
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chipList2,
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
    );
  }
  /*return Wrap(
    spacing: 6.0,
    runSpacing: 6.0,
    children: <Widget>[
      _buildChip(element, Color(0xFFff6666)),
     /* _buildChip('Hacker', Color(0xFF007f5c)),
      _buildChip('Developer', Color(0xFF5f65d3)),
      _buildChip('Racer', Color(0xFF19ca21)),
      _buildChip('Traveller', Color(0xFF60230b)),*/
    ],
  );*/

  convertToFile(XFile file) async {
    var rng = Random();
    var bytes = await rootBundle.load(file.path.toString());
    String tempPath = (await getTemporaryDirectory()).path;
    XFile file2 = XFile(tempPath + (rng.nextInt(100)).toString() + '.png');
    var compressedFile = await File(file2.path).writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  }

  static Future showLoadingDialog(BuildContext context, GlobalKey _key) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            key: _key,
            children: <Widget>[
              Center(
                  child: Container(
                child: Row(children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Text("Please Wait!"),
                ]),
              ))
            ],
          );
        });
  }

  Future<void> _showDayProtectDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bilgi"),
            content: Text(
                "Gün koruması açık tutulduğunda yarışmacılar skorlarını sadece bulunduğu gün için gönderebilir."),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    "Tamam",
                    style: TextStyle(color: AppColors.kRipple),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        //create: (context)=> widget.gameModel,
        value: widget.gameModel,
        child: Stack(children: [
          Scaffold(
              key: scaffoldKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: AppColors.kFont,
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
              body: Stack(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: getProportionateScreenWidth(170),
                              decoration: BoxDecoration(
                                  boxShadow: [kDefualtShadow2, kDefualtShadow3],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => _showPicker(context),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      child: Container(
                                          width:
                                              getProportionateScreenWidth(180),
                                          height:
                                              getProportionateScreenHeight(120),
                                          /*decoration: BoxDecoration(
                                            //border: Border.all(color: isSelected ? Colors.green:Colors.transparent) ,
                                            //color: Colors.green,

                                            image: !widget
                                                    .gameModel!.fromFitGallery
                                                ? DecorationImage(
                                                    image: FileImage(File(
                                                        (widget
                                                            .gameModel!
                                                            .imageBeforeSave!
                                                            .path))),
                                                    fit: BoxFit.cover)
                                                : null),*/
                                          child: widget
                                                  .gameModel!.fromFitGallery
                                              ? ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20)),
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                    fit: BoxFit.cover,
                                                    image: widget
                                                        .gameModel!.imageUrl,
                                                    placeholder:
                                                        kTransparentImage,
                                                  ),
                                                )
                                              : null),
                                    ),
                                  ),
                                  Container(
                                    width: getProportionateScreenWidth(170),
                                    padding: EdgeInsets.all(
                                      getProportionateScreenWidth(
                                          kDefaultPadding),
                                    ),
                                    decoration: const BoxDecoration(
                                      // border: Border.all(color: isSelected ? Colors.green:Colors.transparent),
                                      color: Colors.white,

                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.gameModel!.gameTitle,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          /*FormBuilder(
                          child: Container(
                              decoration: const BoxDecoration(
                                  // color: AppColors.kRipple.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Center(
                                    child: FormBuilderTextField(
                                  maxLines: 2,
                                  minLines: 1,
                                  autovalidateMode: AutovalidateMode.always,
                                  name: 'title',
                                  decoration: InputDecoration(
                                    //  errorText: "Lütfen başlık giriniz.",
                                    labelText: 'Başlık',
                                    suffixIcon: _titleHasError
                                        ? const Icon(Icons.error,
                                            color: Colors.red)
                                        : const Icon(Icons.check,
                                            color: Colors.green),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _titleHasError = !(_formKey
                                              .currentState?.fields['title']
                                              ?.validate() ??
                                          false);
                                    });
                                    widget.taskModel!.dietPlanTitle = val!;
                                  },
                                  //valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context,
                                        errorText:
                                            "Diet Planınıza bir isim veriniz."),
                                    // FormBuilderValidators.numeric(context),
                                    FormBuilderValidators.maxLength(context, 50,
                                        errorText:
                                            "En fazla 50 karakter girebilirsiniz."),
                                    FormBuilderValidators.minLength(context, 3,
                                        errorText:
                                            "En az 3 karakter girmelisiniz.")
                                  ]),
                                  // initialValue: '12',
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                )),
                              )),
                        ),*/
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 18, color: AppColors.kRipple),
                                SizedBox(width: 11),
                                InkWell(
                                    child: Text("Tarih Aralığı",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: AppColors.kFont,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15))),
                                Spacer(),
                                Text(
                                    dateFormat.format(
                                            widget.gameModel!.startTime) +
                                        " - " +
                                        dateFormat
                                            .format(widget.gameModel!.endTime),
                                    style: TextStyle(
                                        //fontFamily: "Poppins",
                                        color: AppColors.kFont,
                                        fontSize: 14))

                                //DateTimePickerWidget()
                              ]),
                          SizedBox(height: 10),
                          SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // ignore: prefer_const_constructors
                                Icon(Icons.calendar_today_rounded,
                                    size: 18, color: AppColors.kRipple),
                                SizedBox(width: 10),
                                InkWell(
                                    child: Text("Toplam Gün",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: AppColors.kFont,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15))),
                                Spacer(),
                                Text(
                                    widget.gameModel!.endTime
                                                .difference(
                                                    widget.gameModel!.startTime)
                                                .inDays
                                                .toString() ==
                                            "0"
                                        ? "1"
                                        : (widget.gameModel!.endTime
                                                    .difference(widget
                                                        .gameModel!.startTime)
                                                    .inDays +
                                                1)
                                            .toString(),
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: AppColors.kFont,
                                        fontSize: 14)),
                              ]),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // ignore: prefer_adjacent_string_concatenation
                              Text(
                                  "Katılımcılar " +
                                      "(" +
                                      (widget.gameModel!.members.length + 1)
                                          .toString() +
                                      ")",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.kFont,
                                      fontWeight: FontWeight.w500)),
                              Spacer(),
                              TextButton(
                                child: Text('Tümü',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.kFont,
                                        fontWeight: FontWeight.w500)),
                                onPressed: () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Participants(
                                          gameModel: widget
                                              .gameModel) //MyFormPage(), // CreateGame2( gameModel: gameModel,
                                      ))
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(

                                  // padding: EdgeInsets.all(getProportionateScreenWidth(24)),
                                  // height: getProportionateScreenWidth(143),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // color: Colors.white,
                                    //boxShadow: [kDefualtShadow],
                                  ),
                                  child: SingleChildScrollView(
                                      clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Friends(
                                                                      1,
                                                                      gameModel:
                                                                          widget
                                                                              .gameModel!,
                                                                    )));
                                                  },
                                                  child: Column(children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            kDefualtShadow2,
                                                            kDefualtShadow3
                                                          ]),
                                                      child: CircleAvatar(
                                                          radius: 20.0,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child:
                                                              Icon(Icons.add)),
                                                    ),

                                                    /* Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            kDefualtShadow2,
                                                            kDefualtShadow3
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                      child: Icon(Icons.add,
                                                          size: 25,
                                                          color:
                                                              AppColors.kRed)),*/
                                                    VerticalSpacing(of: 10),
                                                    Text(
                                                      "Ekle",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              MeCard(currentUser!),
                                              ...List.generate(
                                                  widget.gameModel!.members
                                                      .length, // 4,//myFriends.length,
                                                  (index) => Padding(
                                                        padding: EdgeInsets.only(
                                                            left: getProportionateScreenWidth(
                                                                kDefaultPadding)),
                                                        child: FriendsCard(
                                                          widget.gameModel!
                                                              .members[index],
                                                          press: () {},
                                                        ),
                                                      ))
                                            ]),
                                      )))),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          /*chipList(),
                          SizedBox(height: 20),*/
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(children: [
                              Text(
                                'Gün Koruması:',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.kFont,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              CupertinoSwitch(
                                  activeColor: AppColors.kRipple,
                                  value: _switchValue!,
                                  onChanged: (a) {
                                    setState(() {
                                      _switchValue = a;
                                      _switchValue!
                                          ? _showDayProtectDialog()
                                          : null;
                                    });
                                  })
                            ]),
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Kategoriler:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.kFont,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 10),
                          chipList(),
                          // SizedBox(height: 70),
                          //Divider()
                        ]),
                  ),
                ),
              ]),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              /*floatingActionButton: widget.gameModel!.trackKPIs.length == 1 &&
                    widget.gameModel!.trackKPIs.contains("2")
                ? new Visibility(
                    visible: isUploading ? false : true,
                    child: FadeTransition(
                        opacity: _hideFabAnimController!,
                        child: ScaleTransition(
                            scale: _hideFabAnimController!,
                            child: FloatingActionButton.extended(
                                heroTag: 'fab_new_task',
                                onPressed: () async {
                                  await handleSubmit();

                                  widget.gameModel!.gameDuration = widget
                                          .gameModel!.endTime
                                          .difference(
                                              widget.gameModel!.startTime)
                                          .inDays +
                                      1;
                                  widget.gameModel!.gameOwnerId =
                                      currentUser!.id!;
                                  widget.gameModel!.status = "Waiting";
                                  //  print(widget.taskModel.savedTaskTitle);

                                  await widget.gameModel!.saveGame(
                                      dayProtection: _switchValue,
                                      savedTaskTitle: widget.taskModel != null
                                          ? widget.taskModel!.dailyEventsTitle
                                          : {},
                                      savedDailyPlanTodos:
                                          widget.taskModel != null
                                              ? widget.taskModel!.dailyEvents
                                              : {});
                                  _image = null;

                                  //Future.delayed(const Duration(seconds: 12), () {
                                  isUploading = false;
                                  // });
                                  /*Navigator.of(context).popUntil(
                                    ModalRoute.withName("CreateGame"));*/
                                  /* while (Navigator.canPop(context)) {
                                  // Navigator.canPop return true if can pop
                                  Navigator.pop(context);
                                }*/

                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Home(
                                      currentUser: currentUser,
                                      gameModel: widget.gameModel,
                                      stepModel: Provider.of<StepViewModel>(
                                          context,
                                          listen: false),
                                    );
                                  }), (Route<dynamic> route) => false);
                                },
                                tooltip: '',
                                backgroundColor: AppColors.kRipple,
                                foregroundColor: Colors.white,
                                label: const Text("Daveti Gönder"),
                                icon: const Icon(
                                  Icons.send,
                                  size: 18,
                                )))))
                : FadeTransition(
                    opacity: _hideFabAnimController!,
                    child: ScaleTransition(
                        scale: _hideFabAnimController!,
                        child: SizedBox(
                          width: 120,
                          child: FloatingActionButton.extended(
                              backgroundColor: AppColors.kRipple,
                              foregroundColor: Colors.white,
                              label: const Text("Devam"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GameTiles(
                                        gameModel: widget.gameModel!,
                                        taskModel: widget.taskModel,
                                      ),
                                    ));
                              }),
                        )),
                  ),
                  */

              floatingActionButton: new Visibility(
                  visible: isUploading ? false : true,
                  child: FadeTransition(
                      opacity: _hideFabAnimController!,
                      child: ScaleTransition(
                          scale: _hideFabAnimController!,
                          child: FloatingActionButton.extended(
                              heroTag: 'fab_new_task',
                              onPressed: () async {
                                await handleSubmit();

                                widget.gameModel!.gameDuration = widget
                                        .gameModel!.endTime
                                        .difference(widget.gameModel!.startTime)
                                        .inDays +
                                    1;
                                widget.gameModel!.gameOwnerId =
                                    currentUser!.id!;
                                widget.gameModel!.status = "Waiting";
                                //  print(widget.taskModel.savedTaskTitle);

                                await widget.gameModel!.saveGame(
                                    dayProtection: _switchValue,
                                    savedTaskTitle: widget.taskModel != null
                                        ? widget.taskModel!.dailyEventsTitle
                                        : {},
                                    savedDailyPlanTodos:
                                        widget.taskModel != null
                                            ? widget.taskModel!.dailyEvents
                                            : {});
                                _image = null;

                                //Future.delayed(const Duration(seconds: 12), () {
                                isUploading = false;
                                // });
                                /*Navigator.of(context).popUntil(
                                    ModalRoute.withName("CreateGame"));*/
                                /* while (Navigator.canPop(context)) {
                                  // Navigator.canPop return true if can pop
                                  Navigator.pop(context);
                                }*/

                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Home(
                                    currentUser: currentUser,
                                    gameModel: widget.gameModel,
                                    stepModel: Provider.of<StepViewModel>(
                                        context,
                                        listen: false),
                                  );
                                }), (Route<dynamic> route) => false);
                              },
                              tooltip: '',
                              backgroundColor: AppColors.kRipple,
                              foregroundColor: Colors.white,
                              label: const Text("Daveti Gönder"),
                              icon: const Icon(
                                Icons.send,
                                size: 18,
                              )))))),
          Center(
              child: isUploading
                  ? Loader(
                      child: Lottie.asset("assets/lottie/bouncing-fruits.json",
                          repeat: false,
                          controller:
                              lottieController)) /*Lottie.asset(
                            "assets/lottie/bouncing-fruits.json",
                            width: 300,
                            height: 300,*/

                  : const SizedBox()),
        ]));
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
                  fontFamily: "Poppins", fontSize: 14, color: Colors.blueGrey)),
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
                        this.dateFormat.format(widget.model!.selectedDay!)] =
                    widget.model!.titleModified!;
                widget.model!.savedTaskTitleModify![
                        this.dateFormat.format(widget.model!.selectedDay!)] =
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
                  fontFamily: "Poppins", fontSize: 14, color: Colors.blueGrey)),
          onPressed: () {
            editingController!.clear();
            Navigator.of(context).pop();
            setState(() {
              widget.model!.selectedTaskTitleCopy[
                      dateFormat.format(widget.model!.selectedDay!)] =
                  widget.model!.titleCopy!;
              widget.model!.titleModified = null;
              widget.model!.showAlert = false;
            });

            // Navigator.of(context).pop();
          },
        )
      ],
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
                width: 200,
                height: 200,
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
