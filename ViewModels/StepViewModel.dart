// ignore_for_file: file_names, unrelated_type_equality_checks, unnecessary_null_comparison, non_constant_identifier_names, prefer_if_null_operators
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/admobTest/ad_helper.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:friendfit_ready/models/stepPhrase.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/FriendRequest/FriendRequestService.dart';
import 'package:friendfit_ready/services/navigationService.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/models/user.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:friendfit_ready/models/todoPhrase.dart';
import 'package:health/health.dart';

import 'package:permission_handler/permission_handler.dart';

final dietGamesRef = FirebaseFirestore.instance.collection('dietGames');
final gameInvitationToRef =
    FirebaseFirestore.instance.collection('gameInvitationTo');
final gameInvitationRef =
    FirebaseFirestore.instance.collection('gameInvitation');
HealthFactory health = HealthFactory();
final userStepsRef = FirebaseFirestore.instance.collection('userSteps');
final userWalletRef = FirebaseFirestore.instance.collection('userWallet');

class StepViewModel extends ChangeNotifier {
  Timer? timer;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  Map<String, Map<String, int>?> membersSteps = {};
  List<DietGame> games = [];
  List<DietGame> invitedGames = [];
  List<User> members = [];
  List<User> gameMembers = [];
  bool isLoaded = false;
  bool isActive = false;
  bool isSaved = false;
  bool isTodoLoaded = false;
  bool isEdited = false;
  String? gameOwnerId;
  String? gameTitle;
  String? gamePhrase;
  String dietId = "";
  String? status;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  List<String> trackKPIs = [];
  List<String> trackKPI_Names = [];
  String? imageUrl;
  List<User>? friendsNoMembers;
  DietTask? selectedDiet;
  int? gameDuration;
  bool? isRefreshed;
  DietTask? selectedTask;
  Map<dynamic, DietTask> gamePlanTask = {};
  Map<dynamic, List<DietToDos>> gamePlanTodos = {};
  Map<dynamic, String> gameTasks = {};
  int todayConvertedStepsByDoc = 0;
  DietGame? selectedGame; //=new DietGame();
  File? imageBeforeSave;
  Map<dynamic, String> gameTaskTitle = {};
  String taskTitle = "";
  Map<String, List<String>> gamesAndOwners = {};
  List<User> usersApproved = [];
  List<User> usersDenied = [];
  List<User> usersNoResponse = [];
  bool isCompleted = false;
  List<ToDoPhrase> phrases = [];
  Map<String, List<ToDoPhrase>> a = {};
  List<ToDoPhrase> phrases2 = [];
  List<ToDoPhrase> phrasesFrom = [];
  List<User> scoreUsers = [];
  List<DietToDos> gameTodos = [];
  Map<String, List<ToDoPhrase>> userScores = {};
  Map<String, int> userScoresCompleted = {};
  User selectedOpponent = User(id: null);
  List<ToDoPhrase> timeLinePhrases = [];
  List<HealthDataPoint> resultStep = [];
  List<HealthDataPoint> resultDistance = [];
  List<HealthDataPoint> resultEnergy = [];
  Map<String, double> typeScores = {
    "HealthDataType.ACTIVE_ENERGY_BURNED": 0,
    "HealthDataType.MOVE_MINUTES": 0,
    "HealthDataType.BASAL_ENERGY_BURNED": 0,
    "HealthDataType.DISTANCE_DELTA": 0,
    "HealthDataType.DISTANCE_WALKING_RUNNING": 0,
    "HealthDataType.STEPS": 0
  };
  List<HealthDataPoint> results = [];
  List<HealthDataPoint> results2 = [];

  DocumentSnapshot? stepDoc;

  bool permissionsGiven = false;
  DateTime? rangeStart;

  DateTime? rangeEnd;
  bool _disposed = false;

  Map<int, double> chartData = {};
  int? todaySteps;
  int? convertedSteps;
  double? earnedCoin;
  bool convertible = true;
  int convertibleSteps = 0;
  bool maxLimit = false;
  String alertMsg = "";
  String alertMsg2 = "";
  int totalSteps = 0;
  int totalSteps_Opponent = 0;

