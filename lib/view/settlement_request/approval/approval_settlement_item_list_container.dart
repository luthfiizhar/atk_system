import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/widgets/divider_table.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApprovalSettlementRequestItemListContainer extends StatefulWidget {
  ApprovalSettlementRequestItemListContainer({
    super.key,
    this.index = 0,
    Item? item,
    // this.onChangedValue,
  }) : item = item ?? Item();

  int index;
  Item item;
  // Function? onChangedValue;
  // final TextEditingController _qty = TextEditingController();
  // final TextEditingController _actualPrice = TextEditingController();
  // final FocusNode qtyNode = FocusNode();
  // final FocusNode actualPriceNode = FocusNode();

  @override
  State<ApprovalSettlementRequestItemListContainer> createState() =>
      _ApprovalSettlementRequestItemListContainerState();
}

class _ApprovalSettlementRequestItemListContainerState
    extends State<ApprovalSettlementRequestItemListContainer> {
  onChangeQty(String value) {
    widget.item.actualQty = int.parse(value);
  }

  onChangePrice(String value) {
    widget.item.actualQty = int.parse(value);
  }

  @override
  void initState() {
    super.initState();
    // widget._qty.text = "0";
    // widget._actualPrice.text = "0";
    // widget._qty.addListener(() {
    //   if (widget._qty.text == "") {
    //     widget._qty.text = "0";
    //   }
    //   widget._qty.selection = TextSelection.fromPosition(
    //       TextPosition(offset: widget._qty.text.length));
    //   setState(() {});
    // });
    // widget._actualPrice.addListener(() {
    //   if (widget._qty.text == "") {
    //     widget._actualPrice.text = "0";
    //   }
    //   widget._qty.selection = TextSelection.fromPosition(
    //       TextPosition(offset: widget._qty.text.length));
    //   setState(() {});
    // });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index == 0 ? const SizedBox() : const DividerTable(),
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
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Text(
                          widget.item.actualQty.toString(),
                          style: bodyTableLightText,
                          textAlign: TextAlign.left,
                        ),
                        widget.item.actualQty == widget.item.qty
                            ? const SizedBox()
                            : widget.item.actualQty < widget.item.qty
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
                child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      formatCurrency.format(widget.item.actualPrice),
                      style: bodyTableLightText,
                      textAlign: TextAlign.left,
                    ),
                    widget.item.actualPrice == widget.item.basePrice
                        ? const SizedBox()
                        : widget.item.actualPrice < widget.item.basePrice
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
            ),
          ],
        ),
      ],
    );
  }
}

// class ThousandsSeparatorInputFormatter extends TextInputFormatter {
//   static const separator = '.'; // Change this to '.' for other locales

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     // Short-circuit if the new value is empty
//     if (newValue.text.length == 0) {
//       return newValue.copyWith(text: '');
//     }

//     // Handle "deletion" of separator character
//     String oldValueText = oldValue.text.replaceAll(separator, '');
//     String newValueText = newValue.text.replaceAll(separator, '');

//     if (oldValue.text.endsWith(separator) &&
//         oldValue.text.length == newValue.text.length + 1) {
//       newValueText = newValueText.substring(0, newValueText.length - 1);
//     }

//     // Only process if the old value and new value are different
//     if (oldValueText != newValueText) {
//       int selectionIndex =
//           newValue.text.length - newValue.selection.extentOffset;
//       final chars = newValueText.split('');

//       String newString = '';
//       for (int i = chars.length - 1; i >= 0; i--) {
//         if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
//           newString = separator + newString;
//         newString = chars[i] + newString;
//       }

//       return TextEditingValue(
//         text: newString.toString(),
//         selection: TextSelection.collapsed(
//           offset: newString.length - selectionIndex,
//         ),
//       );
//     }

//     // If the new value and old value are the same, just return as-is
//     return newValue;
//   }
// }
