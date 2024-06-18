// ignore_for_file: file_names, use_key_in_widget_constructors

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/data/task_model.dart';
import 'package:friendfit_ready/models/dietTask.dart';
import 'package:friendfit_ready/models/dietTodos.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/screens/taskSummary.dart';
import 'package:friendfit_ready/services/TaskRequest/TaskRequestService.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/data/image_card.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:friendfit_ready/widgets/cards/diet_card.dart';
import 'package:friendfit_ready/size_config.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:friendfit_ready/utils/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:transparent_image/transparent_image.dart';

final dietTasksRef = FirebaseFirestore.instance.collection('dietTasks');

class DietTaskViewModel extends ChangeNotifier {
  final TaskRequestService _taskRequestService =
      serviceLocator<TaskRequestService>();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  List<DietTask> tasks = [];
  List<DietToDos> todos = [];
  List<DietToDos> todos2 = [];
  List<DietToDos> todosFirst = [];
  List listUrls = [];
  bool isLoaded = false;
  bool isLiked = false;
  bool isModified = false;
  int likeCount = 0;
  String? taskId;
  String? desc = "";
  bool isSaved = false;
  bool isTodoLoaded = false;
  bool isEdited = false;
  int? isFirstOpen = 1;
  List<Choice> iconsList = [];
  List<String> iconIds = [];
  DietTask? selectedTask;
  DietTask? selectedTaskPlan;
  String? titleCopy = "";
  String? titleModified = "";
  bool showAlert = false;
  String? createdTaskId;
  String planTitle = "";
  String dietPlanTitle = "";
  bool fromFitGallery = false;
  bool fromFile = false;

  String? editedTitle; //= "";
  //List<DietToDos> selectedTodos = [];
  Map<dynamic, bool> editDay = {};
  Map<dynamic, bool> modifyDay = {};
  Map<DateTime, List<DietToDos>?> dailyEvents = {};
  Map<String, Map<DateTime, List<DietToDos>?>> dailyPlans = {};
  Map<String, Map<DateTime, String?>> dailyPlansTitle = {};
  Map<DateTime, String?> dailyEventsTitle = {};
  Map<DateTime, List<DietToDos>?> dailyEventsModify = {};
  Map<DateTime, String?> dailyEventsTitleModify = {};

  List selectedEvents = [];
  Map<dynamic, DietTask> selectedDailyPlanTask = {};
  Map<dynamic, DietTask> savedDailyPlanTask = {};

  /*Map<dynamic, List<DietToDos>?> selectedDailyPlanTodos = {};
  Map<dynamic, List<DietToDos>?> selectedDailyPlanTodosCopy = {};
  Map<dynamic, List<DietToDos>?> selectedDailyPlanTodosModify = {};*/

  Map<dynamic, String>? selectedTaskTitle = {};
  Map<dynamic, String> selectedTaskTitleCopy = {};
  Map<dynamic, String> selectedTaskTitleModify = {};
  Map<dynamic, String>? savedTaskTitle = {};
  Map<dynamic, String?>? savedTaskTitleCopy = {};
  Map<dynamic, String>? savedTaskTitleModify = {};

  Map<dynamic, List<DietToDos>?> savedDailyPlanTodos = {};
  Map<dynamic, List<DietToDos>?> savedDailyPlanTodosCopy = {};
  Map<dynamic, List<DietToDos>?> savedDailyPlanTodosModify = {};
  List<ItemData> items = [];
  List<ItemData> itemsFirst = [];
  Map<int, List<ItemData>> dayItems = {};
  Map<int, List<ItemData>> dayItemsCopied = {};

  bool toogle = false;
  DateTime? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<DietToDos> todosCopy = [];
  String imageUrl = "";

  List<dynamic> iconIds2 = [];
  XFile? imageBeforeSave;
  File? compressedImageFile;
  String? postId;
  List<DietToDos> toDosForFirebase = [];

  bool fromRandFuture = true;
  bool fromPhoneGallery = false;
  bool fromPhoneCamera = false;

  /* Future<void> getTasks(String ownerId) async {
    final tasksDocs = await _taskRequestService.getTasks(ownerId);
    tasks = [];
    todos = [];
    await Future.forEach(tasksDocs, (doc) async {
      DietTask task = DietTask.fromDocument(doc);
      tasks.add(task);
      final todosDocs =
          await _taskRequestService.getTaskTodos(ownerId, task.id);
      todosDocs.forEach((doc) {
        DietToDos todo = DietToDos.fromDocument(doc);
        todos.add(todo);
              });
    });
    debugPrint('gets tasks finished');
  }
*/

  List<dynamic> todoPhrases = [];
  List<dynamic> copyTodoPhrases = [];

  DietTask? createdTask;
  String? newTodo;

  DietTask? copiedTask;

  double? selectedValue = 1.0;

  int? copiedTaskLength = 0;

  List deletedItems = [];

  bool togglePlanUpdate = false;

  List<DietToDos> newAddedTodos = [];
  List<DietToDos> newAddedCopiedTodos = [];
  List copytoDosForFirebase = [];

  bool? dayError = false;
  bool? titleError = false;
  int countSaved = 0;
  int indexPlan = 0;

  List<QueryDocumentSnapshot<Object?>>? todoDocs;

  var randomImageUrl;

  List todos2_Copied = [];

  String? planId;

  @override
  dispose() {
    debugPrint("*********Task ViewModel dispose*******");
    super.dispose();
  }

  void addToDoPhrase({String? phrase}) {
//todoPhrases=[];

    copyTodoPhrases.add(phrase);

    notifyListeners();
  }

  void removeToDoPhrase(int index) {
    copyTodoPhrases.removeAt(index);

    notifyListeners();
  }

