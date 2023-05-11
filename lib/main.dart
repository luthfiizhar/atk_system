import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/my_app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:atk_system_ga/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

String? jwtToken = "";
bool isTokenValid = false;
bool isSystemAdmin = false;
bool settingAccess = false;
bool isOps = false;

loginCheck() async {
  var box = await Hive.openBox('userLogin');
  jwtToken = box.get('jwtToken') != "" || box.get('jwtToken') != null
      ? box.get('jwtToken')
      : "";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await loginCheck();
  ApiService apiService = ApiService();

  apiService.tokenCheck().then((value) {
    if (value["Status"] == "200") {
      isTokenValid = true;
    } else {
      isTokenValid = false;
      // isSystemAdmin = false;
    }
    apiService.getUserData().then((value) {
      // print(value);
      if (value['Status'].toString() == "200") {
        settingAccess = value['Data']['SettingAccess'];
      }
      runApp(MyApp());
    });
  });
}
