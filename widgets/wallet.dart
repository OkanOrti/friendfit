import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';

import 'package:friendfit_ready/theme/colors/light_colors.dart';

class Wallet extends StatelessWidget {
  final StepViewModel stepModel;
  const Wallet(this.stepModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      //  color: Colors.green,
      width: MediaQuery.of(context).size.width / 3,
      child: Align(
        alignment: Alignment.center,
        child: stepModel.walletCoin != null
            ? Text('${stepModel.walletCoin.toStringAsFixed(2)} FitCoin',
                style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.kFont))
            : SizedBox(),
      ),
    ); /*FutureBuilder(
        future: stepModel.checkWallet(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // Uncompleted State
            case ConnectionState.none:
            case ConnectionState.waiting:
              return SizedBox(
                height: 40,
                //  color: Colors.green,
                width: MediaQuery.of(context).size.width / 3,
                child: const Align(
                  alignment: Alignment.center,
                  // ignore: prefer_const_constructors
                  child: Text("- FitCoin",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kFont)),
                ),
              );
            /* return Center(child: CircularProgressIndicator());
                            break;*/
            default:
              // Completed with error
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
              }
              return SizedBox(
                height: 40,
                //  color: Colors.green,
                width: MediaQuery.of(context).size.width / 3,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      '${stepModel.walletCoin?.toStringAsFixed(2)} FitCoin',
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kFont)),
                ),
              );
          }
        });*/
  }
}
