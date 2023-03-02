import 'package:atk_system_ga/models/item_class.dart';

class SuppliesRequest {
  SuppliesRequest({
    this.id = "",
    this.createdDate = "",
    this.empName = "",
    this.empNip = "",
    this.status = "",
    List<Item>? items,
  }) : items = items ?? [];

  String? id;
  String? createdDate;
  String? empNip;
  String? empName;
  String? status;
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
