import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuppliesItemListContainer extends StatefulWidget {
  SuppliesItemListContainer({
    super.key,
    this.index = 0,
    Item? item,
    this.countTotal,
  }) : item = item ?? Item();

  int index;
  Item item;
  final TextEditingController _qty = TextEditingController();
  final FocusNode qtyNode = FocusNode();
  Function? countTotal;

  @override
  State<SuppliesItemListContainer> createState() =>
      _SuppliesItemListContainerState();
}

class _SuppliesItemListContainerState extends State<SuppliesItemListContainer> {
  onChangeQty(String value) {
    widget.item.qty = int.parse(value);
    widget.item.totalPrice = widget.item.basePrice * int.parse(value);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    widget._qty.text = widget.item.qty.toString();
    widget._qty.addListener(() {
      if (widget._qty.text == "") {
        widget._qty.text = "0";
        widget._qty.selection = TextSelection.fromPosition(
            TextPosition(offset: widget._qty.text.length));
      }
      setState(() {});
    });
    setState(() {});
  }

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
                      focusNode: widget.qtyNode,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.deny(
                          RegExp(r'^0+'), //users can't type 0 at 1st position
                        )
                      ],
                      onChanged: (value) async {
                        await onChangeQty(value);
                        widget.countTotal!();
                      },
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
