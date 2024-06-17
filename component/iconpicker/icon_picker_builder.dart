import 'package:flutter/material.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'icon_picker.dart';

class IconPickerBuilder extends StatelessWidget {
  final Choice? iconData;
  final ValueChanged<Choice>? action;
  final Color highlightColor;
  final List<Choice>? preIconsList;

  IconPickerBuilder(
      {@required this.iconData,
      @required this.action,
      required Color highlightColor,
      this.preIconsList})
      : this.highlightColor = highlightColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Listenize ikon ekleyin'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Kapat",
                      style: TextStyle(color: AppColors.kRipple),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
                content: SingleChildScrollView(
                  child: IconPicker(
                    preIconsList2: this.preIconsList ?? [],
                    currentIconData: iconData,
                    onIconChanged: action,
                    highlightColor: highlightColor,
                  ),
                ),
              );
            },
          );
        },
        child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.kRipple,
              ),
            ),
            child: Icon(
              Icons.add,
              color: Colors.grey,
            )));
  }
}
