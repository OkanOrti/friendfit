// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendfit_ready/utils/uuid.dart';

class StepPhrase {
  int? steps;
  String? steppedDate;
  bool? isLeft;
  String? id;
  int? win = 0;
  StepPhrase({this.steps = 0, this.steppedDate, this.id, this.isLeft});
}
