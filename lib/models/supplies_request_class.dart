import 'package:atk_system_ga/models/item_class.dart';

class SuppliesRequest {
  SuppliesRequest({
    this.id = "",
    this.createdDate = "",
    this.formType = "",
    this.empName = "",
    this.empNip = "",
    this.status = "",
    this.siteName = "",
    this.orderPeriod = "",
    this.month = "",
    this.siteArea = 0,
    this.budget = 0,
    List<Item>? items,
  }) : items = items ?? [];

  String? id;
  String? createdDate;
  String? formType;
  String? empNip;
  String? empName;
  String? status;
  String? siteName;
  String? orderPeriod;
  String? month;

  int? siteArea;
  int? budget;

  List<Item>? items;

  SuppliesRequest.fromJson(Map<String, String> json)
      : id = json['TransactionID'],
        createdDate = json['CreatedDate'],
        empNip = json['EmployeeNIP'],
        empName = json['EmployeeName'],
        status = json['Status'];

  Map<String, dynamic> toJson() => {
        '"TransactionID"': '"$id"',
        '"createdDate"': '"$createdDate"',
        '"EmployeeName"': '"$empName"',
        '"EmployeeNIP"': '"$empNip"',
        '"Status"': '"$status"'
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
