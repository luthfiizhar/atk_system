class Transaction {
  Transaction({
    this.formId = "",
    this.category = "",
    this.location = "",
    this.created = "",
    this.status = "",
    this.isExpanded = false,
  });
  String formId;
  String category;
  String location;
  String created;
  String status;
  bool isExpanded;

  Map<String, String> toJson() => {
        '"FormID"': '"$formId"',
        '"Category"': '"$category"',
        '"Location"': '"$location"',
        '"Created"': '"$created"',
        '"Status"': '"$status"',
        '"isExpanded"': isExpanded.toString(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class TransactionActivity {
  TransactionActivity({
    this.empName = "",
    this.status = "",
    this.date = "",
    this.comment = "",
    List<Attachment>? attachment,
  }) : attachment = attachment ?? [];

  String empName;
  String status;
  String date;
  String comment;
  List<Attachment> attachment;
}

class Attachment {
  Attachment({
    this.file = "",
    this.type = "",
  });
  String file;
  String type;
}
