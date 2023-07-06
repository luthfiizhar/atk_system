import 'package:flutter/material.dart';

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
  String year;
  int budget;
  int cost;

  CostSummBarChart({
    this.month = "",
    this.year = "",
    this.budget = 0,
    this.cost = 0,
  });

  CostSummBarChart.fromJson(Map<String, dynamic> json)
      : month = json["Month"],
        budget = json["Budget"],
        cost = json["Cost"],
        year = json["Year"] ?? "";

  Map<String, String> toJson() => {
        "Month": month,
        "Budget": budget.toString(),
        "Cost": cost.toString(),
        "Year": year
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class RecentTransactionTable {
  String siteName;
  String type;
  int cost;
  String date;
  String time;
  String formId;
  String approveDate;

  RecentTransactionTable({
    this.siteName = "",
    this.type = "",
    this.cost = 0,
    this.date = "",
    this.time = "",
    this.formId = "",
    this.approveDate = "",
  });

  RecentTransactionTable.fromJson(Map<String, dynamic> json)
      : siteName = json["SiteName"] ?? "",
        type = json["Type"] ?? "",
        cost = json["Cost"] ?? 0,
        date = json["Date"] ?? "",
        time = json["Time"] ?? "",
        formId = json["FormID"] ?? "",
        approveDate = json["ApproveDate"] ?? "";

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
  Color? color;

  TopRequestedItems({
    this.name = "",
    this.qty = "",
    this.rank = "1",
    this.totalCost = "0",
    this.color = Colors.green,
  });

  TopRequestedItems.fromJson(Map<String, dynamic> json)
      : name = json["ItemName"],
        qty = json["TotalRequested"].toString(),
        rank = "1",
        totalCost = "0",
        color = Colors.green;

  Map<String, String> toJson() => {
        "ItemName": name,
        "Quantity": qty,
        "Rank": rank,
        "TotalCost": totalCost,
        "Color": color.toString(),
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

class HistoryTable {
  String id;
  String siteName;
  int budgetMonthly;
  int budgetAdditional;
  String updatedBy;
  String updatedDateTime;
  String file;
  String fileName;
  String note;
  bool? isExpanded;
  String dateTime;

  HistoryTable({
    this.id = "",
    this.siteName = "",
    this.budgetMonthly = 0,
    this.budgetAdditional = 0,
    this.updatedBy = "",
    this.updatedDateTime = "",
    this.fileName = "",
    this.file = "",
    this.note = "",
    this.dateTime = "",
    this.isExpanded = false,
  });

  HistoryTable.fromJson(Map<String, dynamic> json)
      : id = json["RowNumber"].toString(),
        siteName = json["SiteName"],
        budgetMonthly = json["Budget"],
        budgetAdditional = json["AdditionalBudget"],
        file = json["FileData"],
        fileName = json["FileName"],
        note = json["Notes"],
        updatedBy = json["Updated_By"],
        updatedDateTime = json["Updated_At"],
        dateTime = json["Updated_Raw"] ?? "",
        isExpanded = false;

  Map<String, String> toJson() => {
        '"SiteName"': siteName,
        '"Budget"': budgetMonthly.toString(),
        '"AdditionalBudget"': budgetAdditional.toString(),
        '"FileURL"': file,
        '"Notes"': note,
        '"Updated_By"': updatedBy,
        '"Updated_At"': updatedDateTime
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
