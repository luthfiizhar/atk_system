import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/supplies_request_class.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/modules/supplies_request/confirm_dialog_supplies_req.dart';
import 'package:atk_system_ga/modules/supplies_request/supplies_item_list_container.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:atk_system_ga/widgets/total.dart';
import 'package:atk_system_ga/widgets/transaction_activity_section.dart';
import 'package:atk_system_ga/widgets/transaction_info_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  SearchTerm searchTerm = SearchTerm();
  Transaction transaction = Transaction();

  GlobalKey totalCostKey = GlobalKey();

  List<Item> items = [];

  bool isLoadingGetDetail = true;

  bool isLoadingItems = true;

  List<TransactionActivity> transactionActivity = [];

  int totalBudget = 0;
  int totalCost = 0;

  initFormDetail() {
    apiService.getFormDetail(widget.formId).then((value) {
      // print(value);

      setState(() {
        isLoadingGetDetail = false;
        isLoadingItems = false;
      });
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

        for (var element in resultItems) {
          items.add(
            Item(
              itemId: element['ItemID'].toString(),
              itemName: element['ItemName'],
              basePrice: element['Price'],
              qty: element['Quantity'],
              totalPrice: element['TotalPrice'],
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
        setState(() {});
      } else {
        print("not success");
      }
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  countTotal() {
    totalCost = 0;
    for (var element in items) {
      totalCost = totalCost + element.totalPrice;
    }
    totalCostKey.currentState!.setState(() {});
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

  @override
  void initState() {
    super.initState();
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
                  height: 55,
                ),
                headerTable(),
                const SizedBox(
                  height: 20,
                ),
                isLoadingItems
                    ? const CircularProgressIndicator(
                        color: eerieBlack,
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return SuppliesItemListContainer(
                            index: index,
                            item: items[index],
                            countTotal: countTotal,
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
                      onTap: () async {
                        await calculateItems();
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmDialogSuppliesRequest(
                            transaction: transaction,
                          ),
                        );
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
                title: "Order Supplies",
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
                  onTapHeader("BasePrice");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Base Price',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("BasePrice"),
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
                  onTapHeader("Qty");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'QTY',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Qty"),
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
