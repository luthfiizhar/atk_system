import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/modules/supplies_request/order/confirm_dialog_supplies_req.dart';
import 'package:atk_system_ga/modules/supplies_request/order/supplies_item_list_container.dart';
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

class SuppliesRequestPage extends StatefulWidget {
  SuppliesRequestPage({
    super.key,
    this.formId = "",
  });

  String formId;

  @override
  State<SuppliesRequestPage> createState() => _SuppliesRequestPageState();
}

class _SuppliesRequestPageState extends State<SuppliesRequestPage> {
  ApiService apiService = ApiService();
  TextEditingController _search = TextEditingController();
  SearchTerm searchTerm =
      SearchTerm(keywords: "", orderBy: "ItemName", orderDir: "ASC");
  Transaction transaction = Transaction();

  GlobalKey totalCostKey = GlobalKey();

  List<Item> items = [];
  List<SuppliesItemListContainer> itemsContainer = [];
  List<Item> tempItems = [];

  bool isLoadingGetDetail = true;

  bool isLoadingItems = true;

  String formCategory = "";

  List<TransactionActivity> transactionActivity = [];

  int totalBudget = 0;
  int totalCost = 0;
  int tempTotalCost = 0;

  bool isSendBack = false;

  Future updateTable() {
    isLoadingItems = true;
    items.clear();
    setState(() {});
    return apiService.getFormDetail(widget.formId, searchTerm).then((value) {
      isLoadingItems = false;
      setState(() {});
      if (value['Status'].toString() == "200") {
        List resultItems = value["Data"]["Items"];
        for (var element in resultItems) {
          items.add(
            Item(
              itemId: element['ItemID'].toString(),
              itemName: element['ItemName'],
              basePrice: element['EstimatedPrice'],
              // estimatedPrice: element[''],
              qty: element['Quantity'],
              totalPrice: element['TotalPrice'],
              unit: element['Unit'],
            ),
          );
        }

        for (var temp in tempItems) {
          for (var i in items) {
            if (temp.itemId == i.itemId) {
              i.qty = temp.qty;
            }
          }
        }

        print("Temp -> $tempItems");
        print("Real -> $items");
        setState(() {});
      } else {}
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error getFormDetail",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  // initFormDetailFilled() {
  //   return apiService
  //       .getFormDetailFilled(widget.formId, searchTerm)
  //       .then((value) {
  //     // print(value);

  //     setState(() {
  //       isLoadingGetDetail = false;
  //       isLoadingItems = false;
  //     });
  //     if (value['Status'].toString() == "200") {
  //       List resultItems = value["Data"]["Items"];
  //       List resultActivity = value["Data"]["Comments"];
  //       List attachmentResult = [];

  //       formCategory = value["Data"]["FormCategory"];

  //       transaction.formId = value["Data"]["FormID"];
  //       transaction.siteName = value["Data"]["SiteName"];
  //       transaction.siteArea = value["Data"]["SiteArea"];
  //       transaction.budget = value["Data"]["Budget"];
  //       transaction.orderPeriod = value["Data"]["OrderPeriod"];
  //       transaction.month = value["Data"]["Month"];
  //       transaction.status = value["Data"]["Status"];
  //       totalBudget = value['Data']["Budget"];
  //       // isSendBack = value['Data']['Sendback'] > 0 ? true : false;
  //       totalCost = value['Data']['TotalCost'];

  //       for (var element in resultItems) {
  //         items.add(
  //           Item(
  //             itemId: element['ItemID'].toString(),
  //             itemName: element['ItemName'],
  //             basePrice: element['EstimatedPrice'],
  //             qty: element['Quantity'],
  //             totalPrice: element['TotalPrice'],
  //           ),
  //         );
  //       }

  //       if (resultActivity.isNotEmpty) {
  //         for (var element in resultActivity) {
  //           transactionActivity.add(
  //             TransactionActivity(
  //               id: element['CommentID'],
  //               empName: element["EmpName"],
  //               comment: element["CommentText"] ?? "-",
  //               date: element["CommentDate"],
  //               status: element["CommentDescription"],
  //               photo: element["Photo"],
  //               // attachment: element['Attachments'],
  //             ),
  //           );
  //           if (element['Attachments'] != []) {
  //             attachmentResult = element['Attachments'];
  //           }

  //           for (var t in transactionActivity) {
  //             for (var element in attachmentResult) {
  //               if (t.id == element['CommentID']) {
  //                 t.attachment.add(
  //                   Attachment(
  //                     file: element['ImageURL'],
  //                     type: element['FileType'] ?? "image",
  //                   ),
  //                 );
  //               }
  //             }
  //           }
  //         }
  //       }

  //       setState(() {});
  //     } else {
  //       print("not success");
  //     }
  //   }).onError((error, stackTrace) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => const AlertDialogBlack(
  //         title: "Error getFormDetailFilled",
  //         contentText: "No internet connection",
  //         isSuccess: false,
  //       ),
  //     );
  //   });
  // }

  Future initFormDetail() {
    return apiService.getFormDetail(widget.formId, searchTerm).then((value) {
      print(value);

      setState(() {
        isLoadingGetDetail = false;
        isLoadingItems = false;
      });
      if (value['Status'].toString() == "200") {
        List resultItems = value["Data"]["Items"];
        List resultActivity = value["Data"]["Comments"];
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
        isSendBack = value['Data']['Sendback'] > 0 ? true : false;
        totalCost = value['Data']['TotalCost'];

        formCategory = value['Data']['FormCategory'];

        for (var element in resultItems) {
          items.add(
            Item(
              itemId: element['ItemID'].toString(),
              itemName: element['ItemName'],
              basePrice: element['EstimatedPrice'],
              qty: element['Quantity'],
              totalPrice: element['TotalPrice'],
              unit: element['Unit'],
            ),
          );
          tempTotalCost = tempTotalCost +
              (int.parse(element['Quantity'].toString()) *
                  int.parse(element['EstimatedPrice'].toString()));
        }

        for (var i = 0; i < items.length; i++) {
          itemsContainer.add(SuppliesItemListContainer(
            index: i,
            item: items[i],
            countTotal: countTotal,
            saveItem: saveItem,
          ));
        }
        totalCost = tempTotalCost;

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
                      type: element['FileType'] ?? "image",
                    ),
                  );
                }
              }
            }
          }
        }
        setState(() {});
      } else {
        print("not success");
      }
    }).onError((error, stackTrace) {
      print(error);
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error getFormDetail",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  countTotal() {
    tempTotalCost = 0;

    for (var element in items) {
      tempTotalCost = tempTotalCost + element.totalPrice;
    }
    totalCost = tempTotalCost;
    totalCostKey.currentState!.setState(() {});
    transaction.totalCost = totalCost;

    // setState(() {});
  }

  calculateItems() {
    transaction.items.clear();
    items.where((element) => element.qty > 0).forEach((element) {
      transaction.items.add(element);
    });
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
      searchTerm.orderBy = orderBy;
      updateTable().then((value) {});
    });
  }

  saveItem(Item item) {
    apiService.saveItemReq(transaction, item).then((value) {
      if (value['Status'].toString() != "200") {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: "Error saveItem",
            contentText: value['Message'],
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: "Error saveItem",
          contentText: error.toString(),
        ),
      );
    });
    totalCost = 0;
    for (var element in items) {
      totalCost = totalCost + (element.basePrice * element.qty);
    }
  }

  searchItem() {
    // searchTerm.keywords = _search.text;
    setState(() {});
    // updateTable().then((value) {});
  }

  @override
  void initState() {
    super.initState();
    // initFormDetail().then((value) {
    //   if (isSendBack) {
    //     initFormDetailFilled();
    //   }
    // });
    initFormDetail();
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
                infoAndSearch(),
                const SizedBox(
                  height: 30,
                ),
                headerTable(),
                const SizedBox(
                  height: 20,
                ),
                isLoadingItems
                    ? const CircularProgressIndicator(
                        color: eerieBlack,
                      )
                    : transaction.status != "Draft"
                        ? EmptyTable(
                            text:
                                "This order already submitted. Please check detail page.",
                          )
                        : items.isEmpty
                            ? EmptyTable(
                                text: 'No item in database',
                              )
                            : Column(
                                // shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                children: _search.text == ""
                                    ? itemsContainer
                                        .asMap()
                                        .map((index, e) => MapEntry(
                                            index,
                                            Column(
                                              children: [
                                                index == 0
                                                    ? const SizedBox()
                                                    : const DividerTable(),
                                                e,
                                              ],
                                            )))
                                        .values
                                        .toList()
                                    : itemsContainer
                                        .where((element) => element
                                            .item.itemName
                                            .toLowerCase()
                                            .contains(
                                                _search.text.toLowerCase()))
                                        .toList()
                                        .asMap()
                                        .map((index, e) => MapEntry(
                                            index,
                                            Column(
                                              children: [
                                                index == 0
                                                    ? const SizedBox()
                                                    : const DividerTable(),
                                                e,
                                              ],
                                            )))
                                        .values
                                        .toList(),
                              ),
                // ListView.builder(
                //     itemCount: items.length,
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemBuilder: (context, index) {
                //       return SuppliesItemListContainer(
                //         index: index,
                //         item: items[index],
                //         countTotal: countTotal,
                //         saveItem: saveItem,
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
                transaction.status != "Draft"
                    ? const SizedBox()
                    : Row(
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
                            text:
                                isSendBack ? 'Submit Revise' : 'Submit Request',
                            disabled: false,
                            padding: ButtonSize().mediumSize(),
                            onTap: () async {
                              await calculateItems();
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ConfirmDialogSuppliesRequest(
                                  transaction: transaction,
                                  formId: widget.formId,
                                ),
                              ).then((value) {
                                if (value == 1) {
                                  context.replaceNamed('request_order_detail',
                                      params: {
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
        isLoadingGetDetail
            ? const CircularProgressIndicator(
                color: eerieBlack,
              )
            : TransactionInfoSection(
                title: "Order Supplies $formCategory",
                transaction: transaction,
              ),
        SizedBox(
          width: 220,
          child: SearchInputField(
            controller: _search,
            enabled: true,
            obsecureText: false,
            hintText: 'Search here ...',
            maxLines: 1,
            prefixIcon: const Icon(
              Icons.search,
              color: davysGray,
            ),
            onFieldSubmitted: (value) {
              searchItem();
            },
          ),
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
              width: 100,
              child: InkWell(
                onTap: () {
                  onTapHeader("Unit");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Unit',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Unit"),
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
                        'Base Price',
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
              width: 125,
              child: InkWell(
                onTap: () {
                  onTapHeader("Quantity");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Qty',
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
                  onTapHeader("TotalPrice");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Price',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("TotalPrice"),
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
        StatefulBuilder(
            key: totalCostKey,
            builder: (context, setState) {
              return TotalInfo(
                title: 'Total Cost',
                number: totalCost,
                numberColor: totalCost > totalBudget ? orangeAccent : davysGray,
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
