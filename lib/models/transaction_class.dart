import 'package:atk_system_ga/models/item_class.dart';

class Transaction {
  Transaction({
    this.formId = "",
    this.category = "",
    this.siteName = "",
    this.created = "",
    this.status = "",
    this.formType = "",
    this.siteArea = 0,
    this.budget = 0,
    this.isExpanded = false,
    this.orderPeriod = "",
    this.month = "",
    List<Item>? items,
    List<TransactionActivity>? activity,
  })  : items = items ?? [],
        activity = activity ?? [];
  String formId;
  String category;
  String siteName;
  String created;
  String status;
  String formType;
  String orderPeriod;
  String month;

  int siteArea;
  int budget;

  List<Item> items;
  List<TransactionActivity> activity;

  bool isExpanded;

  Map<String, String> toJson() => {
        '"FormID"': '"$formId"',
        '"Category"': '"$category"',
        '"Location"': '"$siteName"',
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
    this.photo = "",
    List<Attachment>? attachment,
  }) : attachment = attachment ?? [];

  String empName;
  String status;
  String date;
  String comment;
  String photo;
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
