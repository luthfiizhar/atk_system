import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/models/main_page_model.dart';

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
    // print(globalModel.toString());
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
    _rankItem.clear();
    _rankSiteStream!.cancel();
    notifyListeners();
  }
}
