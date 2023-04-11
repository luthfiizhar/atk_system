import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/divider_table.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettlementRequestItemListContainer extends StatefulWidget {
  SettlementRequestItemListContainer({
    super.key,
    this.index = 0,
    Item? item,
    this.onChangedValue,
    Transaction? transaction,
    this.removeItem,
  })  : item = item ?? Item(),
        transaction = transaction ?? Transaction();

  int index;
  Item item;
  Function? onChangedValue;
  Transaction transaction;
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _actualPrice = TextEditingController();
  final FocusNode qtyNode = FocusNode();
  final FocusNode actualPriceNode = FocusNode();
  Function? removeItem;

  @override
  State<SettlementRequestItemListContainer> createState() =>
      _SettlementRequestItemListContainerState();
}

class _SettlementRequestItemListContainerState
    extends State<SettlementRequestItemListContainer> {
  ApiService apiService = ApiService();

  onChangeQty(String value) {
    widget.item.actualQty = int.parse(value);
    // if (widget._actualPrice.text.contains(".")) {
    widget.item.actualPrice =
        int.parse(widget._actualPrice.text.replaceAll(".", ""));
    // }
    widget.item.actualTotalPrice = int.parse(value) * widget.item.actualPrice;

    apiService
        .saveItemSetllement(widget.transaction, widget.item)
        .then((value) {})
        .onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error saveItemSettlement",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  onChangePrice(String value) {
    if (value.contains(".")) {
      widget.item.actualPrice = int.parse(value.replaceAll(".", ""));
    } else {
      widget.item.actualPrice = int.parse(value);
    }
    widget.item.actualTotalPrice =
        widget.item.actualPrice * int.parse(widget._qty.text);

    apiService
        .saveItemSetllement(widget.transaction, widget.item)
        .then((value) {})
        .onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error saveItemSetllement",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    widget._qty.text = widget.item.actualQty.toString();
    // widget._actualPrice.text = widget.item.actualPrice.toString();
    widget._actualPrice.value =
        ThousandsSeparatorInputFormatter().formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(
              text: widget.item.actualPrice.toString(),
            ));
    widget._qty.addListener(() {
      if (mounted) {
        if (widget._qty.text == "") {
          widget._qty.text = "0";
        }
        widget._qty.selection = TextSelection.fromPosition(
            TextPosition(offset: widget._qty.text.length));
        // setState(() {});
      }
    });
    widget._actualPrice.addListener(() {
      if (mounted) {
        if (widget._qty.text == "") {
          widget._actualPrice.text = "0";
        }
        widget._qty.selection = TextSelection.fromPosition(
            TextPosition(offset: widget._qty.text.length));
        // setState(() {});
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              widget.item.itemInfo == "Default"
                  ? const SizedBox()
                  : Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: orangeAccent,
                      ),
                    ),
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
                child: Focus(
                  onFocusChange: (value) async {
                    if (!widget.qtyNode.hasFocus &&
                        !widget.actualPriceNode.hasFocus) {
                      await widget.onChangedValue!(widget.index,
                          widget._qty.text, widget._actualPrice.text);
                      onChangeQty(widget._qty.text);
                    }
                  },
                  child: BlackInputField(
                    controller: widget._qty,
                    focusNode: widget.qtyNode,
                    enabled: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                    ],
                    // onFieldSubmitted: (value) async {},
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 150,
          child: Focus(
            onFocusChange: (value) async {
              if (!widget.qtyNode.hasFocus &&
                  !widget.actualPriceNode.hasFocus) {
                await widget.onChangedValue!(
                    widget.index, widget._qty.text, widget._actualPrice.text);

                onChangePrice(widget._actualPrice.text);
              }
            },
            child: BlackInputField(
              controller: widget._actualPrice,
              enabled: true,
              focusNode: widget.actualPriceNode,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                ThousandsSeparatorInputFormatter(),
              ],
              // onFieldSubmitted: (value) async {},
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: widget.item.itemInfo == "Default"
              ? const SizedBox()
              : IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    widget.removeItem!(widget.item.itemId);
                  },
                  icon: const Icon(Icons.close_sharp),
                ),
        ),
      ],
    );
  }
}
