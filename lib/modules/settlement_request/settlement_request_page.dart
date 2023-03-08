import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/modules/settlement_request/dialog_confirm_settlement_request.dart';
import 'package:atk_system_ga/modules/settlement_request/settlement_request_item_list_container.dart';
import 'package:atk_system_ga/modules/supplies_request/supplies_item_list_container.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
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
  SearchTerm searchTerm = SearchTerm();

  ApiService apiService = ApiService();
  Transaction transaction = Transaction();

  List<TransactionActivity> transactionActivity = [];
  List<Item> items = [];

  GlobalKey actualCostKey = GlobalKey();

  int totalBudget = 0;
  int totalReqCost = 0;
  int totalActualCost = 0;

  bool isLoadingDetail = true;

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
  }

  Future initDetailSettlement() {
    return apiService.getSettlementDetail(widget.formId).then((value) {
      isLoadingDetail = false;
      setState(() {});
      if (value['Status'].toString() == "200") {
        List resultItems = value["Data"]["Items"];
        List resultActivity = value["Data"]["Comments"];

        transaction.formId = value["Data"]["FormID"];
        transaction.siteName = value["Data"]["SiteName"];
        transaction.siteArea = value["Data"]["SiteArea"];
        transaction.budget = value["Data"]["Budget"];
        transaction.orderPeriod = value["Data"]["OrderPeriod"];
        transaction.month = value["Data"]["Month"];
        transaction.status = value["Data"]["Status"];
        totalBudget = value['Data']["Budget"];
        totalReqCost = value['Data']['TotalCost'];

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
        }

        for (var element in resultActivity) {
          transactionActivity.add(
            TransactionActivity(
              empName: element["EmpName"],
              comment: element["CommentText"],
              date: element["CommentDate"],
              status: element["CommentDescription"],
              photo: element["Photo"],
            ),
          );
        }
        transaction.items = items;
        setState(() {});
      } else {
        print("not success");
      }
    }).onError((error, stackTrace) {
      print(error);
      isLoadingDetail = false;
      setState(() {});
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
                  height: 55,
                ),
                headerTable(),
                const SizedBox(
                  height: 20,
                ),
                isLoadingDetail
                    ? const SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: CircularProgressIndicator(
                          color: eerieBlack,
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
                              return SettlementRequestItemListContainer(
                                index: index,
                                item: transaction.items[index],
                                onChangedValue: onChangeQtyAndPrice,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TransparentButtonBlack(
                      text: 'Cancel',
                      disabled: false,
                      padding: ButtonSize().mediumSize(),
                      onTap: () {},
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RegularButton(
                      text: 'Submit Request',
                      disabled: false,
                      padding: ButtonSize().mediumSize(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmDialogSettlementRequest(
                            transaction: transaction,
                          ),
                        ).then((value) {
                          if (value) {
                            context.goNamed('home');
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
          title: "Order Settlement",
          transaction: transaction,
        ),
        SizedBox(
          width: 220,
          child: SearchInputField(
            controller: _search,
            enabled: true,
            obsecureText: false,
            hintText: 'Search here ...',
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
                  onTapHeader("reqQty");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Req. Qty',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Req. Qty"),
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
                  onTapHeader("reqPrice");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Req. Price',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("reqPrice"),
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
                  onTapHeader("actualQty");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Actual Qty',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("actualQty"),
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
                numberColor:
                    totalActualCost > totalReqCost ? orangeAccent : greenAcent,
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
