import 'package:atk_system_ga/constant/colors.dart';
import 'package:flutter/material.dart';

class TitleIcon extends StatelessWidget {
  TitleIcon({super.key, this.icon = ""});

  String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      margin: const EdgeInsets.all(3),
      child: ImageIcon(
        AssetImage(icon),
        color: orangeAccent,
      ),
    );
  }
}
