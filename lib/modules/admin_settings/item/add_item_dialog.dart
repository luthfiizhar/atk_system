import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddItemDialog extends StatefulWidget {
  AddItemDialog({
    super.key,
    this.isEdit = false,
    Item? item,
  }) : item = item ?? Item();

  Item item;
  bool isEdit;

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  ApiService apiService = ApiService();
  final formKey = GlobalKey<FormState>();

  TextEditingController _itemName = TextEditingController();
  TextEditingController _price = TextEditingController();

  FocusNode itemNameNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode unitNode = FocusNode();
  FocusNode categoryNode = FocusNode();

  String itemName = "";
  int price = 0;
  String selectedUnit = "";
  String selectedCategory = "";

  List unitList = [];
  List categoryList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 400,
          minWidth: 600,
          maxWidth: 720,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              top: 35,
              bottom: 30,
              left: 40,
              right: 40,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item Data",
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Create or edit item data',
                    style: helveticaText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  inputField(
                    'Item Name',
                    widget: SizedBox(
                      width: 350,
                      child: BlackInputField(
                        controller: _itemName,
                        focusNode: itemNameNode,
                        enabled: true,
                        hintText: 'Name here ...',
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputField(
                    'Price',
                    widget: SizedBox(
                      width: 250,
                      child: BlackInputField(
                        controller: _price,
                        focusNode: priceNode,
                        enabled: true,
                        hintText: 'Price here ...',
                        maxLines: 1,
                        prefixIcon: SizedBox(
                          child: Center(
                            widthFactor: 0.0,
                            child: Text(
                              'Rp',
                              style: helveticaText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: eerieBlack,
                              ),
                            ),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp(
                                  r'^0+') //users can't type 0 at 1st position
                              ),
                          ThousandsSeparatorInputFormatter()
                        ],
                        validator: (value) =>
                            value == "0" ? "This field is required." : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputField(
                    'Unit',
                    widget: SizedBox(
                      width: 250,
                      child: BlackDropdown(
                        items: unitList
                            .map((item) => DropdownMenuItem(
                                  value: item['Value'],
                                  child: Text(
                                    item['Name'],
                                    style: helveticaText.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                  ),
                                ))
                            .toList(),
                        enabled: true,
                        hintText: 'Choose',
                        value: widget.isEdit ? selectedUnit : null,
                        onChanged: (value) {
                          selectedUnit = value;
                        },
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: eerieBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputField(
                    'Category',
                    widget: SizedBox(
                      width: 250,
                      child: BlackDropdown(
                        items: categoryList
                            .map((item) => DropdownMenuItem(
                                  value: item['Value'],
                                  child: Text(
                                    item['Name'],
                                    style: helveticaText.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                  ),
                                ))
                            .toList(),
                        enabled: true,
                        hintText: 'Choose',
                        value: widget.isEdit ? selectedCategory : null,
                        onChanged: (value) {
                          selectedCategory = value;
                        },
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: eerieBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TransparentButtonBlack(
                        text: "Cancel",
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RegularButton(
                        text: "Confirm",
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(String label, {Widget? widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 50,
          ),
          child: SizedBox(
            width: 150,
            child: Text(
              label,
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
          ),
        ),
        widget!,
      ],
    );
  }
}
