// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ad_helper.dart';
import 'package:friendfit_ready/constants.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/widgets/wallet.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'circle_painter.dart';
import 'curve_wave.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:provider/provider.dart';
import 'package:friendfit_ready/screens/chartTrend.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation(
      {Key? key,
      this.size = 80.0,
      this.color = Colors.yellow,
      this.onPressed,
      this.stepToday,
      this.gameModel,
      this.stepModel})
      : super(key: key);
  final double size;
  final Color color;
  final String? stepToday;
  final StepViewModel? stepModel;
  final DietGameViewModel? gameModel;

  //final Widget child;
  final VoidCallback? onPressed;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late AnimationController converterController;
  Timer? timer;
  Timer? timer2;
  RewardedAd? _rewardedAd;
  @override
  void initState() {
    asyncMethod();

    WidgetsBinding.instance!.addObserver(this);
    widget.stepModel!.timer = Timer.periodic(Duration(seconds: 10),
        (Timer t) => widget.stepModel!.getStepDataToday_F());

    // Timer.periodic(Duration(seconds: 10), (Timer T) => debugPrint("oo"));

    /*timer2 =
        Timer.periodic(Duration(seconds: 10), (Timer t) => widget.stepModel!.hello());*/

    converterController = AnimationController(vsync: this);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    _loadRewardedAd();

    super.initState();
  }

  void _loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
                widget.gameModel!.isLoadingLottie = true;
                widget.gameModel!.refresh();
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final granted = await Permission.activityRecognition.isGranted;
      if (granted) {
        await widget.stepModel!.readPermissions();
        //do whatever you want
      }
    }
  }

  asyncMethod() async {
    //await widget.stepModel!.getBalance();
    // await widget.stepModel!.checkPermission();
    //await context.read<StepViewModel>().checkWallet();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.stepModel!.timer!.cancel();
    _rewardedAd?.dispose();
    //  widget.stepModel!.dispose();

    super.dispose();
  }

  Widget _button(String? stepCount) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(color: null),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const CurveWave(),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(stepCount ?? "-",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              color: Colors.grey[300])),
                      SizedBox(height: 2),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("adım",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    color: Colors.grey[300])),
                            // ,
                          ]),
                      SvgPicture.asset('assets/images/run.svg',
                          height: 20.0) //Icon(Icons.directions_run, size: 20)
                    ]),
              ) //Icon(Icons.speaker_phone, size: 44,)
              ),
        ),
      ),
    );
  }

  void showDialogMsg(BuildContext context) {
    RichText? alertMsg;
    RichText? alertMsg2;

    if (widget.stepModel!.maxLimit) {
      alertMsg = RichText(
          text: TextSpan(
              text: 'Günde en fazla ',
              style: TextStyle(
                  color: AppColors.kFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              children: <TextSpan>[
            TextSpan(
              text: '$maxSteps',
              style: TextStyle(
                  color: AppColors.kRipple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            TextSpan(
                text: ' adım dönüştürebilirsin.',
                style: TextStyle(
                    color: AppColors.kFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w500))
          ]));
    }

    if (!widget.stepModel!.maxLimit && !widget.stepModel!.convertible) {
      alertMsg = RichText(
          text: TextSpan(
              text: 'Adımını dönüştürmen için ',
              style: TextStyle(
                  color: AppColors.kFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              children: <TextSpan>[
            TextSpan(
              text: widget.stepModel!.convertibleSteps.toString(),
              style: TextStyle(
                color: AppColors.kRipple,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                //decoration: TextDecoration.underline
              ),
            ),
            TextSpan(
                text: ' adıma daha ihtiyacın var. ',
                style: TextStyle(
                    color: AppColors.kFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w500))
          ]));
    }
    if (!widget.stepModel!.maxLimit && widget.stepModel!.convertible) {
      alertMsg2 = //"Dönüştürebileceğin adım sayısı $convertedSteps";
          RichText(
              text: TextSpan(
                  text: 'Dönüştürülecek adım sayısı: ',
                  style: TextStyle(
                      color: AppColors.kFont,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  children: <TextSpan>[
            TextSpan(
              text: widget.stepModel!.convertibleSteps.toString(),
              style: TextStyle(
                color: AppColors.kRipple,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                //decoration: TextDecoration.underline
              ),
            ),
          ]));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bilgi", style: TextStyle(color: AppColors.kRipple)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(child: alertMsg),
              SizedBox(child: alertMsg2)
            ]),
            actions: <Widget>[
              widget.stepModel!.convertible
                  ? ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(primary: AppColors.kRipple),
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Dönüştür",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();

                        _rewardedAd?.show(
                          onUserEarnedReward: (_, reward) async {
                            await widget.stepModel!.convertStepToCoin();
                            // QuizManager.instance.useHint();
                          },
                        );
                      },
                    )
                  : FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Tamam",
                        style: TextStyle(color: AppColors.kFont),
                      ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,###');
    var steps = Provider.of<StepViewModel>(context, listen: true).todaySteps;
    debugPrint("notified");

    /* widget.stepModel!.convertible
        ? converterController.stop()
        : converterController.forward();*/

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChartTrend()));
        },
        child: CustomPaint(
          painter: CirclePainter(
            _controller,
            color: AppColors.kRipple,
          ),
          child: SizedBox(
              width: widget.size * 5.125,
              height: widget.size * 5.125,
              child: _button(widget.stepModel!.todaySteps == null
                      ? "-"
                      : formatter.format(widget.stepModel!.todaySteps!
                          .toInt()) /*formatter.format(widget
                            .stepModel!.typeScores["HealthDataType.STEPS"]
                            ?.toInt()) */
                  ) //"1000"
              ) //snapshot.data["DataType.STEP_COUNT"].toInt().toString())
          ,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 3,
              //color: Colors.amber,
              child: Center(
                child: Text(
                    formatter.format(widget.stepModel!
                            .typeScores["HealthDataType.ACTIVE_ENERGY_BURNED"]!
                            .toInt()) +
                        " kalori",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kRipple)),
              )),
          _rewardedAd != null // || _rewardedAd == null
              ? GestureDetector(
                  onTap: () async {
                    //check convertible status

                    await widget.stepModel!.checkConvertible();
                    showDialogMsg(context);

                    // await widget.stepModel!.checkConvertible();

                    /* await widget.stepModel!.convertStepToCoin();
                        widget.stepModel!.maxLimit
                            ? showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // title: Text('Öğünü kaldırmak mı istiyorsunuz ?'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          RichText(
                                              text: TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                color: AppColors.kFont,
                                                fontFamily: "Poppins"),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      'Günde maximum 20.000 adım dönüştürebilirsin.'),
                                            ],
                                          )),

                                          /* Text(
                                        'Adımını dönüştürmen icin ' +
                                            '${widget.stepModel!.convertibleSteps} adıma daha ihtiyacın var.',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            //fontWeight: FontWeight.bold,
                                            color: AppColors.kFont)),*/
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Tamam',
                                          style: TextStyle(
                                              color: AppColors.kRipple),
                                        ),
                                        // textColor: Colors.grey,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              )
                            : null;
                        !widget.stepModel!.convertible
                            ? showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // title: Text('Öğünü kaldırmak mı istiyorsunuz ?'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          RichText(
                                              text: TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                color: AppColors.kFont,
                                                fontFamily: "Poppins"),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      'Adımını dönüştürmen icin '),
                                              TextSpan(
                                                  text:
                                                      '${widget.stepModel!.convertibleSteps}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      ' adıma daha ihtiyacın var. '),
                                            ],
                                          )),

                                          /* Text(
                                        'Adımını dönüştürmen icin ' +
                                            '${widget.stepModel!.convertibleSteps} adıma daha ihtiyacın var.',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            //fontWeight: FontWeight.bold,
                                            color: AppColors.kFont)),*/
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Tamam',
                                          style: TextStyle(
                                              color: AppColors.kRipple),
                                        ),
                                        // textColor: Colors.grey,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              )
                            : null;*/
                  },
                  child: SizedBox(
                    height: 40,
                    //color: Colors.green,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Center(
                      child: Lottie.asset('assets/lottie/convert.json',
                          //  controller: converterController,
                          // Configure the AnimationController with the duration of the
                          // Lottie file and start the animation.
                          /* onLoaded: (composition) {
                            converterController
                              ..duration = composition.duration
                              ..forward();
                          },*/
                          width: 40,
                          height: 40),
                    ),
                  ),
                )
              : SpinKitThreeBounce(color: AppColors.kRipple, size: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Center(
              child: Text(
                  widget.stepModel!.typeScores["HealthDataType.DISTANCE_DELTA"]!
                          .toStringAsFixed(2) +
                      " km",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kRipple)),
            ),
            height: 40,
            // color: Colors.blue,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 3,
              //color: Colors.amber,
              child: Align(
                alignment: Alignment.center,
                child: Text("Kalori",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.kFont)),
              )),
          /* Container(
                                    height: 40,
                                    //  color: Colors.green,
                                    width: MediaQuery.of(context).size.width / 3,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          '${widget.stepModel!.walletCoin?.toStringAsFixed(2)} FitCoin',
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.kFont)),
                                    ),
                                  ),*/
          Consumer<StepViewModel>(
              builder: (context, model, child) => Wallet(widget.stepModel!)),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Align(
              alignment: Alignment.center,
              child: Text("Mesafe",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.kFont)),
            ),
            height: 40,
            //color: Colors.blue,
          ),
        ],
      ),
      FutureBuilder<bool>(
          future: widget.stepModel!.checkPermission(),
          builder: (context, snapshot) {
            if (snapshot.data == false) {
              return TextButton.icon(
                  onPressed: () async {
                    await widget.stepModel!.readPermissions();
                  },
                  icon: Icon(Icons.autorenew_rounded),
                  label: Text("Bağlan"));
            }
            return SizedBox();
          }),
      /* !widget.stepModel!.permissionsGiven
          ? TextButton.icon(
              onPressed: () async {
                final canUseStorage = await widget.stepModel!.readPermissions();
              },
              icon: Icon(Icons.autorenew_rounded),
              label: Text("Bağlan"))
          : SizedBox()*/
    ]);
  }
}
