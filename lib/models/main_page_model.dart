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
