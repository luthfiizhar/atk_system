import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/widgets/divider_table.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class ApprovalSuppliesItemListContainer extends StatefulWidget {
  ApprovalSuppliesItemListContainer({
    super.key,
    this.index = 0,
    Item? item,
  }) : item = item ?? Item();

  int index;
  Item item;

  @override
  State<ApprovalSuppliesItemListContainer> createState() =>
      _ApprovalSuppliesItemListContainerState();
}

class _ApprovalSuppliesItemListContainerState
    extends State<ApprovalSuppliesItemListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index == 0 ? const SizedBox() : const DividerTable(),
        Row(
          children: [
            SizedBox(
              width: 420,
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
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    formatCurrency.format(widget.item.estimatedPrice),
                    style: bodyTableLightText,
                    textAlign: TextAlign.left,
                  ),
                  widget.item.basePrice == widget.item.estimatedPrice
                      ? const SizedBox()
                      : widget.item.estimatedPrice < widget.item.basePrice
                          ? const ImageIcon(
                              AssetImage('assets/icons/budget_down.png'),
                              color: greenAcent,
                            )
                          : const ImageIcon(
                              AssetImage('assets/icons/budget_up.png'),
                              color: orangeAccent,
                            )
                ],
              ),
            ),
            SizedBox(
              width: 125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 75,
                    child: Text(
                      widget.item.qty.toString(),
                      style: bodyTableLightText,
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
