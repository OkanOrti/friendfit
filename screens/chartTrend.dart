// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/services/service_locator.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import '../constants.dart';
import 'package:friendfit_ready/widgets/progress.dart';

class ChartTrend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChartTrendState();
}

class ChartTrendState extends State<ChartTrend> {
  final StepViewModel stepModel2 = serviceLocator<StepViewModel>();

  final Color barBackgroundColor = AppColors.kRipple.withOpacity(0.4);
  final Duration animDuration = const Duration(milliseconds: 250);
  final DateFormat dateFormat = DateFormat('yyyy/MM/dd');
  Future? myFuture;
  int? touchedIndex;

  bool isPlaying = false;
  String? languageCode;
  @override
  void initState() {
    // stepModel2.getStepRange();
    // TODO: implement initState
    super.initState();
    stepModel2.firstRange();
    myFuture = stepModel2.getStepRange();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StepViewModel>(
        create: (context) => stepModel2,
        child: Consumer<StepViewModel>(
          builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'Adım Trend Verisi',
                  style: TextStyle(color: AppColors.kFont),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: kIconColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black54),
                brightness: Brightness.light,
                backgroundColor: Colors.white,
              ),
              body: FutureBuilder(
                  future: model.getStepRange(),
                  builder: (context, snapshot) {
                    /*if (!snapshot.hasData) {
                      return circularProgress();
                    }*/
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      /*return SpinKitThreeBounce(
                          color: AppColors.kRipple, size: 20);*/
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              //color: AppColors.kRipple.withOpacity(0.2),
                              child: SizedBox(
                                // height: 250,
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.arrow_left_sharp,
                                                size: 30,
                                              ),
                                              Text(dateFormat
                                                  .format(model.rangeStart!)),
                                              Text("-"),
                                              Text(dateFormat
                                                  .format(model.rangeEnd!)),
                                              DateTime.now().compareTo(
                                                          model.rangeEnd!) >
                                                      0
                                                  ? Icon(
                                                      Icons.arrow_right_sharp,
                                                      size: 30,
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          SizedBox(
                                            height: 150,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: BarChart(
                                                mainBarData(stepModel2),
                                                swapAnimationDuration:
                                                    animDuration,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Divider(
                                height: 1, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                                flex: 1,
                                child: ListView(
                                  children: buildHistData(
                                      model.chartData, model.rangeStart!),
                                ))
                          ],
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            //color: AppColors.kRipple.withOpacity(0.2),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            model.changeRangeBack();
                                            stepModel2.getStepRange();
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.arrow_left_sharp,
                                            size: 30,
                                          )),
                                      Text(
                                          dateFormat.format(model.rangeStart!)),
                                      Text("-"),
                                      Text(dateFormat.format(model.rangeEnd!)),
                                      DateTime.now()
                                                  .compareTo(model.rangeEnd!) >
                                              0
                                          ? GestureDetector(
                                              onTap: () {
                                                model.changeRangeForward();
                                                stepModel2.getStepRange();
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.arrow_right_sharp,
                                                size: 30,
                                              ))
                                          : Container()
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: BarChart(
                                        mainBarData(stepModel2),
                                        swapAnimationDuration: animDuration,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(
                              height: 1, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              //padding: EdgeInsets.zer,
                              //shrinkWrap: true,
                              children: buildHistData(
                                  model.chartData, model.rangeStart!),
                            ),
                          ),
                        ]),
                      );
                    } else {
                      return SizedBox();
                    }
                  })),
        ));
  }

  buildHistData(Map<int, double> data, DateTime start) {
    List<UserResult> results = [];

    for (var i in data.entries) {
      if (i.value != -1) {
        UserResult userResult = UserResult(i.key, i.value, start);
        results.add(userResult);
      }
    }
    return results.reversed.toList();
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = AppColors.kRipple,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: (isTouched ? y + 1 : y),
          color: isTouched ? Colors.white : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(StepViewModel model) =>
      List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
                0,
                (model.chartData[i] == null || model.chartData[i] == -1.0)
                    ? 0
                    : model.chartData[i]!,
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(
                1,
                (model.chartData[i] == null || model.chartData[i] == -1.0)
                    ? 0
                    : model.chartData[i]!,
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(
                2,
                (model.chartData[i] == null || model.chartData[i] == -1.0)
                    ? 0
                    : model.chartData[i]!,
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(
                3,
                (model.chartData[i] == null || model.chartData[i] == -1.0)
                    ? 0
                    : model.chartData[i]!,
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(
                4,
                (model.chartData[i] == null || model.chartData[i] == -1.0)
                    ? 0
                    : model.chartData[i]!,
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(
                5,
                (model.chartData[i] == null || model.chartData[i] == -1.0)
                    ? 0
                    : model.chartData[i]!,
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(
                6,
                (model.chartData[i] == null || model.chartData[i] == -1.0)
                    ? 0
                    : model.chartData[i]!,
                isTouched: i == touchedIndex);
          default:
            return makeGroupData(
                0,
                (model.chartData[i] == null || model.chartData[i] == -1.0)
                    ? 0
                    : model.chartData[i]!,
                isTouched: i == touchedIndex);
        }
      });

  BarChartData mainBarData(StepViewModel model) {
    var formatter = NumberFormat('#,##,###');
    return BarChartData(
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String? weekDay;
                switch (group.x.toInt()) {
                  case 0:
                    weekDay = 'Pazartesi';
                    break;
                  case 1:
                    weekDay = 'Salı';
                    break;
                  case 2:
                    weekDay = 'Çarşamba';
                    break;
                  case 3:
                    weekDay = 'Perşembe';
                    break;
                  case 4:
                    weekDay = 'Cuma';
                    break;
                  case 5:
                    weekDay = 'Cumartesi';
                    break;
                  case 6:
                    weekDay = 'Pazar';
                    break;
                }
                return BarTooltipItem(
                    weekDay! + '\n' + formatter.format(rod.toY),
                    TextStyle(color: Colors.white));
              }),
          touchCallback: ((FlTouchEvent event, barTouchResponse) {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          })),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(model),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColors.kFont,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Pzt', style: style);
        break;
      case 1:
        text = const Text('Sal', style: style);
        break;
      case 2:
        text = const Text('Çar', style: style);
        break;
      case 3:
        text = const Text('Per', style: style);
        break;
      case 4:
        text = const Text('Cum', style: style);
        break;
      case 5:
        text = const Text('Cmt', style: style);
        break;
      case 6:
        text = const Text('Pzr', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return Padding(padding: const EdgeInsets.only(top: 16), child: text);
  }

  Future<dynamic> refreshState() async {
    setState(() {});
  }
}

class UserResult extends StatelessWidget {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  final int keyOf;
  final double value;
  final DateTime start;

  UserResult(this.keyOf, this.value, this.start);
  var formatter = NumberFormat('#,##,###');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            start.add(Duration(days: keyOf)).compareTo(DateTime.now()) > 0
                ? SizedBox()
                : Text(
                    dateFormat.format(start.add(Duration(days: keyOf))),
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Colors.grey),
                  ),
            start.add(Duration(days: keyOf)).compareTo(DateTime.now()) > 0
                ? SizedBox()
                : Row(children: [
                    SvgPicture.asset('assets/images/run.svg', height: 18.0),
                    Text("  " + formatter.format(value) + " adım",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.black)),
                  ]),
            SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
