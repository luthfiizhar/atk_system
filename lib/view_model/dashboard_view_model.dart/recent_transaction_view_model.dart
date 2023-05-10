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
      dynamic result = List<dynamic>.from(jsonString as dynamic);
      List<RecentTransactionTable> list = (result as List)
          .map((e) => RecentTransactionTable.fromJson(e))
          .toList();

      setRecentTransaction(list);
    });
  }

  void closeListener() {
    _listRecTransaction.clear();
    _recentStream!.cancel();
    notifyListeners();
  }
}
