import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:friendfit_ready/screens/create_account.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/login_email_password_screen.dart';
import 'package:friendfit_ready/screens/verifyPage.dart';
import 'package:friendfit_ready/utils/showOTPDialog.dart';
import 'package:friendfit_ready/utils/showSnackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:friendfit_ready/models/user.dart' as UserModel;
import 'package:provider/provider.dart';

final usersCollection = FirebaseFirestore.instance.collection('users');

class SplashEnded {
  bool statu = false;
}

class FirebaseAuthMethods extends ChangeNotifier {
  FirebaseAuth _auth;
  //final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  //final FacebookLogin _facebookSignIn;
  bool googleSignIn = false;
  bool facebookSignIn = false;
  bool credentialSignIn = false;

  bool isSigned = false;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;
  String? _phoneNumber;
  bool? verificationSmsSent;

  var username;

  bool isSubmitted = false;

  @override
  void dispose() {
    // _disposed = true;
    super.dispose();
  }

  FirebaseAuthMethods({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignin,
    // FacebookLogin facebookSignIn
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();
  // _facebookSignIn = facebookSignIn ?? FacebookLogin();
  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;
  UserModel.User? currentUser;
  SplashEnded splashUser = SplashEnded();

  bool splashEnded = false;
  StreamController<bool> controller = StreamController<bool>.broadcast();

  Stream<SplashEnded?> getSplashStatus() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield splashUser;
    }
  }

  refresh() {
    notifyListeners();
  }

  Future<void> signUp(
      {String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? phone,
      String? gender}) async {
    var n = firstName;
    var res = await _auth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );

    String uid = res.user!.uid;

    UserModel.User usr = UserModel.User(
        id: uid,
        firstname: firstName,
        lastname: lastName,
        email: email,
        phone: phone,
        gender: gender);

    await res.user?.sendEmailVerification();

    //await addOrUpdateUser(usr,signIn: true);
  }

  // await FirebaseFirestore.instance.doc("users/$uid").set({
  //   'userId':uid,
  //   "firstName": firstName,
  //   "lastName": lastName,
  //   "email": email,
  //   "phoneNumber": phone,
  //   "gender": gender
  // });

  Future<bool> isSignedIn(BuildContext context) async {
    final authUser = _auth.currentUser;
    if (authUser != null) {
      DocumentSnapshot doc = await usersCollection.doc(user.uid).get();
      if (!doc.exists) {
        usersCollection.doc(user.uid).set({
          "id": user.uid,
          "username": username,
          "photoUrl": user.photoURL,
          "email": user.email,
          "displayName": user.displayName,
          "bio": "",
          "timestamp": timestamp,
          //  "indexes": indexes
        });
        doc = await usersCollection.doc(user.uid).get();
        currentUser = UserModel.User.fromDocument(doc);
        isSigned = true;
        //return true;
      } else {
        currentUser = UserModel.User(
            id: authUser.uid,
            displayName: authUser.displayName,
            email: authUser.email,
            photoUrl: authUser.photoURL);
        isSigned = true;
      }
      return true;
    }
    /* if (!doc.exists) {
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
        doc = await usersCollection.doc(user.uid).get();
        currentUser = UserModel.User.fromDocument(doc);
      } else {*/
    //doc = await usersCollection.doc(user.uid).get();
    // currentUser = UserModel.User.fromDocument(doc);
    //  }
    //isSigned = true;
    //return true;

    /*currentUser = UserModel.User(
          id: authUser.uid,
          displayName: authUser.displayName,
          email: authUser.email,
          photoUrl: authUser.photoURL);*/

    else {
      isSigned = false;
      return false;
    } // 2) if the user doesn't exist, then we want to take them to the create account page
    //final username =
  }

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.sendEmailVerification();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
            //backgroundColor: Colors.grey,
            content: Text("E-mail adresine aktivasyon maili gönderildi."),
          ))
          .closed
          .then((value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Verify()));
        // isSubmitted = true;
        // refresh();
      });
      // await Future.delayed(Duration(seconds: 2));

      /*await Future.delayed(Duration(seconds: 5)).then((value) {
        isSubmitted = false;

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Verify()));
        //Navigator.pop(context);
      });*/
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        print('Şifreniz en az 6 karakterden oluşmalıdır.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      /*  showSnackBar(
          context, e.message!);*/ // Displaying the usual firebase error message
    }

    //isSubmitted = false;
  }

  a(BuildContext context) {
    return Home(
      currentUser: currentUser,
    );
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      } else {
        await isSignedIn(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                    currentUser: currentUser,
                    stepModel:
                        Provider.of<StepViewModel>(context, listen: false))));
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Aktivasyon maili gönderildi.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          if (userCredential.user != null) {
            //await checkUserInFirestore(context, user: user);

            await isSignedIn(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(name: "Home"),
                    builder: (context) => Home(
                          gameModel: Provider.of<DietGameViewModel>(context,
                              listen: false),
                          currentUser: currentUser,
                          stepModel: Provider.of<StepViewModel>(context,
                              listen: false),
                        )));
            //if (userCredential.additionalUserInfo!.isNewUser) {}
          }

          // if you want to do specific task like storing information in firestore
          // only for new users using google sign in (since there are no two options
          // for google sign in and google sign up, only one as of now),
          // do the following:

          // if (userCredential.user != null) {
          //   if (userCredential.additionalUserInfo!.isNewUser) {}
          // }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // ANONYMOUS SIGN IN
  Future<void> signInAnonymously(BuildContext context) async {
    try {
      await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // FACEBOOK SIGN IN
/*  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await _auth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }*/

  // PHONE SIGN IN
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // !!! Works only on web !!!
      ConfirmationResult result =
          await _auth.signInWithPhoneNumber(phoneNumber);

      // Diplay Dialog Box To accept OTP
      showOTPDialog(
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          await _auth.signInWithCredential(credential);
          Navigator.of(context).pop(); // Remove the dialog box
        },
      );
    } else {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // !!! works only on android !!!
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          showSnackBar(context, e.message!);
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          showOTPDialog(
            codeController: codeController,
            context: context,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );

              // !!! Works only on Android, iOS !!!
              await _auth.signInWithCredential(credential);
              Navigator.of(context).pop(); // Remove the dialog box
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => EmailPasswordLogin()));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }

  Future<void> checkUserInFirestore(BuildContext context,
      {bool fromGoogle = true, User? user}) async {
    // 1) check if user exists in users collection in database (according to their id)
    var username;

    DocumentSnapshot doc = await usersCollection.doc(user!.uid).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      //final username =
      await Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateAccount()))
          .then((value) => username = value);

      List<String> indexes = [""];
      for (int i = 1; i <= user.displayName!.length; i++) {
        String subString = user.displayName!.substring(0, i).toLowerCase();
        indexes.add(subString);
      }

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
      doc = await usersCollection.doc(user.uid).get();
      currentUser = UserModel.User.fromDocument(doc);
    }

    //currentUser == currentUser3 ? print("eşit") : print("eşit değil");
    /*else {
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
      } */
    else {
      doc = await usersCollection.doc(user.uid).get();
      currentUser = UserModel.User.fromDocument(doc);
    }
  }
}
