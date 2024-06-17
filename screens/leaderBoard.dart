// ignore_for_file: prefer_const_literals_to_create_immutables, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:friendfit_ready/ViewModels/DietGameViewModel.dart';
import 'package:friendfit_ready/ViewModels/StepViewModel.dart';
import 'package:friendfit_ready/models/diet_game.dart';
import 'package:friendfit_ready/models/stepPhrase.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/service_locator.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';

class LeaderboardPage extends StatelessWidget {
  final DietGame? game;
  final String? dietPlanId;

  const LeaderboardPage({Key? key, this.game, this.dietPlanId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DietGameViewModel gameModel = serviceLocator<DietGameViewModel>();
    final StepViewModel stepModel = serviceLocator<StepViewModel>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Liderlik Tablosu',
              style: TextStyle(
                  fontFamily: "Poppins", color: Colors.white, fontSize: 20)),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(
                text: 'Diet Planı',
              ),
              Tab(text: 'Adım'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Diet Planı Tabı
            FutureBuilder<void>(
              future:
                  gameModel.getGameScoreFromUsers(game!, planId: dietPlanId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  // Diet skorlarını sıralama
                  List<MapEntry<String, int>> sortedScores = (gameModel
                          .userScores.entries
                          .toList()
                        ..sort(
                            (a, b) => b.value.length.compareTo(a.value.length)))
                      .cast<MapEntry<String, int>>();
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20.0,
                      columns: [
                        DataColumn(
                            label: Text('Sıra',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Kullanıcı',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Puan',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                      ],
                      rows: List.generate(sortedScores.length, (index) {
                        var userId = sortedScores[index].key;
                        var score = sortedScores[index].value;
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // Satırların arka plan rengi
                              if (index % 2 == 0) {
                                return Colors.grey.withOpacity(0.1);
                              }
                              return Colors.white;
                            },
                          ),
                          cells: [
                            DataCell(Text('${index + 1}',
                                style: TextStyle(fontSize: 14))),
                            DataCell(
                                Text(userId, style: TextStyle(fontSize: 14))),
                            DataCell(
                                Text('$score', style: TextStyle(fontSize: 14))),
                          ],
                        );
                      }),
                    ),
                  );
                } else {
                  return Center(
                    child:
                        Text('Unexpected state: ${snapshot.connectionState}'),
                  );
                }
              },
            ),
            // Adım Tabı
            FutureBuilder<void>(
              future: stepModel.getGameMemberSteps(
                  currentUser!.id!, game!.startDate!.toDate(), DateTime.now(),
                  gameModel: gameModel),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  // Adım skorlarını sıralama
                  List<StepPhrase> sortedSteps = stepModel.stepPhraseList
                      .toList()
                    ..sort((a, b) => b.steps!.compareTo(a.steps!));
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20.0,
                      columns: [
                        DataColumn(
                            label: Text('Sıra',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Kullanıcı',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Adım',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                      ],
                      rows: List.generate(sortedSteps.length, (index) {
                        var step = sortedSteps[index];
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              // Satırların arka plan rengi
                              if (index % 2 == 0) {
                                return Colors.grey.withOpacity(0.1);
                              }
                              return Colors.white;
                            },
                          ),
                          cells: [
                            DataCell(Text('${index + 1}',
                                style: TextStyle(fontSize: 14))),
                            DataCell(Text(step.id ?? '',
                                style: TextStyle(fontSize: 14))),
                            DataCell(Text('${step.steps}',
                                style: TextStyle(fontSize: 14))),
                          ],
                        );
                      }),
                    ),
                  );
                } else {
                  return Center(
                    child:
                        Text('Unexpected state: ${snapshot.connectionState}'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
