// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';

import 'package:friendfit_ready/models/user.dart' as UserModel;

import 'package:friendfit_ready/screens/create_account.dart';
import 'package:friendfit_ready/screens/create_game.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/screens/profile.dart';
import 'package:friendfit_ready/screens/deneme.dart';
import 'package:friendfit_ready/screens/timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/services/firebase_auth_methods.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/app_bar.dart';
import 'package:friendfit_ready/widgets/fab_bottom_app_bar.dart';
import 'package:provider/src/provider.dart';
import 'activityfeed.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

//final StorageReference storageRef = FirebaseStorage.instance.ref();
final GoogleSignIn googleSignIn = GoogleSignIn();
//final fbLogin = FacebookLogin();
final usersCollection = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final friendref = FirebaseFirestore.instance.collection('friends');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final friendsRef = FirebaseFirestore.instance.collection('friends');
final recipesRef = FirebaseFirestore.instance.collection('recipes');
final dietTasksRef = FirebaseFirestore.instance.collection('dietTasks');

//FacebookLogin facebookLogin = FacebookLogin();
FirebaseAuth _auth = FirebaseAuth.instance;

String isim = "Okan";

final timestamp = DateTime.now();

UserModel.User? currentUser;

class Home extends StatefulWidget {
  Home({Key? key, this.currentUser, this.stepModel, this.gameModel})
      : super(key: key);

  UserModel.User? currentUser;

  StepViewModel? stepModel;
  DietGameViewModel? gameModel;
  final advancedDrawerController = AdvancedDrawerController();

  // final GoogleSignInAccount? googleAccount;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  //StepViewModel stepModel = serviceLocator<StepViewModel>();
  PageController? pageController;

  bool isAuth = false;

  @override
  void dispose() {
    // TODO: implement dispose
    pageController!.dispose();
    widget.advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true, initialPage: pageIndex);

