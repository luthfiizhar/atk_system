import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/modules/settlement_request/settlement_request_item_list_container.dart';
import 'package:atk_system_ga/modules/supplies_request/supplies_item_list_container.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:atk_system_ga/widgets/total.dart';
import 'package:atk_system_ga/widgets/transaction_activity_section.dart';
import 'package:atk_system_ga/widgets/transaction_info_section.dart';
import 'package:flutter/material.dart';

class SettlementRequestPage extends StatefulWidget {
  SettlementRequestPage({super.key});

  @override
  State<SettlementRequestPage> createState() => _SettlementRequestPageState();
}

class _SettlementRequestPageState extends State<SettlementRequestPage> {
  TextEditingController _search = TextEditingController();
  SearchTerm searchTerm = SearchTerm();

  List<TransactionActivity> transactionActivity = [
    TransactionActivity(
        empName: "Luthfi Izhariman",
        status: "Draft Created",
        date: "00:00 - 31 Sept 2023",
        comment:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut accumsan enim est, sit amet tincidunt odio placerat ut. Donec vel sem non sapien congue venenatis in eu elit. Ut metus felis, ullamcorper id purus et, sollicitudin semper dolor.",
        attachment: [
          Attachment(file: "test", type: "image"),
          Attachment(file: "test", type: "pdf")
        ]),
    TransactionActivity(
        empName: "Luthfi Izhariman",
        status: "Draft Created",
        date: "00:00 - 31 Sept 2023",
        comment:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut accumsan enim est, sit amet tincidunt odio placerat ut. Donec vel sem non sapien congue venenatis in eu elit. Ut metus felis, ullamcorper id purus et, sollicitudin semper dolor.",
        attachment: [
          Attachment(file: "test", type: "image"),
          Attachment(file: "test", type: "pdf")
        ])
  ];

  int totalBudget = 800000000000;
  int totalReqCost = 90000000000;
  int totalActualCost = 800000000000;

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
                ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SettlementRequestItemListContainer(
                      index: index,
                      item: Item(
                        itemName: 'REFILL SPIDOL WHITEBOARD WARNA HITAM',
                        // unit: 'EA',
                        // basePrice: 100000,
                        // totalPrice: 100000,
                        reqQty: 200,
                        reqPrice: 800000,
                      ),
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
                        // showDialog(
                        //   context: context,
                        //   builder: (context) => ConfirmDialogSuppliesRequest(),
                        // );
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
        TotalInfo(
          title: 'Total Actual Cost',
          number: totalActualCost,
          numberColor: greenAcent,
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
