// ignore: file_names
// ignore: prefer_const_constructors_in_immutables
// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendfit_ready/models/IntroPageData.dart';
import 'package:friendfit_ready/screens/PageIndicator.dart';
import 'package:friendfit_ready/size_config2.dart';
import 'package:lottie/lottie.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  //final UserRepository _userRepository;

  /* IntroScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
*/
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  PageController? _controller;
  int currentPage = 0;
  bool lastPage = false;
  AnimationController? animationController;
  Animation<double>? _scaleAnimation;

  //UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
    );
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween(begin: 0.6, end: 1.0).animate(animationController!);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFFFF5B7F), Color(0xFFFC9272)],
            tileMode: TileMode.clamp,
            begin: Alignment.topCenter,
            stops: [0.0, 1.0],
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              itemCount: pageList.length,
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  if (currentPage == pageList.length - 1) {
                    lastPage = true;
                    animationController!.forward();
                  } else {
                    lastPage = false;
                    animationController!.reset();
                  }
                  print(lastPage);
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller!,
                  builder: (context, child) {
                    var page = pageList[index];
                    var delta;
                    num y = 1.0;

                    if (_controller!.position.haveDimensions) {
                      delta = (_controller!.page! - index);
                      y = 1 - delta.abs().clamp(0.0, 1.0);
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          child: Lottie.asset(
                            page.imageUrl,
                          ),
                        ),
                        SizedBox(height: SizeConfig2.heightMultiplier * 5),
                        Container(
                          // color: Colors.blue,
                          margin: EdgeInsets.only(
                              left: SizeConfig2.heightMultiplier * 1.5,
                              right: SizeConfig2.heightMultiplier * 1.5),
                          height: SizeConfig2.heightMultiplier * 10,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Center(
                                  child: Text(
                                    page.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30, //SizeConfig2.heightMultiplier * 3.5,
                              top: SizeConfig2.heightMultiplier * 2,
                              right:
                                  30), // SizeConfig2.heightMultiplier * 3.5),
                          child: Transform(
                            transform:
                                Matrix4.translationValues(0, 50.0 * (1 - y), 0),
                            child: Text(
                              page.body,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal
                                  //color: Color(0xFF9B9B9B)
                                  ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ),
            Positioned(
              left: 30.0,
              //right: 30,
              bottom: 30.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    width: 160.0,
                    child: PageIndicator(currentPage, pageList.length)),
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 30.0,
              //bottom: 30.0,
              child: ScaleTransition(
                scale: _scaleAnimation!,
                child: lastPage
                    ? FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          /*BlocProvider.of<AuthenticationBloc>(context)
                              .add(AppStarted());*/
                          Navigator.of(context).pop();
                        },
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
