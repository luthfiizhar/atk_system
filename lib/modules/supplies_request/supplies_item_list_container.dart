import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class SuppliesItemListContainer extends StatefulWidget {
  SuppliesItemListContainer({
    super.key,
    this.index = 0,
    Item? item,
  }) : item = item ?? Item();

  int index;
  Item item;
  final TextEditingController _qty = TextEditingController();

  @override
  State<SuppliesItemListContainer> createState() =>
      _SuppliesItemListContainerState();
}

class _SuppliesItemListContainerState extends State<SuppliesItemListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index == 0
            ? const SizedBox()
            : const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 28,
                ),
                child: Divider(
                  color: grayx11,
                  thickness: 0.5,
                ),
              ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(
                    widget.item.itemName,
                    style: bodyTableNormalText,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                widget.item.unit,
                style: bodyTableLightText,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Text(
                formatCurrency.format(widget.item.basePrice),
                style: bodyTableLightText,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: 125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 75,
                    child: BlackInputField(
                      controller: widget._qty,
                      enabled: true,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                formatCurrency.format(widget.item.totalPrice),
                style: bodyTableLightText,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
