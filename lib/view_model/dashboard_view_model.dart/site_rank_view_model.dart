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
  bool _isLoading = false;

  List get sortOption => _sortOption;
  int get selectedSortOption => _selectedSortOption;

  List<SiteRanking> get rankItem => _rankItem;
  bool get isLoading => _isLoading;

  void setSelectedSortOption(int value) {
    _selectedSortOption = value;
    notifyListeners();
  }

  void setRankList(List<SiteRanking> value) {
    _rankItem = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getBudgetCostComparison(GlobalModel globalModel) async {
    // print(globalModel.toString());
    setIsLoading(true);
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/BudgetCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/List')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<SiteRanking> list =
            (result as List).map((e) => SiteRanking.fromJson(e)).toList();

        setRankList(list);
      } else {
        setRankList([]);
      }

      setIsLoading(false);
    });
  }

  Future getHighestCost(GlobalModel globalModel) async {
    setIsLoading(true);
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/HighestCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/List')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<SiteRanking> list =
            (result as List).map((e) => SiteRanking.fromJson(e)).toList();

        setRankList(list);
      } else {
        setRankList([]);
      }

      setIsLoading(false);
    });
  }

  Future getLowestCost(GlobalModel globalModel) async {
    setIsLoading(true);
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/LowestCost/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/List')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<SiteRanking> list =
            (result as List).map((e) => SiteRanking.fromJson(e)).toList();

        setRankList(list);
      } else {
        setRankList([]);
      }

      setIsLoading(false);
    });
  }

  Future getHighestBudget(GlobalModel globalModel) async {
    setIsLoading(true);
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/HighestBudget/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/List')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<SiteRanking> list =
            (result as List).map((e) => SiteRanking.fromJson(e)).toList();

        setRankList(list);
      } else {
        setRankList([]);
      }

      setIsLoading(false);
    });
  }

  Future getLowestBudget(GlobalModel globalModel) async {
    setIsLoading(true);
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/LowestBudget/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/List')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<SiteRanking> list =
            (result as List).map((e) => SiteRanking.fromJson(e)).toList();

        setRankList(list);
      } else {
        setRankList([]);
      }

      setIsLoading(false);
    });
  }

  Future getFastestLeadTime(GlobalModel globalModel) async {
    setIsLoading(true);
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/FastestLeadTime/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/List')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<SiteRanking> list =
            (result as List).map((e) => SiteRanking.fromJson(e)).toList();

        setRankList(list);
      } else {
        setRankList([]);
      }

      setIsLoading(false);
    });
  }

  Future getSlowestLeadTime(GlobalModel globalModel) async {
    setIsLoading(true);
    _rankSiteStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/SiteRanking/SlowestLeadTime/${globalModel.areaId}/${globalModel.year}/${globalModel.month}/List')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<SiteRanking> list =
            (result as List).map((e) => SiteRanking.fromJson(e)).toList();

        setRankList(list);
      } else {
        setRankList([]);
      }
      setIsLoading(false);
    });
  }

  void closeListener() {
    _rankItem.clear();
    _rankSiteStream!.cancel();
    notifyListeners();
  }
}
