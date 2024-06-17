import 'dart:math';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';

class PositionedTiles extends StatefulWidget {
  DietGameViewModel? w;

  PositionedTiles({this.w, Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  // Stateful tiles now wrapped in padding (a stateless widget) to increase height
  // of widget tree and show why keys are needed at the Padding level.
  List<Widget> tiles = [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: StatefulColorfulTile(
        key: UniqueKey(),
        myColor: Colors.red,
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: StatefulColorfulTile(
        key: UniqueKey(),
        myColor: Colors.blue,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            await widget.w!.refresh();

            //  await taskModel.refresh();
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Row(children: tiles))),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.sentiment_very_satisfied), onPressed: swapTiles),
    );
  }

  swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }
}

class StatefulColorfulTile extends StatefulWidget {
  StatefulColorfulTile({Key? key, this.myColor}) : super(key: key);
  Color? myColor;

  @override
  ColorfulTileState createState() => ColorfulTileState();
}

class ColorfulTileState extends State<StatefulColorfulTile> {
  // ColorfulTileState({this.myColor});

  @override
  void initState() {
    super.initState();
    //  myColor = UniqueColorGenerator.getColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: widget.myColor,
        child: Padding(
          padding: const EdgeInsets.all(70.0),
        ));
  }
}

class UniqueColorGenerator {
  static Random random = new Random();
  static Color getColor() {
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}

class Okan {
  String _ad;
  final String soyad;
  Okan(String a, String s)
      : _ad = a,
        soyad = s;

  func() {}
}
