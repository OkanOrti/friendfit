// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

var pageList = [
  PageModel(
      imageUrl: "assets/lottie/helthyornot.json",
      title: "Sağlıklı beslenmenin en yeni ve eğlenceli yolu",
      body:
          "Kararsız kalma, oyunlaştırma metodlarımız sayesinde hedefine ulaşman artık cok kolay.",
      titleGradient: gradients[0]),
  PageModel(
      imageUrl: "assets/lottie/gamification.json",
      title: "Sağlıklı beslenme yolunda artık yalnız değilsin",
      body:
          "Arkadaşlarınla yarışmalar düzenleyebilir ve birbirinizin gelişimini takip ederek sürekli motive kalabilirsin.",
      titleGradient: gradients[1]),
  PageModel(
      imageUrl: "assets/lottie/doctor.json",
      title: "Yürüyerek ve sağlıklı beslenerek kazan",
      body:
          "Uzman diyetisyenler tarafından hazırlanan diet planlarını arkadaşlarınızla beraber hemen uygulayabilir ve birlikte hedefe ulaşabilrisiniz.",
      titleGradient: gradients[2]),
  PageModel(
      imageUrl: "assets/lottie/coin_intro.json",
      title: "FitCoin'leri keyifle harca",
      body:
          "Topladığın FitCoin'ler ile sürekli güncellenen mağazamız üzerinden dilediğini satın alabilirsin.",
      titleGradient: gradients[2]),
];

List<List<Color>> gradients = [
  [Color(0xFF9708CC), Color(0xFF43CBFF)],
  [Color(0xFFE2859F), Color(0xFFFCCF31)],
  [Color(0xFF5EFCE8), Color(0xFF736EFE)],
];

class PageModel {
  var imageUrl;
  var title;
  var body;
  List<Color>? titleGradient;
  PageModel({this.imageUrl, this.title, this.body, this.titleGradient});
}
