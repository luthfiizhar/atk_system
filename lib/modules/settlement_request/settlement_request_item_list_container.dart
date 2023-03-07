import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettlementRequestItemListContainer extends StatefulWidget {
  SettlementRequestItemListContainer({
    super.key,
    this.index = 0,
    Item? item,
    this.onChangedValue,
  }) : item = item ?? Item();

  int index;
  Item item;
  Function? onChangedValue;
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _actualPrice = TextEditingController();
  final FocusNode qtyNode = FocusNode();
  final FocusNode actualPriceNode = FocusNode();

  @override
  State<SettlementRequestItemListContainer> createState() =>
      _SettlementRequestItemListContainerState();
}

class _SettlementRequestItemListContainerState
    extends State<SettlementRequestItemListContainer> {
  onChangeQty(String value) {
    widget.item.actualQty = int.parse(value);
  }

  onChangePrice(String value) {
    widget.item.actualQty = int.parse(value);
  }

  @override
  void initState() {
    super.initState();
    widget._qty.text = "0";
    widget._actualPrice.text = "0";
    widget._qty.addListener(() {
      if (widget._qty.text == "") {
        widget._qty.text = "0";
      }
      widget._qty.selection = TextSelection.fromPosition(
          TextPosition(offset: widget._qty.text.length));
      setState(() {});
    });
    widget._actualPrice.addListener(() {
      if (widget._qty.text == "") {
        widget._actualPrice.text = "0";
      }
      widget._qty.selection = TextSelection.fromPosition(
          TextPosition(offset: widget._qty.text.length));
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
              child: Text(
                widget.item.itemName,
                style: bodyTableNormalText,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: 135,
              child: Text(
                widget.item.qty.toString(),
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
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 75,
                    child: BlackInputField(
                      controller: widget._qty,
                      focusNode: widget.qtyNode,
                      enabled: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                      ],
                      onChanged: (value) {
                        widget.onChangedValue!(widget.index, widget._qty.text,
                            widget._actualPrice.text);
                      },
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
                  focusNode: widget.actualPriceNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                    ThousandsSeparatorInputFormatter(),
                  ],
                  onChanged: (value) {
                    widget.onChangedValue!(widget.index, widget._qty.text,
                        widget._actualPrice.text);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.'; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
          newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
