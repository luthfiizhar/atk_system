import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/models/main_page_model.dart';

class RecentTransactionViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  StreamSubscription<DatabaseEvent>? _recentStream;
  bool _isLoading = false;

  List<RecentTransactionTable> _listRecTransaction = [];

  List<RecentTransactionTable> get listRecTransaction => _listRecTransaction;
  bool get isLoading => _isLoading;

  void setRecentTransaction(List<RecentTransactionTable> value) {
    _listRecTransaction = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getRecentTransaction(GlobalModel globalModel) async {
    setIsLoading(true);
    _recentStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/RecentTransaction/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      final jsonString = event.snapshot.value;

      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<RecentTransactionTable> list = (result as List)
          .map((e) => RecentTransactionTable.fromJson(e))
          .toList();

      setRecentTransaction(list);
      setIsLoading(false);
    });

    _recentStream!.onError((value) {
      setIsLoading(false);
      setRecentTransaction([]);
    });
  }

  void closeListener() {
    _listRecTransaction.clear();
    _recentStream!.cancel();
    notifyListeners();
  }
}
