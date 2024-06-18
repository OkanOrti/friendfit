// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/ViewModels/SharedPrefsRepo.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:friendfit_ready/screens/SplashScreen.dart';
import 'package:friendfit_ready/screens/case%20.dart';
import 'package:friendfit_ready/screens/caseHub.dart';

import 'package:friendfit_ready/screens/login_email_password_screen.dart';
import 'package:friendfit_ready/screens/phone_screen.dart';

import 'package:friendfit_ready/screens/router.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/screens/signup_email_password_screen.dart';
import 'package:friendfit_ready/services/firebase_auth_methods.dart';
import 'package:friendfit_ready/services/navigationService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/ViewModels/NotificationViewModel.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

import 'models/user.dart';

void main() async {
  var overlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark);
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance!.renderView.automaticSystemUiAdjustment = false;
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    debugPrint("*****************WidgetsBinding******************");
  });
  await Firebase.initializeApp();
  await SharedPrefRepo().addAppInstallDate();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //await initializeDateFormatting();
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NotificationViewModel notifyModel =
      serviceLocator<NotificationViewModel>();
  StepViewModel stepModel = serviceLocator<StepViewModel>();
  DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
  //DietTaskViewModel taskModel = serviceLocator<DietTaskViewModel>();
  final FirebaseAuthMethods fireModel = FirebaseAuthMethods();

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    notifyModel.initializeNotifications();
    notifyModel.makeTodoNotifyList();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotificationViewModel>(
            create: (_) => notifyModel),
        ChangeNotifierProvider<FirebaseAuthMethods>(create: (_) => fireModel),
        ChangeNotifierProvider<StepViewModel>(create: (_) => stepModel),
        ChangeNotifierProvider<DietGameViewModel>(create: (_) => gameModel),
        //  ChangeNotifierProvider<DietTaskViewModel>(create: (_) => taskModel),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        navigatorKey: serviceLocator<NavigationService>().navigatoryKey,
        debugShowCheckedModeBanner: false,
        //  builder: Frame.builder,
        title: 'FriendFit',
        onGenerateRoute: RouterMe.generateRoute,
        //initialRoute: "Home",
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: createMaterialColor(AppColors.kRipple)),
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        routes: {
          "Home": (context) => Home(
                gameModel:
                    Provider.of<DietGameViewModel>(context, listen: false),
                currentUser:
                    Provider.of<FirebaseAuthMethods>(context, listen: false)
                        .currentUser,
                stepModel: Provider.of<StepViewModel>(context, listen: false),
              ),
          EmailPasswordSignup.routeName: (context) =>
              const EmailPasswordSignup(),
          EmailPasswordLogin.routeName: (context) => EmailPasswordLogin(),
          PhoneScreen.routeName: (context) => const PhoneScreen(),
        },
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
          Locale('fa', ''),
          Locale('fr', ''),
          Locale('ja', ''),
          Locale('pt', ''),
          Locale('sk', ''),
          Locale('pl', ''),
          Locale('tr', '')
        ],
        home:

            /*CaseHub(
            gameModelUsed: gameModel,
          )*/
            AuthWrapper(
          fireModel: fireModel,
          stepModel: stepModel,
        ),
        //Home()
      ),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key, this.fireModel, this.stepModel})
      : super(key: key);
  final FirebaseAuthMethods? fireModel;
  final StepViewModel? stepModel;

  @override
  AuthWrapperState createState() => AuthWrapperState();
}

class AuthWrapperState extends State<AuthWrapper> {
  Future<bool>? myFunc;
  handleAsync(BuildContext context) async {
    await widget.fireModel!.isSignedIn(context);
  }

