import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class SettlementRequestItemListContainer extends StatefulWidget {
  SettlementRequestItemListContainer({
    super.key,
    this.index = 0,
    Item? item,
  }) : item = item ?? Item();

  int index;
  Item item;
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _actualPrice = TextEditingController();

  @override
  State<SettlementRequestItemListContainer> createState() =>
      _SettlementRequestItemListContainerState();
}

class _SettlementRequestItemListContainerState
    extends State<SettlementRequestItemListContainer> {
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
              width: 135,
              child: Text(
                widget.item.reqQty.toString(),
                style: bodyTableLightText,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Text(
                formatCurrency.format(widget.item.reqPrice),
                style: bodyTableLightText,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: 150,
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
              // child: Text(
              //   formatCurrency.format(widget.item.totalPrice),
              //   style: bodyTableLightText,
              //   textAlign: TextAlign.left,
              // ),
              child: SizedBox(
                width: 150,
                child: BlackInputField(
                  controller: widget._actualPrice,
                  enabled: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
