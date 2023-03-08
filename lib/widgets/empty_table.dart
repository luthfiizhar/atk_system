import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/material.dart';

class EmptyTable extends StatelessWidget {
  EmptyTable({
    super.key,
    this.text = "",
  });

  String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Center(
        child: Text(
          text,
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
      ),
    );
  }
}