  final types = [
    // HealthDataType.BLOOD_GLUCOSE,
    // HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.MOVE_MINUTES,
    //HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
    //HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.STEPS,

    //HealthDataType.BLOOD_GLUCOSE,
    // Uncomment this line on iOS - only available on iOS
    // HealthDataType.DISTANCE_WALKING_RUNNING,
  ];

  List<HealthDataPoint> _healthDataList = [];
  bool isWaiting = true;
  List<StepPhrase> stepPhraseList = [];
  List<StepPhrase> stepPhraseListOpposite = [];
  Map<String, int> convertedStepsMap = {};
  Map<String, double> earnedCoinsMap = {};
  Map<String, dynamic>? stepHist = {};
  double walletCoin = 0;
  RewardedAd? _rewardedAd;

  firstRange() {
    final date = DateTime.now();

    final weekDay = date.weekday == 7 ? 0 : date.weekday;

    rangeStart = getDate(date.subtract(Duration(days: weekDay - 1)));
    rangeEnd =
        getDate(date.add(Duration(days: DateTime.daysPerWeek - weekDay)));
    var rangestartCopy = rangeStart;

    if (date.isBefore(rangeStart!)) {
      rangeStart = rangeStart!.subtract(const Duration(days: 7));
      rangeEnd = rangestartCopy!.subtract(const Duration(days: 1));
    }
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  changeRangeBack() {
    var rangestartCopy = rangeStart;
    rangeStart = rangeStart!.subtract(const Duration(days: 7));
    rangeEnd = rangestartCopy!.subtract(const Duration(days: 1));

    // notifyListeners();
  }

  changeRangeForward() {
    var rangeEndCopy = rangeEnd;
    rangeEnd = rangeEnd?.add(const Duration(days: 7));
    rangeStart = rangeEndCopy?.add(const Duration(days: 1));

    notifyListeners();
  }

  Future<bool> callPermissionRequest() async {
    final permissionStatus = await Permission.activityRecognition.request();

    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      debugPrint("false");
      return false;
    } else {
      debugPrint("true");
      return true;
    }
  }

