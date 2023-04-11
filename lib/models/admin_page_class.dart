class Site {
  Site({
    this.siteId = "",
    this.siteName = "",
    this.oldSiteId = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.siteArea = 0,
    this.monthlyBudget = 0,
    this.additionalBudget = 0,
    this.isExpanded = false,
  });

  String siteId;
  String oldSiteId;
  String siteName;
  double latitude;
  double longitude;
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
    this.isExpanded = false,
    List? roleList,
  }) : roleList = roleList ?? [];

  String nip;
  String name;
  String siteId;
  String role;
  String oldNip;
  String siteName;
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
