import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/screens/formPage.dart';
import 'package:friendfit_ready/screens/test.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/date_time_picker_widget.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'create_game2.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:friendfit_ready/data/image_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

final storageRef = firebase_storage.FirebaseStorage.instance.ref();

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({Key? key}) : super(key: key);

  @override
  _CreateGamePageState createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
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

  final ImagePicker _picker = ImagePicker();

  bool _enabled = true;
  bool toggleFuture = true;

  Future<Object>? future;
  @override
  void initState() {
    gameTitle = '';
    gamePhrase = '';
    // randomImage().then((value) => null);
    future = gameModel.randomImage();
    super.initState();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _phraseEditingController.dispose();
    super.dispose();
  }

  _imgFromCamera() async {
    gameModel.fromFitGallery = false;
    gameModel.fromRandFuture = false;
    gameModel.fromPhoneCamera = true;
    gameModel.fromPhoneGallery = false;
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      gameModel.imageBeforeSave = image;
    }
  }

  _imgFromGallery() async {
    gameModel.fromFitGallery = false;
    gameModel.fromRandFuture = false;
    gameModel.fromPhoneCamera = false;
    gameModel.fromPhoneGallery = true;

    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      gameModel.imageBeforeSave = image;
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
    gameModel.imageUrl = mediaUrl;
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
              future: gameModel.getDietCoverImages(),
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
                              var iconData = gameModel
                                  .listUrls[index]; // widget.icons[index];
                              return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      //  setState(() async {
                                      // _image = iconData.image;

                                      //await convertToFile(iconData.path!);

                                      setState(() {
                                        gameModel.imageUrl = iconData;
                                        gameModel.fromFitGallery = true;
                                        gameModel.fromRandFuture = false;
                                        gameModel.fromPhoneCamera = false;
                                        gameModel.fromPhoneGallery = false;
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
                            itemCount: gameModel.listUrls.length,
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
    var compressedImage = await File(file.path).writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    _image = File(file.path);
    toggleFuture = false;
    gameModel.imageBeforeSave = file;

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
    //_showImageDialog();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(Localizations.localeOf(context).toString());
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Yeni Oyun',
            style: TextStyle(color: AppColors.kFont),
          ),
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
                    flex: 7,
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
                                      gameModel.gameTitle = val!;
                                    },
                                    //valueTransformer: (text) => num.tryParse(text),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context,
                                          errorText:
                                              "Oyununuza bir isim veriniz."),
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
                                      this.gameModel.gameTitle = text;
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
                                      gameModel.gamePhrase = val;
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
                                        this.gameModel.gamePhrase = text;
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
                          const SizedBox(height: 20),
                          Container(
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
                          ),
                          const SizedBox(height: 30),
                          /*const Text(
                            'Kapak resmi',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: AppColors.kFont,
                            ),
                          ),
                          const SizedBox(height: 20),*/
                          GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: gameModel.imageWidget(
                                  future: future, image: _image)
                              /*toggleFuture
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
                                                      ),
                                                    ),
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
                                            // ignore: unnecessary_this
                                            child: !this
                                                    .gameModel
                                                    .fromFitGallery
                                                ? Image.file(
                                                    File(_image!.path),
                                                    //width: 300,
                                                    //height: 200,
                                                    fit: BoxFit.cover,
                                                  )
                                                : FadeInImage.memoryNetwork(
                                                    fit: BoxFit.cover,
                                                    image: gameModel.imageUrl,
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
                                    )*/
                              ),
                        ]),
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        //color: Colors.blue,
                        /* child: FormBuilderDateRangePicker(
                        name: 'date_range',
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2040),
                        format: DateFormat('yyyy/MM/dd'),
                        //onChanged: _onChanged,
                        validator: rangeCheck(context, 30),
                        errorInvalidRangeText: "hata",
                        decoration: InputDecoration(
                          border: InputBorder.none,
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
                                _formKey.currentState!.fields['date_range']
                                    ?.didChange(null);
                              }),
                        ),
                      ),*/
                        /*Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_today,
                                    color: AppColors.kRipple),
                                SizedBox(width: 10),
                                InkWell(
                                    child: Text("Başlangıç:",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14))),
                                Spacer(),
                                DateTimePickerWidget(
                                    type: "1",
                                    fontSize: 16,
                                    //initialValue:widget.todom == null ? null: widget.todom.startDateTodo.toDate(),
                                    onValueChange2: (t) {
                                      this.gameModel.startTime = t;
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (currentFocus.canRequestFocus)
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                      /*DateTime(now.year, now.month,
                                                now.day, t.hour, t.minute);*/
                                    })
          
                                //DateTimePickerWidget()
                              ]),
                          SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_today,
                                    color: AppColors.kRipple),
                                SizedBox(width: 10),
                                InkWell(
                                    child: Text("Bitiş:",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14))),
                                Spacer(),
                                DateTimePickerWidget(
                                    type: "1",
                                    fontSize: 16,
                                    //initialValue:widget.todom == null ? null: widget.todom.startDateTodo.toDate(),
                                    onValueChange2: (t) {
                                      this.gameModel.endTime = t;
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (currentFocus.canRequestFocus) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      }
                                    })
                              ])
                        ],
                      ),*/
                        ),
                  ),
                ) //SizedBox(height:100)
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
                          //   Navigator.pushNamed(context, '/oyunOlustur2',arguments:gameModel);
                          /* String? msg = gameModel.checkMandatoryFields(
                      gameModel.gameTitle,
                      _image!,
                      gameModel.startTime,
                      gameModel.endTime);
*/
                          if (_titleHasError == true ||
                              _dateRangeHasError == true) {
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
                                settings:
                                    const RouteSettings(name: "CreateGame2"),
                                builder: (context) => CreateGame2(
                                    gameModel:
                                        gameModel) //MyFormPage(), // CreateGame2( gameModel: gameModel,
                                ));
                            /* Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const Test() //MyFormPage(), // CreateGame2( gameModel: gameModel,
                                ));*/
                            /*Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateGame2(
                          gameModel:
                              gameModel) //MyFormPage(), // CreateGame2( gameModel: gameModel,
                      )
                      );*/

                            /* handleSubmit();
                             Navigator.of(context).push(MaterialPageRoute( 
                              builder: (context) => CreateGamePage2(gameModel: this.gameModel)));*/
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

  String? Function(DateTimeRange? value) rangeCheck<T>(
    BuildContext context,
    num max, {
    bool inclusive = true,
    String? errorText,
  }) {
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
          return errorText ??
                  "En fazla 30 günlük bir tarih aralığı girebilirsiniz."
              //FormBuilderLocalizations.of(context).minErrorText(min)

              ;
        } else {
          gameModel.startTime = valueCandidate!.start;
          gameModel.endTime = valueCandidate.end;
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