    /*googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account!);
    }, onError: (err) {});

    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account!);
    }).catchError((err) {
      print('Error signing in: $err');
    });*/
  }

  /* handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      await createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }*/

  Future<void> handleLogin() async {
    /*  final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }*/
  }

  /* Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    if (a != null) {
      await createUserInFirestore(fromGoogle: false, user: a.user);
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }*/

  /*Future<void> facebookSignout() async {
    await _auth.signOut().then((onValue) {
      setState(() {
        facebookLogin.logOut();
        isAuth = false;
      });
    });
  }*/

  void handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();

    widget.advancedDrawerController.showDrawer();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  void onTap(int index) {
    pageController!.jumpToPage(index);
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  buildAuthScreen() {
    return AdvancedDrawer(
        drawer: SafeArea(
            child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/flutter_logo.png',
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.favorite),
                  title: Text('Favourites'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        )),
        backdropColor: AppColors.kRipple,
        controller: widget.advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          // NOTICE: Uncomment if you want to add shadow behind the page.
          // Keep in mind that it may cause animation jerks.
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 0.0,
          //   ),
          // ],
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Scaffold(
          appBar: buildAppBar(context,
              isTransparent: false,
              title: "FriendFit",
              advancedDrawerController: widget.advancedDrawerController,
              handle: handleMenuButtonPressed),
          body: PageView(
            children: <Widget>[
              Timeline(
                currentUserId: widget.currentUser!.id,
                stepModel: widget.stepModel,
                gameModel: widget.gameModel,
              ),
              PositionedTiles(w: widget.gameModel),
              ActivityFeed(
                modelUsed: widget.gameModel,
              ),

              Profile(
                profileId: widget.currentUser!.id,
                isMain: true,
              ),

              //Store(),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
            physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: FABBottomAppBar(
            //backgroundColor: ,
            height: 50, iconSize: 26,
            centerItemText: "", //'',
            color: Colors.grey,
            selectedColor: AppColors.kRipple,

            notchedShape: CircularNotchedRectangle(),
            onTabSelected: onTap,
            items: [
              FABBottomAppBarItem(
                iconData: Icons.home,
              ),
              FABBottomAppBarItem(iconData: Icons.gamepad),
              FABBottomAppBarItem(iconData: Icons.person),
              FABBottomAppBarItem(iconData: Icons.shopping_bag),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFab(context),
        ));
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // ignore: prefer_const_literals_to_create_immutables
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'Friend',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 40.0,
                  color: Colors.black54,
                ),
              ),
              Text(
                'Fit',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 40.0,
                  color: AppColors.kRipple,
                ),
              ),
            ]),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: login,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/google.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  await handleLogin();
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/facebook.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    currentUser = context.read<FirebaseAuthMethods>().currentUser;
    //return isAuth ? buildAuthScreen() : buildUnAuthScreen();
    //final user = context.read<FirebaseAuthMethods>().user;

    /*return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(child: Text(widget.gameModel!.count.toString())),
        TextButton(
          child: Text("hello"),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Case(
                    gameModelUsed: widget.gameModel,
                  ),
                ));
          },
        )
      ]),
    );*/
    return buildAuthScreen();
  }

  /* Future<void> createUserInFirestore(
      {bool fromGoogle = true, User? user}) async {
    // 1) check if user exists in users collection in database (according to their id)

    if (fromGoogle) {
      final GoogleSignInAccount user = googleSignIn.currentUser!;
      DocumentSnapshot doc = await usersCollection.doc(user.id).get();

      if (!doc.exists) {
        // 2) if the user doesn't exist, then we want to take them to the create account page
        //final username =
        await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateAccount()))
            .then((value) => username = value);

        List<String> indexes = [""];
        for (int i = 1; i <= user.displayName!.length; i++) {
          String subString = user.displayName!.substring(0, i).toLowerCase();
          indexes.add(subString);
        }

        // 3) get username from create account, use it to make new user document in users collection
        usersCollection.doc(user.id).set({
          "id": user.id,
          "username": username,
          "photoUrl": user.photoUrl,
          "email": user.email,
          "displayName": user.displayName,
          "bio": "",
          "timestamp": timestamp,
          "indexes": indexes
        });
        doc = await usersCollection.doc(user.id).get();
      }

      currentUser = UserModel.User.fromDocument(doc);
      //var currentUser2 = UserModel.User(id: doc['id']);
      //currentUser3 = UserModel.User.fromDocument(doc);

      //currentUser == currentUser3 ? print("eşit") : print("eşit değil");

    } else {
      DocumentSnapshot doc = await usersCollection.doc(user!.uid).get();
      if (!doc.exists) {
        // 2) if the user doesn't exist, then we want to take them to the create account page
        //final username =
        await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateAccount()))
            .then((value) => username = value);

        List<String> indexes = [""];
        for (int i = 1; i <= user.displayName!.length; i++) {
          String subString = user.displayName!.substring(0, i).toLowerCase();
          indexes.add(subString);
        }
        //print(indexes);
        // 3) get username from create account, use it to make new user document in users collection
        usersCollection.doc(user.uid).set({
          "id": user.uid,
          "username": username,
          "photoUrl": user.photoURL,
          "email": user.email,
          "displayName": user.displayName,
          "bio": "",
          "timestamp": timestamp,
          "indexes": indexes
        });
      } else {
        doc = await usersCollection.doc(user.uid).get();
        currentUser = UserModel.User.fromDocument(doc);
      }
    }
  }*/

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.kRipple,
      onPressed: () {
        /* Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreateNewTaskPage()));*/
        //  Navigator.pushNamed(context, "CreateGame");

        Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: "CreateGame"),
              builder: (context) => CreateGamePage(),
            ));
      },
      tooltip: 'Oyun Başlat',
      // ignore: prefer_const_constructors
      child: Icon(
        Icons.add_outlined,
        color: Colors.white,
        size: getProportionateScreenHeight(30),
      ),
      elevation: 2.0,
    );
  }
}