  Future<List<DietTask>> searchDiets(String query) async {
    var val = await dietTasksRef
        .doc(adminId)
        .collection('userDietTasks')
        .where("indexes", arrayContains: query.toLowerCase())
        .get();

    List<DietTask> searchResults = [];
    val.docs.forEach((doc) {
      DietTask diet = DietTask.fromDocument(doc);

      searchResults.add(diet);
    });
    final suggestionList = searchResults
        .where((p) => p.title!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return suggestionList;
  }

  Future<void> getTasks(String ownerId) async {
    final tasksDocs = await _taskRequestService.getTasks(adminId);
    tasks = [];

    todos = [];
    tasksDocs.forEach((doc) {
      DietTask task = DietTask.fromDocument(doc);
      tasks.add(task);
    });

    debugPrint('gets tasks finished');
  }

  getTaskIcons(List<dynamic> iconsIds) {
    iconIds2 = [];
    iconIds2 = iconsIds;
    choices.forEach((a) {
      if (iconIds2.contains(a.id)) {
        iconsList.add(a);
      } else {
        return;
      }
    });
  }

  Future<void> loadTasks(String ownerId) async {
    await getTasks(ownerId);
    isLoaded = true;
    debugPrint('load tasks finished');
    notifyListeners();
  }

  setTask(DietTask task) {
    selectedTaskPlan = task;
    titleCopy = task.title!;
  }

  setTaskTitle(String? title) {
    selectedTaskPlan?.title = title;
  }

  Future<void> getTaskTodos(String ownerId, String taskId,
      {bool? fromDetail, DietTask? task}) async {
    todos2 = [];
    todosFirst = [];
    todoDocs = await _taskRequestService.getTaskTodosById(ownerId, taskId);

    for (var doc in todoDocs!) {
      DietToDos todo = DietToDos.fromDocument(doc);
      todos2.add(todo);
    }
    todos2.forEach((DietToDos e) {
      DietToDos todo = DietToDos(
          id: e.id,
          isActive: e.isActive,
          isCompleted: e.isCompleted,
          ownerId: e.ownerId,
          parentId: e.parentId,
          phrases: List.from(e.phrases!),
          rank: e.rank,
          startDate: e.startDate,
          endDate: e.endDate,
          title: e.title);
      todosFirst.add(todo);
    });

    /* todos2.sort((a, b) =>  DateTime( DateTime.now().year,DateTime.now().month, DateTime.now().day,  TimeOfDay.fromDateTime(a.startDateTodo.toDate()).hour,TimeOfDay.fromDateTime(a.startDateTodo.toDate()).minute).
    compareTo(DateTime( DateTime.now().year,DateTime.now().month, DateTime.now().day,  TimeOfDay.fromDateTime(b.startDateTodo.toDate()).hour,TimeOfDay.fromDateTime(b.startDateTodo.toDate()).minute)));*/
    /*  todos.forEach((t) { 
 if(t.parentId ==id) todos2.add(t);

    });*/

    //selectedTodos=todos2;
    todos2.sort((a, b) => a.rank!.compareTo(b.rank!));
    setToDoKeys(todos2);
    fromDetail == true ? prepareForDetail(task!, todos2) : null;

    todosFirst.sort((a, b) => a.rank!.compareTo(b.rank!));
    itemsFirst = [];
    // List();
    for (int i = 0; i < todosFirst.length; ++i) {
      itemsFirst.add(ItemData(todosFirst[i], ValueKey(i)));
    }
    //dayItemsCopied = dayItems;

    notifyListeners();
  }

  //edit
  copyDayItemsCopied(Map<int, List<ItemData>> a) {
    List<ItemData> c = [];
    dayItemsCopied = {};
    todos2_Copied = [];

    todos2.forEach((value) {
      DietToDos todo = DietToDos(
          id: value.id,
          isActive: value.isActive,
          isCompleted: value.isCompleted,
          ownerId: value.ownerId,
          parentId: value.parentId,
          phrases: value.phrases,
          dayRank: value.dayRank,
          rank: value.rank,
          startDate: value.startDate,
          endDate: value.endDate,
          title: value.title);
      todos2_Copied.add(todo);
    });

    a.forEach((key, value) {
      c = [];
      value.asMap().forEach((key2, value) {
        DietToDos todo = DietToDos(
            id: value.todo.id,
            isActive: value.todo.isActive,
            isCompleted: value.todo.isCompleted,
            ownerId: value.todo.ownerId,
            parentId: value.todo.parentId,
            phrases: value.todo.phrases,
            dayRank: value.todo.dayRank,
            rank: value.todo.rank,
            startDate: value.todo.startDate,
            endDate: value.todo.endDate,
            title: value.todo.title);
        ItemData x = ItemData(todo, ValueKey(value.todo.rank));
        c.add(x);
      });
      dayItemsCopied[key] = c;
    });
  }

  //undo
  copyDayItems(Map<int, List<ItemData>> a) {
    List<ItemData> c = [];
    todos2 = [];
    items = [];
    dayItems = {};

    todos2_Copied.forEach((element) {
      todos2.add(element);
    });
    a.forEach((key, value) {
      c = [];
      value.asMap().forEach((key2, element) {
        ItemData x = ItemData(element.todo, ValueKey(key2));
        c.add(x);
        items.add(x);
      });
      dayItems[key] = c;
    });
  }

  List<DietToDos> copy(List<DietToDos>? todos, {int? dayRank}) {
    List<DietToDos> copy = [];
    if (todos != null) {
      todos.forEach((DietToDos e) {
        DietToDos todo = DietToDos(
            id: Uuid().generateV4(),
            isActive: e.isActive,
            isCompleted: e.isCompleted,
            ownerId: e.ownerId,
            parentId: e.parentId,
            phrases: e.phrases,
            dayRank: dayRank,
            rank: e.rank,
            startDate: e.startDate,
            endDate: e.endDate,
            title: e.title);
        copy.add(todo);
      });
    } else {
      copy = [];
    }
    return copy;
  }

  setToDoKeys(List<DietToDos> todos, {int? day}) {
    items = [];
    for (int i = 0; i < todos.length; ++i) {
      items.add(ItemData(todos[i], ValueKey(i)));
    }
    day != null ? addCheck(items, day) : null;
  }

  updateRanks() {
    // var a = [];
    todos2 = [];
    dayItems.forEach((key, value) {
      value.forEach((element) {
        todos2.add(element.todo);
      });
    });
  }

  prepareForDetail(DietTask task, List<DietToDos> todos) {
    dayItems = {};

    items.asMap().forEach((key, value) {
      if (dayItems[value.todo.dayRank] != null) {
        dayItems[value.todo.dayRank]?.add(value);
      } else {
        dayItems[value.todo.dayRank!] = [];
        dayItems[value.todo.dayRank!]!.add(value);
      }
    });
  }

  addCheck(List<ItemData> items, int day) {
    dayItems[day] = [];
    List<ItemData> a = [];
    for (var element in items) {
      element.todo.dayRank == day ? a.add(element) : null;
    }

    /*dayItems.forEach((key, value) {
      for (var a in value) {
        items.removeWhere((b) => a.todo.id == b.todo.id);
      }
    });*/

    dayItems[day] = a; //items;
  }

  Future<int> getDietLikesCount(DietTask task) async {
    DocumentSnapshot snapshot = await dietTasksRef
        .doc(adminId)
        .collection('userDietTasks')
        .doc(task.id)
        .get();

    return snapshot['likesCount'];
  }

  Future<Map> isLikeControl(DietTask task) async {
    DocumentSnapshot snapshot = await dietTasksRef
        .doc(adminId)
        .collection('userDietTasks')
        .doc(task.id)
        .get();

    return snapshot['likes'];
  }

  Future<void> isLikedControl(DietTask task) async {
    Map likes = await isLikeControl(task);

    if (likes.isEmpty) {
      isLiked = false;
    } else if (likes.containsKey(currentUser!.id!)) {
      isLiked = likes[currentUser!.id!];
    } else {
      isLiked = false;
    }

    notifyListeners();
  }

  handleLikeDiet(String taskId, String ownerId, {DietTask? task}) async {
    String currentUserId = currentUser!.id!;
    likeCount = await getDietLikesCount(task!);

    if (isLiked) {
      await dietTasksRef
          .doc(ownerId)
          .collection('userDietTasks')
          .doc(taskId)
          .update({'likes.$currentUserId': false});

      likeCount -= 1;
      isLiked = false;

      dietTasksRef
          .doc(ownerId)
          .collection('userDietTasks')
          .doc(taskId)
          .update({'likesCount': likeCount});
    } else if (!isLiked) {
      await dietTasksRef
          .doc(ownerId)
          .collection('userDietTasks')
          .doc(taskId)
          .update({'likes.$currentUserId': true});

      likeCount += 1;
      await dietTasksRef
          .doc(ownerId)
          .collection('userDietTasks')
          .doc(taskId)
          .update({'likesCount': likeCount});
      /*postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likesCount': likeCount});*/
      isLiked = true;
    }
    notifyListeners();
  }

  bool checkSaveCondition(DietTaskViewModel model, int days, {DietTask? task}) {
    bool error = false;
    dayError = false;
    titleError = false;

    List<int> errorDays = [];

    if (task == null) {
      if (createdTask?.title == null) {
        error = true;
        titleError = true;
      } else if (createdTask!.title!.length < 3) {
        error = true;
        titleError = true;
      }
    }

    if (task != null) {
      // ignore: unnecessary_null_comparison
      if (planTitle == null) {
        error = true;
        titleError = true;
      } else if (planTitle.length < 3) {
        error = true;
        titleError = true;
      }
    }

    for (int i = 1; i <= days; i++) {
      if (model.dayItems[i] == null) {
        error = true;
        dayError = true;
        errorDays.add(i);
      } else {
        model.dayItems[i]!.forEach((element) {
          if (element.todo.phrases!.isEmpty) {
            error = true;
            dayError = true;
          }
        });
        null;
      }
    }

    return error;
  }

  Future<void> setTasksIndexes(String ownerId) async {
    final tasksDocsforIndexes = await _taskRequestService.getTasks(ownerId);
    List<String> indexes = [];
    tasksDocsforIndexes.forEach((doc) async {
      DietTask task = DietTask.fromDocument(doc);

      for (int i = 1; i <= task.title!.length; i++) {
        String subString = task.title!.substring(0, i).toLowerCase();
        indexes.add(subString);
      }

      await dietTasksRef
          .doc(ownerId)
          .collection('userDietTasks')
          .doc(task.id)
          .update({"indexes": indexes});
    });
  }

  isEditControl(String taskId, String cuurentUserId, {DateTime? day}) {
    isEdited = true;

    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }

  Future<List<DietTask>> searchTasks(String query) async {
    print("Searching");
    var val = await postsRef
        .doc(adminId)
        .collection('userDietTasks')
        .where("indexes", arrayContains: query.toLowerCase())
        .get();

    List<DietTask> searchResults = [];
    val.docs.forEach((doc) {
      DietTask task = DietTask.fromDocument(doc);
      // DietCard buildTask = DietCard(diet: task, press: () {  },);

      searchResults.add(task);
    });
    final resultList = searchResults
        .where((p) => p.title!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return resultList;
  }

//remove todo

  void removeToDo(String taskId, String todoId) async {
    await dietTasksRef
        .doc(currentUser!.id)
        .collection('userDietTasks')
        .doc(taskId)
        .collection('userDietTaskTodos')
        .doc(todoId)
        .delete();
  }

  void removeToDoFromTodos(String todoId) async {
    Adam a1 = Adam(1, "Okan");
    Adam a2 = Adam(2, "Erdem");
    List<Adam> adamlar = [];
    adamlar.add(a1);
    adamlar.add(a2);
    List<Adam> adamlar2 = [];
    /*adamlar.forEach((element) {
      adamlar2.add(element);
    });*/
    adamlar2 = adamlar;
    Map<int, List<Adam>> x = {};
    x[1] = adamlar2;
    x[2] = adamlar2;
    adamlar.removeAt(0);

    var b = dayItems;
    items.removeWhere((element) => element.todo.id == todoId);
    dayItems.forEach((key, value) {
      value.removeWhere((element) => element.todo.id == todoId);
    });

    notifyListeners();
  }

  void removeToDoFromGame(String todoId) async {
    /*savedDailyPlanTodos[dateFormat.format(selectedDay!)] == null
        ? selectedDailyPlanTodosModify[dateFormat.format(selectedDay!)]!
            .removeWhere((element) => element.id == todoId)
        : savedDailyPlanTodosModify[dateFormat.format(selectedDay!)]!
            .removeWhere((element) => element.id == todoId);*/

    dailyEventsModify[DateTime(
                selectedDay!.year, selectedDay!.month, selectedDay!.day)] !=
            null
        ? dailyEventsModify[DateTime(
                selectedDay!.year, selectedDay!.month, selectedDay!.day)]!
            .removeWhere((element) => element.id == todoId)
        : null;

    toogle = false;

    notifyListeners();
  }
  //delete task

  void removeTask(String taskId) async {
//delete subcollections

    for (var a in todos2) {
      await dietTasksRef
          .doc(currentUser!.id)
          .collection('userDietTasks')
          .doc(taskId)
          .collection('userDietTaskTodos')
          .doc(a.id)
          .delete();
    }

    await dietTasksRef
        .doc(currentUser!.id)
        .collection('userDietTasks')
        .doc(taskId)
        .delete();

    //notifyListeners();
  }

  Future<bool> checkPlanCriteria(DateTimeRange range, int day) async {
    List<DateTime> days = [];
    days = getDaysInBetween(range.start, range.end);

    return days.length > day ? true : false;
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    DateTime start = DateTime(2023, 10, 29);
    DateTime end = DateTime(2023, 10, 29);
    end.add(const Duration(days: 1));
    debugPrint(end.toString());
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      //days.add(startDate.add(Duration(days: i)));
      days.add(DateTime(startDate.year, startDate.month, startDate.day + i));
    }
    return days;
  }

  undoMap() {
    dailyEventsModify = {};
    for (var element in dailyEvents.keys) {
      dailyEventsModify[element] = copy(dailyEvents[element]);
    }

    dailyEventsTitleModify = {};
    for (var element in dailyEventsTitle.keys) {
      dailyEventsTitleModify[element] = dailyEventsTitle[element]!;
    }
  }

  copyMap() {
    //String a = Uuid().generateV4();
    // dailyPlans = {};
    // dailyPlansTitle = {};
    //indexPlan += 1;
    dailyEvents = {};
    for (var element in dailyEventsModify.keys) {
      dailyEvents[element] = copy(dailyEventsModify[element]);

      dailyEventsTitle = {};
      for (var element in dailyEventsTitleModify.keys) {
        dailyEventsTitle[element] = dailyEventsTitleModify[element]!;
      }
    }
  }

  setPlanToGame(DateTimeRange range, DietTask iconData) async {
    List<DateTime> days = [];
    Map<int, List<DietToDos>> dietPlan = {};

    days = getDaysInBetween(range.start, range.end);
    var days_diet = iconData.days!;

    await getTaskTodos(adminId, iconData.id!);

    todos2.asMap().forEach((key, value) {
      if (dietPlan[value.dayRank] != null) {
        dietPlan[value.dayRank]?.add(value);
      } else {
        dietPlan[value.dayRank!] = [];
        dietPlan[value.dayRank!]!.add(value);
      }
    });

    var a = days.length % days_diet;

    if (days.length > days_diet && a == 0) {
      for (int i = days_diet + 1; i <= days.length; i++) {
        for (int j = 1; j <= days_diet; j++) {
          todos2.forEach((element) {
            dietPlan[i] == null ? dietPlan[i] = [] : null;
            element.dayRank == j ? dietPlan[i]!.add(element) : null;
          });
          //i++;
        }
      }
    }

    titleModified = null;
    setTask(iconData);

    for (int i = 0; i < days.length; i++) {
      dailyEvents[DateTime(days[i].year, days[i].month, days[i].day)] =
          dietPlan[i + 1];
      dailyEventsTitle[DateTime(days[i].year, days[i].month, days[i].day)] =
          dietPlan[i + 1] != null ? titleCopy : null;
      dailyEventsModify[DateTime(days[i].year, days[i].month, days[i].day)] =
          copy(dietPlan[i + 1]);
      dailyEventsTitleModify[
              DateTime(days[i].year, days[i].month, days[i].day)] =
          dietPlan[i + 1] != null ? titleCopy : null;

      /*selectedDailyPlanTodosModify[dateFormat.format(days[i])] =
          copy(dietPlan[i + 1]);
      selectedDailyPlanTodosCopy[dateFormat.format(days[i])] =
          copy(dietPlan[i + 1]);

      selectedTaskTitleCopy[dateFormat.format(days[i])] = titleCopy!;
      selectedTaskTitleModify[dateFormat.format(days[i])] = titleCopy!;*/

      selectedDailyPlanTask[dateFormat.format(days[i])] = selectedTaskPlan!; //

    }

    /* for (int i = 0; i < days.length; i++) {
      dailyEvents[DateTime(days[i].year, days[i].month, days[i].day)] =
          dietPlan[i + 1];
      dailyEventsTitle[DateTime(days[i].year, days[i].month, days[i].day)] =
          titleCopy;

      selectedDailyPlanTodosModify[dateFormat.format(days[i])] =
          copy(dietPlan[i + 1]);
      selectedDailyPlanTodos[dateFormat.format(days[i])] =
          List.from(dietPlan[i + 1]!);
      selectedDailyPlanTodosCopy[dateFormat.format(days[i])] =
          copy(dietPlan[i + 1]);

      savedDailyPlanTodosCopy[dateFormat.format(days[i])] = null;
      savedDailyPlanTodosModify[dateFormat.format(days[i])] = null;
      savedDailyPlanTodos[dateFormat.format(days[i])] = null;

      selectedTaskTitleCopy![dateFormat.format(days[i])] = titleCopy!;
      selectedTaskTitleModify[dateFormat.format(days[i])] = titleCopy!;
      savedTaskTitleCopy?[dateFormat.format(days[i])] = "";
      savedTaskTitleModify?[dateFormat.format(days[i])] = "";
      selectedDailyPlanTask[dateFormat.format(days[i])] = selectedTaskPlan!; //

    }*/

    /*days.forEach((day) {
      selectedDailyPlanTask[dateFormat.format(day)] =
          selectedTaskPlan!; //iconData;

      selectedTaskTitleCopy![dateFormat.format(day)] = titleCopy!;
      selectedTaskTitleModify![dateFormat.format(day)] = titleCopy!;
      savedTaskTitleCopy?[dateFormat.format(day)] = "";
      savedTaskTitleModify?[dateFormat.format(day)] = "";

      selectedDailyPlanTodosModify[dateFormat.format(day)] = copy(todos2);
      selectedDailyPlanTodos[dateFormat.format(day)] = List.from(todos2);
      selectedDailyPlanTodosCopy[dateFormat.format(day)] = copy(todos2);
    
      dailyEvents[DateTime(day.year, day.month, day.day)] = List.from(todos2); //[];

      dailyEventsTitle[DateTime(day.year, day.month, day.day)] = titleCopy;

      savedDailyPlanTodosCopy[dateFormat.format(day)] = null;
      savedDailyPlanTodosModify[dateFormat.format(day)] = null;
      savedDailyPlanTodos[dateFormat.format(day)] = null;
    });*/
  }

  modifyPlan(DietTask? task) {
    dayItems.entries.forEach((element) {
      debugPrint("hello");
    });
  }

  //modify task
  Future<void> modifyTask(
      String taskTitle, String currentUserId, String backgroundId,
      {DateTime? day, DietTask? task, int? days}) async {
    List<String> iconIdsModified = [];
    var a = this.dayItems;
    var b = items;
    //editedTitle="";
    task = createdTask == null ? task : createdTask;
    iconsList.forEach((Choice element) {
      iconIdsModified.add(element.id!);
    });
    /* await dietTasksRef
        .doc(currentUserId)
        .collection('userDietTasks')
        .doc(task!.id)
        .update({
      "title": taskTitle,
      "backgroundId": backgroundId,
      "iconIds": iconIdsModified,
      "days": days
    });*/
    isEdited = false;

    editedTitle = taskTitle;
    for (int i = 0; i < items.length; i++) {
      debugPrint("Hello");
      /*await dietTasksRef
          .doc(currentUserId)
          .collection('userDietTasks')
          .doc(task?.id)
          .collection('userDietTaskTodos')
          .doc(items[i].todo.id)
          .set({
        "parentId": task.id,
        "Id": items[i].todo.id,
        "title": items[i].todo.title,
        "phrases": items[i].todo.phrases,

        "startDate": items[i].todo.startDate,
        "endDate": items[i].todo.endDate,

        "Rank": i
        //"startDateTodo": todos2[i].startDateTodo
      });*/
    }
/////////////////////////////////////////////////////////////////////////
    /* for (int i = 0; i < todos2.length; i++) {
      await dietTasksRef
          .doc(currentUserId)
          //.doc(todos2[i].ownerId)
          .collection('userDietTasks')
          .doc(task.id)
          .collection('userDietTaskTodos')
          .doc(todos2[i].id)
          .set({
        "parentId": task.id,
        "Id": todos2[i].id,
        "title": todos2[i].title,
        "phrase": todos2[i].phrase,
        "startDateTodo": todos2[i].startDateTodo
      });
    }*/

    /*final selectedTaskDoc = await dietTasksRef
          .doc(currentUserId)
          //.doc(todos2[i].ownerId)
          .collection('userDietTasks')
          .doc(selectedTask.id).get();
    selectedTask= DietTask.fromDocument(selectedTaskDoc);

      
    final   QuerySnapshot snapshot =await dietTasksRef
          .doc(currentUserId)
          //.doc(todos2[i].ownerId)
          .collection('userDietTasks')
          .doc(selectedTask.id)
          .collection('userDietTaskTodos')
          .get();
          
         final selectedTaskTodosDoc=snapshot.docs;

          
          selectedTodos=[];
 
    selectedTaskTodosDoc.forEach((doc) {
      DietToDos todo = DietToDos.fromDocument(doc);
      selectedTodos.add(todo);
    });

    selectedTodos.sort((a, b) => a.startDateTodo.compareTo(b.startDateTodo));*/

    notifyListeners();
  }

  int returnDay({DietTask? task}) {
    var day = 1;

    /* if (createdTaskId == null) {
      day = 1;
    }*/
    if (createdTask!.days == null) {
      day = 1;
    }
    if (createdTask!.days != null) {
      day = createdTask!.days!;
    }

    return day;
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
    var file = File(imageBeforeSave!.path);
    Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());
    compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
  }

