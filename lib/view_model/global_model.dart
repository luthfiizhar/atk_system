import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalModel extends ChangeNotifier {
  String? _businessUnit;
  String? _role;
  String? _areaId;
  String? _year;
  String? _month;

  String get businessUnit => _businessUnit ?? "1";
  String get role => _role ?? "RegionalManager";
  String get areaId => _areaId ?? "RM1";
  String get year => _year ?? DateTime.now().year.toString();
  String get month => _month ?? "Apr";

  void setRole(String value) {
    _role = value;
    notifyListeners();
  }

  void setAreaId(String value) {
    _areaId = value;
    notifyListeners();
  }

  void setYear(String value) {
    _year = value;
    notifyListeners();
  }

  void setMonth(String value) {
    _month = value;
    notifyListeners();
  }
}
