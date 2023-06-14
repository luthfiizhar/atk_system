import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/models/main_page_model.dart';

class HistoryViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  StreamSubscription<DatabaseEvent>? _historyStream;
  bool _isLoading = false;

  List<HistoryTable> _listHistory = [];

  List<HistoryTable> get listHistory => _listHistory;
  bool get isLoading => _isLoading;

  void setHistoryList(List<HistoryTable> value) {
    _listHistory = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getBudgetHistory(GlobalModel globalModel) async {
    setLoading(true);
    _historyStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/History/Budget/List')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;

        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<HistoryTable> list =
            (result as List).map((e) => HistoryTable.fromJson(e)).toList();

        setHistoryList(list);
      } else {
        setHistoryList([]);
      }
      setLoading(false);
    });
  }

  void closeListener() {
    _listHistory.clear();
    _historyStream!.cancel();
    notifyListeners();
  }
}