  reOrderDayItemsTodosRank() {
    dayItems.forEach((key, List<ItemData> value) {
      for (int i = 0; i < value.length; i++) {
        value[i].todo.rank = i + 1;
      }
    });
  }

  Future<void> modifyTaskNew({DateTime? day, DietTask? task, int? days}) async {
    if (imageBeforeSave != null) {
      postId = Uuid().generateV4();
      await compressImage();
      imageUrl = await uploadImage(compressedImageFile);
    }

    /*** set indexes***/

    var title = task!.title;
    List indexes = [];

    for (int i = 1; i <= title!.length; i++) {
      String subString = title.substring(0, i).toLowerCase();
      indexes.add(subString);
    }

    //editedTitle="";
    /*task = createdTask == null ? task : createdTask;
    iconsList.forEach((Choice element) {
      iconIdsModified.add(element.id!);
    });*/

    toDosForFirebase = [];
    copytoDosForFirebase = [];

    reOrderDayItemsTodosRank();

    dayItems.forEach((key, List<ItemData> value) {
      value.forEach((element) {
        toDosForFirebase.add(element.todo);
        // copytoDosForFirebase.add(element.todo);
      });
    });
    copytoDosForFirebase = List.from(toDosForFirebase);

    if (newAddedTodos.isNotEmpty) {
      newAddedTodos.forEach((element) {
        copytoDosForFirebase.forEach((element2) {
          if (element.id == element2.id) {
            toDosForFirebase.remove(element2);
          }
        });
      });
    }

    if (newAddedCopiedTodos.isNotEmpty) {
      newAddedCopiedTodos.forEach((element) {
        copytoDosForFirebase.forEach((element2) {
          if (element.id == element2.id) {
            toDosForFirebase.remove(element2);
          }
        });
      });
    }

    await dietTasksRef
        .doc(currentUser!.id)
        .collection('userDietTasks')
        .doc(task.id)
        .update({
      "title": task.title,
      "backgroundId": imageUrl != "" ? imageUrl : task.backgroundId,
      "indexes": indexes,
      //"iconIds": iconIdsModified,
      "days": days!,
      "desc": task.desc
    });
    isEdited = false;

    if (togglePlanUpdate) {
//silinecekler
      for (var element in deletedItems) {
        await dietTasksRef
            .doc(currentUser!.id)
            .collection('userDietTasks')
            .doc(task.id)
            .collection('userDietTaskTodos')
            .doc(element.todo.id)
            .delete();
      }

// yeni eklenenler

      for (int i = 0; i < newAddedTodos.length; i++) {
        await dietTasksRef
            .doc(currentUser!.id)
            .collection('userDietTasks')
            .doc(task.id)
            .collection('userDietTaskTodos')
            .doc(newAddedTodos[i].id)
            .set({
          "parentId": task.id,
          "Id": newAddedTodos[i].id,
          "title": newAddedTodos[i].title,
          "phrases": newAddedTodos[i].phrases,
          "startDate": newAddedTodos[i].startDate,
          "endDate": newAddedTodos[i].endDate,
          "dayRank": newAddedTodos[i].dayRank,
          "Rank": newAddedTodos[i].rank
          //"startDateTodo": todos2[i].startDateTodo
        });
      }

//dialogdan kopyalanan todolar
      if (newAddedCopiedTodos.isNotEmpty) {
        for (int i = 0; i < newAddedCopiedTodos.length; i++) {
          await dietTasksRef
              .doc(currentUser!.id)
              .collection('userDietTasks')
              .doc(task.id)
              .collection('userDietTaskTodos')
              .doc(newAddedCopiedTodos[i].id)
              .set({
            "parentId": task.id,
            "Id": newAddedCopiedTodos[i].id,
            "title": newAddedCopiedTodos[i].title,
            "phrases": newAddedCopiedTodos[i].phrases,
            "startDate": newAddedCopiedTodos[i].startDate,
            "endDate": newAddedCopiedTodos[i].endDate,
            "dayRank": newAddedCopiedTodos[i].dayRank,
            "Rank": newAddedCopiedTodos[i].rank
            //"startDateTodo": todos2[i].startDateTodo
          });
        }
      }
      // update edilecekler

      for (int i = 0; i < toDosForFirebase.length; i++) {
        await dietTasksRef
            .doc(currentUser!.id)
            .collection('userDietTasks')
            .doc(task.id)
            .collection('userDietTaskTodos')
            .doc(toDosForFirebase[i].id)
            .update({
          "parentId": task.id,
          "Id": toDosForFirebase[i].id,
          "title": toDosForFirebase[i].title,
          "phrases": toDosForFirebase[i].phrases,
          "startDate": toDosForFirebase[i].startDate,
          "endDate": toDosForFirebase[i].endDate,
          "dayRank": toDosForFirebase[i].dayRank,
          "Rank": toDosForFirebase[i].rank
          //"startDateTodo": todos2[i].startDateTodo
        });
      }

// Update for CurrentTodos
      /* dayItems.forEach((key, value) {
        Future.forEach(value, (ItemData element) async {
          await dietTasksRef
              .doc(currentUser!.id)
              .collection('userDietTasks')
              .doc(task.id)
              .collection('userDietTaskTodos')
              .doc(element.todo.id)
              .update({
            "parentId": task.id,
            "Id": element.todo.id,
            "title": element.todo.title,
            "phrases": element.todo.phrases,
            "startDate": element.todo.startDate,
            "endDate": element.todo.endDate,
            "dayRank": key,
            "Rank": element.todo.rank
            //"startDateTodo": todos2[i].startDateTodo
          });
        });
      });*/
    }

    // editedTitle = taskTitle;

    /*await dietTasksRef
          .doc(currentUserId)
          .collection('userDietTasks')
          .doc(task?.id)
          .collection('userDietTaskTodos')
          .doc(items[i].todo.id)
          .set({
        "parentId": task.id,
        "Id": items[i].todo.id,
        "title": items[i].todo.title,
        "phrases": items[i].todo.phrases,

        "startDate": items[i].todo.startDate,
        "endDate": items[i].todo.endDate,

        "Rank": i
        //"startDateTodo": todos2[i].startDateTodo
      });*/

/////////////////////////////////////////////////////////////////////////
    /* for (int i = 0; i < todos2.length; i++) {
      await dietTasksRef
          .doc(currentUserId)
          //.doc(todos2[i].ownerId)
          .collection('userDietTasks')
          .doc(task.id)
          .collection('userDietTaskTodos')
          .doc(todos2[i].id)
          .set({
        "parentId": task.id,
        "Id": todos2[i].id,
        "title": todos2[i].title,
        "phrase": todos2[i].phrase,
        "startDateTodo": todos2[i].startDateTodo
      });
    }*/

    /*final selectedTaskDoc = await dietTasksRef
          .doc(currentUserId)
          //.doc(todos2[i].ownerId)
          .collection('userDietTasks')
          .doc(selectedTask.id).get();
    selectedTask= DietTask.fromDocument(selectedTaskDoc);

      
    final   QuerySnapshot snapshot =await dietTasksRef
          .doc(currentUserId)
          //.doc(todos2[i].ownerId)
          .collection('userDietTasks')
          .doc(selectedTask.id)
          .collection('userDietTaskTodos')
          .get();
          
         final selectedTaskTodosDoc=snapshot.docs;

          
          selectedTodos=[];
 
    selectedTaskTodosDoc.forEach((doc) {
      DietToDos todo = DietToDos.fromDocument(doc);
      selectedTodos.add(todo);
    });

    selectedTodos.sort((a, b) => a.startDateTodo.compareTo(b.startDateTodo));*/

    notifyListeners();
  }

