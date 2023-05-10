import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/models/main_page_model.dart';

class TotalCostStatModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  // GlobalModel globalModel = GlobalModel();

  List<CostSummaryCard>? _costSummaryList = [];

  StreamSubscription<DatabaseEvent>? _totalReqListener;
  StreamSubscription<DatabaseEvent>? _totalSettleListener;
  StreamSubscription<DatabaseEvent>? _totalBudgetListener;

  List<CostSummaryCard> get costSummaryList => _costSummaryList ?? [];

  void setCostSummaryList(List<CostSummaryCard> value) {
    _costSummaryList = value;
    notifyListeners();
  }

  void addCostSummaryList(CostSummaryCard value) {
    _costSummaryList!.add(value);
    notifyListeners();
  }

  Future getSumCostValue(GlobalModel globalModel) async {
    _costSummaryList!.clear();

    _totalReqListener = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Request')
        .onValue
        .listen((event) {
      CostSummaryCard requestValue;
      print(event.snapshot.value);
      final jsonString = event.snapshot.value;
      final result = Map<String, dynamic>.from(jsonString as dynamic);
      // print(result);
      requestValue =
          CostSummaryCard.fromJson(jsonString as Map<String, dynamic>);
      // print(budgetValue.toString());
      requestValue
        ..title = "Total Cost Requested"
        ..from = "from last month";
      addCostSummaryList(requestValue);
      // _costSummaryList!.add(budgetValue);
    });

    _totalSettleListener = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Settlement')
        .onValue
        .listen((event) {
      CostSummaryCard settlementValue;
      print(event.snapshot.value);
      final jsonString = event.snapshot.value;
      final result = Map<String, dynamic>.from(jsonString as dynamic);
      // print(result);
      settlementValue =
          CostSummaryCard.fromJson(jsonString as Map<String, dynamic>);
      // print(budgetValue.toString());
      settlementValue
        ..title = "Cost Settled"
        ..from = "from last month";
      addCostSummaryList(settlementValue);
      // _costSummaryList!.add(budgetValue);
    });

    _totalBudgetListener = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Budget')
        .onValue
        .listen((event) {
      CostSummaryCard budgetValue;
      print(event.snapshot.value);
      final jsonString = event.snapshot.value;
      final result = Map<String, dynamic>.from(jsonString as dynamic);
      // print(result);
      budgetValue =
          CostSummaryCard.fromJson(jsonString as Map<String, dynamic>);
      // print(budgetValue.toString());
      budgetValue
        ..title = "Budget"
        ..from = "from last month";
      addCostSummaryList(budgetValue);
      // _costSummaryList!.add(budgetValue);
    });
  }

  void closeListener() {
    _costSummaryList!.clear();
    _totalReqListener!.cancel();
    _totalSettleListener!.cancel();
    _totalBudgetListener!.cancel();
    notifyListeners();
  }
}