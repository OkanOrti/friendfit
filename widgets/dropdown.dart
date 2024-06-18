import "package:flutter/material.dart";
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/models/dietTodos.dart';

class DropDownButton extends StatefulWidget {
  final Function(String) onValueChange;
  DropDownButton(this.onValueChange, {this.initialValue});
  final String? initialValue;
  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  var _value;

  DropdownButton _hintDown() => DropdownButton<String>(
        underline: SizedBox(),
        isExpanded: true,
        items: [
          DropdownMenuItem<String>(
              value: "1",
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text(
                      "Sabah",
                      style: TextStyle(
                          color: AppColors.kFont,
                          fontFamily: "Poppins",
                          fontSize: 16),
                    ),
                    //Icon(FontAwesome.calendar_o),
                  ])),
          DropdownMenuItem<String>(
            value: "2",
            child: Text(
              "Öğlen",
              style: TextStyle(
                  color: AppColors.kFont, fontFamily: "Poppins", fontSize: 16),
            ),
          ),
          DropdownMenuItem<String>(
            value: "3",
            child: Text(
              "Akşam",
              style: TextStyle(
                  color: AppColors.kFont, fontFamily: "Poppins", fontSize: 16),
            ),
          ),
          DropdownMenuItem<String>(
            value: "4",
            child: Text(
              "Ara Öğün",
              style: TextStyle(
                  color: AppColors.kFont, fontFamily: "Poppins", fontSize: 16),
            ),
          ),
          DropdownMenuItem<String>(
            value: "5",
            child: Text(
              "Gece",
              style: TextStyle(
                  color: AppColors.kFont, fontFamily: "Poppins", fontSize: 16),
            ),
          )
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
          });
          widget.onValueChange(value!);
        },
        hint: Text(
          "Lütfen  periyod seçiniz",
          style: TextStyle(
              color: AppColors.kFont, fontFamily: "Poppins", fontSize: 16),
        ),
        value: widget.initialValue == null ? _value : widget.initialValue,
        elevation: 2,
      );

  /*DropdownButton _hint2Down() => DropdownButton<String>(
        items: null,
        onChanged: null,
        disabledHint: Text("You can't select anything."),
      );

  DropdownButton _normal2Down() => DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            value: "1",
            child: Text(
              "First",
            ),
          ),
          DropdownMenuItem<String>(
            value: "2",
            child: Text(
              "Second",
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        value: _value,
        elevation: 2,
        style: TextStyle(fontSize: 30),
        isDense: true,
        iconSize: 40.0,
      );

  /*DropdownButton _normalDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            value: "1",
            child: Text(
              "First",
            ),
          ),
          DropdownMenuItem<String>(
            value: "2",
            child: Text(
              "Second",
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        value: _value,
      );

  DropdownButton _itemDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem(
            value: "1",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.build),
                SizedBox(width: 10),
                Text(
                  "build",
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "2",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.settings),
                SizedBox(width: 10),
                Text(
                  "Setting",
                ),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        value: _value,
        isExpanded: true,
      );
*/
  */

  @override
  Widget build(BuildContext context) {
    return _hintDown();
  }
}