  Future<void> addTaskNew_({DietTask? task, int? days}) async {
    countSaved += 1;

    if (imageBeforeSave != null) {
      postId = Uuid().generateV4();
      await compressImage();
      imageUrl = await uploadImage(compressedImageFile);
    }

    // iconsList = iconsList;
//set indexes
    List<String> indexes = [];

    for (int i = 1; i <= task!.title!.length; i++) {
      String subString = task.title!.substring(0, i).toLowerCase();
      indexes.add(subString);
    }

    //DietTask dietTask = DietTask(title: task.title, ownerId: currentUser!.id);
    /*taskId = dietTask.id;
    createdTaskId = taskId;
    createdTask = dietTask;*/
    // tasks.add(dietTask);
    // _calcTaskCompletionPercent(task.id);Ö
    //_db.insertTask(task);

    var taskID = Uuid().generateV4();

    await dietTasksRef
        .doc(currentUser!.id)
        .collection('userDietTasks')
        .doc(taskID)
        .set({
      "title": task.title,
      "Id": taskID,
      "iconIds": iconIds,
      "backgroundId": imageUrl == "" ? task.backgroundId : imageUrl,
      "days": selectedValue?.toInt() ?? 1,
      "indexes": indexes,
      "desc": task.desc,
      "likesCount": 0,

      "likes": {"deneme": true}

      //   this.imageUrl
    });

    dayItems.forEach((key, items) async {
      for (int i = 0; i < items.length; i++) {
        await dietTasksRef
            .doc(currentUser!.id)
            .collection('userDietTasks')
            .doc(taskID)
            .collection('userDietTaskTodos')
            .doc(items[i].todo.id)
            .set({
          "parentId": taskID,
          "Id": items[i].todo.id,
          "title": items[i].todo.title,
          "phrases": items[i].todo.phrases,
          "startDate": items[i].todo.startDate,
          "endDate": items[i].todo.endDate,
          "taskTitle": task.title,
          "Rank": i + 1,
          "dayRank": key
          //"startDateTodo": todos2[i].startDateTodo
        });
      }
    });

    isSaved = true;
    notifyListeners();
  }

