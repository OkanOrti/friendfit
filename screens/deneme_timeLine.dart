// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
//import 'package:flutter_showcase/flutter_showcase.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:friendfit_ready/models/diet_game.dart';

class DenemeTimeLine extends StatefulWidget {
  final DietGame? game;
  // final DietGameViewModel model;

  const DenemeTimeLine({Key? key, this.game}) : super(key: key);
  @override
  DenemeTimelineState_ createState() => DenemeTimelineState_();
}

class DenemeTimelineState_ extends State<DenemeTimeLine> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TimelineTile(
        alignment: TimelineAlign.center,
        //lineXY: 0.3,
        startChild: Container(
          width: 100,
          height: 100,
          /*constraints: const BoxConstraints(
            minHeight: 120,
          ),*/
          color: Colors.lightGreenAccent,
        ),
        endChild: Container(
          width: 100,
          height: 100,
          color: Colors.amberAccent,
        ),
      ),
    );
  }
}

class Example3Vertical extends StatelessWidget {
  const Example3Vertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Container(
            color: Colors.white,
            child: TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.3,
              startChild: Container(
                constraints: const BoxConstraints(
                  minHeight: 120,
                ),
                color: Colors.lightGreenAccent,
              ),
              endChild: Container(
                color: Colors.amberAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Example3Horizontal extends StatelessWidget {
  const Example3Horizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 100),
                color: Colors.white,
                child: TimelineTile(
                  axis: TimelineAxis.horizontal,
                  alignment: TimelineAlign.manual,
                  lineXY: 0.3,
                  startChild: Container(
                    constraints: const BoxConstraints(
                      minWidth: 120,
                    ),
                    color: Colors.lightGreenAccent,
                  ),
                  endChild: Container(
                    color: Colors.amberAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
