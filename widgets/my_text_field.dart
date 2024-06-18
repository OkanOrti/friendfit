import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? label;
  final int maxLines;
  final int minLines;
  final Icon? icon;
  final int? maxlength;
  MyTextField(
      {this.label,
      this.maxLines = 1,
      this.minLines = 1,
      this.icon,
      this.maxlength});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //textAlign: TextAlign.center,
      style:
          TextStyle(color: Colors.black87, fontFamily: "Poppins", fontSize: 14),
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxlength,

      decoration: InputDecoration(
        suffixIcon: icon == null ? null : icon,
        hintText: label,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        //labelStyle: TextStyle(color: Colors.black45),

        // focusedBorder:              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        //border:              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))
      ),
    );
  }
}
