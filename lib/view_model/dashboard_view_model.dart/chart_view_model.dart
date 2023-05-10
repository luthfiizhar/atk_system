import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/models/main_page_model.dart';

class CostSummaryBarChartModel extends ChangeNotifier {
  // ApiResponse barChartResult = ApiResponse.loading();
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  StreamSubscription<DatabaseEvent>? _chartSettingStream;
  StreamSubscription<DatabaseEvent>? _chartDataStream;

  List<CostSummBarChart>? _summCostBarChartResult = [];

  List? _resultsData;
  List? _yearsList;
  int? _maxY;

  bool _isTouched = false;
  bool _showPercentage = true;

  List<CostSummBarChart> get summCostBarChart => _summCostBarChartResult ?? [];
  List get resultsData => _resultsData ?? [];
  List get yearsList => _yearsList ?? [];
  int get maxY => _maxY ?? 1000000;

  bool get isTouched => _isTouched;
  bool get showPercentage => _showPercentage;

  void setIsTouched(bool value) {
    _isTouched = value;
    if (value) {
      _showPercentage = false;
    } else {
      _showPercentage = true;
    }

    notifyListeners();
  }

  void setResultsData(List<CostSummBarChart> value) {
    _summCostBarChartResult = value;
    notifyListeners();
  }

  void setMaxY(int value) {
    _maxY = value;
    notifyListeners();
  }

  Future getSumCostBar(GlobalModel globalModel) async {
    _chartSettingStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/Chart/${globalModel.areaId}/${globalModel.year}/ChartSetting')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = Map<String, dynamic>.from(jsonString as dynamic);
      setMaxY(result['Max']);
    });

    _chartDataStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/Chart/${globalModel.areaId}/${globalModel.year}/Data')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<CostSummBarChart> list =
          (result as List).map((e) => CostSummBarChart.fromJson(e)).toList();
      setResultsData(list);
    });
  }

  void closeListener() {
    _summCostBarChartResult!.clear();
    _chartDataStream!.cancel();
    _chartSettingStream!.cancel();
    notifyListeners();
  }
}
