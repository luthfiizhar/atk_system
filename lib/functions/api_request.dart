import 'dart:convert';
import 'dart:io';

import 'package:atk_system_ga/functions/api_link.dart';
import 'package:atk_system_ga/main.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/supplies_request_class.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiConstant urlConstant = ApiConstant();

  // String urlA = url.apiUrlGlobal;

  Future login(String username, String password) async {
    // var url =
    //     Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/user/login');
    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/user/login-hcplus');
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Username" : "$username",
        "Password" : "$password"
    }
  """;

    try {
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);

      var data = json.decode(response.body);
      var box = await Hive.openBox('userLogin');
      if (data['Status'].toString() == "200") {
        box.put('jwtToken', data['Data']['Token'] ?? "");
        jwtToken = data['Data']['Token'];
        isTokenValid = true;
      }

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future tokenCheck() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/user/check-token');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      // if (data["Status"] != "200") {
      //   isTokenValid = false;
      // }
      return data;
    } on Error catch (e) {
      return e;
    } on SocketException catch (e) {
      return e;
    }
  }

  Future getDateTime() async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/date-server');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getUserData() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/user/detail');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    try {
      var response = await http.get(url, headers: requestHeader);
      // print(response.statusCode);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getTransactionList(SearchTerm body) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/form/list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
      {
        "FormType" : "${body.formType}",
        "Search" : "${body.keywords}",
        "PageNumber" : ${body.pageNumber},
        "MaxRecord" : ${body.max},
        "SortBy" : "${body.orderBy}",
        "SortOrder" : "${body.orderDir}"
      }
  """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future createTransaction(String formCategory) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/supply/transaction');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
      {
        "FormCategory" : "$formCategory"
      }
  """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future cancelTransaction(String formId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/supply/cancel');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
      {
        "FormID" : "$formId"
      }
    """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future generateSettlement(String formId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/generate-settlement');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
      {
        "FormID" : "$formId"
      }
  """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getFormDetail(String formId, SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
      urlConstant.apiUrl,
      '/GSS_Backend/public/api/form/supply/$formId',
      {
        "item_sort": searchTerm.orderBy,
        "item_dir": searchTerm.orderDir,
        "search": searchTerm.keywords,
      },
    );
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getFormDetailFilled(String formId, SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
      urlConstant.apiUrl,
      '/GSS_Backend/public/api/form/supply/filled/$formId',
      {
        "item_sort": searchTerm.orderBy,
        "item_dir": searchTerm.orderDir,
        "search": searchTerm.keywords,
      },
    );
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future submitSuppliesRequest(Transaction transaction) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/supply/submit');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID": "${transaction.formId}",
        "TotalCost": ${transaction.totalCost},
        "Items": ${transaction.items},
        "Comment" : "${transaction.activity.first.comment}",
        "Attachments" : ${transaction.activity.first.submitAttachment}
    }
    """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future approveSuppliesRequest(Transaction transaction) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/supply/confirm');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID": "${transaction.formId}",
        "Comment" : "${transaction.activity.first.comment}",
        "Attachments" : ${transaction.activity.first.submitAttachment}
    }
    """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getSettlementDetail(String formId, SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/settlement/$formId', {
      "item_sort": searchTerm.orderBy,
      "item_dir": searchTerm.orderDir,
      "search": searchTerm.keywords
    });
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future submitSettlementRequest(Transaction transaction) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/settlement/submit');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID": "${transaction.formId}",
        "TotalActualCost": ${transaction.actualTotalCost},
        "Items": ${transaction.items},
        "Comment" : "${transaction.activity.first.comment}",
        "Attachments" : ${transaction.activity.first.submitAttachment}
    }
    """;
    print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future approveSettlementRequest(Transaction transaction) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/supply/confirm');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID": "${transaction.formId}",
        "Comment" : "${transaction.activity.first.comment}",
        "Attachments" : ${transaction.activity.first.submitAttachment}
    }
    """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future sendBack(Transaction transaction) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/supply/sendback');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID": "${transaction.formId}",
        "Comment" : "${transaction.activity.first.comment}",
        "Attachments" : ${transaction.activity.first.submitAttachment}
    }
    """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future saveItemReq(Transaction transaction, Item item) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/form/item-save');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID" : "${transaction.formId}",
        "ItemID" : ${item.itemId},
        "Price" : ${item.estimatedPrice},
        "Quantity" : ${item.qty},
        "TotalPrice" : ${item.totalPrice}
    }
    """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future saveItemSetllement(Transaction transaction, Item item) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/form/settlement/item-save');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID" : "${transaction.formId}",
        "ItemID" : ${item.itemId},
        "ActualPrice" : ${item.actualPrice},
        "ActualQuantity" : ${item.actualQty},
        "TotalActualPrice" : ${item.actualTotalPrice},
        "RowID" : ${item.itemListId}
    }
    """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getTabTransactionCount() async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/type-count');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future printOrderSupplies(String formId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/supply/print-pdf/$formId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future printSettlement(String formId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/settlement/print-pdf/$formId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getToDoList() async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/user/to-do');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAdminPageSiteList(SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/site-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy" : "${searchTerm.orderBy}",
        "OrderDir" : "${searchTerm.orderDir}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAdminPageItemList(SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/item-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy" : "${searchTerm.orderBy}",
        "OrderDir" : "${searchTerm.orderDir}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAdminPageUserList(SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/user-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
       "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy" : "${searchTerm.orderBy}",
        "OrderDir" : "${searchTerm.orderDir}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAdminPageBusinessUnitList(SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/business-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max}
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAdminPageRegionList(SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/region-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy": "${searchTerm.orderBy}",
        "OrderDir": "${searchTerm.orderDir}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAdminPageAreaList(SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/area-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy": "${searchTerm.orderBy}",
        "OrderDir": "${searchTerm.orderDir}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future addBusinessUnit(BusinessUnit businessUnit) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/add-business');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Name" : "${businessUnit.name}",
        "Image" : "${businessUnit.photo}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future updateBusinessUnit(BusinessUnit businessUnit) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/edit-business');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "BusinessID" : ${businessUnit.businessUnitId},
        "Name" : "${businessUnit.name}",
        "Image" : "${businessUnit.photo}"
    }
    """;

    try {
      var response =
          await http.put(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future deleteBusinssUnit(BusinessUnit businessUnit) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/delete-business');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "BusinessID" : ${businessUnit.businessUnitId}
    }
    """;

    try {
      var response =
          await http.delete(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future addRegion(Region region) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/add-region');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "RegionName" : "${region.regionName}",
        "CompID" : "${region.businessUnitID}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future updateRegion(Region region) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/edit-region');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "RegionID" : "${region.regionId}",
        "RegionName" : "${region.regionName}",
        "CompID" : "${region.businessUnitID}"
    }
    """;

    try {
      var response =
          await http.put(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future deleteRegion(Region region) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/delete-region');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "RegionalID" : "${region.regionId}"
    }
    """;

    try {
      var response =
          await http.delete(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future addArea(Area area) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/admin/add-area');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "AreaName" : "${area.areaName}",
        "RegionalID" : "${area.regionID}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future updateArea(Area area) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/edit-area');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "AreaID" : "${area.areaId}",
        "AreaName" : "${area.areaName}",
        "RegionalID" : "${area.regionID}"
    }
    """;

    try {
      var response =
          await http.put(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future deleteArea(Area area) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/delete-area');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        
    }
    """;

    try {
      var response =
          await http.delete(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future addSite(Site site) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/admin/site-add');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "SiteId" : "${site.siteId}",
        "SiteName" : "${site.siteName}",
        "SiteArea" : ${site.siteArea},
        "Latitude" : ${site.latitude},
        "Longitude" : ${site.longitude},
        "MonthlyBudget" : ${site.monthlyBudget},
        "AdditionalBudget" : ${site.additionalBudget},
        "AreaID" : "${site.areaId}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future updateSite(Site site) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/site-edit');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "OldSiteId" : "${site.oldSiteId}",
        "SiteId" : "${site.siteId}",
        "SiteName" : "${site.siteName}",
        "SiteArea" : ${site.siteArea},
        "Latitude" : ${site.latitude},
        "Longitude" : ${site.longitude},
        "MonthlyBudget" : ${site.monthlyBudget},
        "AdditionalBudget" : ${site.additionalBudget},
        "AreaID" : "${site.areaId}"
    }
    """;

    try {
      var response =
          await http.put(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future deleteSite(String siteId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/admin/site-delete/$siteId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.delete(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getSiteListDropdown(String keywords) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/site-dropdown');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Keywords" : "$keywords"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAreaListDropdown() async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/area-dropdown');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
   
    """;

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getRoleListDropdown() async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/role-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getSiteListDropdownByRole(String role, String keyword) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/user-site-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "UserRole" : "$role",
      "Keywords" : "$keyword"
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getBUListDropdown() async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/business-dropdown');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
   
    """;

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getRegionListDropdown() async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/region-dropdown');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
   
    """;

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future addUser(User user) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/admin/user-add');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "UserNIP" : "${user.nip}",
        "Fullname" : "${user.name}",
        "SiteId" : "${user.siteId}",
        "CompID" : "${user.compId}",
        "Role" : "${user.role}"
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future updateUser(User user) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/user-update');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "OldUserNIP" : "${user.oldNip}",
        "UserNIP" : "${user.nip}",
        "Fullname" : "${user.name}",
        "SiteId" : "${user.siteId}",
        "CompID" : "${user.compId}",
        "Role" : "${user.role}"
    }
    """;

    try {
      var response =
          await http.put(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future deleteUser(String empNip) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/admin/user-delete/$empNip');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.delete(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future addItem(Item item) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/admin/add-item');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "ItemName" : "${item.itemName}",
        "ItemPrice" : ${item.basePrice},
        "ItemUnit" : "${item.unit}",
        "Business" : ${item.buList}
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future updateItem(Item item) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/edit-item');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "ItemID" : "${item.itemId}",
        "ItemName" : "${item.itemName}",
        "ItemPrice" : ${item.basePrice},
        "ItemUnit" : "${item.unit}",
        "Business" : ${item.buList}
    }
    """;

    try {
      var response =
          await http.put(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future deleteItem(String itemId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/admin/delete-item/$itemId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.delete(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getUnitList() async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/admin/unit-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: requestHeader);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future exportTransactionList(String startDate, String endDate) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/export-excel');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Start" : "$startDate",
        "End" : "$endDate"
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future newItemSettleList(String formId, SearchTerm searchTerm) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/form/settlement/item-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID" : "$formId",
        "Keywords" : "",
        "OrderBy" : "",
        "OrderDir" : ""
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future addSettlementItem(String formId, List item) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/settlement/add-item');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID" : "$formId",
        "Items" : $item
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future deleteAdditionalItemSettle(
      String formId, String itemId, String rowId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/form/settlement/delete-item');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FormID" : "$formId",
        "ItemID" : $itemId,
        "RowID": $rowId
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  //DASHBOARD
  Future dashboardRecentTransactionDetail(
      SearchTerm searchTerm, GlobalModel globalModel) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/dashboard/recent-transaction-detail');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "CompName": "",
        "CompID": "${globalModel.businessUnit}",
        "Role" : "${globalModel.role}",
        "Site" : "${globalModel.areaId}",
        "Month" : ${globalModel.month},
        "Year" : "${globalModel.year}",
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy" : "${searchTerm.orderBy}",
        "OrderDir" : "${searchTerm.orderDir}"
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future dashboardActualPriceDetail(
      SearchTerm searchTerm, GlobalModel globalModel) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/dashboard/item-pricing-detail');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "CompName": "",
        "CompID": "${globalModel.businessUnit}",
        "Role" : "${globalModel.role}",
        "Site" : "${globalModel.areaId}",
        "Month" : ${globalModel.month},
        "Year" : "${globalModel.year}",
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy" : "${searchTerm.orderBy}",
        "OrderDir" : "${searchTerm.orderDir}"
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future dashboardTopRequestedItemDetail(
      SearchTerm searchTerm, GlobalModel globalModel) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/dashboard/requested-item-detail');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "CompName": "",
        "CompID": "${globalModel.businessUnit}",
        "Role" : "${globalModel.role}",
        "Site" : "${globalModel.areaId}",
        "Month" : ${globalModel.month},
        "Year" : "${globalModel.year}",
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy" : "${searchTerm.orderBy}",
        "OrderDir" : "${searchTerm.orderDir}"
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future dashboardSiteRanking(
    SearchTerm searchTerm,
    GlobalModel globalModel,
    String dataType,
  ) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url;

    if (dataType == "Highest Cost" || dataType == "Lowest Cost") {
      url = Uri.https(urlConstant.apiUrl,
          '/GSS_Backend/public/api/dashboard/ranking-cost-detail');
    }
    if (dataType == "Highest Budget" || dataType == "Lowest Budget") {
      url = Uri.https(urlConstant.apiUrl,
          '/GSS_Backend/public/api/dashboard/budget-detail');
    }
    if (dataType == "Slowest Leadtime" || dataType == "Fastest Leadtime") {
      url = Uri.https(urlConstant.apiUrl,
          '/GSS_Backend/public/api/dashboard/ranking-leadtime-detail');
    }

    if (dataType == "Cost vs Budget") {
      url = Uri.https(urlConstant.apiUrl,
          '/GSS_Backend/public/api/dashboard/budget-cost-site-detail');
    }
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "DataType" : "$dataType",
        "CompName": "",
        "CompID": "${globalModel.businessUnit}",
        "Role" : "${globalModel.role}",
        "Site" : "${globalModel.areaId}",
        "Month" : ${globalModel.month},
        "Year" : "${globalModel.year}",
        "Keywords" : "${searchTerm.keywords}",
        "PageNumber" : ${searchTerm.pageNumber},
        "MaxRecord" : ${searchTerm.max},
        "OrderBy" : "${searchTerm.orderBy}",
        "OrderDir" : "${searchTerm.orderDir}"
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future exportDashboard(
    String dataType,
    String month,
    String year,
    GlobalModel globalModel,
  ) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/dashboard/export');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "DataType": "$dataType",
        "Role": "${globalModel.role}",
        "CompName": "${globalModel.companyName}",
        "CompID": "${globalModel.businessUnit}",
        "Site": "${globalModel.areaId}",
        "Month": $month,
        "Year": "$year"
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future dashboardOptAreaList(
      String role, String area, String businessUnit, String search) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/dashboard/user-location-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Role" : "$role",
        "Site" : "$area",
        "Keyword" : "$search",
        "BusinessID" : $businessUnit
    }
    """;

    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future dashboardOptBusinessUnitList() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/dashboard/business-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(
        url,
        headers: requestHeader,
      );

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future dashboardOptMonthList(String businessUnitId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/dashboard/month-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "CompID" : $businessUnitId
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future dashboardOptYearList(String businessUnitId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/dashboard/year-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "CompID" : $businessUnitId
    }
    """;

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }
}
