import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/layout/admin_setting_layout.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:flutter/material.dart';

class SettingSitePage extends StatefulWidget {
  SettingSitePage({super.key, this.menu = "Site"});

  String menu;

  @override
  State<SettingSitePage> createState() => _SettingSitePageState();
}

class _SettingSitePageState extends State<SettingSitePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: greenAcent,
    );
    return AdminSettingLayoutPageWeb(
      menu: widget.menu,
      menuIndex: 1,
      index: 0,
      child: Container(
        width: double.infinity,
        height: 300,
        color: greenAcent,
      ),
    );
  }
}
