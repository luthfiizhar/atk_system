import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/material.dart';

class TotalInfo extends StatelessWidget {
  TotalInfo({
    super.key,
    this.title = "",
    this.number = 0,
    this.numberColor = davysGray,
    this.titleColor = davysGray,
    Widget? icon,
  }) : icon = icon ?? const SizedBox();

  String title;
  int number;
  Color numberColor;
  Color titleColor;
  Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: titleColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text(
              formatCurrency.format(number),
              style: helveticaText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: numberColor,
              ),
            ),
            icon!,
          ],
        ),
      ],
    );
  }
}
