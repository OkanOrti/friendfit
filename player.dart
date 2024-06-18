import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:video_player/video_player.dart';
class PlayerScreen extends StatefulWidget {

  final String url;


  PlayerScreen({required this.url});
  @override
  _PlayerScreenScreenState createState() => _PlayerScreenScreenState();
}

class _PlayerScreenScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;
  bool isLandscape=false;
  int turns=0;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          (turns==0)?AppBar(title: Text("Player"),):SizedBox.shrink(),
          SingleChildScrollView(
            child:(_controller.value.isInitialized) ? RotatedBox(quarterTurns:turns,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child:  Stack(
                  alignment: Alignment.bottomCenter,
                  children: [

                    VideoPlayer(_controller),
                    _ControlsOverlay(controller: _controller,onClickCallback:(){
                      setState(() {
                        if( turns==0)
                          turns=1;
                        else turns=0;
                      });
                    }),
                    VideoProgressIndicator(_controller, allowScrubbing: true),

                  ],

                ),),
            ):
            Container(height:300,child: Center(child: CircularProgressIndicator(),)),



          ),
        ],
      ),

    );
  }

}
/// blocks rotation; sets orientation to: portrait
void _LandscapeModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
typedef ColorCallback = void Function();
class _ControlsOverlay extends StatelessWidget {
  final ColorCallback onClickCallback;
  const _ControlsOverlay({Key? key, required this.controller,required this.onClickCallback})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          color: Colors.black26,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              reverseDuration: Duration(milliseconds: 200),
              child: Row(

                children: [
                  MaterialButton(
                    minWidth: 20,
                    onPressed: () async{
                      var position=   await controller.position;

                      controller.seekTo(Duration(seconds: position!.inSeconds-5));
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 10,),
                  controller.value.isPlaying
                      ? MaterialButton(
                    minWidth: 20,
                    child: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      controller.value.isPlaying ? controller.pause() : controller.play();
                    },
                  )
                      : MaterialButton(
                    minWidth: 20,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      controller.value.isPlaying ? controller.pause() : controller.play();
                    },
                  ),
                  SizedBox(width: 10,),
                  MaterialButton(
                    minWidth: 20,
                    onPressed: () async{
                      var position=   await controller.position;

                      controller.seekTo(Duration(seconds: position!.inSeconds+5));
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ), SizedBox(width: 10,),
                  MaterialButton(
                    minWidth: 20,
                    onPressed: () async{
                      onClickCallback();
                    },
                    child: Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 10,),
                  PopupMenuButton<double>(
                    initialValue: controller.value.playbackSpeed,
                    tooltip: 'Playback speed',
                    color: Colors.white,
                    onSelected: (speed) {
                      controller.setPlaybackSpeed(speed);
                    },
                    itemBuilder: (context) {
                      return [
                        for (final speed in _examplePlaybackRates)
                          PopupMenuItem(
                            value: speed,
                            child: Text('${speed}x',),
                          )
                      ];
                    },
                    child: Text('${controller.value.playbackSpeed}x',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }
}