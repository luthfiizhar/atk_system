import 'dart:convert';
import 'dart:io';

import 'package:atk_system_ga/functions/api_link.dart';
import 'package:atk_system_ga/main.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/supplies_request_class.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
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
        "TotalActualPrice" : ${item.actualTotalPrice}
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
        "MonthlyBudget" : ${site.monthlyBudget},
        "AdditionalBudget" : ${site.additionalBudget}
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
        "MonthlyBudget" : ${site.monthlyBudget},
        "AdditionalBudget" : ${site.additionalBudget}
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
        "Keywords" : "$keywords"
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

  Future deleteUser(String siteId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(urlConstant.apiUrl,
        '/GSS_Backend/public/api/admin/user-delete/$siteId');
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
}
