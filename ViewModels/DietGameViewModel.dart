// ignore_for_file: file_names, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:friendfit_ready/models/stepPhrase.dart';
import 'package:friendfit_ready/screens/create_game.dart';
import 'package:friendfit_ready/screens/home.dart' as home;
import 'package:friendfit_ready/services/FriendRequest/FriendRequestService.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:friendfit_ready/models/todoPhrase.dart';
import 'package:friendfit_ready/ViewModels/DietTaskViewModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:friendfit_ready/viewmodels/NotificationViewModel.dart';
import 'package:transparent_image/transparent_image.dart';
//import'package:friendfit_ready/pages/home.dart';

final dietGamesRef = FirebaseFirestore.instance.collection('dietGames');
final stepGamesRef = FirebaseFirestore.instance.collection('stepGames');

final gameInvitationToRef =
    FirebaseFirestore.instance.collection('gameInvitationTo');
final gameInvitationRef =
    FirebaseFirestore.instance.collection('gameInvitation');
User? gameOwner;

class DietGameViewModel extends ChangeNotifier {
  List<User?> selectedUsers = [];
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat dateFormat2 = DateFormat('yyyy-MM-dd hh:mm:ss');
  List<DietGame> games = [];
  List<DietGame> invitedGames = [];
  List<User> members = [];
  List<User> selectedMembers = [];
  List<User> gameMembers = [];
  List<String> selectedUserIds = [];
  List<String> memberIds = [];
  List<String> selectedMemberIds = [];
  Map<String, dynamic> checkedPhrases = {};
  List<dynamic> phrasesTodo = [];
  bool fromFitGallery = false;
  List<DietGame> games3 = [];
  List<DietGame> games2 = [];
  Map<String, int> stepScores = {};
  bool isLoaded = false;
  bool isActive = false;
  bool isSaved = false;
  bool isTodoLoaded = false;
  bool isEdited = false;
  List listUrls = [];
  bool isFiltered = false;
  late String gameOwnerId;
  late String gameTitle;

  String? gamePhrase;
  String dietId = "";
  late String status;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  List<String> trackKPIs = [];
  List<String> trackKPI_Names = [];
  late String imageUrl;
  late List<User> friendsNoMembers;
  late DietTask selectedDiet;
  late int gameDuration;
  late bool isRefreshed;
  late DietTask selectedTask;
  Map<dynamic, DietTask> gamePlanTask = {};
  Map<dynamic, List<DietToDos>?> gamePlanTodos = {};
  Map<dynamic, String> gameTasks = {};
  late DietGame selectedGame; //=new DietGame();
  XFile? imageBeforeSave;
  Map<dynamic, String?> _savedTaskTitle = {};
  Map<dynamic, String> gameTaskTitle = {};
  String taskTitle = "";
  Map<dynamic, List<DietToDos>?> _savedDailyPlanTodos = {};
  Map<String, List<String>> gamesAndOwners = {};
  final FriendRequestService _friendRequestService =
      serviceLocator<FriendRequestService>();
  List<User> usersApproved = [];
  List<User> usersDenied = [];
  List<User> usersNoResponse = [];
  bool isCompleted = false;
  List<ToDoPhrase> phrases = [];
  Map<String, List<ToDoPhrase>> a = {};

  List<ToDoPhrase> phrases2 = [];
  Map<String, List<ToDoPhrase>> phrasesFromScore = {};
  List<ToDoPhrase> phrasesFrom = [];
  List<User> scoreUsers = [];
  List<DietToDos> gameTodos = [];
  Map<String, DietTaskViewModel> dietPlans = {};

  List<DietTaskViewModel> dietPlansList = [];
  Map<String?, List<ToDoPhrase>> userScores = {};
  Map<String, int> userScoresCompleted = {};
  User selectedOpponent = User(id: "");
  List<ToDoPhrase> timeLinePhrases = [];
  late String uID;
  bool isSendingScore = false;
  bool isLoadingLottie = false;
  int count = 0;
  bool fromPhoneCamera = false;

  bool fromPhoneGallery = false;

  bool fromRandFuture = true;

  var randomImageUrl;

  List<DietToDos> planTodos = [];
  int home_ = 0;
  int oppo = 0;

  //final NotificationViewModel notifyModel =      serviceLocator<NotificationViewModel>();
  // Map<String, Map<String, List<dynamic>>> allCheckedMap = {};
  /* getGamePhrases(String ownerId, String gameId)async{
    phrases3=[];
    
    QuerySnapshot snapshot = await dietGamesRef
        .doc(ownerId)
        .collection("userDietGames")
        .doc(gameId)
        .collection("gameTodos")
        .get(); 
    final todoDocs = snapshot.docs;
    List<DietToDos> gameTodos = [];
    List<dynamic> keys = [];
 
    todoDocs.forEach((doc) {
      DietToDos a = DietToDos.fromDocument(doc);
      gameTodos.add(a);
    });

   await Future.forEach(gameTodos, (e) async{ 
   
      
QuerySnapshot snapshot = await dietGamesRef
        .doc(ownerId)
        .collection("userDietGames")
        .doc(gameId)
        .collection("gameTodos")
        .doc(e.id)
        .collection("checkedBy")
        .doc(currentUser.id)
        .collection("phrases")
        .get();
        });

    final docs=snapshot.docs;

    docs.forEach((doc) {
      ToDoPhrase phrase = ToDoPhrase.fromDocument(doc);
      phrases3.add(phrase);

    });




  }*/

  getStepScores(
      List<StepPhrase> opposite, List<StepPhrase> current, DietGame game) {
    List<String> datesBetweenString = [];
    List<DateTime> datesBetween = [];
    DateTime start = DateTime(game.startDate!.toDate().year,
        game.startDate!.toDate().month, game.startDate!.toDate().day);

    DateTime end = DateTime(game.endDate!.toDate().year,
        game.endDate!.toDate().month, game.endDate!.toDate().day);
    int days = end.difference(start).inDays;

    for (int i = 0; i <= days; i++) {
      var startX = start.add(Duration(days: i));
      datesBetweenString.add(DateFormat('yyyy-MM-dd').format(startX));
    }
    for (int i = 0; i <= days; i++) {
      var startX = start.add(Duration(days: i));
      datesBetween.add(startX);
    }

    home_ = 0;
    oppo = 0;

    if (current.isNotEmpty && opposite.isNotEmpty) {
      datesBetweenString.forEach((element) {
        /* StepPhrase h = current
            .where((StepPhrase element2) =>
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(element2.steppedDate!)) ==
                element,              ).first;
    StepPhrase o = opposite
            .where((StepPhrase element2) =>
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(element2.steppedDate!)) ==
                element)
            .first;
 */

        StepPhrase? h = current.firstWhere(
          (element2) =>
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(element2.steppedDate!)) ==
              element,
          orElse: () => StepPhrase(),
        );
        StepPhrase? o = opposite.firstWhere(
          (element2) =>
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(element2.steppedDate!)) ==
              element,
          orElse: () => StepPhrase(),
        );
        if (h.steps != -1 && o.steps != -1) {
          if (h.steps! > o.steps!) {
            home_ += 1;
            h.win = 1;
            o.win = -1;
          } else if (o.steps! > h.steps!) {
            oppo += 1;
            o.win = 1;
            h.win = -1;
          } else if (o.steps! == h.steps!) {
            // oppo += 1;
            o.win = 2;
            h.win = 2;
          } else {
            null;
          }
        } else {
          null;
        }
      });

