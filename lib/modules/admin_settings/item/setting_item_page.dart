import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/layout/admin_setting_layout.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class ItemSettingPage extends StatefulWidget {
  ItemSettingPage({super.key, this.menu = "Item"});

  String menu;

  @override
  State<ItemSettingPage> createState() => _ItemSettingPageState();
}

class _ItemSettingPageState extends State<ItemSettingPage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialogBlack(
                contentText: 'aaa',
                title: 'aaa',
              ),
            );
          },
          child: Text('test'),
        ),
        BlackInputField(
          controller: _controller,
          enabled: true,
        )
      ],
    );
    return AdminSettingLayoutPageWeb(
      menu: widget.menu,
      menuIndex: 0,
      index: 0,
      child: Container(
        width: double.infinity,
        height: 300,
        color: violetAccent,
      ),
    );
  }
}