  Future<void> addTaskNew({DietTask? task, int? days}) async {
    countSaved += 1;

    if (imageBeforeSave != null) {
      postId = Uuid().generateV4();
      await compressImage();
      imageUrl = await uploadImage(compressedImageFile);
    }

    // iconsList = iconsList;
//set indexes
    List<String> indexes = [];

    for (int i = 1; i <= task!.title!.length; i++) {
      String subString = task.title!.substring(0, i).toLowerCase();
      indexes.add(subString);
    }

    //DietTask dietTask = DietTask(title: task.title, ownerId: currentUser!.id);
    /*taskId = dietTask.id;
    createdTaskId = taskId;
    createdTask = dietTask;*/
    // tasks.add(dietTask);
    // _calcTaskCompletionPercent(task.id);Ö
    //_db.insertTask(task);

    await dietTasksRef
        .doc(createdTask!.ownerId)
        .collection('userDietTasks')
        .doc(createdTask!.id)
        .set({
      "title": createdTask!.title,
      "Id": createdTask!.id,
      "iconIds": iconIds,
      "backgroundId": imageUrl == "" ? task.backgroundId : imageUrl,
      "days": createdTask!.days ?? 1,
      "indexes": indexes,
      "desc": createdTask!.desc,
      "likesCount": 0,
      "likes": {"deneme": true}
      //   this.imageUrl
    });

    dayItems.forEach((key, items) async {
      for (int i = 0; i < items.length; i++) {
        await dietTasksRef
            .doc(items[i].todo.ownerId)
            .collection('userDietTasks')
            .doc(createdTask!.id)
            .collection('userDietTaskTodos')
            .doc(items[i].todo.id)
            .set({
          "parentId": createdTask!.id,
          "Id": items[i].todo.id,
          "title": items[i].todo.title,
          "phrases": items[i].todo.phrases,
          "startDate": items[i].todo.startDate,
          "endDate": items[i].todo.endDate,
          "Rank": i + 1,
          "dayRank": key
          //"startDateTodo": todos2[i].startDateTodo
        });
      }
    });

    isSaved = true;
    notifyListeners();
  }

