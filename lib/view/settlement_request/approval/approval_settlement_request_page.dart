import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/view/settlement_request/approval/approval_settlement_item_list_container.dart';
import 'package:atk_system_ga/view/settlement_request/approval/dialog_confirm_approval_settlement.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:atk_system_ga/widgets/send_back_dialog.dart';
import 'package:atk_system_ga/widgets/total.dart';
import 'package:atk_system_ga/widgets/transaction_activity_section.dart';
import 'package:atk_system_ga/widgets/transaction_info_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApprovalSettlementRequestPage extends StatefulWidget {
  ApprovalSettlementRequestPage({
    super.key,
    this.formId = "",
  });

  String formId;

  @override
  State<ApprovalSettlementRequestPage> createState() =>
      _ApprovalSettlementRequestPageState();
}

class _ApprovalSettlementRequestPageState
    extends State<ApprovalSettlementRequestPage> {
  TextEditingController _search = TextEditingController();
  SearchTerm searchTerm =
      SearchTerm(keywords: "", orderBy: "ItemName", orderDir: "ASC");

  ApiService apiService = ApiService();
  Transaction transaction = Transaction();

  List<TransactionActivity> transactionActivity = [];
  List<Item> items = [];

  GlobalKey actualCostKey = GlobalKey();

  int totalBudget = 0;
  int totalReqCost = 0;
  int totalActualCost = 0;

  bool isLoadingDetail = true;
  bool isLoadingItem = true;

  onChangeQtyAndPrice(int index, String qtyValue, String priceValue) {
    if (priceValue.contains(".")) {
      transaction.items[index].actualPrice =
          int.parse(priceValue.replaceAll(".", ""));
    }
    transaction.items[index].actualQty = int.parse(qtyValue);

    totalActualCost = 0;
    for (var element in transaction.items) {
      totalActualCost =
          totalActualCost + (element.actualQty * element.actualPrice);
    }
    // setState(() {});
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
      updateList().then((value) {});
    });
  }

  Future updateList() {
    isLoadingItem = true;
    items.clear();
    setState(() {});
    return apiService
        .getSettlementDetail(widget.formId, searchTerm)
        .then((value) {
      isLoadingItem = false;
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
            ),
          );
          transaction.items = items;
          // totalActualCost = totalActualCost +
          //     (int.parse(element['ActualPrice'].toString()) *
          //         int.parse(element['ActualQuantity'].toString()));
        }
      } else {}
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error getSettlementDetail",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
      isLoadingItem = false;
      setState(() {});
    });
  }

  searchItem() {
    searchTerm.keywords = _search.text;

    updateList().then((value) {});
  }

  Future initDetailSettlement() {
    return apiService
        .getSettlementDetail(widget.formId, searchTerm)
        .then((value) {
      isLoadingDetail = false;
      isLoadingItem = false;
      setState(() {});
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
        totalReqCost = value['Data']['TotalCost'];
        // totalActualCost = value['Data']['TotalActualCost'];

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
            ),
          );

          totalActualCost = totalActualCost +
              (int.parse(element['ActualPrice'].toString()) *
                  int.parse(element['ActualQuantity'].toString()));
        }

        // for (var element in resultActivity) {
        //   transactionActivity.add(
        //     TransactionActivity(
        //       empName: element["EmpName"],
        //       comment: element["CommentText"] ?? "",
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
      print(error);
      isLoadingDetail = false;
      isLoadingItem = false;
      setState(() {});
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error getSettlementDetail",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initDetailSettlement();
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
                isLoadingItem
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
                        : ListView.builder(
                            itemCount: transaction.items.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ApprovalSettlementRequestItemListContainer(
                                index: index,
                                item: transaction.items[index],
                              );
                            },
                          ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TransparentButtonBlack(
                      text: 'Send Back',
                      disabled: false,
                      padding: ButtonSize().mediumSize(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => SendBackDialog(
                            transaction: transaction,
                          ),
                        ).then((value) {
                          if (value == 1) {
                            context.goNamed('settlement_detail', params: {
                              "formId": widget.formId,
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RegularButton(
                      text: 'Approve',
                      disabled: false,
                      padding: ButtonSize().mediumSize(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ApproveSettlementDialog(
                            transaction: transaction,
                          ),
                        ).then((value) {
                          if (value == 1) {
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
                ),
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
          title: "Settlement Approval",
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
            onFieldSubmitted: (value) {
              searchItem();
            },
            prefixIcon: const Icon(
              Icons.search,
              color: davysGray,
            ),
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

  Widget totalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                            AssetImage('assets/icons/budget_up.png'),
                            color: orangeAccent,
                          )
                        : const ImageIcon(
                            AssetImage('assets/icons/budget_down.png'),
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
