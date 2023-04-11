import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/modules/admin_settings/item/add_item_dialog.dart';
import 'package:atk_system_ga/modules/settlement_request/request/add_new_items_dialog.dart';
import 'package:atk_system_ga/modules/settlement_request/request/dialog_confirm_settlement_request.dart';
import 'package:atk_system_ga/modules/settlement_request/request/settlement_request_item_list_container.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/divider_table.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:atk_system_ga/widgets/total.dart';
import 'package:atk_system_ga/widgets/transaction_activity_section.dart';
import 'package:atk_system_ga/widgets/transaction_info_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettlementRequestPage extends StatefulWidget {
  SettlementRequestPage({
    super.key,
    this.formId = "",
  });

  String formId;

  @override
  State<SettlementRequestPage> createState() => _SettlementRequestPageState();
}

class _SettlementRequestPageState extends State<SettlementRequestPage> {
  TextEditingController _search = TextEditingController();
  SearchTerm searchTerm = SearchTerm(
    keywords: "",
    orderBy: "ItemName",
    orderDir: "ASC",
  );

  ApiService apiService = ApiService();
  Transaction transaction = Transaction();

  List<TransactionActivity> transactionActivity = [];
  List<Item> items = [];
  List<SettlementRequestItemListContainer> itemsContainer = [];

  GlobalKey actualCostKey = GlobalKey();

  int totalBudget = 0;
  int totalReqCost = 0;
  int totalActualCost = 0;
  int tempTotalActualCost = 0;

  bool isLoadingDetail = true;
  bool isLoadingItems = true;
  bool isSendBack = false;

  assignItemToTable() {
    for (var i = 0; i < items.length; i++) {
      itemsContainer.add(
        SettlementRequestItemListContainer(
          index: i,
          item: items[i],
          onChangedValue: onChangeQtyAndPrice,
          transaction: transaction,
          removeItem: removeItem,
        ),
      );
    }
  }