  Future<void> addTask(String taskTitle, String currentUserId,
      List<Choice> iconsList, String backgroundId,
      {int? days}) async {
    iconsList = iconsList;
//set indexes
    List<String> indexes = [];

    for (int i = 1; i <= taskTitle.length; i++) {
      String subString = taskTitle.substring(0, i).toLowerCase();
      indexes.add(subString);
    }

    DietTask dietTask = DietTask(title: taskTitle, ownerId: currentUserId);
    taskId = dietTask.id;
    createdTaskId = taskId;
    createdTask = dietTask;
    tasks.add(dietTask);
    // _calcTaskCompletionPercent(task.id);Ö
    //_db.insertTask(task);
    iconsList.forEach((element) {
      iconIds.add(element.id!);
    });

    await dietTasksRef
        .doc(dietTask.ownerId)
        .collection('userDietTasks')
        .doc(dietTask.id)
        .set({
      "title": dietTask.title,
      "Id": taskId,
      "iconIds": iconIds,
      "backgroundId": imageUrl,
      "days": days,
      "indexes": indexes
      //   this.imageUrl
    });

    dayItems.forEach((key, items) async {
      for (int i = 0; i < items.length; i++) {
        await dietTasksRef
            .doc(items[i].todo.ownerId)
            .collection('userDietTasks')
            .doc(taskId)
            .collection('userDietTaskTodos')
            .doc(items[i].todo.id)
            .set({
          "parentId": taskId,
          "Id": items[i].todo.id,
          "title": items[i].todo.title,
          "phrases": items[i].todo.phrases,
          "startDate": items[i].todo.startDate,
          "endDate": items[i].todo.endDate,
          "Rank": i,
          "dayRank": key
          //"startDateTodo": todos2[i].startDateTodo
        });
      }
    });

    isSaved = true;
    notifyListeners();
  }