      if (!stepScores.containsKey(current.first.id)) {
        stepScores[current.first.id!] = home_;
      } else {
        stepScores.addAll({current.first.id!: home_});
      }

      if (!stepScores.containsKey(opposite.first.id)) {
        stepScores[opposite.first.id!] = oppo;
      } else {
        stepScores.addAll({opposite.first.id!: oppo});
      }
    } else {
      null;
    }

    // notifyListeners();
  }

  getDietScores(DietGameViewModel model, DietGame game) {
    var a = userScores;
    var b = checkedPhrases;
    var c = timeLinePhrases;
    List<String> datesBetweenString = [];
    List<DateTime> datesBetween = [];
    DateTime start = DateTime(game.startDate!.toDate().year,
        game.startDate!.toDate().month, game.startDate!.toDate().day);

    DateTime end = DateTime(game.endDate!.toDate().year,
        game.endDate!.toDate().month, game.endDate!.toDate().day);
    int days = end.difference(start).inDays;

    for (int i = 0; i <= days; i++) {
      var startX = start.add(Duration(days: i));
      datesBetweenString.add(DateFormat('yyyy-MM-dd').format(startX));
    }
    for (int i = 0; i <= days; i++) {
      var startX = start.add(Duration(days: i));
      datesBetween.add(startX);
    }

    int home = 0;
    int oppo = 0;

    /*  if (current.isNotEmpty && opposite.isNotEmpty) {
      datesBetweenString.forEach((element) {
        StepPhrase h = current
            .where((StepPhrase element2) =>
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(element2.steppedDate!)) ==
                element)
            .first;
        StepPhrase o = opposite
            .where((StepPhrase element2) => element2.steppedDate == element)
            .first;

        if (h.steps != -1 && o.steps != -1) {
          if (h.steps! > o.steps!) {
            home_ += 1;
            h.win = 1;
            o.win = -1;
          } else if (o.steps! > h.steps!) {
            oppo += 1;
            o.win = 1;
            h.win = -1;
          } else {
            null;
          }
        } else {
          null;
        }
      });

      if (!stepScores.containsKey(current.first.id)) {
        stepScores[current.first.id!] = home;
      } else {
        stepScores.addAll({current.first.id!: home});
      }

      if (!stepScores.containsKey(opposite.first.id)) {
        stepScores[opposite.first.id!] = oppo;
      } else {
        stepScores.addAll({opposite.first.id!: oppo});
      }
    } else {
      null;
    }
    */

    // notifyListeners();
  }

  Future getGameScoreFromUsers(DietGame game, {String? planId}) async {
    /* usersApproved = [];
    usersDenied = [];
    scoreUsers = [];
    */
    timeLinePhrases = [];

    /*  List<dynamic>? memberIds = List.from(game.memberIds!);
    memberIds.add(game.gameOwnerId);

    memberIds != null ? await getGameMembers(memberIds) : null;
*/
    /*await Future.forEach(gameMembers, (User element) async {
      var a = element;

      DocumentSnapshot memberDoc = await gameInvitationRef
          .doc(a.id)
          .collection("gamesFrom")
          .doc(game.gameOwnerId)
          .collection("games")
          .doc(game.id)
          .get();
      if (memberDoc.exists && memberDoc['status'] == "Onay") {
        usersApproved.add(element);
      } else if (memberDoc.exists && memberDoc['status'] == "Red") {
        usersDenied.add(element);
      } else if (memberDoc.exists) {
        usersNoResponse.add(element);
      }
    });
    */
    // print(gameMembers);

    /*for (var element in usersApproved) {
      scoreUsers.add(element);
    }*/
    //scoreUsers.add(home.currentUser!);

    /*  gameMembers.forEach((element) {
      scoreUsers.add(element);
    });
*/
    DocumentSnapshot? snapshot2;
    await getGameTodos(game.gameOwnerId, game.id);
    await getDietPlanTodos(game.gameOwnerId, game, planId: planId);

// !!  for all approved users'scores..

    phrasesFromScore = {};
    List<QueryDocumentSnapshot> docSnaps = [];

    /*await Future.forEach(gameTodos, (DietToDos e) async {
        snapshot2 = await dietGamesRef
            .doc(game.gameOwnerId)
            .collection("userDietGames")
            .doc(game.id)
            .collection("gameTodos")
            .doc(e.id)
            .collection("checkedBy")
            .doc(element.id)
            .collection("phrases")
            .get();
        for (var element in snapshot2.docs) {
          docSnaps.add(element);
        }
      });*/

    await Future.forEach(planTodos, (DietToDos e) async {
      checkedPhrases = {};
      snapshot2 = await dietGamesRef
          .doc(game.gameOwnerId)
          .collection("userDietGames")
          .doc(game.id)
          .collection("gamePlans")
          .doc(planId)
          .collection("gameTodos")
          .doc(e.id)
          .get();

      (snapshot2!.data() as Map).containsKey('checkedPhrases')
          ? checkedPhrases = snapshot2!['checkedPhrases']
          : null;

      (snapshot2!.data() as Map).containsKey('phrases')
          ? phrasesTodo = snapshot2!['phrases']
          : null;

      checkedPhrases.forEach((key, value) {
        value.forEach((userId) {
          List empty = [];
          String a = key;
          String b = a.split("_")[2];
          ToDoPhrase phrase = ToDoPhrase(
              checkedUserId: value,
              isLeft: home.currentUser!.id == userId ? true : false,
              title: a.split("_")[2],
              rank: int.parse(a.split("_")[3]),
              phrase: phrasesTodo[int.parse(a.split("_")[3])],
              checkedDate: e.startDate!.toDate(),
              id: key
              //dateFormat2.format(e.startDate!.toDate()) //a.split("_")[4],
              );
          /* phrasesFromScore[userId] == null
              ? phrasesFromScore[userId] = empty.add(phrase)
              : phrasesFromScore[userId]!.add(phrase);*/
          timeLinePhrases.add(phrase);
          userScores[userId] = addListPhrase(
              phrasesFromScore, phrase, userId); //phrasesFromScore[userId]!;
        });
      });
    });

    // print(snapshot2!['checkedPhrases']);
    /* for (var doc in docSnaps) {
      ToDoPhrase phrase = ToDoPhrase.fromDocument(doc);
      phrase.isCompleted == 1 ? phrasesFrom.add(phrase) : null;
    }
    userScores[element.id] = phrasesFrom;

    for (var i in userScores.entries) {
      i.key == home.currentUser!.id!
          ? i.value.forEach((element) {
              element.isLeft = true;
              timeLinePhrases.add(element);
            })
          : null;
    }*/
    debugPrint("hello");
    //  notifyListeners();
  }

  addListPhrase(Map<String, List<ToDoPhrase>> phrasesFromScore,
      ToDoPhrase phrase, String userId) {
    List<ToDoPhrase> empty = [];
    if (phrasesFromScore[userId] == null) {
      empty.add(phrase);
      phrasesFromScore[userId] = empty;
    } else {
      phrasesFromScore[userId]!.add(phrase);
    }

    return phrasesFromScore[userId];
  }

  getOpponentScores(String id) {
    timeLinePhrases
        .removeWhere((element) => element.checkedUserId.contains(id));
    for (var i in userScores.entries) {
      i.key != home.currentUser!.id
          ? i.value.forEach((element) {
              element.isLeft = false;
              timeLinePhrases.add(element);
            })
          : null;
    }
    notifyListeners();
  }

  int getTaskCompletionPercent(
      String gameId, String id, DateTime day, String title, int rank) {
    String id2 = gameId +
        "_" +
        id +
        "_" +
        title +
        "_" +
        rank.toString() +
        "_" +
        dateFormat.format(day);
    int count = 0;

    int total = 0;
    total = a[id]!.length;
    if (total > 0) {
      for (var i in a[id]!) {
        i.isCompleted == 1 ? count += 1 : null;
      }
//notifyListeners();
      return (100 * (count / total)).toInt();
    }
    return 0;
  }

  createPhraseObjetsFromTodos(String gameId, String ownerId) {
    for (var e in planTodos) {
      phrases = [];
      /* var phraseFromQuery = phrasesFrom.isNotEmpty
          ? phrasesFrom.where((element) => element.parentId == e.id).toList()
          : null;

print(phraseFromQuery);
*/

      e.phrases!.asMap().forEach((index, element) {
        ToDoPhrase phrase = ToDoPhrase(
          id: gameId +
              "_" +
              e.id! +
              "_" +
              e.title! +
              "_" +
              index.toString() +
              "_" +
              dateFormat2.format(e.startDate!.toDate()) +
              "_",
          parentId: e.id,
          phrase: element.toString(),
          title: e.title,
        );
        phrases.add(phrase);
      });
      if (e.checkedPhrases != null) {
        for (var i in e.checkedPhrases.entries) {
          for (var element in phrases) {
            if (i.key == element.id) element.checkedUserId = i.value;
            if (i.key == element.id && i.value.contains(home.currentUser!.id)) {
              element.isCompleted = 1;
            }
          }
        }
      }

//phrases.sort((a,b)=>a.rank.compareTo(b.rank));
      a[e.id!] = phrases;
    }
  }

  sendScore(DietGame game, String currentUserId, [String? dietPlanId]) async {
    isLoadingLottie = false;
    isSendingScore = true;
    notifyListeners();
    //Map checkedPhrases2 ={};

    List<ToDoPhrase> resultPhrase = [];

    for (var i in a.entries) {
      for (var element in i.value) {
        resultPhrase.add(element);
      }
    }

    Map<String?, Map<String?, List<dynamic>>> allCheckedMap = {};

    for (var element in resultPhrase) {
      if (allCheckedMap[element.parentId] == null) {
        allCheckedMap[element.parentId] = {element.id: element.checkedUserId};
      } else {
        allCheckedMap[element.parentId]![element.id] = element.checkedUserId;
      }
    }

    for (int i = 0; i < resultPhrase.length; i++) {
      await dietGamesRef
          .doc(game.gameOwnerId)
          .collection('userDietGames')
          .doc(game.id)
          .collection('gamePlans')
          .doc(dietPlanId)
          .collection('gameTodos')
          .doc(resultPhrase[i].parentId)
          .update({
        "checkedPhrases": allCheckedMap[
            resultPhrase[i].parentId] //resultPhrase[i].checkedUserId
        //allCheckedMap[resultPhrase[i].parentId]
      });
    }

    //await Future.delayed(const Duration(seconds: 15), () {});

    isSendingScore = false;
    isLoadingLottie = true;
    notifyListeners();
    /* await Future.delayed(const Duration(seconds: 5), () {
      isSendingScore = false;
      isLoadingLottie = true;
      notifyListeners();
    });*/

    /* newCheckedPhrasesOfcurrentUser.forEach((element) {
        if()
 newCheckedMap[element.parentId]={element.id:[currentUserId]};




       });
      
        Map<String,Map<String,String>> newMap={};
  newMap["A"]={"1":"Okan"};
  newMap["A"]={"2":"Okan"};
  
  print (newMap);
  
      for (int i = 0; i < newCheckedPhrasesOfcurrentUser.length; i++) {


        await dietGamesRef
            .doc(game.gameOwnerId)
            .collection('userDietGames')
            .doc(game.id)
            .collection('gameTodos')
            .doc(newCheckedPhrasesOfcurrentUser[i].parentId)
            .update({
         
          "checkedPhrases": {
            newCheckedMap[newCheckedPhrasesOfcurrentUser[i].parentId]: currentUserId
          }
        });
      }*/
  }

  Future<void> setPhraseStatus(ToDoPhrase phrase, int index, bool value) async {
    phrase.isCompleted = value == true ? 1 : 0;
    phrase.isCompleted == 0
        ? phrase.checkedUserId.remove(home.currentUser!.id)
        : !phrase.checkedUserId.contains(home.currentUser!.id)
            ? phrase.checkedUserId.add(home.currentUser!.id)
            : null;
  }

  Future<void> getGames(String ownerId) async {
    User a = home.currentUser!;
    ownerId = home.currentUser!.id!;
    QuerySnapshot snapshot =
        await dietGamesRef.doc(ownerId).collection('userDietGames').get();

    QuerySnapshot snapshot2 =
        await gameInvitationRef.doc(ownerId).collection("gamesFrom").get();

    List<String> gameOwners = [];
    List<String> gameIds = [];

    final List<QueryDocumentSnapshot> gamesDocs2 = snapshot2.docs;
    for (var element in gamesDocs2) {
      gameOwners.add(element.id);
    }

    await Future.forEach(gameOwners, (String element) async {
      QuerySnapshot snapshot3 = await gameInvitationRef
          .doc(ownerId)
          .collection("gamesFrom")
          .doc(element)
          .collection("games")
          .get();
      List<QueryDocumentSnapshot> gamesDocs3 = snapshot3.docs
          .where((element4) => element4['status'] == "Onay")
          .toList();
      for (var element2 in gamesDocs3) {
        gameIds.add(element2['dietId']);
      }
      gamesAndOwners[element] = gameIds;
    });
    List<DocumentSnapshot> gamesDocs4 = [];
    for (var i in gamesAndOwners.entries) {
      for (int k = 0; k < i.value.length; k++) {
        DocumentSnapshot snapshot3 = await dietGamesRef
            .doc(i.key)
            .collection('userDietGames')
            .doc(i.value[k])
            .get();
        gamesDocs4.add(snapshot3);
      }
    }

    //Future.forEach(gamesDocs2, (element) => gameOwners.add(element. .toString()));

    final gamesDocs = snapshot.docs;
    for (var element in gamesDocs) {
      gamesDocs4.add(element);
    }

    DietGame addGame = DietGame(id: "1");
    games = [];
    games2 = [];
    games3 = [];
    games2.add(addGame);

    for (var doc in gamesDocs4) {
      DietGame game = DietGame.fromDocument(doc);
      //checkStatusGame(game);
      games2.add(game);
    }

    games2.forEach((element) {
      setStatusGame(element);

      games.add(element);
      games3.add(element);
    });
    // notifyModel.getActiveStartedGames(games);
  }

  List<DietGame> filterGames(List<String>? result, {bool type = false}) {
    List<DietGame> a = [];
    isFiltered = false;
    if (type) {
      isFiltered = true;

      if (result!.contains("Tümü")) {
        return games3;
      }

      result.forEach((element) {
        for (var element2 in games3) {
          element == element2.status2 ? a.add(element2) : null;
        }
      });

      return a;
    } else
      return games3;
  }

  checkStatusGame(DietGame game) async {
    if (game.endDate!.toDate().compareTo(DateTime.now()) < 0 &&
        game.startDate!.toDate().compareTo(DateTime.now()) < 0) {
      game.status2 = "İnaktif";
    }
  }

  setStatusGame(DietGame game) {
/*Waiting, Started, Cancelled, Inactive, Completed

Waiting: Oyun henüz sahibi tarafından başlatılmadı.
Cancelled: Oyun sahibi tarafından iptal edildi.(oyun sahibi istediği zaman iptal edebilir.)
Started: Oyun sahibi tarfından en geç başlangıç günü bitimine kadar başlatılabilir, başlatılmazsa inaktif olur.
Completed: Oyun başlatıldı ve son gün sonlandıysa completed.
Inactive: Bekliyor ve oyun başlangıç günü geçtiyse.*/

    if (game.status == 'Started' &&
        !(DateTime.utc(game.endDate!.toDate().year,
                    game.endDate!.toDate().month, game.endDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0)) {
      game.status2 = "Başladı";
    } else if (game.status == 'Cancelled') {
      game.status2 = "İptal";
    } else if (game.status == 'Started' &&
        DateTime.utc(game.endDate!.toDate().year, game.endDate!.toDate().month,
                    game.endDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0) {
      game.status2 = "Tamamlandı";
    } else if (game.status == 'Waiting' &&
        DateTime.utc(
                    game.startDate!.toDate().year,
                    game.startDate!.toDate().month,
                    game.startDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0) {
      var a = DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      var b = DateTime.utc(game.startDate!.toDate().year,
          game.startDate!.toDate().month, game.startDate!.toDate().day);
      game.status2 = "İnaktif";
    } else if (game.status == 'Waiting' &&
        DateTime.utc(
                    game.startDate!.toDate().year,
                    game.startDate!.toDate().month,
                    game.startDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) >=
            0) {
      game.status2 = "Bekliyor";
    } else {
      game.status2 = "";
    }
  }

  getStatusGame(DietGame game) {
/*Waiting, Started, Cancelled, Inactive, Completed

Waiting: Oyun henüz sahibi tarafından başlatılmadı.
Cancelled: Oyun sahibi tarafından iptal edildi.(oyun sahibi istediği zaman iptal edebilir.)
Started: Oyun sahibi tarfından en geç başlangıç günü bitimine kadar başlatılabilir, başlatılmazsa inaktif olur.
Completed: Oyun başlatıldı ve son gün sonlandıysa completed.
Inactive: Bekliyor ve oyun başlangıç günü geçtiyse.*/

    if (game.status == 'Started' &&
        !(DateTime.utc(game.endDate!.toDate().year,
                    game.endDate!.toDate().month, game.endDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0)) {
      return const Text('Başladı',
          style: TextStyle(
              overflow: TextOverflow.fade,
              fontFamily: "Poppins",
              fontSize: 10,
              color: Colors.green));
    } else if (game.status == 'Cancelled') {
      return const Text('İptal',
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 10, color: Colors.red));
    } else if (game.status == 'Started' &&
        DateTime.utc(game.endDate!.toDate().year, game.endDate!.toDate().month,
                    game.endDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0) {
      return Container(
        padding: const EdgeInsets.only(right: 10.0),
        child: const Text(
          'Tamamlandı',
          //overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10.0,
            fontFamily: 'Poppins',
            color: Colors.green,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else if (game.status == 'Waiting' &&
        DateTime.utc(
                    game.startDate!.toDate().year,
                    game.startDate!.toDate().month,
                    game.startDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0) {
      return const Text('İnaktif',
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 10, color: Colors.grey));
    } else if (game.status == 'Waiting' &&
        DateTime.utc(
                    game.startDate!.toDate().year,
                    game.startDate!.toDate().month,
                    game.startDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) >=
            0) {
      return const Text('Bekliyor',
          style: TextStyle(
              fontFamily: "Poppins", fontSize: 10, color: Colors.grey));
    } else {
      return const SizedBox();
    }
  }

  bool isCheckable(DietGame game, DateTime selectedDay) {
    // Eğer oyun durumu başladı ise ve gün bugünden büyük değil ise check edebilir.

    var toDay = DateTime.utc(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);

    var day =
        DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);

    if (game.status == 'Started' &&
        game.dayProtection != null &&
        game.dayProtection == false &&
        (toDay.compareTo(day) >= 0) &&
        getStatusGameAsString(game) != "Tamamlandı")
      return true;
    else if (game.status == 'Started' &&
        game.dayProtection != null &&
        game.dayProtection == true &&
        (toDay.compareTo(day) > 0) &&
        getStatusGameAsString(game) != "Tamamlandı") {
      return false;
    } else if (game.status == 'Started' &&
        (toDay.compareTo(day) >= 0) &&
        getStatusGameAsString(game) != "Tamamlandı") {
      return true;
    } else
      return false;
  }

  String getStatusGameAsString(DietGame game) {
/*Waiting, Started, Cancelled, Inactive, Completed

Waiting: Oyun henüz sahibi tarafından başlatılmadı.
Cancelled: Oyun sahibi tarafından iptal edildi.(oyun sahibi istediği zaman iptal edebilir.)
Started: Oyun sahibi tarfından en geç başlangıç günü bitimine kadar başlatılabilir, başlatılmazsa inaktif olur.
Completed: Oyun başlatıldı ve son gün sonlandıysa completed.
Inactive: Bekliyor ve oyun başlangıç günü geçtiyse.*/

    if (game.status == 'Started' &&
        !(DateTime.utc(game.endDate!.toDate().year,
                    game.endDate!.toDate().month, game.endDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0)) {
      return 'Başladı';
    } else if (game.status == 'Cancelled') {
      return 'İptal';
    } else if (game.status == 'Started' &&
        DateTime.utc(game.endDate!.toDate().year, game.endDate!.toDate().month,
                    game.endDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0) {
      return 'Tamamlandı';
    } else if (game.status == 'Waiting' &&
        DateTime.utc(
                    game.startDate!.toDate().year,
                    game.startDate!.toDate().month,
                    game.startDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) <
            0) {
      return 'İnaktif';
    } else if (game.status == 'Waiting' &&
        DateTime.utc(
                    game.startDate!.toDate().year,
                    game.startDate!.toDate().month,
                    game.startDate!.toDate().day)
                .compareTo(DateTime.utc(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)) >=
            0) {
      return 'Bekliyor';
    } else {
      return "";
    }
  }

  Future<void> startGame(String gameId, String gameOwnerId) async {
    await dietGamesRef
        .doc(gameOwnerId)
        .collection("userDietGames")
        .doc(gameId)
        .update({"status": "Started"});
    notifyListeners();
  }

  Future<void> cancelGame(String gameId, String gameOwnerId) async {
    await dietGamesRef
        .doc(gameOwnerId)
        .collection("userDietGames")
        .doc(gameId)
        .update({"status": "Cancelled"});

    notifyListeners();
  }

  Future<void> getDietPlanTodos(String? ownerId, DietGame? game,
      {String? planId}) async {
    QuerySnapshot snapshot = await dietGamesRef
        .doc(ownerId)
        .collection("userDietGames")
        .doc(game!.id)
        .collection("gamePlans")
        .doc(planId!)
        .collection("gameTodos")
        .get();
    var plandocs = snapshot.docs;

    planTodos = [];

    for (var doc in plandocs) {
      DietToDos a = DietToDos.fromDocument(doc);
      planTodos.add(a);
    }
    List<dynamic> keys = [];

    for (var e in planTodos) {
      keys.add(e.startDate!.toDate());
    }

/*    gameTodos.forEach((element) {
      element.id = Uuid().generateV4();
    });
*/
    keys = keys.toSet().toList();

    for (int i = 0; i < keys.length; i++) {
      //gamePlanTodos= Map.fromIterable( gameTodos.where((e) => e.startDateTodo.toDate()==keys[i]),key:(e) => e.startDateTodo.toDate(), value: (e) {gameTodos2.add(e); return gameTodos2; });
      /*gameTaskTitle[dateFormat.format(keys[i])] = plandocs
          .where((element) => element['startDate'].toDate() == keys[i])
          .first['taskTitle'];*/
      gamePlanTodos[dateFormat.format(keys[i])] = planTodos
          .where((e) =>
              dateFormat.format(e.startDate!.toDate()) ==
              dateFormat.format(keys[i]))
          .cast<DietToDos>()
          .toList();
      gamePlanTodos[dateFormat.format(keys[i])]!
          .sort((a, b) => a.rank!.compareTo(b.rank!));
    }

    createPhraseObjetsFromTodos(game.id!, ownerId!);

    notifyListeners();
  }

  Future<void> getGameTodos(String? ownerId, String? gameId) async {
    QuerySnapshot snapshot = await dietGamesRef
        .doc(ownerId)
        .collection("userDietGames")
        .doc(gameId)
        .collection("gameTodos")
        .get();
    final todoDocs = snapshot.docs;
    gameTodos = [];
    List<dynamic> keys = [];
    gamePlanTodos = {};
    for (var doc in todoDocs) {
      DietToDos a = DietToDos.fromDocument(doc);
      gameTodos.add(a);
    }

    for (var e in gameTodos) {
      keys.add(e.startDate!.toDate());
    }

/*    gameTodos.forEach((element) {
      element.id = Uuid().generateV4();
    });
*/
    keys = keys.toSet().toList();

    for (int i = 0; i < keys.length; i++) {
      //gamePlanTodos= Map.fromIterable( gameTodos.where((e) => e.startDateTodo.toDate()==keys[i]),key:(e) => e.startDateTodo.toDate(), value: (e) {gameTodos2.add(e); return gameTodos2; });
      gameTaskTitle[dateFormat.format(keys[i])] = todoDocs
          .where((element) => element['startDate'].toDate() == keys[i])
          .first['taskTitle'];
      gamePlanTodos[dateFormat.format(keys[i])] =
          gameTodos.where((e) => e.startDate!.toDate() == keys[i]).toList();
      gamePlanTodos[dateFormat.format(keys[i])]!
          .sort((a, b) => a.rank!.compareTo(b.rank!));
    }

    createPhraseObjetsFromTodos(gameId!, ownerId!);

    notifyListeners();
  }

  checkPhrases(String ownerId, String gameId) async {
    phrasesFrom = [];
    List<QueryDocumentSnapshot> docSnaps = [];
    QuerySnapshot snapshot2;
    for (int i = 0; i < gameTodos.length; i++) {
      snapshot2 = await dietGamesRef
          .doc(ownerId)
          .collection("userDietGames")
          .doc(gameId)
          .collection("gameTodos")
          .doc(gameTodos[i].id)
          .collection("checkedBy")
          .doc(home.currentUser!.id)
          .collection("phrases")
          .get();
      for (var element in snapshot2.docs) {
        docSnaps.add(element);
      }
    }
    docSnaps != null
        ? docSnaps.forEach((doc) {
            ToDoPhrase phrase = ToDoPhrase.fromDocument(doc);
            phrasesFrom.add(phrase);
          })
        : null;

    //gamePlanTodos= Map.fromIterable(gameTodos,key:(e) => e.startDateTodo, value: (e) {gameTodos2.add(e); return gameTodos2; });
    notifyListeners();
  }

  Future<void> gameInvitationStatus(String gameOwnerId, String dietId,
      {String? type}) async {
    await gameInvitationRef
        .doc(home.currentUser!.id)
        .collection("gamesFrom")
        .doc(gameOwnerId)
        .set({
      "gameOwnerId": gameOwnerId,
    });

    await gameInvitationRef
        .doc(home.currentUser!.id)
        .collection("gamesFrom")
        .doc(gameOwnerId)
        .collection("games")
        .doc(dietId)
        .set({
      "dietId": dietId,
      "gameOwnerId": gameOwnerId,
      "status": type == "1" ? "Onay" : "Red",
    });
    await gameInvitationToRef
        .doc(home.currentUser!.id)
        .collection("invitationFrom")
        .doc(dietId)
        .delete();
    notifyListeners();
  }

  String? checkMandatoryFields(
      String title, File image, DateTime start, DateTime end) {}

  Future<void> getMemberStatus(
      List<dynamic> memberIds, String id, String ownerId,
      {List<User>? gameMembers}) async {
    usersNoResponse = [];
    usersApproved = [];
    usersDenied = [];
    final doc = await _friendRequestService.getProfileUser(ownerId);
    gameOwner = User.fromDocument(doc);
    await getGameMembers(memberIds);

    await Future.forEach(memberIds, (element) async {
      String e = element.toString();
      DocumentSnapshot memberDoc = await gameInvitationRef
          .doc(e)
          .collection("gamesFrom")
          .doc(ownerId)
          .collection("games")
          .doc(id)
          .get();
      if (memberDoc.exists && memberDoc['status'] == "Onay") {
        for (var element2 in this.gameMembers) {
          element2.id == element ? usersApproved.add(element2) : null;
        }
      } else if (memberDoc.exists && memberDoc['status'] == "Red") {
        for (var element2 in this.gameMembers) {
          element2.id == element ? usersDenied.add(element2) : null;
        }
      } else if (memberDoc.exists) {
        for (var element2 in this.gameMembers) {
          element2.id == element ? usersNoResponse.add(element2) : null;
        }
      }
    });
    home.currentUser!.id != gameOwner!.id
        ? usersApproved.add(gameOwner!)
        : null;

    //notifyListeners();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<void> getChallenges(String currentUser) async {
    QuerySnapshot snapshot = await gameInvitationToRef
        .doc(currentUser)
        .collection("invitationFrom")
        .get();
    final gamesDocs = snapshot.docs;
    invitedGames = [];
    for (var doc in gamesDocs) {
      DietGame game = DietGame.fromDocument(doc);
      invitedGames.add(game);
    }
  }

  void isRefreshedControl() {
    isRefreshed = true;
    notifyListeners();
  }

  void addMember(User user) {
    members.add(user);
    notifyListeners();
  }

  void addMembers() {
    var a = dietPlansList;
    /*List a = [
      Person("okan", "er"),
      Person("can", "er"),
      Person("ali", "er"),
    ];
    List b = [Person("imren", "er"), Person("can", "er")];

    b.forEach((e) {
      bool i = true;
      a.any((k) => k.ad == e.ad) ? i = false : null;
      i == true ? a.add(e) : null;
    });

    a.forEach((m) => print(m.ad.toString() + "," + m.soyad.toString()));*/

    members = [];

    for (var l in selectedUsers) {
      int i = 0;
      members.any((e) => e.id == l!.id) ? i += 1 : null;
      i == 0 ? members.add(l!) : null;
    }
    members.forEach((User a) {
      int i = 0;
      User c = User(
          id: a.id,
          bio: a.bio,
          displayName: a.displayName,
          email: a.email,
          isAdmin: a.isAdmin,
          isDietician: a.isDietician,
          isProMember: a.isProMember,
          photoUrl: a.photoUrl,
          proEndDate: a.proEndDate,
          proStartDate: a.proStartDate,
          username: a.username);
      selectedMembers.any((e) => e.id == c.id) ? i += 1 : null;
      i == 0 ? selectedMembers.add(c) : null;
    });
    //  selectedUsers = [];
    notifyListeners();
  }

  void addMembers2() {
    var a = dietPlansList;
    members = [];
    selectedUsers = [];
    for (var element in selectedMembers) {
      int i = 0;
      members.any((e) => e.id == element.id) ? i += 1 : null;
      i == 0 ? members.add(element) : null;
    }
    members.forEach((User a) {
      int i = 0;
      User c = User(
          id: a.id,
          bio: a.bio,
          displayName: a.displayName,
          email: a.email,
          isAdmin: a.isAdmin,
          isDietician: a.isDietician,
          isProMember: a.isProMember,
          photoUrl: a.photoUrl,
          proEndDate: a.proEndDate,
          proStartDate: a.proStartDate,
          username: a.username);
      selectedUsers.any((e) => e!.id == c.id) ? i += 1 : null;
      i == 0 ? selectedUsers.add(c) : null;
    });

    // members.add(users);
    notifyListeners();
  }

  getFriendsExceptMembers(List<User> friends) {
    friendsNoMembers = [];
    for (var m in members) {
      friends.removeWhere((f) => f.id == m.id);
    }

    friendsNoMembers = friends;
  }

  Future<void> getGameDiet(String id) async {
    final doc = await home.dietTasksRef
        .doc(home.currentUser!.id)
        .collection('userDietTasks')
        .doc(id)
        .get();

    DietTask task = DietTask.fromDocument(doc);
    selectedTask = task;
  }

  Future<List<DietGame>> searchGames(String query) async {
    var val = await dietGamesRef
        .doc(adminId)
        .collection('userDietGames')
        .where("indexes", arrayContains: query.toLowerCase())
        .get();

    List<DietGame> searchResults = [];
    val.docs.forEach((doc) {
      DietGame game = DietGame.fromDocument(doc);

      searchResults.add(game);
    });
    final suggestionList = searchResults
        .where((p) => p.title!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return suggestionList;
  }

  Future<void> getGameMembers(List<dynamic> memberIds) async {
    gameMembers = [];
    for (var memberId in memberIds) {
      final friendDoc = await _friendRequestService.getProfileUser(memberId);
      User friendUser = User.fromDocument(friendDoc);
      gameMembers.add(friendUser);
      debugPrint('profile snapshot finished');
    }
  }

  saveGame(
      {Map<dynamic, String?>? savedTaskTitle,
      Map<dynamic, List<DietToDos>?>? savedDailyPlanTodos,
      bool? dayProtection}) async {
    _savedTaskTitle = savedTaskTitle!;
    _savedDailyPlanTodos = savedDailyPlanTodos!;

    List<String> memberIds = [];

    for (var element in members) {
      memberIds.add(element.id!);
    }

    gameTasks = {};

    DietGame dietGame = DietGame(
        title: gameTitle,
        phrase: gamePhrase ?? "",
        startDate: Timestamp.fromDate(startTime),
        endDate: Timestamp.fromDate(endTime),
        trackKPIs: trackKPIs,
        memberIds: memberIds,
        imageTitleUrl: imageUrl,
        dietId: dietId,
        isActive: isActive,
        gameOwnerId: gameOwnerId,
        dayProtection: dayProtection,
        status: status);

    /* trackKPIs.contains("Adım")
        ? await stepGamesRef.doc(dietGame.id).set({
            "title": dietGame.title,
            "Id": dietGame.id,
            "phrase": dietGame.phrase,
            "startDate": dietGame.startDate,
            "endDate": dietGame.endDate,
            "trackKPIs": dietGame.trackKPIs,
            "memberIds": dietGame.memberIds,
            "stepMap": null
          })
        : null;*/

    await dietGamesRef
        .doc(home.currentUser!.id)
        .collection('userDietGames')
        .doc(dietGame.id)
        .set({
      "title": dietGame.title,
      "Id": dietGame.id,
      "phrase": dietGame.phrase,
      "startDate": dietGame.startDate,
      "endDate": dietGame.endDate,
      "trackKPIs": dietGame.trackKPIs,
      "memberIds": dietGame.memberIds,
      "imageTitleUrl": dietGame.imageTitleUrl,
      "dietId": dietGame.id,
      "isActive": dietGame.isActive,
      "gameDuration": dietGame.gameDuration,
      "isAdminPrepared": dietGame.isAdminPrepared,
      "isAdminTested": dietGame.isAdminTested,
      "isDieticianPrepared": dietGame.isDieticianPrepared,
      "isProPrepared": dietGame.isProPrepared,
      "gameOwnerId": dietGame.gameOwnerId,
      "dayProtection": dietGame.dayProtection,
      "status": dietGame.status,
    });

//benim kodum
    List<Map<dynamic, List<DietToDos>?>> dailyEventsM = [];

    dietPlansList.forEach((element) {
      dailyEventsM.add(element.dailyEvents);
    });

    List<String> planIds = [];

    for (var element in dailyEventsM) {
      var id = Uuid().generateV4();
      planIds.add(id);
      for (var a in element.entries) {
        for (var b in a.value!) {
          uID = Uuid().generateV4();
          await dietGamesRef
              .doc(home.currentUser!.id)
              .collection('userDietGames')
              .doc(dietGame.id)
              .collection('gamePlans')
              .doc(id //Uuid().generateV4()
                  //k.value[x].id
                  )
              .collection('gameTodos')
              .doc(uID)
              .set({
            //"taskId": task.id,
            "Id": uID, //k.value[x].id,
            "title": b.title,
            "phrases": b.phrases,
            "Rank": b.rank,
            "startDate": DateTime(
                a.key.year,
                a.key.month,
                a.key.day,
                b.startDate!.toDate().hour,
                b.startDate!.toDate().minute,
                b.startDate!.toDate().second),
            "endDate": DateTime(
                a.key.year,
                a.key.month,
                a.key.day,
                b.endDate!.toDate().hour,
                b.endDate!.toDate().minute,
                b.endDate!.toDate().second),
            //"startDate": a.key, //DateTime.parse(k.key),
            //"startDateToDo": b.startDate,
            //"endDate": b.endDate,
            // "taskTitle": i.value
          });
        }
      }
    }

    await dietGamesRef
        .doc(home.currentUser!.id)
        .collection('userDietGames')
        .doc(dietGame.id)
        .update({"planIds": planIds});

/*
// gameTodo ların set edildiği yer
    for (var i in _savedTaskTitle.entries)
      for (var k in _savedDailyPlanTodos.entries
          .where((element) => element.key == i.key)) {
        for (int x = 0; x < k.value!.length; x++) {
          uID = Uuid().generateV4();
          await dietGamesRef
              .doc(home.currentUser!.id)
              .collection('userDietGames')
              .doc(dietGame.id)
              .collection('gameTodos')
              .doc(uID //Uuid().generateV4(
                  //k.value[x].id
                  )
              .set({
            //"taskId": task.id,
            "Id": uID, //k.value[x].id,
            "title": k.value![x].title,
            "phrases": k.value![x].phrases,
            "Rank": k.value![x].rank,
            "startDate": k.key, //DateTime.parse(k.key),
            "startDateToDo": k.value![x].startDate,
            "endDate": k.value![x].endDate,
            "taskTitle": i.value
          });
        }
      }*/

    /* for (var i in _savedTaskTitle.entries)
      for (var k in _savedDailyPlanTodos.entries
          .where((element) => element.key == i.key))
        for (int x = 0; x < k.value.length; x++)
          await dietGamesRef
              .doc(currentUser.id)
              .collection('userDietGames')
              .doc(dietGame.id)
              .collection('gameTodos')
              .doc(Uuid().generateV4())
              .set({
            //"taskId": task.id,
            "todoId": k.value[x].id,
            "title": k.value[x].title,
            "phrases": k.value[x].phrases,
            "Rank": k.value[x].rank,
            "startDateTodo": DateTime.parse(k.key),
            "taskTitle": i.value
          });*/

//davet
    await Future.forEach(memberIds, (String element) async {
      await gameInvitationToRef
          .doc(element)
          .collection("invitationFrom")
          .doc(dietGame.id)
          .set({
        "title": dietGame.title,
        "Id": dietGame.id,
        "phrase": dietGame.phrase,
        "startDate": dietGame.startDate,
        "endDate": dietGame.endDate,
        "trackKPIs": dietGame.trackKPIs,
        "memberIds": dietGame.memberIds,
        "imageTitleUrl": imageUrl,
        "dietId": dietGame.dietId,
        "isActive": dietGame.isActive,
        "gameDuration": gameDuration,
        "isAdminPrepared": dietGame.isAdminPrepared,
        "isAdminTested": dietGame.isAdminTested,
        "isDieticianPrepared": dietGame.isDieticianPrepared,
        "isProPrepared": dietGame.isProPrepared,
        "gameOwnerId": gameOwnerId,
        "status": dietGame.status
      });
    });

    await Future.forEach(memberIds, (String element) async {
      await gameInvitationRef
          .doc(element)
          .collection("gamesFrom")
          .doc(dietGame.gameOwnerId)
          .collection("games")
          .doc(dietGame.id)
          .set({
        "title": dietGame.title,
        "Id": dietGame.id,
        "phrase": dietGame.phrase,
        "startDate": dietGame.startDate,
        "endDate": dietGame.endDate,
        "trackKPIs": dietGame.trackKPIs,
        "memberIds": dietGame.memberIds,
        "imageTitleUrl": imageUrl,
        "dietId": dietGame.dietId,
        "isActive": dietGame.isActive,
        "gameDuration": gameDuration,
        "isAdminPrepared": dietGame.isAdminPrepared,
        "isAdminTested": dietGame.isAdminTested,
        "isDieticianPrepared": dietGame.isDieticianPrepared,
        "isProPrepared": dietGame.isProPrepared,
        "gameOwnerId": gameOwnerId,
        "status": dietGame.status
      });
    });

    List<String> indexes = [];
    for (int i = 1; i <= dietGame.title!.length; i++) {
      String subString = dietGame.title!.substring(0, i).toLowerCase();
      indexes.add(subString);
    }

    await dietGamesRef
        .doc(home.currentUser!.id)
        .collection('userDietGames')
        .doc(dietGame.id)
        .update({"indexes": indexes});

    /*for (var i in gamePlanTask.entries) {
      DietTask task = DietTask(title: i.value.title);
      await dietGamesRef
          .doc(currentUser.id)
          .collection('userDietGames')
          .doc(dietGame.id)
          .collection('gameTasks')
          .doc(task.id)
          .set({"title": task.title});

      gameTasks[i.key] = task.id;
    }

    for (var k in gameTasks.entries)
      for (var i in this
          .gamePlanTodos
          .entries
          .where((element) => element.key == k.key))
        for (int x = 0; x < i.value.length; x++)
          await dietGamesRef
              .doc(currentUser.id)
              .collection('userDietGames')
              .doc(dietGame.id)
              .collection('gameTasks')
              .doc(k.value)
              .collection('gameTodos')
              .doc(i.value[x].id)
              .set({
            // "parentId": task.id,
            //"Id": i.value[x].id,
            "title": i.value[x].title,
            "phrase": i.value[x].phrase,
            "Rank": x
            //"startDateTodo": todos2[i].startDateTodo
          });

    await dietGamesRef
        .doc(currentUser.id)
        .collection('userDietGames')
        .doc(dietGame.id)
        .set({
      "title": dietGame.title,
      "Id": dietGame.id,
      "phrase": dietGame.phrase,
      "startDate": dietGame.startDate,
      "endDate": dietGame.endDate,
      "trackKPIs": dietGame.trackKPIs,
      "memberIds": dietGame.memberIds,
      "imageTitleUrl": dietGame.imageTitleUrl,
      "dietId": dietGame.dietId,
      "isActive": dietGame.isActive,
      "gameTasks": this.gameTasks
    });
    this.selectedGame =dietGame;*/
    notifyListeners();
  }

  Future<void> loadGames(String ownerId) async {
    await getGames(ownerId);
    isLoaded = true;
    debugPrint('load games finished');
    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }

  getDietCoverImages() async {
    listUrls = [];

    ListResult listData = await storageRef.child("Diets").listAll();

    await Future.forEach(listData.items, (Reference element) async {
      await element.getDownloadURL().then((value) => listUrls.add(value));
    });

    debugPrint(listUrls.hashCode.toString());
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

    await getDietCoverImages();
    var length = listUrls.length;
    Random random = Random();
    int randomNumber = random.nextInt(length);

    randomImageUrl = listUrls[randomNumber];

    fromRandFuture = false;
    imageUrl = randomImageUrl;
    fromFitGallery = true;
    //taskModel.imageBeforeSave = file;

    return randomImageUrl;
  }

  Widget imageWidget({Future<Object>? future, File? image}) {
    if (fromRandFuture) {
      return FutureBuilder<Object>(
          future: future,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                return Stack(
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                          color: AppColors.kRipple.withOpacity(0.3),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          )),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: FadeInImage.memoryNetwork(
                            fit: BoxFit.cover,
                            image: snapshot.data,
                            placeholder: kTransparentImage,
                          )),
                    ),
                    const Positioned(
                      right: 0,
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child:
                          Icon(Icons.camera_alt, size: 35, color: Colors.white),
                    )
                  ],
                );
              }
            }
            return const Center(
                child: SpinKitThreeBounce(color: AppColors.kRipple, size: 20));
          });
    } else if (fromPhoneGallery || fromPhoneCamera) {
      return Stack(children: [
        Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
                color: AppColors.kRipple.withOpacity(0.3),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                )),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.file(
                  File(image!.path),
                  //width: 300,
                  //height: 200,
                  fit: BoxFit.cover,
                )))
      ]);
    } else if (fromFitGallery) {
      return Stack(children: [
        Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
                color: AppColors.kRipple.withOpacity(0.3),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                )),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                image: imageUrl,
                placeholder: kTransparentImage,
                imageErrorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey.withOpacity(0.2)),
              ),
            ))
      ]);
    } else {
      return const SizedBox();
    }
  }

  void savePlan(DietTaskViewModel? taskmodel) {
    var planId = Uuid().generateV4();
    dietPlansList = [];
    if ((taskmodel!.planId != null)) {
      dietPlans[taskmodel.planId!] = taskmodel;
    } else if (taskmodel.planId == null) {
      taskmodel.planId = planId;
      dietPlans[planId] = taskmodel;
    }
    dietPlans.forEach((key, value) {
      dietPlansList.add(value);
    });
  }
}
