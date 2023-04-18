import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:flutter/material.dart';

class AddNewItemDialog extends StatefulWidget {
  AddNewItemDialog({super.key, this.formId = ""});

  String formId;

  @override
  State<AddNewItemDialog> createState() => _AddNewItemDialogState();
}

class _AddNewItemDialogState extends State<AddNewItemDialog> {
  ApiService apiService = ApiService();
  TextEditingController _search = TextEditingController();
  SearchTerm searchTerm = SearchTerm()
    ..orderBy = "ItemName"
    ..orderDir = "ASC";

  List<Item> itemList = [];
  List<int> selectedItem = [];

  List<NewItemCheckBoxContainer> itemContainer = [];

  initItemList() {
    apiService.newItemSettleList(widget.formId, searchTerm).then((value) {
      if (value["Status"].toString() == "200") {
        List itemResult = value['Data'];
        for (var element in itemResult) {
          itemList.add(
            Item(
              itemId: element["ItemID"].toString(),
              itemName: element["ItemName"],
            ),
          );
        }

        for (var i = 0; i < itemList.length; i++) {
          itemContainer.add(
            NewItemCheckBoxContainer(
              item: itemList[i],
              index: i,
              onChangedItem: onChangeItem,
            ),
          );
        }
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value["Title"],
            contentText: value["Message"],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: "Error ",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  onChangeItem(Item item) {
    if (item.isChecked) {
      item.isChecked = false;
      selectedItem.removeWhere((element) => element == int.parse(item.itemId));
    } else {
      item.isChecked = true;
      selectedItem.add(int.parse(item.itemId));
    }

    print(selectedItem);
  }

  @override
  void initState() {
    super.initState();
    initItemList();
  }

  @override
  void dispose() {
    super.dispose();
    _search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 652,
          minWidth: 652,
          minHeight: 300,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: white,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
                vertical: 40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Item',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchInputField(
                    controller: _search,
                    enabled: true,
                    hintText: 'Search here ...',
                    prefixIcon: const Icon(
                      Icons.search_sharp,
                      // size: 16,
                      color: davysGray,
                    ),
                    maxLines: 1,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Item Name',
                            style: headerTableTextStyle,
                          ),
                        ),
                        iconSort("ItemName"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(
                    color: spanishGray,
                    thickness: 1,
                  ),
                  Column(
                    children: _search.text == ""
                        ? itemContainer
                            .asMap()
                            .map((index, value) => MapEntry(
                                index,
                                Column(
                                  children: [
                                    index == 0
                                        ? const Padding(
                                            padding: EdgeInsets.only(
                                              top: 15,
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                            child: Divider(
                                              thickness: 0.5,
                                              color: grayx11,
                                            ),
                                          ),
                                    value,
                                  ],
                                )))
                            .values
                            .toList()
                        : itemContainer
                            .where((element) => element.item.itemName
                                .toLowerCase()
                                .contains(_search.text.toLowerCase()))
                            .toList()
                            .asMap()
                            .map((index, value) => MapEntry(
                                index,
                                Column(
                                  children: [
                                    index == 0
                                        ? const Padding(
                                            padding: EdgeInsets.only(
                                              top: 15,
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                            child: Divider(
                                              thickness: 0.5,
                                              color: grayx11,
                                            ),
                                          ),
                                    value,
                                  ],
                                )))
                            .values
                            .toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: spanishGray,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TransparentButtonBlack(
                        text: 'Cancel',
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {},
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RegularButton(
                        text: 'Confirm',
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          apiService
                              .addSettlementItem(widget.formId, selectedItem)
                              .then((value) {
                            if (value['Status'].toString() == "200") {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialogBlack(
                                  title: value['Title'],
                                  contentText: value['Message'],
                                  isSuccess: true,
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
                              builder: (context) => AlertDialogBlack(
                                title: "Error addItemSettlement",
                                contentText: error.toString(),
                                isSuccess: true,
                              ),
                            );
                          });
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

  Widget iconSort(String orderBy) {
    return SizedBox(
      width: 20,
      height: 25,
      child: orderBy != searchTerm.orderBy
          ? Stack(
              children: const [
                Visibility(
                  child: Positioned(
                    top: 0,
                    left: 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 16,
                    ),
                  ),
                ),
                Visibility(
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    child: Icon(
                      Icons.keyboard_arrow_up_sharp,
                      size: 16,
                    ),
                  ),
                )
              ],
            )
          : searchTerm.orderDir == "ASC"
              ? const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 16,
                  ),
                )
              : const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.keyboard_arrow_up_sharp,
                    size: 16,
                  ),
                ),
    );
  }
}

class NewItemCheckBoxContainer extends StatefulWidget {
  NewItemCheckBoxContainer({
    super.key,
    this.index = 0,
    Item? item,
    this.onChangedItem,
  }) : item = item ?? Item();
  Item item;
  int index;
  Function? onChangedItem;

  @override
  State<NewItemCheckBoxContainer> createState() =>
      _NewItemCheckBoxContainerState();
}

class _NewItemCheckBoxContainerState extends State<NewItemCheckBoxContainer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.item.itemName,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: davysGray,
            ),
          ),
        ),
        Checkbox(
          value: widget.item.isChecked,
          onChanged: (value) {
            widget.onChangedItem!(widget.item);
            // if (widget.item.isChecked) {
            //   widget.item.isChecked = false;
            // } else {
            //   widget.item.isChecked = true;
            // }
            setState(() {});
          },
          activeColor: eerieBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
      ],
    );
  }
}