  void addTodoToTaskForGame(
      {String? taskId,
      String? periodName,
      DateTime? periodTime,
      String? periodPhrase,
      DietToDos? todom}) async {
    if (taskId == null) {
      DietToDos dietToDo = DietToDos(
          parentId: taskId,
          title: periodName,
          startDate: Timestamp.fromDate(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            startTime == null ? 7 : startTime!.hour,
            startTime == null ? 30 : startTime!.minute,
          )),
          endDate: Timestamp.fromDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              endTime == null ? 8 : endTime!.hour,
              endTime == null ? 30 : endTime!.minute)),
          phrases: copyTodoPhrases,
          ownerId: currentUser!.id);

      if (dailyEventsModify.containsKey(
          DateTime(selectedDay!.year, selectedDay!.month, selectedDay!.day))) {
        dailyEventsModify[DateTime(
                selectedDay!.year, selectedDay!.month, selectedDay!.day)]!
            .add(dietToDo);
      } else {
        dailyEventsModify[DateTime(
            selectedDay!.year, selectedDay!.month, selectedDay!.day)] = [];
        dailyEventsModify[DateTime(
                selectedDay!.year, selectedDay!.month, selectedDay!.day)]!
            .add(dietToDo);
      }

      for (var a in dailyEventsModify[
          DateTime(selectedDay!.year, selectedDay!.month, selectedDay!.day)]!) {
        if (a.id == taskId) {
          a.title = periodName;
          a.phrases = copyTodoPhrases;
          a.startDate = Timestamp.fromDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              startTime != null ? startTime!.hour : a.startDate!.toDate().hour,
              startTime != null
                  ? startTime!.hour
                  : a.startDate!.toDate().minute));
          a.endDate = Timestamp.fromDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              endTime != null ? endTime!.hour : a.endDate!.toDate().hour,
              endTime != null ? endTime!.minute : a.endDate!.toDate().minute));
        }
      }
    }

    toogle = false;
    notifyListeners();
  }

  void addTodoToTask(
      {String? taskId,
      DietToDos? todom,
      String? periodName,
      DateTime? periodTime,
      String? periodPhrase,
      int? day}) async {
    newAddedTodos = [];

    if (taskId == null) {
      DietToDos dietToDo = DietToDos(
          dayRank: day,
          parentId: taskId,
          title: periodName,
          //phrases: copyTodoPhrases,
          startDate: Timestamp.fromDate(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            startTime == null ? 7 : startTime!.hour,
            startTime == null ? 30 : startTime!.minute,
          )),
          endDate: Timestamp.fromDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              endTime == null ? 8 : endTime!.hour,
              endTime == null ? 30 : endTime!.minute)),
          phrases: copyTodoPhrases,
          ownerId: currentUser!.id);
      todos2.add(dietToDo);
      newAddedTodos.add(dietToDo);
    } else {
      todos2.forEach((a) {
        if (a.id == taskId) {
          a.title = periodName;
          a.dayRank = day;
          a.phrases = copyTodoPhrases;
          a.startDate = Timestamp.fromDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              startTime != null ? startTime!.hour : a.startDate!.toDate().hour,
              startTime != null
                  ? startTime!.minute
                  : a.startDate!.toDate().minute));
          a.endDate = Timestamp.fromDate(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              endTime != null ? endTime!.hour : a.endDate!.toDate().hour,
              endTime != null ? endTime!.minute : a.endDate!.toDate().minute));
          //  a.startDateTodo = Timestamp.fromDate(periodTime);

        }
      });

      /*todom!.title = periodName;
      todom.phrases = copyTodoPhrases;
      todom.startDate = Timestamp.fromDate(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          startTime != null ? startTime!.hour : todom.startDate!.toDate().hour,
          startTime != null
              ? startTime!.hour
              : todom.startDate!.toDate().minute));
      todom.endDate = Timestamp.fromDate(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          endTime != null ? endTime!.hour : todom.endDate!.toDate().hour,
          endTime != null ? endTime!.minute : todom.endDate!.toDate().minute));*/
    }
    //   selectedDailyPlanTodosModify[dateFormat.format(selectedDay)]=todos2;
    setToDoKeys(todos2, day: day);
    /* todos2.sort ((a, b) =>  DateTime( DateTime.now().year,DateTime.now().month, DateTime.now().day,  TimeOfDay.fromDateTime(a.startDateTodo.toDate()).hour,TimeOfDay.fromDateTime(a.startDateTodo.toDate()).minute).
    compareTo(DateTime( DateTime.now().year,DateTime.now().month, DateTime.now().day,  TimeOfDay.fromDateTime(b.startDateTodo.toDate()).hour,TimeOfDay.fromDateTime(b.startDateTodo.toDate()).minute)));*/
    // selectedTodos=todos2;

    /*await dietTasksRef
          .doc(dietToDo.ownerId)
          .collection('userDietTasks')
          .doc(dietToDo.parentId)
          .set({"title": dietToDo.title,
          "phrase": dietToDo.phrase,
          "startDateTodo":dietToDo.startDateTodo
                  });
        isTodoLoaded=true;  */

    notifyListeners();
  }

  giveUp() {
    todos2 = [];

    todosFirst.forEach((e) {
      DietToDos todo = DietToDos(
          id: e.id,
          isActive: e.isActive,
          isCompleted: e.isCompleted,
          ownerId: e.ownerId,
          parentId: e.parentId,
          phrases: List.from(e.phrases!),
          rank: e.rank,
          startDate: e.startDate,
          endDate: e.endDate,
          title: e.title);
      todos2.add(todo);
    });

    setToDoKeys(todos2);
    notifyListeners();
  }

  prepareTodoBeforeSave(String currentUserId) {
    //todoId = Uuid().generateV4();
  }

  void copyTask(DietTask? task) {
    String deneme = "";
    copiedTask = DietTask(
        backgroundId: task?.backgroundId,
        categoryName: task?.categoryName,
        days: task?.days,
        iconIds: task?.iconIds,
        id: task?.id,
        imageTitleUrl: task?.imageTitleUrl,
        indexes: task?.indexes,
        isActive: task?.isActive,
        isAdminTested: task?.isAdminTested,
        language: task?.language,
        likes: task?.likes,
        likesCount: task?.likesCount,
        ownerId: task?.ownerId,
        publishDate: task?.publishDate,
        title: task?.title);
  }

  saveTask(DietTask? task) async {}

  //takvimde seçilen günün plandaki sırasını değiştirir

  void changeDayRank(DateTime selectedDate, int day) {
    dayItems[selectedDate.day.toInt()];

    List<ItemData>? value1 = dayItems[day];
    List<ItemData>? value2 = dayItems[selectedDate.day];

    dayItems.remove(day);

    value1?.forEach((element) {
      element.todo.dayRank = selectedDate.day;
    });
    value2?.forEach((element) {
      element.todo.dayRank = day;
    });

    dayItems[selectedDate.day] = value1!;
    dayItems[day] = value2!;
    togglePlanUpdate = true;
    refresh();
  }

  //takvimde seçilen günün plandaki sırasını değiştirir

  void changeDayRankForGame(DateTime selectedDate, DateTime day) {
    String dayF = dateFormat.format(DateTime(day.year, day.month, day.day));
    String selectedDateF = dateFormat.format(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day));

    DateTime day_ = DateTime(day.year, day.month, day.day);
    DateTime selectedDate_ =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    List<DietToDos>? value1 = dailyEvents[day_];
    List<DietToDos>? value2 = dailyEvents[selectedDate_];

    List<String> v = ['1', '2'];
    Map<int, List<String>> a = {};
    Map<int, List<String>> b = {};
    a[1] = v;
    b[1] = v;

    v = ['4'];

    Map<int, String> c = {};
    Map<int, String> d = {};
    String x = '1';
    c[1] = x;
    d[1] = x;

    x = '2';

    dailyEventsModify.remove(day_);
    //   selectedDailyPlanTodosModify.remove(dayF);

    dailyEventsModify[selectedDate_] = value1!;
    dailyEventsModify[day_] = value2!;

    //selectedDailyPlanTodosModify[selectedDateF] = List.from(value1);
    //selectedDailyPlanTodosModify[dayF] = List.from(value2);

    String value1Title = dailyEventsTitle[day_]!;
    String value2Title = dailyEventsTitle[selectedDate_]!;

    dailyEventsTitleModify[selectedDate_] = value1Title;
    dailyEventsTitleModify[day_] = value2Title;

    //selectedTaskTitleModify[dayF] = value2Title;
    //selectedTaskTitleModify[selectedDateF] = value1Title;

    togglePlanUpdate = true;
    refresh();
  }

  void copyDayForGame(DateTime selectedDate, DateTime day) {
    String dayF = dateFormat.format(DateTime(day.year, day.month, day.day));
    String selectedDateF = dateFormat.format(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day));

    DateTime day_ = DateTime(day.year, day.month, day.day);
    DateTime selectedDate_ =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    List<DietToDos>? value2 = dailyEventsModify[selectedDate_];

    dailyEventsModify.remove(day_);
    //selectedDailyPlanTodosModify.remove(dayF);

    dailyEventsModify[day_] = value2!;
    //selectedDailyPlanTodosModify[dayF] = value2;

    String value2Title = dailyEventsTitle[selectedDate_]!;
    //selectedTaskTitleModify[dayF] = value2Title;
    dailyEventsTitleModify[day_] = value2Title;

    togglePlanUpdate = true;
    refresh();
  }

  void copyDay(DateTime selectedDate, int day) {
    debugPrint(newAddedCopiedTodos.length.toString());

    var value2 = dayItems[selectedDate.day];
    //newAddedTodos = [];
    List<DietToDos> newAddedTodos_ = [];

    for (var element in value2!) {
      newAddedTodos_.add(element.todo);
    }

    newAddedCopiedTodos = copy(newAddedTodos_, dayRank: day);
    newAddedCopiedTodos.forEach((element) {
      todos2.add(element);
    });

    List<ItemData> a = [];

    newAddedCopiedTodos.asMap().forEach((key, value) {
      ItemData x = ItemData(value, ValueKey(key));
      a.add(x);
    });

    dayItems[day] = a;
    togglePlanUpdate = true;

    refresh();
  }

  void deleteDay(DietTask task, DateTime selectedDate) {
    deletedItems = [];
    for (var element in dayItems[selectedDate.day]!) {
      deletedItems.add(element);
    }

    dayItems.remove(selectedDate.day);
    for (int i = selectedDate.day; i <= dayItems.keys.length; i++) {
      var value = dayItems[i + 1];
      dayItems[i] = value!;
      i + 1 == dayItems.keys.length ? dayItems.remove(i + 1) : null;
    }
    //  dayItems.remove(dayItems.keys.length);
    task.days = dayItems.keys.length;
    selectedValue = dayItems.keys.length.toDouble();
    debugPrint(task.days.toString());
    togglePlanUpdate = true;

    refresh();
  }

  bool checkHavingEvent(DateTime date) {
    if (dayItems.keys.contains(date.day)) {
      return true;
    } else {
      return false;
    }
  }

  bool checkHavingEventForGame(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    var a = [];
    var b = dateFormat.format(date);

    dailyEvents.forEach((key, value) {
      a.add(dateFormat.format(key));
    });

    if (a.contains(b)) {
      return true;
    } else {
      return false;
    }
  }

  void createTask({String? title, String? desc}) {
    createdTask =
        DietTask(title: title, desc: desc, ownerId: currentUser!.id, days: 1);
  }

  void copyNewTask() {
    copiedTask = DietTask(
        backgroundId: createdTask?.backgroundId,
        categoryName: createdTask?.categoryName,
        days: createdTask?.days,
        iconIds: createdTask?.iconIds,
        id: createdTask?.id,
        imageTitleUrl: createdTask?.imageTitleUrl,
        indexes: createdTask?.indexes,
        isActive: createdTask?.isActive,
        isAdminTested: createdTask?.isAdminTested,
        language: createdTask?.language,
        likes: createdTask?.likes,
        likesCount: createdTask?.likes,
        ownerId: createdTask?.ownerId,
        publishDate: createdTask?.publishDate,
        title: createdTask?.title);
  }

  getDietCoverImages() async {
    listUrls = [];

    ListResult listData = await storageRef.child("Diets").listAll();

    await Future.forEach(listData.items, (Reference element) async {
      await element.getDownloadURL().then((value) => listUrls.add(value));
    });
  }

  checkSliderDay() {
    List<int> deletedDays = [];

    newAddedCopiedTodos.removeWhere((element) {
      if (element.dayRank! > selectedValue!) {
        return true;
      } else {
        return false;
      }
    });

    newAddedTodos.removeWhere((element) {
      if (element.dayRank! > selectedValue!) {
        return true;
      } else {
        return false;
      }
    });

    dayItems.removeWhere((key, value) {
      if (key > selectedValue!) {
        deletedDays.add(key);
        togglePlanUpdate = true;

        for (var element in dayItems[key]!) {
          deletedItems.add(element);
        }
        ;
        return true;
      } else {
        return false;
      }
    });
    /*  if (deletedDays.isNotEmpty) {
      for (var element in deletedDays) {
        dayItemsCopied[element]!.forEach((element2) {
          deletedItems.add(element2.todo);
        });
      }
    }*/
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
}

class BuildCard extends StatelessWidget {
  final DietTask? task = null;

  const BuildCard(task);

  @override
  build(BuildContext context) {
    return Container(
      //color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              /*await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlogPage(blog: blog),
                ),
              );*/
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(task!.imageTitleUrl!),
                ),
                title: Text(
                  task!.title!,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 20,
                        color: AppColors.kRipple,
                      ),
                      const SizedBox(width: 5),
                      Text(task!.likesCount.toString(),
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15,
                              color: AppColors.kRipple))
                    ]),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}

class ItemData {
  final DietToDos todo;
  final Key key;

  ItemData(this.todo, this.key);
}

class Adam {
  final int id;
  final String ad;
  Adam(this.id, this.ad);
}