  Future<bool> requestPermission(Permission setting) async {
    // setting.request() will return the status ALWAYS
    // if setting is already requested, it will return the status
    final _result = await setting.request();
    switch (_result) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        return false;
    }
  }

  Future<bool> readPermissions() async {
    bool check = false;
    if (Platform.isAndroid) {
      final permissionStatus = Permission.activityRecognition.request();
      if (await permissionStatus.isDenied ||
          await permissionStatus.isPermanentlyDenied) {
        debugPrint("Red durumda");
        timer?.cancel();
        await serviceLocator<NavigationService>().openDialog();
        // check = await serviceLocator<NavigationService>().openDialog();
        //check == true ? readPermissions() : null;

        /* showToast(
        'activityRecognition permission required to fetch your steps count');*/
        return false;
      }
    }
    debugPrint("izin verildi");
    !timer!.isActive
        ? timer = Timer.periodic(
            const Duration(seconds: 10), (Timer t) => getStepDataToday_F())
        : null;
    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    bool requested =
        await health.requestAuthorization(types, permissions: permissions);
    return requested;

    /* try {
      final responses = await FitKit.hasPermissions([
        DataType.HEART_RATE,
        DataType.STEP_COUNT,
        DataType.HEIGHT,
        DataType.WEIGHT,
        DataType.DISTANCE,
        DataType.ENERGY,
        DataType.WATER,
        DataType.SLEEP,
        DataType.STAND_TIME,
        DataType.EXERCISE_TIME
      ]);

      if (!responses) {
        final value = await FitKit.requestPermissions([
          DataType.HEART_RATE,
          DataType.STEP_COUNT,
          DataType.HEIGHT,
          DataType.WEIGHT,
          DataType.DISTANCE,
          DataType.ENERGY,
          DataType.WATER,
          DataType.SLEEP,
          DataType.STAND_TIME,
          DataType.EXERCISE_TIME
        ]);

        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print(e);
      return false;*/
  }

  Future<void> getBalance() async {
    DocumentSnapshot walletDoc = await userWalletRef.doc(currentUser!.id).get();

    walletDoc != null ? walletCoin = double.parse(walletDoc['balance']) : 0;
    notifyListeners();
  }

  hello() {
    debugPrint("hello");
    getStepDataToday_F();
    //getStepDataToday();
  }

  Future<bool> checkPermission() async {
    permissionsGiven = await readPermissions();
    return permissionsGiven;
  }

  Future<void> getStepDataToday_F() async {
    if (permissionsGiven) {
      //await Future.delayed(const Duration(seconds: 10000000));
      await calculation(today: true);
      //await calculation(today: true, type: HealthDataType.DISTANCE_WALKING_RUNNING);
      // await calculation(today: true, type: HealthDataType.ACTIVE_ENERGY_BURNED);
      typeScores == null ? typeScores = {} : null;
      // await checkConvertible();
      // await checkWallet();

      notifyListeners();
    }
  }

  Future<void> _loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;

              _loadRewardedAd();
            },
          );

          _rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  Stream<Map<String, double>> getStepDataToday() async* {
    bool permissionsGiven = await readPermissions();

    if (permissionsGiven) {
      //await Future.delayed(const Duration(seconds: 10000000));
      await calculation(today: true);
      //await calculation(today: true, type: HealthDataType.DISTANCE_WALKING_RUNNING);
      // await calculation(today: true, type: HealthDataType.ACTIVE_ENERGY_BURNED);
      typeScores == null ? typeScores = {} : null;

      yield typeScores;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  calculation(
      {bool today = false,
      DateTime? from,
      DateTime? to,
      HealthDataType? type}) async {
    DateTime current = DateTime.now();
    double totalCal = 0;
    double totalMin = 0;
    double totalDist = 0;
    int? steps = 0;
    if (today == true) {
      from = current.subtract(Duration(
        hours: current.hour,
        minutes: current.minute,
        seconds: current.second,
      ));
      to = DateTime.now();
    }

    /*
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.MOVE_MINUTES,
    //HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
    */

    _healthDataList = [];
    totalCal = 0;
    totalMin = 0;
    totalDist = 0;
    typeScores["HealthDataType.ACTIVE_ENERGY_BURNED"] = totalCal;
    typeScores["HealthDataType.MOVE_MINUTES"] = totalMin;
    typeScores["HealthDataType.DISTANCE_DELTA"] =
        (totalDist.round() / 1000).toDouble();
    typeScores["HealthDataType.STEPS"] = steps.toDouble();
    //todaySteps = 0;
    /*if (today = true) {
      steps = await health.getTotalStepsInInterval(from!, to!);
      todaySteps = steps ?? 0;
    }*/
    steps = await health.getTotalStepsInInterval(from!, to!) ?? 0;
    today == true ? todaySteps = steps : null;
    List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(from, to, types);
    _healthDataList.addAll(healthData);
    _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

    _healthDataList.forEach((x) {
      if (x.type.toString() == "HealthDataType.ACTIVE_ENERGY_BURNED") {
        totalCal = totalCal + x.value.round().toDouble();
      } else if (x.type.toString() == "HealthDataType.MOVE_MINUTES") {
        totalMin += x.value.round().toDouble();
      } else if (x.type.toString() == "HealthDataType.DISTANCE_DELTA") {
        totalDist += x.value.round().toDouble();
      } else {
        null;
      }
    });
    typeScores["HealthDataType.ACTIVE_ENERGY_BURNED"] = totalCal;
    typeScores["HealthDataType.MOVE_MINUTES"] = totalMin;
    typeScores["HealthDataType.DISTANCE_DELTA"] =
        (totalDist.round() / 1000).toDouble();
    typeScores["HealthDataType.STEPS"] = steps.toDouble();

    //typeScores[type.toString()] = steps == null ? 0 : steps.toDouble();
    //double total = 0;

    /* for (FitData datasw in results) {
      total += datasw.value.toDouble();
    }
    if (type == DataType.DISTANCE) {
      total = (total / 1000);
      total = roundDouble(total, 2);
    }
    this.typeScores[type.toString()] = total;*/
  }

  getStepRange() async {
    int? steps;
    for (int i = 0; i < 7; i++) {
      var to = rangeStart!.add(Duration(days: i));
      var from = to.subtract(Duration(
        hours: to.hour,
        minutes: to.minute,
        seconds: to.second,
      ));
      var to2 = DateTime(to.year, to.month, to.day, 23, 59, 59);

      steps = await health.getTotalStepsInInterval(from, to2) ?? 0;

      chartData[i] = to.compareTo(DateTime.now()) < 0 ? steps.toDouble() : -1;
    }

    //notifyListeners();
  }

  refresh() {
    notifyListeners();
  }

  Future getGameMemberStepsOpponent(
      String id, DateTime start, DateTime end) async {
    // Map<String, Map<String, int>?> membersSteps = {};
    /* totalSteps_Opponent = 0;
    // Bulunduğumuz tarih
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    List<String> datesBetweenString = [];
    List<DateTime> datesBetween = [];
    DateTime start_ = DateTime(start.year, start.month, start.day);

    DateTime end_ = DateTime(end.year, end.month, end.day);
    int days = end.difference(start).inDays;

    for (int i = 0; i <= days; i++) {
      var startX = start.add(Duration(days: i));
      datesBetweenString.add(DateFormat('yyyy-MM-dd').format(startX));
    }
    for (int i = 0; i <= days; i++) {
      var startX = start.add(Duration(days: i));
      datesBetween.add(startX);
    }

    DateTime yesterdayStart = DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day - 1, 00, 00, 00);
    DateTime yesterdayEnd = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - 1, 23, 59, 59);

    DocumentSnapshot stepDoc = await userStepsRef.doc(id).get();
    var yesterdayString = DateFormat('yyyy-MM-dd').format(yesterdayStart);

    if (stepDoc.exists && (stepDoc.data() as Map).containsKey('stepHist')) {
      stepHist = stepDoc['stepHist'];

      datesBetweenString.forEach((element) {
        if (stepHist!.containsKey(element)
            //&& stepHist![element] != 0
            //&& stepHist![element] != -1
            &&
            element != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          int steps = stepHist![element] as int;
          totalSteps_Opponent += (steps == null || steps == -1) ? 0 : steps;
          // ignore: curly_braces_in_flow_control_structures
          if (!membersSteps.containsKey(id)) {
            membersSteps[id] = {element: stepHist![element]};
          } else {
            membersSteps[id]!.addAll({element: stepHist![element]});
          }
        } else if (element == today) {
// Bulunduğumuz gün için en son saati bul
          {
            String latestKey = '';
            stepHist!.forEach((key, value) {
              if (key.startsWith(today)) {
                if (latestKey == '' || key.compareTo(latestKey) > 0) {
                  latestKey = key;
                }
              }
            });
            if (latestKey != '') {
              membersSteps[id]!.addAll({latestKey: stepHist![latestKey]});
            } else {
              debugPrint('Bugün için kayıt bulunamadı.');
            }
          }
        } else {
          if (!membersSteps.containsKey(id)) {
            membersSteps[id] = {element: -1};
          } else {
            membersSteps[id]!.addAll({element: -1});
          }
        }
      });
    }

   
    stepPhraseListOpposite = [];

    for (var i in membersSteps.entries) {
      if (i.key == id) {
        i.value!.forEach((key, value) {
          StepPhrase y =
              StepPhrase(isLeft: false, steps: value, steppedDate: key, id: id);
          //stepPhraseList.add(y);
          stepPhraseListOpposite.add(y);
        });
      }
    }*/
    totalSteps_Opponent = 0;
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Tarih aralığını oluştur
    List<String> datesBetweenString = [];
    DateTime start_ = DateTime(start.year, start.month, start.day);
    DateTime end_ = DateTime(end.year, end.month, end.day);
    int days = end_.difference(start_).inDays;

    for (int i = 0; i <= days; i++) {
      var date = start_.add(Duration(days: i));
      datesBetweenString.add(DateFormat('yyyy-MM-dd').format(date));
    }

    // Firebase'den adım verilerini çek
    DocumentSnapshot stepDoc = await userStepsRef.doc(id).get();
    if (stepDoc.exists && (stepDoc.data() as Map).containsKey('stepHist')) {
      var stepHist = stepDoc['stepHist'] as Map<String, dynamic>;

      for (String date in datesBetweenString) {
        if (stepHist.containsKey(date) && date != today) {
          int steps = stepHist[date] as int;
          totalSteps_Opponent += (steps == -1) ? 0 : steps;

          if (!membersSteps.containsKey(id)) {
            membersSteps[id] = {date: steps};
          } else {
            membersSteps[id]!.addAll({date: steps});
          }
        } else if (date == today) {
          // Bugünkü en son saati bul
          String latestKey = '';
          stepHist.forEach((key, value) {
            if (key.startsWith(today) &&
                (latestKey.isEmpty || key.compareTo(latestKey) > 0)) {
              latestKey = key;
            }
          });
          if (latestKey.isNotEmpty) {
            if (!membersSteps.containsKey(id)) {
              membersSteps[id] = {latestKey: stepHist[latestKey]};
            } else {
              membersSteps[id]!.addAll({latestKey: stepHist[latestKey]});
            }
          } else {
            // Bugün için kayıt bulunamazsa -1 yaz
            if (!membersSteps.containsKey(id)) {
              membersSteps[id] = {today: -1};
            } else {
              membersSteps[id]!.addAll({today: -1});
            }
            debugPrint('Bugün için kayıt bulunamadı.');
          }
        } else {
          if (!membersSteps.containsKey(id)) {
            membersSteps[id] = {date: -1};
          } else {
            membersSteps[id]!.addAll({date: -1});
          }
        }
      }
    }

    stepPhraseListOpposite = [];
    if (membersSteps.containsKey(id)) {
      membersSteps[id]?.forEach((key, value) {
        StepPhrase stepPhrase =
            StepPhrase(isLeft: false, steps: value, steppedDate: key, id: id);
        stepPhraseListOpposite.add(stepPhrase);
      });
    } else {
      debugPrint('Üye adım verisi bulunamadı.');
    }
  }

  Future getGameMemberSteps(String id, DateTime start, DateTime end,
      {DietGameViewModel? gameModel}) async {
    DateTime yesterdayStart = DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day - 1, 00, 00, 00);
    DateTime yesterdayEnd = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - 1, 23, 59, 59);
    membersSteps = {};
    totalSteps = 0;
    //stepHist = {};
    stepPhraseList = [];
    DocumentSnapshot stepDoc = await userStepsRef.doc(id).get();
    var yesterdayString = DateFormat('yyyy-MM-dd').format(yesterdayStart);

    List<String> datesBetweenString = [];
    List<DateTime> datesBetween = [];
    DateTime start_ = DateTime(start.year, start.month, start.day);

    DateTime end_ = DateTime(end.year, end.month, end.day);
    int days = end.difference(start).inDays;

    for (int i = 0; i <= days; i++) {
      var startX = start.add(Duration(days: i));
      datesBetweenString.add(DateFormat('yyyy-MM-dd').format(startX));
    }
    for (int i = 0; i <= days; i++) {
      var startX = start.add(Duration(days: i));
      datesBetween.add(startX);
    }

    if (stepDoc.exists && (stepDoc.data() as Map).containsKey('stepHist')) {
      stepHist = stepDoc['stepHist'];
      for (var element in datesBetweenString) {
        if (stepHist!.keys.contains(element) &&
            stepHist![element] != 0 &&
            stepHist![element] != -1 &&
            element != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          int steps = stepHist![element] as int;
          if (!membersSteps.containsKey(id)) {
            membersSteps[id] = {element: stepHist![element]};
          } else {
            membersSteps[id]!.addAll({element: stepHist![element]});
          }
          totalSteps += (steps == null || steps == -1) ? 0 : steps;
        } else {
          var steps = await health.getTotalStepsInInterval(
              DateTime(
                  DateTime.parse(element).year,
                  DateTime.parse(element).month,
                  DateTime.parse(element).day,
                  00,
                  00,
                  00),
              DateTime(
                  DateTime.parse(element).year,
                  DateTime.parse(element).month,
                  DateTime.parse(element).day,
                  23,
                  59,
                  59));
          if (!membersSteps.containsKey(id)) {
            element =
                (element == DateFormat('yyyy-MM-dd').format(DateTime.now()))
                    ? DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now())
                    : element;

            membersSteps[id] = {element: steps ?? 0}; /////
          } else {
            element =
                (element == DateFormat('yyyy-MM-dd').format(DateTime.now()))
                    ? DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now())
                    : element;
            membersSteps[id]!.addAll({element: steps ?? 0});
          }
          totalSteps += (steps == null || steps == 0) ? 0 : steps;
          stepHist![element] = steps ?? 0;

          await userStepsRef.doc(id).update({"stepHist": stepHist});
        }
      }
    } else {
      for (var element in datesBetweenString) {
        var steps = await health.getTotalStepsInInterval(
            DateTime(
                DateTime.parse(element).year,
                DateTime.parse(element).month,
                DateTime.parse(element).day,
                00,
                00,
                00),
            DateTime(
                DateTime.parse(element).year,
                DateTime.parse(element).month,
                DateTime.parse(element).day,
                23,
                59,
                59));
        if (!membersSteps.containsKey(id)) {
          element = (element == DateFormat('yyyy-MM-dd').format(DateTime.now()))
              ? DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now())
              : element;
          membersSteps[id] = {element: steps ?? 0};
        } else {
          element = (element == DateFormat('yyyy-MM-dd').format(DateTime.now()))
              ? DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now())
              : element;
          membersSteps[id]!
              .addAll({element: steps ?? 0 /*stepHist![element]*/});
        }

        stepHist![element] = steps ?? 0;
      }

      await userStepsRef.doc(id).set({"stepHist": stepHist});
    }

    for (var i in membersSteps.entries) {
      if (i.key == currentUser!.id) {
        i.value!.forEach((key, value) {
          StepPhrase x = StepPhrase(
              isLeft: true, steps: value, steppedDate: key, id: i.key);
          stepPhraseList.add(x);
        });
        //stepPhraseList.reversed;
      } else {
        null;
        /* i.value!.forEach((key, value) {
          StepPhrase y = StepPhrase(
              isLeft: false, steps: value, steppedDate: key, id: i.key);
          stepPhraseList.add(y);
        });
        */
        /*     stepPhraseList.sort((a, b) => DateTime.parse(a.steppedDate!)
            .compareTo(DateTime.parse(b.steppedDate!)));*/
        //stepPhraseList.reversed;
      }
    }
  }

  Future<void> checkWallet() async {
    DocumentSnapshot walletDoc = await userWalletRef.doc(currentUser!.id).get();

    walletDoc.exists ? walletCoin = double.parse(walletDoc['balance']) : 0;
    debugPrint("checked wallet");
    // notifyListeners();
  }

  Future<bool> checkConvertible() async {
    alertMsg = "";
    convertible = false;
    convertedSteps = 0;
    convertibleSteps = 0;

    Timestamp? recordDate;

    DateTime? recordDateByDoc;
    DateTime todayDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    stepDoc = await userStepsRef.doc(currentUser!.id).get();

    if (stepDoc!.exists && (stepDoc!.data() as Map).containsKey('recordDate')) {
      recordDate = stepDoc!['recordDate'];
    }

    (stepDoc!.exists && recordDate != null)
        ? recordDateByDoc = DateTime(recordDate.toDate().year,
            recordDate.toDate().month, recordDate.toDate().day)
        : null;

    (recordDateByDoc != null && recordDateByDoc.compareTo(todayDate) == 0)
        ? todayConvertedStepsByDoc = stepDoc!['convertedSteps']
        : null;
    // todaySteps = 25000;
    // todayConvertedStepsByDoc = 0;
    todayConvertedStepsByDoc == 0
        ? convertedSteps = todaySteps ?? 0
        : convertedSteps = (todaySteps ?? 0) - todayConvertedStepsByDoc;

    todayConvertedStepsByDoc > maxSteps ? maxLimit = true : maxLimit = false;

    convertedSteps! <= minStep
        ? convertibleSteps = minStep - (convertedSteps ?? 0)
        : convertibleSteps =
            convertedSteps! > maxSteps ? maxSteps : convertedSteps!;

    // convertedSteps! >= 500 ? convertedSteps = convertedSteps! - 500 : null;
    convertedSteps! < minStep || maxLimit
        ? convertible = false
        : convertible = true;
    return convertible;
  }

  Future<void> convertStepToCoin() async {
    //reklamı izlet
    //await _loadRewardedAd();
    /* await _rewardedAd?.show(onUserEarnedReward: (_, reward) {
      //QuizManager.instance.useHint();
    });*/
    //convertible = false;
    //maxLimit = false;
    //convertedSteps = 0;

    Map<String, dynamic>? convertedStepsMap;

    convertedStepsMap = (stepDoc!.exists &&
            (stepDoc!.data() as Map).containsKey('convertedStepsMap'))
        ? stepDoc!['convertedStepsMap']
        : {};
    Map<String, dynamic>? earnedCoinsMap = (stepDoc!.exists &&
            (stepDoc!.data() as Map).containsKey('earnedCoinsMap'))
        ? stepDoc!['earnedCoinsMap']
        : {};
    /*Map<String, int>? stepHist =
        (stepDoc!.exists & (stepDoc!.data() as Map).containsKey('stepHist'))
            ? stepDoc!['stepHist']
            : {};*/

    // Timestamp? recordDate;
    walletCoin = 0;
    // int todayConvertedStepsByDoc = 0;
    double earnedCoinByDoc = 0.0;
    /*  DateTime? recordDateByDoc;
    DateTime todayDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime yesterdayStart = DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day - 1, 00, 00, 00);
    DateTime yesterdayEnd = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - 1, 23, 59, 59);
*/
    //  DocumentSnapshot stepDoc = await userStepsRef.doc(currentUser!.id).get();
    DocumentSnapshot walletDoc = await userWalletRef.doc(currentUser!.id).get();

    // var yesterdayString = DateFormat('yyyy-MM-dd').format(yesterdayStart);

    walletDoc.exists
        ? walletCoin = double.parse(walletDoc['balance'])
        : walletCoin = 0;

    /*   if (stepDoc.exists && (stepDoc.data() as Map).containsKey('recordDate')) {
      recordDate = stepDoc['recordDate'];
    }

//eğer düne ilişkin adım kaydın yoksa dün icin adımı al ve map'e ekle
    if (stepDoc.exists && (stepDoc.data() as Map).containsKey('stepHist')) {
      stepHist = stepDoc['stepHist'];
      if (stepHist!.keys.contains(yesterdayString) &&
          stepHist![yesterdayString] != 0) {
        debugPrint("düne ait adım mevcut");
      }
    } else {
      var steps =
          await health.getTotalStepsInInterval(yesterdayStart, yesterdayEnd);

      stepHist![yesterdayString] = steps ?? 0;
    }

    (stepDoc.exists && recordDate != null)
        ? recordDateByDoc = DateTime(recordDate.toDate().year,
            recordDate.toDate().month, recordDate.toDate().day)
        : null;

    (recordDateByDoc != null && recordDateByDoc.compareTo(todayDate) == 0)
        ? todayConvertedStepsByDoc = stepDoc['convertedSteps']
        : null;
    (recordDateByDoc != null && recordDateByDoc.compareTo(todayDate) == 0)
        ? earnedCoinByDoc = stepDoc['earnedCoin']
        : null;

    todayConvertedStepsByDoc == null
        ? convertedSteps = todaySteps
        : convertedSteps = todaySteps! - todayConvertedStepsByDoc;

    if (convertedSteps! <= 5) {
      convertible = false;
    }

    convertedSteps! <= 20
        ? convertibleSteps = 20 - (convertedSteps ?? 0)
        : null;
    (convertedSteps ?? 0) > 20000 ? maxLimit = true : maxLimit = false;*/

    if (convertible) {
      // convertible = true;
      earnedCoin = (convertibleSteps / dividerSteps);
      //if (earnedCoin! > 0.0) {
      var totalTodayEarnedCoin = earnedCoinByDoc + earnedCoin!;
      var totalTodayConvertedSteps =
          convertibleSteps + todayConvertedStepsByDoc;

      walletCoin = walletCoin + earnedCoin!;

      convertedStepsMap![DateFormat('yyyy-MM-dd – kk:mm:ss')
          .format(DateTime.now())] = convertibleSteps;
      earnedCoinsMap![DateFormat('yyyy-MM-dd – kk:mm:ss')
          .format(DateTime.now())] = earnedCoin!;

      await userStepsRef.doc(currentUser!.id).set({
        "userId": currentUser!.id,
        "earnedCoin": totalTodayEarnedCoin,
        "convertedSteps": totalTodayConvertedSteps,
        "recordDate": DateTime.now(),
        "convertedStepsMap": convertedStepsMap,
        // "deneme": b
        "earnedCoinsMap": earnedCoinsMap,
        // "stepHist": stepHist
      });

      await userWalletRef.doc(currentUser!.id).set({
        "userId": currentUser!.id,
        "balance": walletCoin.toStringAsFixed(2),
        "recordDate": DateTime.now(),
      });
      //  }

      notifyListeners();
      //convertible = false;
    }
  }

  /* double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }*/
}