  Future updateList() {
    isLoadingItems = true;
    items.clear();
    itemsContainer.clear();
    setState(() {});
    return apiService
        .getSettlementDetail(widget.formId, searchTerm)
        .then((value) {
      isLoadingItems = false;
      setState(() {});
      if (value['Status'].toString() == "200") {
        List resultItems = value["Data"]["Items"];

        for (var element in resultItems) {
          items.add(
            Item(
              itemId: element['ItemID'].toString(),
              itemName: element['ItemName'],
              basePrice: element['ItemPrice'],
              qty: element['Quantity'],
              totalPrice: element['TotalPrice'],
              actualPrice: element['ActualPrice'],
              actualQty: element['ActualQuantity'],
              itemInfo: element['ItemInformation'],
            ),
          );
          transaction.items = items;
          setState(() {});

          // totalActualCost = totalActualCost +
          //     (int.parse(element['ActualPrice'].toString()) *
          //         int.parse(element['ActualQuantity'].toString()));
        }

        assignItemToTable();
      } else {}
    }).onError((error, stackTrace) {
      isLoadingItems = false;
      setState(() {});
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error saveItem",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  removeItem(String itemId) {
    // itemsContainer.removeAt(index);
    apiService.deleteAdditionalItemSettle(widget.formId, itemId).then((value) {
      if (value["Status"].toString() == "200") {
        updateList().then((value) {});
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
          title: "Error deleteAdditionalItem",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
    setState(() {});
  }

  onChangeQtyAndPrice(int index, String qtyValue, String priceValue) {
    // if (priceValue.contains(".")) {
    transaction.items[index].actualPrice =
        int.parse(priceValue.replaceAll(".", ""));
    // }
    transaction.items[index].actualQty = int.parse(qtyValue);
    transaction.items[index].actualTotalPrice =
        transaction.items[index].actualQty *
            transaction.items[index].actualPrice;

    totalActualCost = 0;
    for (var element in transaction.items) {
      totalActualCost =
          totalActualCost + (element.actualQty * element.actualPrice);
    }
    // setState(() {});
    // totalActualCost = totalActualCost + tempTotalActualCost;
    transaction.actualTotalCost = totalActualCost;
    actualCostKey.currentState!.setState(() {});
  }

  onTapHeader(String orderBy) {
    setState(() {
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
      searchTerm.orderBy = orderBy;
    });
    updateList().then((value) {});
  }

  searchItem() {
    // searchTerm.keywords = _search.text;
    // updateList().then((value) {});
    setState(() {});
  }

  Future initDetailSettlement() {
    // print(widget.formId);
    return apiService
        .getSettlementDetail(widget.formId, searchTerm)
        .then((value) {
      print(value);
      isLoadingDetail = false;
      isLoadingItems = false;
      setState(() {});
      if (value['Status'].toString() == "200") {
        List resultItems = value["Data"]["Items"] ?? [];
        List resultActivity = value["Data"]["Comments"] ?? [];
        List attachmentResult = [];

        transaction.formId = value["Data"]["FormID"];
        transaction.siteName = value["Data"]["SiteName"];
        transaction.siteArea =
            double.parse(value["Data"]["SiteArea"].toString());
        transaction.budget = value["Data"]["Budget"];
        transaction.orderPeriod = value["Data"]["OrderPeriod"];
        transaction.month = value["Data"]["Month"];
        transaction.status = value["Data"]["Status"];
        totalBudget = value['Data']["Budget"];
        totalReqCost = value['Data']['TotalCost'];
        isSendBack = value["Data"]["Sendback"] > 0 ? true : false;

        for (var element in resultItems) {
          items.add(
            Item(
                itemId: element['ItemID'].toString(),
                itemName: element['ItemName'],
                basePrice: element['ItemPrice'],
                qty: element['Quantity'],
                totalPrice: element['TotalPrice'],
                actualPrice: element['ActualPrice'],
                actualQty: element['ActualQuantity'],
                itemInfo: element['ItemInformation']),
          );

          totalActualCost = totalActualCost +
              (int.parse(element['ActualPrice'].toString()) *
                  int.parse(element['ActualQuantity'].toString()));
        }
        assignItemToTable();
        // for (var i = 0; i < items.length; i++) {
        //   itemsContainer.add(
        //     SettlementRequestItemListContainer(
        //       index: i,
        //       item: items[i],
        //       onChangedValue: onChangeQtyAndPrice,
        //       transaction: transaction,
        //       removeItem: removeItem,
        //     ),
        //   );
        // }

        // for (var element in resultActivity) {
        //   transactionActivity.add(
        //     TransactionActivity(
        //       empName: element["EmpName"],
        //       comment: element["CommentText"] ?? "-",
        //       date: element["CommentDate"],
        //       status: element["CommentDescription"],
        //       photo: element["Photo"],
        //     ),
        //   );
        // }
        if (resultActivity.isNotEmpty) {
          for (var element in resultActivity) {
            transactionActivity.add(
              TransactionActivity(
                id: element['CommentID'],
                empName: element["EmpName"],
                comment: element["CommentText"] ?? "-",
                date: element["CommentDate"],
                status: element["CommentDescription"],
                photo: element["Photo"],
                // attachment: element['Attachments'],
              ),
            );
            if (element['Attachments'] != []) {
              attachmentResult = element['Attachments'];
            }

            for (var t in transactionActivity) {
              for (var element in attachmentResult) {
                if (t.id == element['CommentID']) {
                  t.attachment.add(
                    Attachment(
                      file: element['ImageURL'],
                      type: element['FileType'],
                      fileName: element['FileName'] ?? "",
                    ),
                  );
                }
              }
            }
          }
        }
        transaction.items = items;
        setState(() {});
      } else {
        print("not success");
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error initDetailSettlement",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
      isLoadingDetail = false;
      isLoadingItems = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    initDetailSettlement();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 0,
      child: ConstrainedBox(
        constraints: pageContstraint,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 1100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                isLoadingDetail
                    ? const CircularProgressIndicator(
                        color: eerieBlack,
                      )
                    : infoAndSearch(),
                const SizedBox(
                  height: 30,
                ),
                headerTable(),
                const SizedBox(
                  height: 20,
                ),
                isLoadingItems
                    ? const SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: eerieBlack,
                            ),
                          ),
                        ),
                      )
                    : transaction.items.isEmpty
                        ? EmptyTable(
                            text: 'No item in database',
                          )
                        : Column(
                            children: _search.text == ""
                                ? itemsContainer
                                    .asMap()
                                    .map((index, value) => MapEntry(
                                        index,
                                        Column(
                                          children: [
                                            index == 0
                                                ? const SizedBox()
                                                : const DividerTable(),
                                            value,
                                          ],
                                        )))
                                    .values
                                    .toList()
                                : itemsContainer
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
                                                ? const SizedBox()
                                                : const DividerTable(),
                                            value,
                                          ],
                                        )))
                                    .values
                                    .toList(),
                          ),
                // : ListView.builder(
                //     itemCount: transaction.items.length,
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemBuilder: (context, index) {
                //       return SettlementRequestItemListContainer(
                //         index: index,
                //         item: transaction.items[index],
                //         onChangedValue: onChangeQtyAndPrice,
                //         transaction: transaction,
                //       );
                //     },
                //   ),
                const SizedBox(
                  height: 50,
                ),
                totalSection(),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 38,
                    bottom: 23,
                  ),
                  child: Divider(
                    color: grayx11,
                    thickness: 1,
                  ),
                ),
                TransactionActivitySection(
                  transactionActivity: transactionActivity,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 23,
                    bottom: 28,
                  ),
                  child: Divider(
                    color: grayx11,
                    thickness: 1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TransparentButtonBlack(
                      text: 'Cancel',
                      disabled: false,
                      padding: ButtonSize().mediumSize(),
                      onTap: () {
                        context.goNamed('home');
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RegularButton(
                      text: isSendBack ? 'Submit Revise' : 'Submit Request',
                      disabled: false,
                      padding: ButtonSize().mediumSize(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmDialogSettlementRequest(
                            transaction: transaction,
                            formId: widget.formId,
                          ),
                        ).then((value) {
                          if (value == 1) {
                            // context.goNamed('home');
                            context.goNamed('settlement_detail', params: {
                              "formId": widget.formId,
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoAndSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TransactionInfoSection(
          title: "Create Settlement",
          transaction: transaction,
        ),
        Row(
          children: [
            CustomRegularButton(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddNewItemDialog(
                    formId: widget.formId,
                  ),
                ).then((value) {
                  if (value == 1) {
                    updateList().then((value) {});
                  }
                });
              },
              child: Wrap(
                runAlignment: WrapAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Add Item',
                    style: helveticaText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 220,
              child: SearchInputField(
                controller: _search,
                enabled: true,
                obsecureText: false,
                hintText: 'Search here ...',
                maxLines: 1,
                onFieldSubmitted: (value) {
                  searchItem();
                },
                prefixIcon: const Icon(
                  Icons.search,
                  color: davysGray,
                ),
              ),
            ),
          ],
        )
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
                        'Item Name',
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
                  onTapHeader("Quantity");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Req. Qty',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Quantity"),
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
                  onTapHeader("Price");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Req. Price',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Price"),
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
            SizedBox(
              width: 150,
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
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 40,
            )
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

  Widget totalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TotalInfo(
          title: 'Total Budget',
          number: totalBudget,
        ),
        const SizedBox(
          width: 60,
        ),
        TotalInfo(
          title: 'Total Requested Cost',
          number: totalReqCost,
        ),
        const SizedBox(
          width: 60,
        ),
        StatefulBuilder(
            key: actualCostKey,
            builder: (context, setstate) {
              return TotalInfo(
                title: 'Total Actual Cost',
                number: totalActualCost,
                numberColor: totalActualCost == totalReqCost
                    ? davysGray
                    : totalActualCost > totalReqCost
                        ? orangeAccent
                        : greenAcent,
                icon: totalActualCost == totalReqCost
                    ? const SizedBox()
                    : totalActualCost > totalReqCost
                        ? const ImageIcon(
                            AssetImage('icons/budget_up.png'),
                            color: orangeAccent,
                          )
                        : const ImageIcon(
                            AssetImage('icons/budget_down.png'),
                            color: greenAcent,
                          ),
              );
            }),
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
