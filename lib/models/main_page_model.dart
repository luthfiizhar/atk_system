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

class CostSummaryCard {
  String title;
  int value;
  String from;
  String dir;
  double percentage;

  CostSummaryCard({
    this.title = "",
    this.value = 0,
    this.percentage = 0.0,
    this.from = "",
    this.dir = "",
  });

  CostSummaryCard.fromJson(Map<String, dynamic> json)
      : title = "",
        value = json['Total'],
        from = "",
        dir = json['Direction'],
        percentage = json['Percentage'];

  Map<String, String> toJson() => {
        "Title": title,
        "Value": value.toString(),
        "From": from,
        "Percentage": percentage.toString(),
        "Direction": dir
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class CostSummBarChart {
  String month;
  int budget;
  int cost;

  CostSummBarChart({
    this.month = "",
    this.budget = 0,
    this.cost = 0,
  });

  CostSummBarChart.fromJson(Map<String, dynamic> json)
      : month = json["Month"],
        budget = json["Budget"],
        cost = json["Cost"];

  Map<String, String> toJson() => {
        "Month": month,
        "Budget": budget.toString(),
        "Cost": cost.toString(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class RecentTransactionTable {
  String siteName;
  String type;
  String cost;
  String date;
  String time;
  String formId;

  RecentTransactionTable({
    this.siteName = "",
    this.type = "",
    this.cost = "",
    this.date = "",
    this.time = "",
    this.formId = "",
  });

  RecentTransactionTable.fromJson(Map<String, dynamic> json)
      : siteName = json["SiteName"] ?? "",
        type = json["Type"] ?? "",
        cost = json["Cost"] ?? "0",
        date = json["Date"] ?? "",
        time = json["Time"] ?? "",
        formId = json["FormID"] ?? "";

  Map<String, String> toJson() => {
        "SiteName": siteName,
        "FormType": type,
        "Cost": cost.toString(),
        "Date": date,
        "Time": time,
        "FormID": formId
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class TopRequestedItems {
  String name;
  String qty;
  String rank;
  String totalCost;

  TopRequestedItems({
    this.name = "",
    this.qty = "",
    this.rank = "1",
    this.totalCost = "0",
  });

  TopRequestedItems.fromJson(Map<String, dynamic> json)
      : name = json["ItemName"],
        qty = json["TotalRequested"].toString(),
        rank = "1",
        totalCost = "0";

  Map<String, String> toJson() => {
        "ItemName": name,
        "Quantity": qty,
        "Rank": rank,
        "TotalCost": totalCost,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class ActualPriceItem {
  String itemName;
  int basePrice;
  int avgPrice;
  double percentage;
  String dir;
  String? rank;

  ActualPriceItem({
    this.itemName = "",
    this.basePrice = 0,
    this.avgPrice = 0,
    this.percentage = 0.0,
    this.dir = "",
    this.rank = "",
  });

  ActualPriceItem.fromJson(Map<String, dynamic> json)
      : itemName = json["ItemName"],
        basePrice = json["Price"],
        avgPrice = json["AveragePrice"],
        percentage = json["Percentage"],
        dir = json["Direction"],
        rank = json["Rank"] ?? "";

  Map<String, String> toJson() => {
        "ItemName": itemName,
        "Price": basePrice.toString(),
        "AveragePrice": avgPrice.toString(),
        "Percentage": percentage.toString()
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class SiteRanking {
  String rank;
  String siteName;
  int? costCompare;
  int? budgetCompare;
  int? cost;
  int? budgetMonthly;
  int? budgetAddition;
  double? percentageCompare;
  String? reqTime;
  String? settlementTime;
  String? reqSubmission;
  String? settlementSubmission;

  SiteRanking({
    this.rank = "0",
    this.siteName = "",
    this.cost = 0,
    this.budgetMonthly = 0,
    this.budgetAddition = 0,
    this.reqTime = "",
    this.settlementTime = "",
    this.reqSubmission = "",
    this.settlementSubmission = "",
    this.percentageCompare = 50.0,
    this.costCompare = 0,
    this.budgetCompare = 0,
  });

  SiteRanking.fromJson(Map<String, dynamic> json)
      : rank = json["Order"] ?? "1",
        siteName = json["SiteName"] ?? "",
        cost = json["TotalCost"] ?? 0,
        costCompare = json["Cost"] ?? 0,
        budgetCompare = json["Budget"] ?? 0,
        budgetMonthly = json["MonthlyBudget"] ?? 0,
        budgetAddition = json["AdditionalBudget"] ?? 0,
        reqTime = json["RequestTime"] ?? "",
        settlementTime = json["SettlementTime"] ?? "",
        reqSubmission = json["RequestSub"] ?? "",
        settlementSubmission = json["SettlementSub"] ?? "",
        percentageCompare = json["Percentage"] ?? 50.0;

  Map<String, String> toJson() => {
        "Rank": rank.toString(),
        "SiteName": siteName,
        "Cost": cost.toString(),
        "BudgetMonthly": budgetMonthly.toString(),
        "BudgetAddition": budgetAddition.toString(),
        "RequsetTime": reqTime ?? "",
        "SettlementTime": settlementTime ?? "",
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
