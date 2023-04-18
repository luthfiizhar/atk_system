import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/models/main_page_model.dart';

class CostSummaryBarChartModel extends ChangeNotifier {
  // ApiResponse barChartResult = ApiResponse.loading();
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  GlobalModel globalModel = GlobalModel();

  List<CostSummBarChart>? _summCostBarChartResult = [];

  List? _resultsData;
  List? _yearsList;
  int? _maxY;

  List<CostSummBarChart> get summCostBarChart => _summCostBarChartResult ?? [];
  List get resultsData => _resultsData ?? [];
  List get yearsList => _yearsList ?? [];
  int get maxY => _maxY ?? 1000000;

  void setResultsData(List<CostSummBarChart> value) {
    _summCostBarChartResult = value;
    notifyListeners();
  }

  void setMaxY(int value) {
    _maxY = value;
    notifyListeners();
  }

  Future getSumCostBar() async {
    databaseRef
        .child(
            '${globalModel.role}/Chart/${globalModel.areaId}/${globalModel.year}/Data')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<CostSummBarChart> list =
          (result as List).map((e) => CostSummBarChart.fromJson(e)).toList();
      setResultsData(list);
    });

    databaseRef
        .child(
            '${globalModel.role}/Chart/${globalModel.areaId}/${globalModel.year}/ChartSetting')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = Map<String, dynamic>.from(jsonString as dynamic);
      setMaxY(result['Max']);
    });
  }
}

class TotalCostStatModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  GlobalModel globalModel = GlobalModel();

  List<CostSummaryCard>? _costSummaryList = [];

  List<CostSummaryCard> get costSummaryList => _costSummaryList ?? [];

  void setCostSummaryList(List<CostSummaryCard> value) {
    _costSummaryList = value;
    notifyListeners();
  }

  void addCostSummaryList(CostSummaryCard value) {
    _costSummaryList!.add(value);
    notifyListeners();
  }

  Future getSumCostValue() async {
    databaseRef
        .child(
            '${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Budget')
        .onValue
        .listen((event) {
      CostSummaryCard budgetValue = CostSummaryCard();
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

    databaseRef
        .child(
            '${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Request')
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
        ..title = "Total Request"
        ..from = "from last month";
      addCostSummaryList(requestValue);
      // _costSummaryList!.add(budgetValue);
    });

    databaseRef
        .child(
            '${globalModel.role}/MonthlyCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/Settlement')
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
        ..title = "Settlement"
        ..from = "from last month";
      addCostSummaryList(settlementValue);
      // _costSummaryList!.add(budgetValue);
    });
  }
}

class RecentTransactionViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  GlobalModel globalModel = GlobalModel();

  final List<RecentTransactionTable> _listRecTransaction = [];

  List<RecentTransactionTable> get listRecTransaction => _listRecTransaction;
}

class TopReqItemsViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  GlobalModel globalModel = GlobalModel();

  List<TopRequestedItems> _topReqItems = [];

  List<TopRequestedItems> get topReqItems => _topReqItems;

  void setTopReqItems(List<TopRequestedItems> value) {
    _topReqItems = value;
    notifyListeners();
  }

  Future getTopReqItems() async {
    databaseRef
        .child(
            '${globalModel.role}/TopRequestedItem/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<TopRequestedItems> list =
          (result as List).map((e) => TopRequestedItems.fromJson(e)).toList();
      print(list);
      setTopReqItems(list);
    });
  }
}

class ActualPriceItemViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  GlobalModel globalModel = GlobalModel();

  List<ActualPriceItem> _itemList = [];
  List<List<ActualPriceItem>> _sliderList = [];

  List<ActualPriceItem> get itemList => _itemList;
  List<List<ActualPriceItem>> get sliderList => _sliderList;

  void setActualPriceItemList(List<ActualPriceItem> value) {
    _itemList = value;
    notifyListeners();
  }

  void setActualPriceSlider(List<List<ActualPriceItem>> value) {
    _sliderList = value;
    notifyListeners();
  }

  Future getActualPriceItem() async {
    databaseRef
        .child(
            '${globalModel.role}/ItemAveragePrice/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<ActualPriceItem> list =
          (result as List).map((e) => ActualPriceItem.fromJson(e)).toList();
      // print(list);
      setActualPriceItemList(list);

      List<List<ActualPriceItem>> newList = [];
      for (var i = 0; i < _itemList.length; i++) {
        int end = i + 3;
        if (end > _itemList.length) {
          end = _itemList.length;
        }
        List<ActualPriceItem> subList = itemList.sublist(
            i, i + 3 > itemList.length ? itemList.length : i += 3);
        if (!newList.contains(subList)) {
          newList.add(subList);
        }
      }

      setActualPriceSlider(newList);
    });
  }
}