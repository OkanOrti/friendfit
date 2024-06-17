// ignore: file_names
// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/screens/addDetailScreen.dart';
import 'package:friendfit_ready/screens/formPage.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/test.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/date_time_picker_widget.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:friendfit_ready/data/image_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class newPlan extends StatefulWidget {
  const newPlan({Key? key}) : super(key: key);

  @override
  _newPlanState createState() => _newPlanState();
}

class _newPlanState extends State<newPlan> {
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
  ChoiceImage selectedIconData =
      const ChoiceImage(id: '1', image: AssetImage('assets/images/diet.jpg'));
  final _formKey = GlobalKey<FormBuilderState>();
  bool _titleHasError = true;
  bool _descHasError = false;
  bool _dateRangeHasError = true;
  double selectedValue = 1;

  final ImagePicker _picker = ImagePicker();

  bool _enabled = true;
  bool toggleFuture = true;
  @override
  void initState() {
    gameTitle = '';
    gamePhrase = '';
    // randomImage().then((value) => null);

    super.initState();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _phraseEditingController.dispose();
    super.dispose();
  }

  _imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      taskModel.imageBeforeSave = image;
    }
  }

  _imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      taskModel.imageBeforeSave = image;
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
    setState(() {
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

                    return SingleChildScrollView(
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
                                        taskModel.fromFitGallery = true;
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
                            itemCount: Provider.of<DietGameViewModel>(context,
                                    listen: false)
                                .listUrls
                                .length,
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

  Future<String> randomImage() async {
    var length = choicesImages.length;
    Random random = Random();
    int randomNumber = random.nextInt(length);
    var iconData = choicesImages[randomNumber];
    var rng = Random();
    var bytes = await rootBundle.load(iconData.path!);
    String tempPath = (await getTemporaryDirectory()).path;
    XFile file = XFile(tempPath + (rng.nextInt(100)).toString() + '.png');
    await File(file.path).writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    _image = File(file.path);
    toggleFuture = false;
    taskModel.imageBeforeSave = file;

    return "random image is ok";
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

  @override
  Widget build(BuildContext context) {
    debugPrint(Localizations.localeOf(context).toString());

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Yeni Plan',
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
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                      taskModel.planTitle = val!;
                                    },
                                    //valueTransformer: (text) => num.tryParse(text),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context,
                                          errorText: "Lütfen başlık giriniz."),
                                      // FormBuilderValidators.numeric(context),
                                      FormBuilderValidators.maxLength(
                                          context, 50,
                                          errorText:
                                              "En fazla 50 karakter girebilirsiniz."),
                                      FormBuilderValidators.minLength(
                                          context, 3,
                                          errorText:
                                              "En az 3 karakter girmelisiniz.")
                                    ]),
                                    // initialValue: '12',
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
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
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),

                                  //color: Colors.green,
                                  child: FormBuilderTextField(
                                    maxLines: 2,
                                    minLines: 1,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    name: 'desc',
                                    decoration: InputDecoration(
                                      //  errorText: "Lütfen başlık giriniz.",
                                      labelText: 'Açıklama',
                                      //hintText: "Aç",
                                      suffixIcon: _descHasError
                                          ? const Icon(Icons.error,
                                              color: Colors.red)
                                          : const Icon(Icons.check,
                                              color: Colors.green),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        _descHasError = !(_formKey
                                                .currentState?.fields['desc']
                                                ?.validate() ??
                                            false);
                                      });
                                      taskModel.desc = val;
                                    },
                                    //valueTransformer: (text) => num.tryParse(text),
                                    validator: FormBuilderValidators.compose([
                                      /* FormBuilderValidators.required(context,
                                        errorText:
                                            "İsterseniz açıklama girebilirsiniz."),*/
                                      // FormBuilderValidators.numeric(context),
                                      FormBuilderValidators.maxLength(
                                          context, 100,
                                          errorText:
                                              "En fazla 100 karakter girebilirsiniz.")
                                    ]),
                                    // initialValue: '12',
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                  ) /* TextField(
                                    textAlign: TextAlign.center,
                                    controller: _phraseEditingController,
                                    onChanged: (text) {
                                      setState(() {
                                        this.taskModel.gamePhrase = text;
                                      });
                                    },
                                    minLines: 1,
                                    maxLength: 100,
                                    maxLines: 2,
                                    //cursorColor: taskColor,
                                    autofocus: false, //true,
                                    decoration: InputDecoration(
                                        counterStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        hintText:
                                            'İsterseniz açıklama girebilirsiniz',
                                        hintStyle: TextStyle(
                                            color: Colors.black26,
                                            fontFamily: "Poppins",
                                            fontSize: 14)),
                                    style: TextStyle(
                                        color: AppColors.kFont.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0),
                                  ),*/

                                  )),
                          const SizedBox(height: 30),
                          /*  Container(
                            decoration: const BoxDecoration(
                                // color: AppColors.kRipple.withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: FormBuilderDateRangePicker(
                                autovalidateMode: AutovalidateMode.always,
                                name: 'date_range',
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2040),
                                format: DateFormat('yyyy/MM/dd'),
                                //onChanged: _onChanged,
                                validator: FormBuilderValidators.compose([
                                  rangeCheck(context, 30),
                                  FormBuilderValidators.required(context,
                                      errorText:
                                          "İsterseniz açıklama girebilirsiniz.")
                                ]),
                                errorInvalidRangeText: "hata",
                                decoration: InputDecoration(
                                  //  border: InputBorder.none,
                                  //alignLabelWithHint: true,
                                  labelText: 'Tarih Aralığı',
                                  // helperText: 'Helper text',
                                  hintText: 'Hint text',
                                  suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _formKey
                                            .currentState!.fields['date_range']
                                            ?.didChange(null);
                                      }),
                                ),
                              ),
                            ),
                          ),*/
                          Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  // ignore: unnecessary_brace_in_string_interps
                                  child: Text(
                                      "Gün Sayısı: ${selectedValue.toInt()}",
                                      style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 14)),
                                )),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoSlider(
                                value: selectedValue,
                                min: 1,
                                max: 30,
                                divisions: 29,
                                activeColor: AppColors.kRipple,
                                onChanged: (value) {
                                  selectedValue = value;
                                  setState(() {});
                                },
                              ),
                            ),
                          ]),
                          /* FormBuilderSlider(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              name: "gun",
                              initialValue: 1,
                              min: 1,
                              max: 30,
                              //label: "a",
                              divisions: 29,
                              decoration: const InputDecoration(
                                /*border: OutlinesInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.kFont)),*/

                                //suffixStyle: TextStyle(color: Colors.white),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                //suffixText: "a",

                                labelText: "Gün sayısı",

                                // disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              numberFormat: NumberFormat(),
                              validator: slideCheck(context,
                                  10) //FormBuilderValidators.max(context, 5, errorText: "En az 1 gün olmalı"),
                              ),*/
                          const SizedBox(height: 30),
                          /* const Text(
                            'Kapak resmi',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: AppColors.kFont,
                            ),
                          ),*/
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                /*   FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }*/
                                _showPicker(context);
                                debugPrint("Okan2");
                              },
                              child: toggleFuture
                                  ? FutureBuilder<Object>(
                                      future: randomImage(),
                                      builder: (context, snapshot) {
                                        return snapshot.hasData
                                            ? Stack(
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
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    20)),
                                                        child: Image.file(
                                                          File(_image!.path),
                                                          //width: 300,
                                                          //height: 200,
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                  const Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    child: Icon(
                                                        Icons.camera_alt,
                                                        size: 35,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )
                                            : const Icon(
                                                Icons.camera_alt,
                                                size: 35,
                                                color: AppColors.kFont,
                                              );
                                      })
                                  : Stack(
                                      children: [
                                        Container(
                                          width: 170,
                                          height: 170,
                                          decoration: BoxDecoration(
                                              color: AppColors.kRipple
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(20),
                                              )),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: !taskModel.fromFitGallery
                                                ? Image.file(
                                                    File(_image!.path),
                                                    //width: 300,
                                                    //height: 200,
                                                    fit: BoxFit.cover,
                                                  )
                                                : FadeInImage.memoryNetwork(
                                                    fit: BoxFit.cover,
                                                    image: taskModel.imageUrl,
                                                    placeholder:
                                                        kTransparentImage,
                                                  ),
                                          ),
                                        ),
                                        const Positioned(
                                          right: 0,
                                          top: 0,
                                          left: 0,
                                          bottom: 0,
                                          child: Icon(Icons.camera_alt,
                                              size: 35, color: Colors.white),
                                        )
                                      ],
                                    )),
                        ]),
                      ),
                    )),
                //SizedBox(height:100)
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return SizedBox(
              width: 120,
              child: FloatingActionButton.extended(
                  heroTag: 'fab_new_card',
                  //icon: Icon(Icons.send_sharp),
                  backgroundColor: AppColors.kRipple, //taskColor,
                  label: const Text('Devam',
                      style: TextStyle(color: Colors.white)),
                  onPressed: _enabled == false
                      ? null
                      : () {
                          //  await  handleSubmit();
                          //   Navigator.pushNamed(context, '/oyunOlustur2',arguments:taskModel);
                          /* String? msg = taskModel.checkMandatoryFields(
                      taskModel.gameTitle,
                      _image!,
                      taskModel.startTime,
                      taskModel.endTime);
*/
                          if (_titleHasError == true) {
                            setState(() => _enabled = false);
                            //_enabled = false;
                            const snackBar = SnackBar(
                              content:
                                  Text('Lütfen zorunlu alanları doldurunuz.'),
                              backgroundColor: Colors.grey,
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                            Timer(const Duration(seconds: 4),
                                () => setState(() => _enabled = true));
                            // _scaffoldKey.currentState.showSnackBar(snackBar);
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddDetailScreen(
                                      model: taskModel,
                                      days: selectedValue.toInt(),
                                    ) //MyFormPage(), // CreateGame2( taskModel: taskModel,
                                ));
                            /* Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const Test() //MyFormPage(), // CreateGame2( taskModel: taskModel,
                                ));*/
                            /*Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateGame2(
                          taskModel:
                              taskModel) //MyFormPage(), // CreateGame2( taskModel: taskModel,
                      )
                      );*/

                            /* handleSubmit();
                             Navigator.of(context).push(MaterialPageRoute( 
                              builder: (context) => CreateGamePage2(taskModel: this.taskModel)));*/
                            /* if (periodPhrase.isEmpty) {
                        final snackBar = SnackBar(
                          content: Text(
                              'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                          backgroundColor: taskColor,
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                        // _scaffoldKey.currentState.showSnackBar(snackBar);
                      } else {
                        widget.todoModel.addTodoToTask(taskId: widget.todom ==null ?null:widget.todom.id,periodName:periodName,periodPhrase:periodPhrase,periodTime:periodTime);
                        Navigator.pop(context);
                      }*/
                          }
                        }),
            );
          },
        ));
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
