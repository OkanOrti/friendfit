import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

import 'filter_model.dart';

class FilterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FilterScreenState();
  }
}

class FilterScreenState extends State<FilterScreen> {
  bool isPaid = false;
  bool isFree = false;
  bool isLatest = false;
  bool isOld = false;
  bool isFilter = false;
  List<String> selected = List.empty(growable: true);
  List<BookF> filter_three = [
    BookF("1", "Tümü", false),
    BookF("2", "Başladı", false),
    BookF("3", "İptal", false),
    BookF("4", "Tamamlandı", false),
    BookF("5", "Bekliyor", false),
    BookF("6", "İnaktif", false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.kRipple,
        actions: [
          MaterialButton(onPressed: () {
            setState(() {
              filter_three.forEach((element) {
                element.isSelected = false;
              });

              isFilter = false;
              isPaid = false;
              isFree = false;
              isLatest = false;
              isOld = false;
            });
          }),
          MaterialButton(
              onPressed: () {
                Map<String, dynamic> filters = Map();
                /*filters['isPaid'] = (isPaid) ? 1 : 0;
                filters['isFree'] = (isFree) ? 1 : 0;
                filters['Latest'] = (isLatest) ? 1 : 0;
                filters['Old'] = (isOld) ? 1 : 0;*/
                filters['selected'] = (selected);
                Navigator.pop(context, selected);
              },
              child: const Text(
                "Uygula",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /* Text("Sort By", style: TextStyle(color: Colors.red)),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Checkbox(
                      value: isPaid,
                      onChanged: (value) {
                        setState(() {
                          isPaid = value!;
                          isFilter = true;
                        });
                      }),
                  Text("Paid", style: TextStyle(color: Colors.red)),
                ]),
                Row(children: [
                  Checkbox(
                      value: isFree,
                      onChanged: (value) {
                        setState(() {
                          isFree = value!;
                          isFilter = true;
                        });
                      }),
                  Text("Free", style: TextStyle(color: Colors.red)),
                ]),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                Text("Sort By", style: TextStyle(color: Colors.deepPurple)),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Checkbox(
                      value: isLatest,
                      onChanged: (value) {
                        setState(() {
                          isLatest = value!;
                        });
                      }),
                  Text("Latest", style: TextStyle(color: Colors.deepPurple)),
                ]),
                Row(children: [
                  Checkbox(
                      value: isOld,
                      onChanged: (value) {
                        setState(() {
                          isOld = value!;
                        });
                      }),
                  Text("Old", style: TextStyle(color: Colors.deepPurple)),
                ]),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 2,
                  color: Colors.grey,
                ),*/
                const Text("Filtre",
                    style: TextStyle(
                        color: AppColors.kFont, fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8,
                  direction: Axis.horizontal,
                  children: techChips(
                      filter_three, AppColors.kRipple.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> techChips(List<BookF> _chipsList, color) {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: FilterChip(
          selectedColor: color,
          label: Text(_chipsList[i].filter_title),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: color,
          selected: _chipsList[i].isSelected,
          checkmarkColor: Colors.white,
          onSelected: (bool value) {
            if (value) {
              selected.add(_chipsList[i].filter_title);
            } else {
              selected.remove(_chipsList[i].filter_title);
            }
            setState(() {
              _chipsList[i].isSelected = value;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}
