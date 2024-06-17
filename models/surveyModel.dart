// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  final String? id;
  final String? title;
  final String? instructionTitle;
  final String? instructionText;
  final String? instructionButtonText;
  final String? completionTitle;
  final String? completionText;
  final String? completionButtonText;
  final String? imageTitleUrl;
  final String? text;
  final List<dynamic>? textChoices;
  final List<dynamic>? participants;
  final String? buttonText;
  final String? answerFormat;
  final bool? isActive;
  final int? fitCoin;
  final int? defaultValue;
  final int? minimumValue;
  final int? maximumValue;
  final String? hint;
  final String? defaultSelection;
  final Timestamp? defaultValueTime;
  final Timestamp? minDate;
  final Timestamp? maxDate;
  final Timestamp? defaultDate;
  final bool?
      isOptional; //değer "false" ise sadece admin görebilir makaleyi kontrol amaçlı.
  final String? positiveAnswer;
  final String? negativeAnswer;
  final int? row;
  final bool? isAdminChecked;

  final List<dynamic>? indexes;
  final Map<String, dynamic>?
      surveyResults; //ilerde diyetisyenler ve profesyonel kullanıcılarda yazı gönderebilir.
  SurveyModel(
      {this.id,
      this.title,
      this.isAdminChecked,
      this.surveyResults,
      this.row,
      this.instructionButtonText,
      this.instructionText,
      this.instructionTitle,
      this.imageTitleUrl,
      this.answerFormat,
      this.buttonText,
      this.completionButtonText,
      this.completionText,
      this.completionTitle,
      this.defaultDate,
      this.defaultSelection,
      this.defaultValue,
      this.defaultValueTime,
      this.fitCoin,
      this.hint,
      this.indexes,
      this.isActive,
      this.isOptional,
      this.maxDate,
      this.minDate,
      this.negativeAnswer,
      this.maximumValue,
      this.minimumValue,
      this.participants,
      this.positiveAnswer,
      this.text,
      this.textChoices});

  factory SurveyModel.fromDocument(DocumentSnapshot doc) {
    //print(doc);
    return SurveyModel(
      id: (doc.data() as Map).containsKey('id') ? doc['id'] : doc.id,
      title: (doc.data() as Map).containsKey('title') ? doc['title'] : null,
      imageTitleUrl: (doc.data() as Map).containsKey('imageTitleUrl')
          ? doc['imageTitleUrl']
          : null,
      answerFormat: (doc.data() as Map).containsKey('answerFormat')
          ? doc['answerFormat']
          : null,
      buttonText: (doc.data() as Map).containsKey('buttonText')
          ? doc['buttonText']
          : null,
      instructionButtonText:
          (doc.data() as Map).containsKey('instructionButtonText')
              ? doc['instructionButtonText']
              : null,
      instructionText: (doc.data() as Map).containsKey('instructionText')
          ? doc['instructionText']
          : null,
      instructionTitle: (doc.data() as Map).containsKey('instructionTitle')
          ? doc['instructionTitle']
          : null,
      completionButtonText:
          (doc.data() as Map).containsKey('completionButtonText')
              ? doc['completionButtonText']
              : null,
      completionText: (doc.data() as Map).containsKey('completionText')
          ? doc['completionText']
          : null,
      completionTitle: (doc.data() as Map).containsKey('completionTitle')
          ? doc['completionTitle']
          : null,
      defaultDate: (doc.data() as Map).containsKey('defaultDate')
          ? doc['defaultDate']
          : null,
      defaultSelection: (doc.data() as Map).containsKey('defaultSelection')
          ? doc['defaultSelection']
          : null,
      defaultValue: (doc.data() as Map).containsKey('defaultValue')
          ? doc['defaultValue']
          : null,
      defaultValueTime: (doc.data() as Map).containsKey('defaultValueTime')
          ? doc['defaultValueTime']
          : null,
      fitCoin:
          (doc.data() as Map).containsKey('fitCoin') ? doc['fitCoin'] : null,
      hint: (doc.data() as Map).containsKey('hint') ? doc['hint'] : null,
      indexes:
          (doc.data() as Map).containsKey('indexes') ? doc['indexes'] : null,
      isActive:
          (doc.data() as Map).containsKey('isActive') ? doc['isActive'] : null,
      isOptional: (doc.data() as Map).containsKey('isOptional')
          ? doc['isOptional']
          : null,
      maxDate:
          (doc.data() as Map).containsKey('maxDate') ? doc['maxDate'] : null,
      minDate:
          (doc.data() as Map).containsKey('minDate') ? doc['minDate'] : null,
      negativeAnswer: (doc.data() as Map).containsKey('negativeAnswer')
          ? doc['negativeAnswer']
          : null,
      maximumValue: (doc.data() as Map).containsKey('maximumValue')
          ? doc['maximumValue']
          : null,
      minimumValue: (doc.data() as Map).containsKey('minimumValue')
          ? doc['minimumValue']
          : null,
      participants: (doc.data() as Map).containsKey('participants')
          ? doc['participants']
          : null,
      positiveAnswer: (doc.data() as Map).containsKey('positiveAnswer')
          ? doc['positiveAnswer']
          : null,
      text: (doc.data() as Map).containsKey('text') ? doc['text'] : null,
      textChoices: (doc.data() as Map).containsKey('textChoices')
          ? doc['textChoices']
          : null,
      row: (doc.data() as Map).containsKey('row') ? doc['row'] : null,
      surveyResults:
          (doc.data() as Map).containsKey('sonuclar') ? doc['sonuclar'] : null,
      isAdminChecked: (doc.data() as Map).containsKey('isAdminChecked')
          ? doc['isAdminChecked']
          : null,
    );
  }
}
