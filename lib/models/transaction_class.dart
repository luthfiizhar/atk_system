import 'package:atk_system_ga/models/item_class.dart';

class Transaction {
  Transaction({
    this.formId = "",
    this.reqId = "",
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
    this.totalCost = 0,
    this.actualTotalCost = 0,
    this.settlementId = "",
    this.settlementStatus = "",
    List<Item>? items,
    List<TransactionActivity>? activity,
  })  : items = items ?? [],
        activity = activity ?? [];
  String formId;
  String reqId;
  String category;
  String siteName;
  String created;
  String status;
  String formType;
  String orderPeriod;
  String month;
  String settlementId;
  String settlementStatus;

  double siteArea;
  int budget;
  int totalCost;
  int actualTotalCost;

  List<Item> items;
  List<TransactionActivity> activity;

  bool isExpanded;

  Map<String, String> toJson() => {
        '"FormID"': '"$formId"',
        '"Category"': '"$category"',
        '"Location"': '"$siteName"',
        '"Created"': '"$created"',
        '"Status"': '"$status"',
        '"Items"': '$items',
        '"Activity"': '$activity',
        '"isExpanded"': isExpanded.toString()
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class TransactionActivity {
  TransactionActivity({
    this.id = "",
    this.empName = "",
    this.status = "",
    this.date = "",
    this.comment = "",
    this.photo = "",
    List<Attachment>? attachment,
    List? submitAttachment,
  })  : attachment = attachment ?? [],
        submitAttachment = submitAttachment ?? [];

  String id;
  String empName;
  String status;
  String date;
  String comment;
  String photo;
  List<Attachment> attachment;
  List submitAttachment;

  @override
  String toString() {
    return "empName: $empName, status: $status, date: $date, comment: $comment, photo:$photo, attachment: $attachment";
  }
}

class Attachment {
  Attachment({
    this.id = "",
    this.file = "",
    this.type = "",
    this.fileName = "",
  });
  String id;
  String file;
  String fileName;
  String type;

  @override
  String toString() {
    return "{fileName: $fileName, type: $type, base64 : $file}";
  }
}
