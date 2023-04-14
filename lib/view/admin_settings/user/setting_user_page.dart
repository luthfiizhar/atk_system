import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/layout/admin_setting_layout.dart';
import 'package:flutter/material.dart';

class UserSettingPage extends StatefulWidget {
  UserSettingPage({
    super.key,
    this.menu = "User",
  });
  String menu;

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: yellow,
    );
    return AdminSettingLayoutPageWeb(
      index: 0,
      menu: widget.menu,
      menuIndex: 2,
      child: Container(
        width: double.infinity,
        height: 300,
        color: yellow,
      ),
    );
  }
}
