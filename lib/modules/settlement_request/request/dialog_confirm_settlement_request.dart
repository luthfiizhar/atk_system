import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/attachment_files.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/divider_table.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:atk_system_ga/widgets/total.dart';
import 'package:flutter/material.dart';

class ConfirmDialogSettlementRequest extends StatefulWidget {
  ConfirmDialogSettlementRequest({
    super.key,
    Transaction? transaction,
  }) : transaction = transaction ?? Transaction();

  Transaction transaction;

  @override
  State<ConfirmDialogSettlementRequest> createState() =>
      _ConfirmDialogSettlementRequestState();
}

class _ConfirmDialogSettlementRequestState
    extends State<ConfirmDialogSettlementRequest> {
  SearchTerm searchTerm = SearchTerm(
    orderBy: "ItemName",
    orderDir: "ASC",
  );
  ApiService apiService = ApiService();

  TextEditingController _comment = TextEditingController();

  String comment = "";

  int totalBudget = 0;
  int totalCost = 0;
  int totalActualCost = 0;

  List<Item> itemList = [];
  List<Attachment> attachment = [];
  List<TransactionActivity> activity = [];

  initDetail() {
    totalBudget = widget.transaction.budget;

    for (var element in widget.transaction.items) {
      totalCost = totalCost + element.totalPrice;
      totalActualCost =
          totalActualCost + (element.actualPrice * element.actualQty);
    }

    itemList = widget.transaction.items;

    setState(() {});
  }

  onTapHeader(String orderBy) {
    setState(() {
      // tempItems = items;
      if (searchTerm.orderBy == orderBy) {
        switch (searchTerm.orderDir) {
          case "ASC":
            searchTerm.orderDir = "DESC";
            break;
          case "DESC":
            searchTerm.orderDir = "ASC";
            break;
          default:
        }
      }

      switch (orderBy) {
        case "ReqPrice":
          if (searchTerm.orderDir == "ASC") {
            itemList.sort(
              (a, b) => a.basePrice.compareTo(b.basePrice),
            );
          } else {
            itemList.sort(
              (a, b) => b.basePrice.compareTo(a.basePrice),
            );
          }
          break;
        case "ItemName":
          if (searchTerm.orderDir == "ASC") {
            itemList.sort(
              (a, b) => a.itemName.compareTo(b.itemName),
            );
          } else {
            itemList.sort(
              (a, b) => b.itemName.compareTo(a.itemName),
            );
          }
          break;
        case "ReqQuantity":
          if (searchTerm.orderDir == "ASC") {
            itemList.sort(
              (a, b) => a.qty.compareTo(b.qty),
            );
          } else {
            itemList.sort(
              (a, b) => b.qty.compareTo(a.qty),
            );
          }
          break;
        case "ActualPrice":
          if (searchTerm.orderDir == "ASC") {
            itemList.sort(
              (a, b) => a.actualPrice.compareTo(b.actualPrice),
            );
          } else {
            itemList.sort(
              (a, b) => b.actualPrice.compareTo(a.actualPrice),
            );
          }
          break;
        case "ActualQuantity":
          if (searchTerm.orderDir == "ASC") {
            itemList.sort(
              (a, b) => a.actualQty.compareTo(b.actualQty),
            );
          } else {
            itemList.sort(
              (a, b) => b.actualQty.compareTo(a.actualQty),
            );
          }
          break;
        default:
      }

      searchTerm.orderBy = orderBy;
      // updateTable().then((value) {});
    });
  }

  @override
  void initState() {
    super.initState();
    initDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 1150,
          maxWidth: 1150,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 45,
              vertical: 40,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  titleSection(),
                  const SizedBox(
                    height: 40,
                  ),
                  orderSummarySection(),
                  const SizedBox(
                    height: 40,
                  ),
                  headerTable(),
                  itemList.isEmpty
                      ? EmptyTable(
                          text: 'No item chosen by user',
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: itemList.length,
                          itemBuilder: (context, index) =>
                              DialogConfirmItemListContainerSettlementRequest(
                            index: index,
                            item: itemList[index],
                          ),
                        ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 23),
                    child: Divider(
                      color: spanishGray,
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Comment",
                              style: helveticaText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: eerieBlack,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            BlackInputField(
                              controller: _comment,
                              enabled: true,
                              maxLines: 4,
                              hintText: "Comment here ...",
                              onSaved: (newValue) {
                                comment = newValue.toString();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: AttachmentFiles(
                          files: attachment,
                          activity: widget.transaction.activity,
                          // transaction: widget.transaction,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TransparentButtonBlack(
                        text: 'Cancel',
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
                        text: 'Confirm',
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          formKey.currentState!.save();
                          widget.transaction.activity
                              .add(TransactionActivity());
                          widget.transaction.activity.first.comment = comment;

                          for (var element in attachment) {
                            widget.transaction.activity.first.submitAttachment
                                .add('"${element.file}"');
                          }

                          print(widget.transaction);
                          apiService
                              .submitSettlementRequest(widget.transaction)
                              .then((value) {
                            if (value["Status"].toString() == "200") {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialogBlack(
                                  title: value['Title'],
                                  contentText: value['Message'],
                                  isSuccess: true,
                                ),
                              ).then((value) {
                                Navigator.of(context).pop(true);
                              });
                            } else if (value["Status"].toString() == "401") {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialogBlack(
                                  title: value['Title'],
                                  contentText: value['Message'],
                                  isSuccess: false,
                                ),
                              );
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
                                title: "Error submitSuppliesRequest",
                                contentText: error.toString(),
                                isSuccess: false,
                              ),
                            );
                          });
                        },
                      )
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

  Widget titleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Request Confirmation',
          style: dialogTitleText,
        ),
        Text(
          '${widget.transaction.month} - ${widget.transaction.formId}',
          style: dialogFormNumberText,
        )
      ],
    );
  }

  Widget orderSummarySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Site',
                style: dialogSummaryTitleText,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.transaction.siteName,
                style: dialogSummaryContentText,
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  text: 'Area: ',
                  style: dialogSummaryContentLightText,
                  children: [
                    TextSpan(
                      text: "${widget.transaction.siteArea} m2",
                      style: dialogSummaryContentText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        TotalInfo(
          title: 'Total Budget',
          number: totalBudget,
          titleColor: orangeAccent,
        ),
        TotalInfo(
          title: 'Total Requested Cost',
          number: totalCost,
          titleColor: orangeAccent,
        ),
        TotalInfo(
          title: 'Total Actual Cost',
          number: totalActualCost,
          titleColor: orangeAccent,
          numberColor: totalActualCost > totalCost ? orangeAccent : greenAcent,
          icon: totalActualCost > totalCost
              ? const Icon(
                  Icons.arrow_drop_up_sharp,
                  color: orangeAccent,
                )
              : const Icon(
                  Icons.arrow_drop_down_sharp,
                  color: greenAcent,
                ),
        ),
      ],
    );
  }

  Widget headerTable() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  onTapHeader("ItemName");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ItemName',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("ItemName"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 135,
              child: InkWell(
                onTap: () {
                  onTapHeader("ReqQuantity");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Req. Qty',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("ReqQuantity"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("ReqPrice");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Req. Price',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("ReqPrice"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: InkWell(
                onTap: () {
                  onTapHeader("ActualQuantity");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Actual Qty',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("ActualQuantity"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("ActualPrice");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Actual Price',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("ActualPrice"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        const Divider(
          color: spanishGray,
          thickness: 1,
        ),
      ],
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

class DialogConfirmItemListContainerSettlementRequest extends StatelessWidget {
  DialogConfirmItemListContainerSettlementRequest({
    super.key,
    Item? item,
    this.index = 0,
  }) : item = item ?? Item();

  Item item;
  int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        index == 0
            ? const SizedBox(
                height: 18,
              )
            : const DividerTable(),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                item.itemName,
                style: bodyTableNormalText,
              ),
            ),
            SizedBox(
              width: 135,
              child: Text(
                item.qty.toString(),
                style: bodyTableLightText,
              ),
            ),
            Expanded(
              child: Text(
                formatCurrency.format(item.basePrice),
                style: bodyTableNormalText,
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                item.actualQty.toString(),
                style: bodyTableLightText,
              ),
            ),
            Expanded(
              child: Text(
                formatCurrency.format(item.actualPrice),
                style: bodyTableLightText,
              ),
            ),
          ],
        )
      ],
    );
  }
}
