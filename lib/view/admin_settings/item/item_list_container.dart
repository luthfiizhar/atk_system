import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/view/admin_settings/item/add_item_dialog.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class ItemListContainer extends StatefulWidget {
  ItemListContainer({
    super.key,
    Item? item,
    this.index = 0,
    this.onClick,
    this.close,
    this.menu = "",
    this.updateList,
  }) : item = item ?? Item();

  Item item;
  int index;
  Function? onClick;
  Function? close;
  Function? updateList;
  String menu;

  @override
  State<ItemListContainer> createState() => _ItemListContainerState();
}

class _ItemListContainerState extends State<ItemListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index != 0
            ? const Divider(
                thickness: 0.5,
                color: grayStone,
              )
            : const SizedBox(),
        InkWell(
          onTap: () {
            if (widget.item.isExpanded) {
              widget.close!(widget.index);
            } else {
              widget.onClick!(widget.index);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 19),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.item.itemName,
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: Text(
                        widget.item.unit,
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 210,
                      child: Text(
                        formatCurrency.format(widget.item.basePrice),
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 75,
                    ),
                    SizedBox(
                      width: 20,
                      child: !widget.item.isExpanded
                          ? const Icon(
                              Icons.keyboard_arrow_right_sharp,
                            )
                          : const Icon(
                              Icons.keyboard_arrow_down_sharp,
                            ),
                    ),
                  ],
                ),
                !widget.item.isExpanded
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: RegularButton(
                                    text: 'Edit',
                                    disabled: false,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AddItemDialog(
                                          isEdit: true,
                                          item: widget.item,
                                        ),
                                      ).then((value) {
                                        if (value == 1) {
                                          widget.updateList!(widget.menu);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: DeleteButton(
                                    text: 'Delete',
                                    disabled: false,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    onTap: () {
                                      ApiService apiService = ApiService();
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const ConfirmDialogBlack(
                                          title: "Confirmation",
                                          contentText:
                                              "Are you sure want delete this item?",
                                        ),
                                      ).then((value) {
                                        if (value == 1) {
                                          apiService
                                              .deleteItem(widget.item.itemId)
                                              .then((value) {
                                            if (value['Status'].toString() ==
                                                "200") {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialogBlack(
                                                  title: value['Title'],
                                                  contentText: value['Message'],
                                                ),
                                              ).then((value) {
                                                widget.updateList!(widget.menu);
                                              });
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialogBlack(
                                                  title: value['Title'],
                                                  contentText: value['Message'],
                                                  isSuccess: false,
                                                ),
                                              );
                                            }
                                          }).onError((error, stackTrace) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const AlertDialogBlack(
                                                title: "Error deleteItem",
                                                contentText:
                                                    "No internet connection",
                                                isSuccess: false,
                                              ),
                                            );
                                          });
                                        }
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
