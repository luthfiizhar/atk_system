import 'dart:convert';

import 'package:atk_system_ga/functions/api_link.dart';
import 'package:atk_system_ga/main.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiConstant urlConstant = ApiConstant();

  // String urlA = url.apiUrlGlobal;

  Future login(String username, String password) async {
    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/user/login');
    Map<String, String> requestHeader = {
      // 'Authorization': 'Bearer $tokenDummy',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
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

  Future getTransactionList(SearchTerm body) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url =
        Uri.https(urlConstant.apiUrl, '/GSS_Backend/public/api/form/list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
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
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
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

  Future getFormDetail(String formId) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    // jwt = jwtToken;

    var url = Uri.https(
        urlConstant.apiUrl, '/GSS_Backend/public/api/form/supply/$formId');
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
}
