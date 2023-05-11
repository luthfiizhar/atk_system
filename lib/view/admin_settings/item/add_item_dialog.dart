import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
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
  TextEditingController _businessUnit = TextEditingController();

  FocusNode itemNameNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode unitNode = FocusNode();
  FocusNode categoryNode = FocusNode();
  FocusNode buNode = FocusNode();

  String itemName = "";
  int price = 0;
  String selectedUnit = "";
  String selectedCategory = "";

  List unitList = [];
  List categoryList = [];

  List<BusinessUnit> buList = [];
  OverlayEntry? buOverlayEntry;
  GlobalKey buKey = GlobalKey();
  LayerLink buLayerLink = LayerLink();
  bool isBuOverlayOpen = false;

  String selectedRole = "";
  List selectedBuList = [];
  List selectedIDBuList = [];

  changeFieldRole() {
    if (selectedBuList.length > 1) {
      for (var i = 0; i < selectedBuList.length; i++) {
        if (i == selectedRole.length - 1) {
          _businessUnit.text +=
              selectedBuList[i].toString().replaceAll('"', "");
        } else {
          _businessUnit.text +=
              "${selectedBuList[i].toString().replaceAll('"', "")}, ";
        }
      }
    } else {
      _businessUnit.text = selectedBuList
          .toString()
          .replaceAll('"', "")
          .replaceAll("[", "")
          .replaceAll("]", "");
    }
  }

  addBu(BusinessUnit unit) {
    _businessUnit.text = "";
    selectedBuList.add('"${unit.name}"');
    selectedIDBuList.add('"${unit.businessUnitId}"');
    changeFieldRole();

    print(selectedIDBuList);
  }

  removeBu(BusinessUnit unit) {
    _businessUnit.text = "";
    selectedBuList.remove('"${unit.name}"');
    selectedIDBuList.remove('"${unit.businessUnitId}"');
    changeFieldRole();
    print(selectedIDBuList);
  }

  OverlayEntry buOverlay() {
    RenderBox? renderBox =
        buKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Stack(
              children: [
                ModalBarrier(
                  onDismiss: () {
                    if (isBuOverlayOpen) {
                      isBuOverlayOpen = false;
                      if (buOverlayEntry!.mounted) {
                        buOverlayEntry!.remove();
                      }
                    }
                  },
                ),
                Positioned(
                    // left: offset.dx,
                    // top: offset.dy + size.height + 10,
                    width: size.width,
                    child: CompositedTransformFollower(
                      showWhenUnlinked: false,
                      offset: Offset(0.0, size.height - 77.0),
                      link: buLayerLink,
                      child: Material(
                        elevation: 4.0,
                        color: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: BusinessUnitPickerContainer(
                          buList: buList,
                          check: addBu,
                          removeBu: removeBu,
                        ),
                      ),
                    )),
              ],
            ));
  }

  initUnitList() {
    apiService.getUnitList().then((value) {
      if (value["Status"].toString() == "200") {
        unitList = value['Data'];
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error getUnitList",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  Future initBuList() {
    return apiService.getBUListDropdown().then((value) {
      if (value["Status"].toString() == "200") {
        List resultData = value["Data"];

        for (var element in resultData) {
          buList.add(BusinessUnit(
            name: element["CompanyName"],
            businessUnitId: element["ID"].toString(),
          ));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initUnitList();
    initBuList().then((value) {
      if (widget.isEdit) {
        _itemName.text = widget.item.itemName;
        _price.value = ThousandsSeparatorInputFormatter().formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(
              text: widget.item.basePrice.toString(),
            ));
        selectedCategory = widget.item.category;
        selectedUnit = widget.item.unit;
      }
      for (var element in widget.item.buList) {
        for (var bu in buList) {
          if (bu.businessUnitId == element) {
            bu.isSelected = true;
            addBu(bu);
          }
        }
      }
    });

    _price.addListener(() {
      if (_price.text == "") {
        _price.text = "0";
        _price.selection = TextSelection.fromPosition(
            TextPosition(offset: _price.text.length));
      }
      setState(() {});
    });
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
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        onSaved: (newValue) {
                          itemName = newValue.toString();
                        },
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
                        onSaved: (newValue) {
                          price = int.parse(
                              newValue.toString().replaceAll(".", ""));
                        },
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
                    "Business Unit",
                    widget: Expanded(
                      child: Container(
                        key: buKey,
                        child: CompositedTransformTarget(
                          link: buLayerLink,
                          child: CustomInputField(
                            controller: _businessUnit,
                            focusNode: buNode,
                            enabled: true,
                            hintText: 'Choose Role',
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: eerieBlack,
                            ),
                            onTap: () {
                              if (isBuOverlayOpen) {
                                isBuOverlayOpen = false;
                                if (buOverlayEntry!.mounted) {
                                  buOverlayEntry!.remove();
                                }
                              } else {
                                buOverlayEntry = buOverlay();
                                Overlay.of(context).insert(buOverlayEntry!);
                                isBuOverlayOpen = true;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // inputField(
                  //   'Category',
                  //   widget: SizedBox(
                  //     width: 250,
                  //     child: BlackDropdown(
                  //       items: categoryList
                  //           .map((item) => DropdownMenuItem(
                  //                 value: item['Value'],
                  //                 child: Text(
                  //                   item['Name'],
                  //                   style: helveticaText.copyWith(
                  //                     fontSize: 14,
                  //                     fontWeight: FontWeight.w300,
                  //                     color: davysGray,
                  //                   ),
                  //                 ),
                  //               ))
                  //           .toList(),
                  //       enabled: true,
                  //       hintText: 'Choose',
                  //       value: widget.isEdit ? selectedCategory : null,
                  //       onChanged: (value) {
                  //         selectedCategory = value;
                  //       },
                  //       validator: (value) =>
                  //           value == "" ? "This field is required" : null,
                  //       suffixIcon: const Icon(
                  //         Icons.keyboard_arrow_down_outlined,
                  //         color: eerieBlack,
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                          Navigator.of(context).pop(0);
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
                            Item itemSave = Item();
                            itemSave.itemName = itemName.replaceAll('"', '\\"');
                            itemSave.basePrice = price;
                            itemSave.unit = selectedUnit;
                            itemSave.buList = selectedIDBuList;
                            if (widget.isEdit) {
                              itemSave.itemId = widget.item.itemId;
                              apiService.updateItem(itemSave).then((value) {
                                if (value['Status'].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pop(1);
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: false,
                                    ),
                                  );
                                }
                              }).onError((error, stackTrace) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialogBlack(
                                    title: "Error updateItem",
                                    contentText: "No internet connection.",
                                    isSuccess: false,
                                  ),
                                );
                              });
                            } else {
                              apiService.addItem(itemSave).then((value) {
                                if (value['Status'].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pop(1);
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: false,
                                    ),
                                  );
                                }
                              }).onError((error, stackTrace) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialogBlack(
                                    title: "Error updateItem",
                                    contentText: "No internet connection.",
                                    isSuccess: false,
                                  ),
                                );
                              });
                            }
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

class BusinessUnitPickerContainer extends StatefulWidget {
  BusinessUnitPickerContainer({
    super.key,
    List<BusinessUnit>? buList,
    this.check,
    this.removeBu,
  }) : buList = buList ?? [];

  List<BusinessUnit> buList;
  Function? check;
  Function? removeBu;

  @override
  State<BusinessUnitPickerContainer> createState() =>
      _BusinessUnitPickerContainerState();
}

class _BusinessUnitPickerContainerState
    extends State<BusinessUnitPickerContainer> {
  List<CheckContainer> checkBoxList = [];
  @override
  void initState() {
    super.initState();
    for (var element in widget.buList) {
      checkBoxList.add(
        CheckContainer(
          businessUnit: element,
          check: widget.check,
          removeBu: widget.removeBu,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 185,
        maxWidth: 185,
        minHeight: 275,
        maxHeight: 275,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: white,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: checkBoxList
              .asMap()
              .entries
              .map((e) => Padding(
                  padding: EdgeInsets.only(
                    top: e.key == 0 ? 0 : 15,
                  ),
                  child: e.value))
              .toList(),
        ),
      ),
    );
  }
}

class CheckContainer extends StatefulWidget {
  CheckContainer({
    super.key,
    BusinessUnit? businessUnit,
    this.check,
    this.removeBu,
  }) : businessUnit = businessUnit ?? BusinessUnit();

  BusinessUnit businessUnit;
  Function? check;
  Function? removeBu;

  @override
  State<CheckContainer> createState() => _CheckContainerState();
}

class _CheckContainerState extends State<CheckContainer> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        Checkbox(
          value: widget.businessUnit.isSelected,
          onChanged: (value) {
            if (widget.businessUnit.isSelected) {
              widget.businessUnit.isSelected = false;
              widget.removeBu!(widget.businessUnit);
            } else {
              widget.businessUnit.isSelected = true;
              widget.check!(widget.businessUnit);
            }
            setState(() {});
          },
          activeColor: eerieBlack,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.5)),
        ),
        Text(
          widget.businessUnit.name,
          style: helveticaText.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        )
      ],
    );
  }
}
