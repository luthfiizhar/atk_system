import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalModel extends ChangeNotifier {
  String? _businessUnit;
  String? _companyName;
  String? _empName;
  String? _role;
  String? _areaId;
  String? _year;
  String? _month;
  String? _siteName;

  String get businessUnit => _businessUnit ?? "1";
  String get companyName => _companyName ?? "";
  String get empName => _empName ?? "";
  String get role => _role ?? "RegionalManager";
  String get areaId => _areaId ?? "RM1";
  String get year => _year ?? DateTime.now().year.toString();
  String get month => _month ?? DateFormat("MMM").format(DateTime.now());
  String get siteName => _siteName ?? "All Regional";

  void setCompanyName(String value) {
    _companyName = value;
    notifyListeners();
  }

  void setBusinessUnit(String value) {
    _businessUnit = value;
    notifyListeners();
  }

  void setEmpName(String value) {
    _empName = value;
    notifyListeners();
  }

  void setRole(String value) {
    _role = value;
    notifyListeners();
  }

  void setAreaId(String value) {
    _areaId = value;
    notifyListeners();
  }

  void setAreaName(String value) {
    _siteName = value;
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

  @override
  String toString() {
    return """
    ===GLOBAL MODEL===
    Role : $role,
    AreaId : $_areaId, 
    BusinessUnit : $_businessUnit, 
    CompanyName : $_companyName, 
    EmpName : $_empName, 
    Month: $_month,
    Year: $_year, 
    """;
  }
}
