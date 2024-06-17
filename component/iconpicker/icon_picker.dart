import 'package:flutter/material.dart';
import 'package:friendfit_ready/component/todo_badge.dart';
import 'package:friendfit_ready/data/choice_card.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

class IconPicker extends StatefulWidget {
  final ValueChanged<Choice>? onIconChanged;
  final Choice? currentIconData;
  final Color? highlightColor;
  final Color? unHighlightColor;
  final List<Choice>? preIconsList2;

  final List<Image> icons = [
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/clock.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/no_fastfood.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/bread.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/dairy.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/fruits.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/no-junk-food.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/juice.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/no-gluten.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/no-meat.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/no-nut.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/no-sugar.png')),
    /* Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/proteins.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/reduce.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/tartı.png')),
    Image(
        width: 35,
        height: 35,
        image: AssetImage('assets/images/nutrition_icons/water.png')),*/
  ];

  final List<Choice> icons_ = [];

  IconPicker({
    @required this.currentIconData,
    @required this.onIconChanged,
    this.preIconsList2,
    Color? highlightColor,
    Color? unHighlightColor,
  })  : this.highlightColor = highlightColor ?? Colors.red,
        this.unHighlightColor = unHighlightColor ?? Colors.blueGrey;

  @override
  State<StatefulWidget> createState() {
    return _IconPickerState();
  }
}

class _IconPickerState extends State<IconPicker> {
  Choice? selectedIconData;

  @override
  void initState() {
    selectedIconData = widget.currentIconData;
    choices.forEach((element) {
      widget.preIconsList2!.contains(element)
          ? element.isSelected = 1
          : element.isSelected = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: orientation == Orientation.portrait ? 200.0 : 200.0,
      height: orientation == Orientation.portrait ? 260.0 : 100.0,
      child: GridView.builder(
        itemBuilder: (BuildContext context, int index) {
          var iconData = choices[index]; // widget.icons[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIconData = iconData;
                  if (iconData.isSelected == 1) {
                    iconData.isSelected = 0;
                  } else {
                    iconData.isSelected = 1;
                  }
                  // selectedIconData.isSelected=1;
                });
                widget.onIconChanged!(iconData);
              },
              borderRadius: BorderRadius.circular(50.0),
              child: TodoBadge(
                // id: iconData.hashCode.toString(),
                codePoint: iconData,
                outlineColor: (iconData.isSelected == 1) ? Colors.green : null,
                color: (iconData ==
                        selectedIconData) //iconData == selectedIconData
                    ? widget.highlightColor
                    : widget.unHighlightColor,
                size: 40,
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: choices.length,
      ),
    );
  }
}
