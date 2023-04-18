import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/admin_setting_layout.dart';
import 'package:atk_system_ga/models/main_model.dart';
import 'package:atk_system_ga/my_app.dart';
import 'package:atk_system_ga/view/admin_settings/admin_setting_page.dart';
import 'package:atk_system_ga/view/admin_settings/item/setting_item_page.dart';
import 'package:atk_system_ga/view/admin_settings/site/setting_site_page.dart';
import 'package:atk_system_ga/view/admin_settings/user/setting_user_page.dart';
import 'package:atk_system_ga/view/dashboard/main_page_dashboard.dart';
import 'package:atk_system_ga/view/home/home_page.dart';
import 'package:atk_system_ga/view/login/login_page.dart';
import 'package:atk_system_ga/view/settlement_request/approval/approval_settlement_request_page.dart';
import 'package:atk_system_ga/view/settlement_request/detail/settlement_request_detail_page.dart';
import 'package:atk_system_ga/view/settlement_request/request/settlement_request_page.dart';
import 'package:atk_system_ga/view/supplies_request/approval/approval_supplies_req_page.dart';
import 'package:atk_system_ga/view/supplies_request/detail/supplies_req_detail_page.dart';
import 'package:atk_system_ga/view/supplies_request/order/supplies_request_page.dart';
import 'package:atk_system_ga/view/transaction_list/transaction_list_page.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/view_model/main_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:atk_system_ga/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constant/key.dart';

String? jwtToken = "";
bool isTokenValid = false;
bool isSystemAdmin = false;

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
        isSystemAdmin = value['Data']['SystemAdmin'];
      }
      runApp(MyApp());
    });
  });
}
