import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';

class TimePickerWidget extends StatefulWidget {
  final String? type;
  final double? fontSize;
  final TimeOfDay? initialValue;
  final Function(TimeOfDay)? onValueChange;
  TimePickerWidget(
      {this.type, this.fontSize, this.onValueChange, this.initialValue});

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay? selectedTime; //= TimeOfDay(hour: 10, minute: 00);
  TimeOfDay? selectedTime2; //= TimeOfDay(hour: 10, minute: 00);

  String? value;
  @override
  void initState() {
    // TODO: implement initState
    //value = dateFormat2.format(selectedDate).toString();
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
              (widget.initialValue == null && selectedTime == null)
                  ? widget.type == "1"
                      ? " Başlangıç"
                      : "Bitiş"
                  : this.selectedTime == null
                      ? formatDate(
                          DateTime(2019, 08, 1, widget.initialValue!.hour,
                              widget.initialValue!.minute),
                          [HH, ':', nn, " ", am]).toString()
                      : formatDate(
                          DateTime(2019, 08, 1, selectedTime!.hour,
                              selectedTime!.minute),
                          [HH, ':', nn, " ", am]).toString(),
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 16, color: AppColors.kFont),
            ),
            /* Container(
                child: Image(
                    image:
                        AssetImage('assets/images/nutrition_icons/clock.png'),
                    width: 30,
                    height: 30)),*/
          ]),
      onTap: () async {
        /* selectedDate2 =
            widget.type == "1" ? await _selectDateTime(context) : null;
        // if (selectedDate == null) return;
        //final selectedTime2 = widget.type == "1" ? await _selectTime(context) : null;
        value =  widget.type == "1" ? dateFormat2.format(selectedDate2).toString()/* +
            " " +
            formatDate(
                DateTime(2019, 08, 1,selectedTime2.hour, selectedTime2.minute
                ),
                [HH, ':', nn, " ", am]
                ).toString()*/ :null;
        print(selectedDate);*/

        this.selectedTime = await _selectTime(context);
        //if (selectedTime == null) return;
        widget.onValueChange!(selectedTime!);

        setState(() {});
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
}
