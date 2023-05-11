import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/models/main_page_model.dart';

class ActualPriceItemViewModel extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  StreamSubscription<DatabaseEvent>? _actPriceStream;

  List<ActualPriceItem> _itemList = [];
  List<List<ActualPriceItem>> _sliderList = [];

  bool _isLoading = false;

  List<ActualPriceItem> get itemList => _itemList;
  List<List<ActualPriceItem>> get sliderList => _sliderList;
  bool get isLoading => _isLoading;

  void setActualPriceItemList(List<ActualPriceItem> value) {
    _itemList = value;
    notifyListeners();
  }

  void setActualPriceSlider(List<List<ActualPriceItem>> value) {
    _sliderList = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getActualPriceItem(GlobalModel globalModel) async {
    setIsLoading(true);
    _actPriceStream = databaseRef
        .child(
            '${globalModel.businessUnit}/${globalModel.role}/ItemAveragePrice/${globalModel.areaId}/${globalModel.year}/${globalModel.month}')
        .onValue
        .listen((event) {
      setIsLoading(false);
      if (event.snapshot.exists) {
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
      } else {
        setActualPriceItemList([]);
      }
    });
  }

  void closeStream() {
    _sliderList.clear();
    _actPriceStream!.cancel();
    notifyListeners();
  }
}
