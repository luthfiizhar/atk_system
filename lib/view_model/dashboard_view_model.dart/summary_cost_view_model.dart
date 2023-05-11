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

  bool _isLoading = false;
  List<CostSummaryCard>? _costSummaryList = [];

  StreamSubscription<DatabaseEvent>? _totalReqListener;
  StreamSubscription<DatabaseEvent>? _totalSettleListener;
  StreamSubscription<DatabaseEvent>? _totalBudgetListener;

  List<CostSummaryCard> get costSummaryList => _costSummaryList ?? [];

  bool get isLoading => _isLoading;

  void setCostSummaryList(List<CostSummaryCard> value) {
    _costSummaryList = value;
    notifyListeners();
  }

  void addCostSummaryList(CostSummaryCard value) {
    _costSummaryList!.add(value);
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getSumCostValue(GlobalModel globalModel) async {
    setIsLoading(true);
    _costSummaryList!.clear();
    _totalReqListener = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Request')
        .onValue
        .listen((event) {
      CostSummaryCard requestValue = CostSummaryCard();

      // _costSummaryList!.add(budgetValue);
      setIsLoading(false);
      if (event.snapshot.exists) {
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
      } else {
        requestValue
          ..value = 0
          ..percentage = 0
          ..title = "Total Cost Requested"
          ..from = "from last month";
        addCostSummaryList(requestValue);
      }
    });

    _totalSettleListener = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Settlement')
        .onValue
        .listen((event) {
      CostSummaryCard settlementValue = CostSummaryCard();

      // _costSummaryList!.add(budgetValue);
      setIsLoading(false);
      if (event.snapshot.exists) {
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
      } else {
        settlementValue
          ..value = 0
          ..percentage = 0
          ..title = "Total Cost Settled"
          ..from = "from last month";
        addCostSummaryList(settlementValue);
      }
    });

    _totalSettleListener!.onError((value) {
      setIsLoading(false);
      CostSummaryCard requestValue = CostSummaryCard();
      requestValue
        ..value = 0
        ..percentage = 0
        ..title = "Total Cost Settled"
        ..from = "from last month";
      addCostSummaryList(requestValue);
    });

    _totalBudgetListener = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Budget')
        .onValue
        .listen((event) {
      CostSummaryCard budgetValue = CostSummaryCard();
      // print(event.snapshot.exists);
      if (event.snapshot.exists) {
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
        setIsLoading(false);
      } else {
        setIsLoading(false);
        budgetValue
          ..value = 0
          ..percentage = 0
          ..title = "Budget"
          ..from = "from last month";
        addCostSummaryList(budgetValue);
      }
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
