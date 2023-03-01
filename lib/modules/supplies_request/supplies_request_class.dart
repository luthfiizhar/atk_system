class SuppliesRequest {
  SuppliesRequest({
    this.id = "",
    this.createdDate = "",
    this.empName = "",
    this.empNip = "",
    this.status = "",
  });

  String? id;
  String? createdDate;
  String? empNip;
  String? empName;
  String? status;

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
