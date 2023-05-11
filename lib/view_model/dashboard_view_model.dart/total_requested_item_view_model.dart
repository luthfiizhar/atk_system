import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/models/main_page_model.dart';

class TopReqItemsViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _topReqStream;

  // GlobalModel globalModel = GlobalModel();

  List<TopRequestedItems> _topReqItems = [];
  bool _isLoading = false;

  List<TopRequestedItems> get topReqItems => _topReqItems;
  bool get isLoading => _isLoading;

  void setTopReqItems(List<TopRequestedItems> value) {
    _topReqItems = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getTopReqItems(GlobalModel globalModel) async {
    setIsLoading(true);
    // _topReqItems.clear();
    _topReqStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/TopRequestedItem/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final jsonString = event.snapshot.value;
        dynamic result = List<dynamic>.from(jsonString as dynamic);
        List<TopRequestedItems> list =
            (result as List).map((e) => TopRequestedItems.fromJson(e)).toList();
        print(list);
        setTopReqItems(list);
      } else {
        setTopReqItems([]);
      }

      setIsLoading(false);
    });

    _topReqStream!.onError((value) {
      setIsLoading(false);
    });
  }

  void closeListener() {
    _topReqItems.clear();
    _topReqStream!.cancel();
    notifyListeners();
  }
}
