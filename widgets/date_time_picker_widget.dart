import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';

class DateTimePickerWidget extends StatefulWidget {
  final String? type;
  final double? fontSize;
  final DateTime? initialValue;
  final Function(TimeOfDay)? onValueChange;
  final Function(DateTime)? onValueChange2;
  DateTimePickerWidget(
      {this.type,
      this.fontSize,
      this.onValueChange,
      this.onValueChange2,
      this.initialValue});

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime? selectedDate = DateTime.now();
  DateTime? selectedDate2 = DateTime.now();
  DateTime? selectedDateTime = DateTime.now();
  TimeOfDay? selectedTime; //= TimeOfDay(hour: 10, minute: 00);
  TimeOfDay? selectedTime2; //= TimeOfDay(hour: 10, minute: 00);
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm a');
  final DateFormat dateFormat2 = DateFormat('yyyy-MM-dd');
  String? value;
  @override
  void initState() {
    // TODO: implement initState
    value = dateFormat2.format(selectedDate!).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //selectedTime = widget.initialValue == null ?null:TimeOfDay.fromDateTime(widget.initialValue);

    return InkWell(
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.type == "1"
                  ? value ?? "Seçiniz"
                  /* +"okan"+ formatDate(
                              DateTime(2019, 08, 1, selectedTime2.hour,
                                  selectedTime2.minute),
                              [HH, ':', nn, " ", am]).toString()*/
                  : (widget.initialValue == null && selectedTime == null)
                      ? "Lütfen seçiniz"
                      : this.selectedTime == null
                          ? formatDate(
                              DateTime(
                                  2019,
                                  08,
                                  1,
                                  TimeOfDay.fromDateTime(widget.initialValue!)
                                      .hour,
                                  TimeOfDay.fromDateTime(widget.initialValue!)
                                      .minute),
                              [HH, ':', nn, " ", am]).toString()
                          : formatDate(
                              DateTime(2019, 08, 1, selectedTime!.hour,
                                  selectedTime!.minute),
                              [HH, ':', nn, " ", am]).toString(),
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 14, color: AppColors.kFont),
            ),
            /* Container(
                child: Image(
                    image:
                        AssetImage('assets/images/nutrition_icons/clock.png'),
                    width: 30,
                    height: 30)),*/
          ]),
      onTap: () async {
        selectedDate2 =
            widget.type == "1" ? await _selectDateTime(context) : null;
        // if (selectedDate == null) return;
        //final selectedTime2 = widget.type == "1" ? await _selectTime(context) : null;
        value = widget.type == "1"
            ? dateFormat2
                .format(selectedDate2!)
                .toString() /* +
            " " +
            formatDate(
                DateTime(2019, 08, 1,selectedTime2.hour, selectedTime2.minute
                ),
                [HH, ':', nn, " ", am]
                ).toString()*/
            : null;
        print(selectedDate);

        final selectedTime =
            widget.type == "2" ? await _selectTime(context) : null;
        //if (selectedTime == null) return;

        setState(() {
          this.value = widget.type == "1"
              ? dateFormat2
                  .format(selectedDate2!)
                  .toString() /*+
                  " " +
                  formatDate(
                      DateTime(2019, 08, 1, selectedTime2.hour,
                          selectedTime2.minute),
                      //[HH, ':', nn, " ", am]
                      ).toString()*/
              : null;
          this.selectedTime = widget.type == "2" ? selectedTime : null;
          widget.type == "1"
              ? widget.onValueChange2!(DateTime(
                  selectedDate2!.year,
                  selectedDate2!.month,
                  selectedDate2!.day,
                  //selectedTime2.hour,
                  //selectedTime2.minute
                ))
              : widget.onValueChange!(selectedTime!);
        });
      },
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) {
    final now = DateTime.now();

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
}
