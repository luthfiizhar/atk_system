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
    _chartDataStream!.cancel();
    _chartSettingStream!.cancel();
  }
}

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
    print("AREA ID --> ${globalModel.areaId}");
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
        ..title = "Total Request"
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
        ..title = "Settlement"
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
    _totalReqListener!.cancel();
    _totalSettleListener!.cancel();
    _totalBudgetListener!.cancel();
  }
}

class RecentTransactionViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  StreamSubscription<DatabaseEvent>? _recentStream;

  List<RecentTransactionTable> _listRecTransaction = [];

  List<RecentTransactionTable> get listRecTransaction => _listRecTransaction;

  void setRecentTransaction(List<RecentTransactionTable> value) {
    _listRecTransaction = value;
    notifyListeners();
  }

  Future getRecentTransaction(GlobalModel globalModel) async {
    _recentStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/RecentTransaction/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      print("$jsonString");
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<RecentTransactionTable> list = (result as List)
          .map((e) => RecentTransactionTable.fromJson(e))
          .toList();

      setRecentTransaction(list);
    });
  }

  void closeListener() {
    _recentStream!.cancel();
  }
}

class TopReqItemsViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _topReqStream;

  // GlobalModel globalModel = GlobalModel();

  List<TopRequestedItems> _topReqItems = [];

  List<TopRequestedItems> get topReqItems => _topReqItems;

  void setTopReqItems(List<TopRequestedItems> value) {
    _topReqItems = value;
    notifyListeners();
  }

  Future getTopReqItems(GlobalModel globalModel) async {
    // _topReqItems.clear();
    _topReqStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/TopRequestedItem/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
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

  void closeListener() {
    _topReqStream!.cancel();
  }
}

class ActualPriceItemViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  StreamSubscription<DatabaseEvent>? _actPriceStream;

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

  Future getActualPriceItem(GlobalModel globalModel) async {
    _actPriceStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/ItemAveragePrice/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
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

  void closeStream() {
    _actPriceStream!.cancel();
  }
}

class SiteRankViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  StreamSubscription<DatabaseEvent>? _rankSiteStream;

  List _sortOption = [];
  int _selectedSortOption = 0;

  List<SiteRanking> _rankItem = [];

  List get sortOption => _sortOption;
  int get selectedSortOption => _selectedSortOption;

  List<SiteRanking> get rankItem => _rankItem;

  void setSelectedSortOption(int value) {
    _selectedSortOption = value;
    notifyListeners();
  }

  void setRankList(List<SiteRanking> value) {
    _rankItem = value;
    notifyListeners();
  }

  Future getBudgetCostComparison(GlobalModel globalModel) async {
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/BudgetCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<SiteRanking> list =
          (result as List).map((e) => SiteRanking.fromJson(e)).toList();

      setRankList(list);
    });
  }

  Future getHighestCost(GlobalModel globalModel) async {
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/HighestCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<SiteRanking> list =
          (result as List).map((e) => SiteRanking.fromJson(e)).toList();

      setRankList(list);
    });
  }

  Future getLowestCost(GlobalModel globalModel) async {
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/LowestCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<SiteRanking> list =
          (result as List).map((e) => SiteRanking.fromJson(e)).toList();

      setRankList(list);
    });
  }

  Future getHighestBudget(GlobalModel globalModel) async {
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/HighestBudget/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<SiteRanking> list =
          (result as List).map((e) => SiteRanking.fromJson(e)).toList();

      setRankList(list);
    });
  }

  Future getLowestBudget(GlobalModel globalModel) async {
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/LowestBudget/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<SiteRanking> list =
          (result as List).map((e) => SiteRanking.fromJson(e)).toList();

      setRankList(list);
    });
  }

  Future getFastestLeadTime(GlobalModel globalModel) async {
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/FastestLeadTime/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<SiteRanking> list =
          (result as List).map((e) => SiteRanking.fromJson(e)).toList();

      setRankList(list);
    });
  }

  Future getSlowestLeadTime(GlobalModel globalModel) async {
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/SlowestLeadTime/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<SiteRanking> list =
          (result as List).map((e) => SiteRanking.fromJson(e)).toList();

      setRankList(list);
    });
  }

  void closeListener() {
    _rankSiteStream!.cancel();
  }
}
