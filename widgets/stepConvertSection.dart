// ignore_for_file: empty_statements, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:lottie/lottie.dart';

class StepConvertSection extends StatefulWidget {
  final DietGameViewModel? model;
  const StepConvertSection({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  StepConvertSectionState createState() => StepConvertSectionState();
}

class StepConvertSectionState extends State<StepConvertSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CardContainer(),
    );
  }
}

class CardContainer extends StatelessWidget {
  const CardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  width: double.infinity,
      // height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.kRipple.withOpacity(0.1),
      ),
      /*gradient:const LinearGradient(
          colors: [
            Color(0xFFFF422C),
            Color(0xFFFF9003),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.25, 0.90],
        ),
        // ignore: prefer_const_literals_to_create_immutables
        /* boxShadow: [
          BoxShadow(
            color: Color(0xFF101012),
            offset: Offset(-12, 12),
            blurRadius: 8,
          ),
        ],*/
      ),*/
      alignment: Alignment.centerLeft, //to align its child
      padding: EdgeInsets.all(20),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flexible(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Adımlarını Dönüştür",
                style: TextStyle(color: AppColors.kFont),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(),
                  /* Lottie.asset('assets/lottie/sprinter.json', width: 50, height: 50),
                  SizedBox(width: 15),*/
                  Lottie.asset('assets/lottie/convert.json',
                      width: 40, height: 40),
                  /* SizedBox(width: 15),
                  Lottie.asset('assets/lottie/coin-stacking.json',
                      width: 45, height: 45),*/
                ],
              ),
            ]),
          ),
        ),
        Flexible(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "İzle Kazan",
              style: TextStyle(color: AppColors.kFont),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                /* Lottie.asset('assets/lottie/sprinter.json', width: 50, height: 50),
                SizedBox(width: 15),*/
                Lottie.asset('assets/lottie/convert.json',
                    width: 40, height: 40),
                SizedBox(width: 15),
                Lottie.asset('assets/lottie/coin-stacking.json',
                    width: 45, height: 45),
              ],
            ),
          ]),
        ),
        Flexible(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Yanıtla/Bil Kazan",
              style: TextStyle(color: AppColors.kFont),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                /* Lottie.asset('assets/lottie/sprinter.json', width: 50, height: 50),
                SizedBox(width: 15),*/
                Lottie.asset('assets/lottie/convert.json',
                    width: 40, height: 40),
              ],
            ),
          ]),
        ),
      ]),
    );
  }
}
