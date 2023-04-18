import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/view/supplies_request/approval/approval_supplies_item_container.dart';
import 'package:atk_system_ga/view/supplies_request/approval/approve_dialog_supplies_req.dart';
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
  SearchTerm searchTerm = SearchTerm(
    orderBy: "ItemName",
    orderDir: "ASC",
    keywords: "",
  );
  ApiService apiService = ApiService();

  Transaction transaction = Transaction();
  List<TransactionActivity> transactionActivity = [];

  List<Item> items = [];

  bool isLoadingDetail = true;

  String formCategory = "";

  // bool isLoadingGetDetail = true;

  bool isLoadingItems = true;

  int totalBudget = 0;
  int totalCost = 0;

  Future updateTable() {
    isLoadingItems = true;
    items.clear();
    setState(() {});
    return apiService
        .getFormDetailFilled(widget.formId, searchTerm)
        .then((value) {
      isLoadingItems = false;
      print(value);
      if (value['Status'].toString() == "200") {
        List resultItems = value["Data"]["Items"];
        for (var element in resultItems) {
          items.add(
            Item(
              itemId: element['ItemID'].toString(),
              itemName: element['ItemName'],
              unit: element['Unit'],
              basePrice: element['BasePrice'],
              qty: element['Quantity'],
              totalPrice: element['TotalPrice'],
              estimatedPrice: element['EstimatedPrice'],
            ),
          );
        }
        setState(() {});
      } else {}
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error getDetailFormFilled",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
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
      updateTable().then((value) {});
    });
  }

  Future initDetailFilled() {
    return apiService
        .getFormDetailFilled(widget.formId, searchTerm)
        .then((value) {
      isLoadingDetail = false;
      isLoadingItems = false;
      setState(() {});
      print(value);
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
        totalCost = value['Data']['TotalCost'];

        formCategory = value['Data']['FormCategory'];

        for (var element in resultItems) {
          items.add(
            Item(
              itemId: element['ItemID'].toString(),
              itemName: element['ItemName'],
              unit: element['Unit'],
              basePrice: element['BasePrice'],
              qty: element['Quantity'],
              totalPrice: element['TotalPrice'],
              estimatedPrice: element['EstimatedPrice'],
            ),
          );
        }

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
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error initDetailFilled",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  searchItem() {
    searchTerm.keywords = _search.text;

    updateTable().then((value) {});
  }

  @override
  void initState() {
    super.initState();
    initDetailFilled().onError((error, stackTrace) {
      print(error);
    });
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
            width: 1160,
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
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: eerieBlack,
                              ),
                            ),
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
                            if (value == 1) {
                              context.goNamed('request_order_detail', params: {
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
                            builder: (context) => ApproveDialogSuppliesReq(
                              transaction: transaction,
                            ),
                          ).then((value) {
                            if (value == 1) {
                              // context.goNamed('home');
                              context.goNamed('request_order_detail', params: {
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
          title: "Order Supplies $formCategory Approval",
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
            SizedBox(
              width: 420,
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
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("EstimatedPrice");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Est. Price',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("EstimatedPrice"),
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
        TotalInfo(
          title: 'Total Cost',
          number: totalCost,
          numberColor: totalCost == totalBudget
              ? davysGray
              : totalCost > totalBudget
                  ? orangeAccent
                  : davysGray,
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
