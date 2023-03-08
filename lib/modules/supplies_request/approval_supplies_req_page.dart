import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/modules/supplies_request/approval_supplies_item_container.dart';
import 'package:atk_system_ga/modules/supplies_request/approve_dialog_supplies_req.dart';
import 'package:atk_system_ga/modules/supplies_request/confirm_dialog_supplies_req.dart';
import 'package:atk_system_ga/modules/transaction_list/transaction_list_container.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:atk_system_ga/widgets/send_back_dialog.dart';
import 'package:atk_system_ga/widgets/total.dart';
import 'package:atk_system_ga/widgets/transaction_activity_list.dart';
import 'package:atk_system_ga/widgets/transaction_activity_section.dart';
import 'package:atk_system_ga/widgets/transaction_info_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApprovalSuppliesReqPage extends StatefulWidget {
  ApprovalSuppliesReqPage({
    super.key,
    this.formId = "",
  });

  String formId;

  @override
  State<ApprovalSuppliesReqPage> createState() =>
      _ApprovalSuppliesReqPageState();
}

class _ApprovalSuppliesReqPageState extends State<ApprovalSuppliesReqPage> {
  TextEditingController _search = TextEditingController();
  SearchTerm searchTerm = SearchTerm();
  ApiService apiService = ApiService();

  Transaction transaction = Transaction();
  List<TransactionActivity> transactionActivity = [];

  List<Item> items = [];

  bool isLoadingDetail = true;

  // bool isLoadingGetDetail = true;

  bool isLoadingItems = true;

  int totalBudget = 0;
  int totalCost = 0;

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

  Future initDetailFilled() {
    return apiService.getFormDetailFilled(widget.formId).then((value) {
      isLoadingDetail = false;
      setState(() {});
      print(value);
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
        totalCost = value['Data']['TotalCost'];

        for (var element in resultItems) {
          items.add(
            Item(
              itemId: element['ItemID'].toString(),
              itemName: element['ItemName'],
              unit: element['Unit'],
              basePrice: element['BasePrice'],
              qty: element['Quantity'],
              totalPrice: element['TotalPrice'],
            ),
          );
        }

        for (var element in resultActivity) {
          transactionActivity.add(
            TransactionActivity(
              empName: element["EmpName"],
              comment: element["CommentText"] ?? "-",
              date: element["CommentDate"],
              status: element["CommentDescription"],
              photo: element["Photo"],
            ),
          );
        }
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initDetailFilled();
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
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
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
                      : items.isEmpty
                          ? EmptyTable(
                              text: 'No item in database',
                            )
                          : ListView.builder(
                              itemCount: items.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ApprovalSuppliesItemListContainer(
                                  index: index,
                                  item: items[index],
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
                      bottom: 18,
                    ),
                    child: Divider(
                      color: grayx11,
                      thickness: 1,
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     TransparentButtonBlack(
                  //       text: 'Cancel',
                  //       disabled: false,
                  //       padding: ButtonSize().mediumSize(),
                  //       onTap: () {},
                  //     ),
                  //     const SizedBox(
                  //       width: 20,
                  //     ),
                  //     RegularButton(
                  //       text: 'Submit Request',
                  //       disabled: false,
                  //       padding: ButtonSize().mediumSize(),
                  //       onTap: () {
                  //         showDialog(
                  //           context: context,
                  //           builder: (context) => ConfirmDialogSuppliesRequest(),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // commentSection(),
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
                            if (value) {
                              context.goNamed('home');
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
                            builder: (context) => ApproveDialogSuppliesReq(
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
                  ),
                ]),
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
          title: "Order Supplies Approval",
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
                        'Qty',
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
        TotalInfo(
          title: 'Total Cost',
          number: totalCost,
          numberColor: totalCost > totalBudget ? orangeAccent : greenAcent,
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

  Widget commentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Transaction Activity',
          style: helveticaText.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          itemCount: transactionActivity.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return TransactionActivityListContainer(
              index: index,
              transactionActivity: transactionActivity[index],
            );
          },
        ),
      ],
    );
  }
}
