// ignore_for_file: file_names, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/models/surveyModel.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:survey_kit/survey_kit.dart' as a;

class SurveyViewModel extends ChangeNotifier {
  final surveyRef = FirebaseFirestore.instance.collection('survey');
  List<a.TextChoice> choicesText = [];
  List<a.Step> surveySteps = [];
  List<SurveyModel>? docs = [];
  String? surveyId = "";
  Map<String, dynamic> resultsByUser = {};
  Map<String, String> results = {};

  SurveyModel? selectedSurvey;

  getSurveyQuestions(String id) async {
    surveyId = id;
    SurveyModel? doc;
    surveySteps = [];
    List<SurveyModel?> sortedDocs = [];
    var questionsDocs = await surveyRef.doc(id).collection("questions").get();
    var selectedSurveyDoc = await surveyRef.doc(id).get();
    selectedSurvey = SurveyModel.fromDocument(selectedSurveyDoc);
    //questionsDocs.docs.sort((a, b) => mySortComparison(a, b));
    //(a, b) => int.parse(a["row"]).compareTo(int.parse(b["row"]))

    //sortedDocs = questionsDocs.docs;
    questionsDocs.docs.forEach((element) {
      doc = SurveyModel.fromDocument(element);
      sortedDocs.add(doc);

      //createSurvey(doc!);
    });
    sortedDocs.sort((a, b) => mySortComparison(a!, b!));
    sortedDocs.forEach((element) {
      createSurvey(element!);
    });

    var task = a.OrderedTask(id: a.TaskIdentifier(), steps: surveySteps);
    return task;
  }

  int mySortComparison(SurveyModel a, SurveyModel b) {
    final propertyA = a.row!.toInt();
    final propertyB = b.row!.toInt();
    if (propertyA < propertyB) {
      return -1;
    } else if (propertyA > propertyB) {
      return 1;
    } else {
      return 0;
    }
  }

  getSurveys() async {
    SurveyModel? doc;
    SurveyModel? doc2;
    docs = [];

    var val = await surveyRef.where("statu", isEqualTo: true).get();

    if (val.docs.isNotEmpty) {
      val.docs.forEach((element) {
        doc = SurveyModel.fromDocument(element);
        (doc!.isAdminChecked == false && currentUser!.id != adminId)
            ? null
            : currentUser!.id == adminId
                ? docs?.add(doc!)
                : (doc!.surveyResults!.containsKey(currentUser!.id)
                    ? null
                    : docs?.add(doc!));
      });
    }

    return (docs);
  }

  createSurvey(SurveyModel doc) {
    if (doc.answerFormat == "IntegerAnswerFormat") {
      surveySteps.add(a.QuestionStep(
        title: doc.title!,
        answerFormat: a.IntegerAnswerFormat(
          defaultValue: doc.defaultValue,
          hint: doc.hint!,
        ),
        isOptional: doc.isOptional!,
      ));
    } else if (doc.answerFormat == "BooleanAnswerFormat") {
      surveySteps.add(a.QuestionStep(
        title: doc.title!,
        text: doc.text!,
        answerFormat: a.BooleanAnswerFormat(
          positiveAnswer: doc.positiveAnswer!,
          negativeAnswer: doc.negativeAnswer!,
          //result: BooleanResult.POSITIVE,
        ),
      ));
    } else if (doc.answerFormat == "ScaleAnswerFormat") {
      surveySteps.add(a.QuestionStep(
        title: doc.title!,
        answerFormat: a.ScaleAnswerFormat(
          step: 1,
          minimumValue: doc.minimumValue!.toDouble(),
          maximumValue: doc.maximumValue!.toDouble(),
          defaultValue: doc.defaultValue!.toDouble(),
          // minimumValueDescription: '1',
          // maximumValueDescription: '5',
        ),
      ));
    } else if (doc.answerFormat == "TextAnswerFormat") {
      surveySteps.add(a.QuestionStep(
        title: doc.title!,
        text: doc.text!,
        answerFormat: const a.TextAnswerFormat(
          maxLines: 5,
          validationRegEx: "^(?!\s*\$).+",
        ),
      ));
    } else if (doc.answerFormat == "MultipleChoiceAnswerFormat") {
      getTextChoices(doc.textChoices!);
      surveySteps.add(a.QuestionStep(
          title: doc.title!,
          text: doc.text!,
          isOptional: doc.isOptional!,
          answerFormat:
              a.MultipleChoiceAnswerFormat(textChoices: choicesText)));
    } else if (doc.answerFormat == "SingleChoiceAnswerFormat") {
      getTextChoices(doc.textChoices!);
      surveySteps.add(a.QuestionStep(
        title: doc.title!,
        text: doc.text!,
        answerFormat: a.SingleChoiceAnswerFormat(
          textChoices: choicesText,
          defaultSelection: a.TextChoice(
              text: doc.defaultSelection!, value: doc.defaultSelection!),
        ),
      ));
    } else if (doc.answerFormat == "TimeAnswerFormat") {
      surveySteps.add(a.QuestionStep(
        title: doc.title!,
        answerFormat: a.TimeAnswerFormat(
          defaultValue: TimeOfDay(
            hour: doc.defaultValueTime!.toDate().hour,
            minute: doc.defaultValueTime!.toDate().minute,
          ),
        ),
      ));
    } else if (doc.answerFormat == "DateAnswerFormat") {
      surveySteps.add(a.QuestionStep(
        title: doc.title!,
        answerFormat: a.DateAnswerFormat(
          minDate: doc.minDate!.toDate(), //  DateTime.utc(1970),
          defaultDate: doc.defaultDate!.toDate(),
          maxDate: DateTime.now(),
        ),
      ));
    } else if (doc.answerFormat == "CompletionStep") {
      surveySteps.add(a.CompletionStep(
        stepIdentifier: a.StepIdentifier(),
        text: doc.text!,
        title: doc.title!,
        buttonText: doc.buttonText!,
      ));
    } else if (doc.answerFormat == "InstructionStep") {
      surveySteps.add(a.InstructionStep(
        text: doc.text!,
        title: doc.title!,
        buttonText: doc.buttonText!,
      ));
    }
  }

  void getTextChoices(List choices) {
    choices.forEach((element) {
      choicesText.add(a.TextChoice(text: element.text, value: element.value));
    });
  }

  handleStep(a.QuestionResult questionResult) async {
    Map<String, Map<String, String>> deneme = {};
    Map<String, String> deneme2 = {};
    //deneme.addEntries(MapEntry("yaşınız kaç","12"));

    deneme2["Yaşınız kaç?"] = "12";
    deneme["okan"]?["yaş"] = "14";
    //  ornek1[questionResult.title] = questionResult.result.toString();
    results[questionResult.title!] =
        questionResult.result == null ? "" : questionResult.result.toString();
  }

  saveSurvey() async {
    resultsByUser = selectedSurvey!.surveyResults ?? {};
    if (resultsByUser.containsKey(currentUser!.id)) {
      return null;
    }
    //kontrol et aynı user için kayıt varsa ekleme kayıt yoksa ekle..

    resultsByUser[currentUser!.id!] = results;
    await surveyRef.doc(surveyId).update({"sonuclar": resultsByUser});
  }
}
