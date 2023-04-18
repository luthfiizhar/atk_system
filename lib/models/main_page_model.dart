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
  int cost;
  String date;
  String time;

  RecentTransactionTable({
    this.siteName = "",
    this.type = "",
    this.cost = 0,
    this.date = "",
    this.time = "",
  });

  RecentTransactionTable.fromJson(Map<String, dynamic> json)
      : siteName = json["SiteName"],
        type = json['FormType'],
        cost = json["Cost"],
        date = json["Date"],
        time = json["Time"];

  Map<String, String> toJson() => {
        "SiteName": siteName,
        "FormType": type,
        "Cost": cost.toString(),
        "Date": date,
        "Time": time,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class TopRequestedItems {
  String name;
  String qty;

  TopRequestedItems({
    this.name = "",
    this.qty = "",
  });

  TopRequestedItems.fromJson(Map<String, dynamic> json)
      : name = json["ItemName"],
        qty = json["TotalRequested"].toString();

  Map<String, String> toJson() => {"ItemName": name, "Quantity": qty};

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

  ActualPriceItem({
    this.itemName = "",
    this.basePrice = 0,
    this.avgPrice = 0,
    this.percentage = 0.0,
    this.dir = "",
  });

  ActualPriceItem.fromJson(Map<String, dynamic> json)
      : itemName = json["ItemName"],
        basePrice = json["Price"],
        avgPrice = json["AveragePrice"],
        percentage = json["Percentage"],
        dir = json["Direction"];

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
