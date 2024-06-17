// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:friendfit_ready/screens/MultiItem.dart';
import 'package:friendfit_ready/screens/create_game2.dart';
import 'package:lottie/lottie.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
//import 'package:flutter_multiselection_list/home_page.dart';

class GridItemMulti extends StatefulWidget {
  final Key? key;
  final ItemMulti item;
  final ValueChanged<bool>? isSelected;

  GridItemMulti(this.item, this.isSelected, this.key);

  @override
  _GridItemMultiState createState() => _GridItemMultiState();
}

class _GridItemMultiState extends State<GridItemMulti> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            widget.isSelected!(isSelected);
          });
        },
        child: Column(children: [
          /*Text(
            widget.item.title,
            style: const TextStyle(
                fontFamily: "Poppins", fontSize: 16, color: AppColors.kFont),
          ),*/
          Container(
            width: MediaQuery.of(context).size.width - 200,
            height: MediaQuery.of(context).size.width -
                200, // MediaQuery.of(context).size.height / 2 - 150,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                border: Border.all(
                    width: isSelected ? 2 : 1,
                    color: isSelected
                        ? Colors.green
                        : AppColors.kRipple.withOpacity(0.4))),
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 5),
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: AppColors.kFont),
                  ),
                  Center(
                    child: Lottie.asset(
                      widget.item.imageUrl,
                      fit: BoxFit.contain,
                      width: widget.item.rank == 1 ? 180 : 150,
                      height: widget.item.rank == 1 ? 160 : 140,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]));

    /*return

        /*Column(children: 
    [
    Stack( fit:StackFit.loose , children: [
    Text("okan"),],),
    Text("Erdoğan")
    
    ]);*/
        Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
              widget.isSelected!(isSelected);
            });
          },
          child: Container(
              width: 20,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  border: Border.all(
                      width: isSelected ? 2 : 1,
                      color: isSelected
                          ? Colors.green
                          : AppColors.kRipple.withOpacity(
                              0.4))) /*,
             
              child: widget.item.rank < 4
                  ? Center(
                      child: Lottie.asset(
                        widget.item.imageUrl,
                        width: 90,
                        height: 90,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: 40,
                        height: 200,
                        //color: Colors.green,
                       /* child: Image.asset(
                          widget.item.imageUrl, scale: 1, width: 40.0,
                          height: 40.0,
                          //color: Colors.black.withOpacity(isSelected ? 0.9 : 0),
                          //fit: BoxFit.contain,
                        ),*/
                      ),
                    )
                    
                    */

              ),
        ),
        const SizedBox(height: 5),
        Center(
          child: Text(
            widget.item.title,
            style: const TextStyle(
                fontFamily: "Poppins", fontSize: 12, color: AppColors.kFont),
          ),
        )
      ],
    );*/
  }
}