  @override
  void initState() {
    //myFunc = widget.fireModel!.isSignedIn(context);
    //  handleAsync(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var xx = Provider.of<DietGameViewModel>(context, listen: false);
    // handleAsync(context);
    //final firebaseUser2 = context.watch<User?>();
    // debugPrint("hello");

    //final firebaseUser = context.watch<FirebaseAuthMethods>().currentUser;
    //final splashEnded = context.watch<SplashEnded?>();

    return ChangeNotifierProvider<FirebaseAuthMethods>.value(
        value: widget.fireModel!,
        child: Consumer<FirebaseAuthMethods>(builder: (context, model, child) {
          if (model.splashEnded == false) {
            //return EmailPasswordLogin();
            return SplashScreen(fireModel: widget.fireModel);
          }
          /* } else if (model.isSigned) {
            return Home(currentUser: widget.fireModel!.currentUser);
          } else {
            return const LoginScreen();
          }*/

          else {
            return FutureBuilder(
                future: widget.fireModel!.isSignedIn(context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const SplashScreen();
                    case ConnectionState.done:
                      return snapshot.data == true
                          ? Home(
                              gameModel: Provider.of<DietGameViewModel>(context,
                                  listen: false),
                              currentUser: widget.fireModel!.currentUser,
                              stepModel: widget.stepModel,
                            )
                          : EmailPasswordLogin();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('Result: ${snapshot.data}');
                      }
                  }
                });
          }
        }));

    //once splash sonra authorized  ya da unauthorized(login) ekranı
  }
}

// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
/*
import 'package:friendfit_ready/admobTest/app_theme.dart';
import 'package:friendfit_ready/admobTest/game_route.dart';
import 'package:friendfit_ready/admobTest/home_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(
    MaterialApp(
      // home: HomeRoute(),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const HomeRoute(),
        '/game': (BuildContext context) => const GameRoute()
      },
      theme: ThemeData(
        primaryColor: AppTheme.primary,
        primaryColorDark: AppTheme.primaryDark,
        accentColor: AppTheme.accent,
        textTheme: GoogleFonts.acmeTextTheme().copyWith(
            button: GoogleFonts.ubuntuMono(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )),
        buttonTheme: ButtonThemeData(
          buttonColor: AppTheme.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
    ),
  );
}
*/
/*
import 'package:flutter/material.dart';
//import 'package:friendfit_ready/player.dart';
import 'package:friendfit_ready/player.dart';

import 'filterscreen.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FilterScreen()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Called");
    return Scaffold(
        appBar: AppBar(title: Text("Rotate Widget")),
        body: Center(
            child: MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  print("Called");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PlayerScreen(
                        url:
                            "https://d17k9hgq4rqcv9.cloudfront.net/video_tutorials/634/148682_6201572435171/playlist.m3u8");
                  }));
                },
                child: Text("Play Viedo"))));
  }
}
*/

// ignore_for_file: use_key_in_widget_constructors
/*
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget();
  @override
  State<StatefulWidget> createState() {
    return MyWidget_State();
  }
}

class MyWidget_State extends State<MyWidget> {
  String initial = "okan";
  bool enabled = false;
  TextEditingController? controllerText;
  final keyT = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerText = TextEditingController();
    controllerText?.text = "Okan";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  enabled = true;
                });
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                setState(() {
                  enabled = false;
                  controllerText?.text = "Oki";
                });
              },
              icon: const Icon(Icons.undo)),
          Container(
              decoration: const BoxDecoration(
                  // color: AppColors.kRipple.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Center(
                  child: FormBuilderTextField(
                    key: keyT,
                    controller: controllerText,
                    //key:                                                    UniqueKey(), //(widget.task!.title!),
                    enabled: enabled,
                    maxLines: 2,
                    minLines: 1,
                    autovalidateMode: AutovalidateMode.always,
                    name: 'title',
                    // initialValue: initial,

                    onChanged: (val) {
                      debugPrint("hello");
                      setState(() {});
                      
                      // widget.model!.planTitle = val!;
                    },
                    //valueTransformer: (text) => num.tryParse(text),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Lütfen başlık giriniz."),
                      // FormBuilderValidators.numeric(context),
                      FormBuilderValidators.maxLength(context, 50,
                          errorText: "En fazla 50 karakter girebilirsiniz."),
                      FormBuilderValidators.minLength(context, 3,
                          errorText: "En az 3 karakter girmelisiniz.")
                    ]),
                    // initialValue: '12',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              )),

          /* ElevatedButton(
            child: const Text('showModalBottomSheet'),
            onPressed: () {
              /*FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {*/
              FocusManager.instance.primaryFocus?.unfocus();
              //}
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    color: Colors.amber,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Modal BottomSheet'),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              debugPrint("");
            },
          )*/
        ],
      ),
    );
  }
}
*/