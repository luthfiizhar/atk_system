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

  bool _isLoading = true;

  List? _resultsData;
  List? _yearsList;
  int? _maxY;

  bool _isTouched = false;
  bool _showPercentage = true;

  List<CostSummBarChart> get summCostBarChart => _summCostBarChartResult ?? [];
  List get resultsData => _resultsData ?? [];
  List get yearsList => _yearsList ?? [];
  int get maxY => _maxY ?? 100;

  bool get isTouched => _isTouched;
  bool get showPercentage => _showPercentage;

  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
    setIsLoading(true);
    _chartSettingStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/Chart/${globalModel.areaId}/${globalModel.year}/ChartSetting')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = Map<String, dynamic>.from(jsonString as dynamic);
        setMaxY(result['Max']);
      } else {
        setMaxY(100);
      }
    });

    _chartDataStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/Chart/${globalModel.areaId}/${globalModel.year}/Data')
        .onValue
        .listen((event) {
      print("CHART VALUE -> ${event.snapshot.value}");
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<CostSummBarChart> list =
            (result as List).map((e) => CostSummBarChart.fromJson(e)).toList();
        setResultsData(list);
      } else {
        setResultsData([
          CostSummBarChart(
            month: "Jan",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Feb",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Mar",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Apr",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "May",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Jun",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Jul",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Aug",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Sep",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Okt",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Nov",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
          CostSummBarChart(
            month: "Dec",
            budget: 0,
            cost: 0,
            year: globalModel.year,
          ),
        ]);
      }
      setIsLoading(false);
    });
  }

  void closeListener() {
    _summCostBarChartResult!.clear();
    _chartDataStream!.cancel();
    _chartSettingStream!.cancel();
    notifyListeners();
  }
}
