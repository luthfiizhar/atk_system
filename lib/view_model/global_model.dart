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
  String? _logoUrl;

  String? _initAreaId;
  String? _initBusinessUnit;
  String? _initRole;
  String? _initAreaName;

  String get businessUnit => _businessUnit ?? "1";
  String get companyName => _companyName ?? "";
  String get empName => _empName ?? "";
  String get role => _role ?? "OperationHO";
  String get areaId => _areaId ?? "HO";
  String get year => _year ?? DateTime.now().year.toString();
  String get month => _month ?? DateFormat("MMM").format(DateTime.now());
  String get siteName => _siteName ?? "All Indonesia Region";
  String get logoUrl => _logoUrl ?? "";

  String get initAreaId => _initAreaId ?? "HO";
  String get initRole => _initRole ?? "Operation";
  String get initBusinessUnit => _initBusinessUnit ?? "1";
  String get initAreaName => _initAreaName ?? "All Indonesia Region";

  void setInitGlobal(String bu, String role, String area, String areaName) {
    _initBusinessUnit = bu;
    _initRole = role;
    _initAreaId = area;
    _initAreaName = areaName;
    notifyListeners();
  }

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

  void setUrlLogo(String value) {
    print("setLogo $value");
    _logoUrl = value;
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
