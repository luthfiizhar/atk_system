import 'package:atk_system_ga/models/transaction_class.dart';

class AdminMenu {
  String name;
  String value;
  bool isShowed;

  AdminMenu({
    this.name = "",
    this.value = "",
    this.isShowed = true,
  });
}

class Site {
  Site({
    this.siteId = "",
    this.siteName = "",
    this.oldSiteId = "",
    this.latitude = "",
    this.longitude = "",
    this.siteArea = 0,
    this.regionName = "",
    this.areaId = "",
    this.areaName = "",
    this.monthlyBudget = 0,
    this.additionalBudget = 0,
    this.note = "",
    this.isExpanded = false,
    List<TransactionActivity>? activity,
  }) : activity = activity ?? [];

  String siteId;
  String oldSiteId;
  String siteName;
  String areaId;
  String areaName;
  String regionName;
  String latitude;
  String longitude;
  String note;
  List<TransactionActivity> activity;
  int monthlyBudget;
  int additionalBudget;
  double siteArea;
  bool isExpanded;

  Map<String, String> toJson() => {
        '"SiteID"': '"$siteId"',
        '"SiteName"': '"$siteName"',
        '"MonthlyBudget"': monthlyBudget.toString(),
        '"AdditionalBudget"': additionalBudget.toString(),
        '"SiteArea"': siteArea.toString(),
        '"isExpanded"': isExpanded.toString(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class User {
  User({
    this.nip = "",
    this.name = "",
    this.siteId = "",
    this.role = "",
    this.oldNip = "",
    this.siteName = "",
    this.compName = "",
    this.compId = "",
    this.isExpanded = false,
    List? roleList,
  }) : roleList = roleList ?? [];

  String nip;
  String name;
  String siteId;
  String role;
  String oldNip;
  String siteName;
  String compName; //Business Unit
  String compId;
  bool isExpanded;
  List roleList;

  Map<String, String> toJson() => {
        '"EmpNIP"': '"$nip"',
        '"EmpName"': '"$name"',
        '"SiteID"': '"$siteId"',
        '"Role"': '"$role"',
        '"isExpanded"': isExpanded.toString(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Role {
  Role({
    this.name = "",
    this.value = "",
    this.isChecked = false,
  });
  String name;
  String value;
  bool isChecked;

  Map<String, String> toJson() =>
      {'"Name"': '"$name"', '"Value"': '"$value"', '"IsChecked"': '$isChecked'};

  @override
  String toString() {
    return toJson().toString();
  }
}

class Region {
  String regionName;
  String regionId;
  String logoBase64;
  String businessUnitID;
  String businessUnitName;
  bool isExpanded;

  Region({
    this.regionId = "",
    this.regionName = "",
    this.logoBase64 = "",
    this.businessUnitID = "1",
    this.businessUnitName = "",
    this.isExpanded = false,
  });

  Map<String, String> toJson() =>
      {"RegionId": regionId, "RegionName": regionName};

  @override
  String toString() {
    return toJson().toString();
  }
}

class Area {
  String areaId;
  String areaName;
  String regionID;
  String regionName;
  bool isExpanded;

  Area({
    this.areaId = "",
    this.areaName = "",
    this.regionID = "",
    this.regionName = "",
    this.isExpanded = false,
  });

  Map<String, String> toJson() => {
        "RegionId": regionID,
        "RegionName": regionName,
        "AreaName": areaName,
        "AreaId": areaId,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class BusinessUnit {
  String name;
  String photo;
  String businessUnitId;
  bool isSelected;
  BusinessUnit({
    this.name = "",
    this.businessUnitId = "",
    this.photo = "",
    this.isSelected = false,
  });

  Map<String, String> toJson() => {
        "Name": name,
        "BusinessUnitID": businessUnitId,
        "Photo": photo,
        "isSelected": isSelected.toString()
      };

  @override
  String toString() {
    return toJson.toString();
  }
}
