import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/modules/supplies_request/approval_supplies_item_container.dart';
import 'package:atk_system_ga/modules/transaction_list/transaction_list_container.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:atk_system_ga/widgets/transaction_activity_list.dart';
import 'package:flutter/material.dart';

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

  int totalBudget = 800000000000;
  int totalCost = 8000000000;

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
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
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
                      return ApprovalSuppliesItemListContainer(
                        index: index,
                        item: Item(
                          itemName: 'REFILL SPIDOL WHITEBOARD WARNA HITAM',
                          unit: 'EA',
                          basePrice: 100000,
                          totalPrice: 100000,
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
                  commentSection(),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Order Supplies Approval - October - H001REGM102201',
              style: helveticaText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                text: 'Site: ',
                style: infoTextLight,
                children: [
                  TextSpan(
                    text: 'H001 - Chatime HO',
                    style: infoTextBold,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            RichText(
              text: TextSpan(
                text: 'Site Area: ',
                style: infoTextLight,
                children: [
                  TextSpan(
                    text: '500.000 m2',
                    style: infoTextBold,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            RichText(
              text: TextSpan(
                text: 'Status: ',
                style: infoTextLight,
                children: [
                  TextSpan(
                    text: 'Create New',
                    style: infoTextBold,
                  ),
                ],
              ),
            ),
          ],
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Budget',
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              formatCurrency.format(totalBudget),
              style: helveticaText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: davysGray,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 60,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Cost',
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              formatCurrency.format(totalCost),
              style: helveticaText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: orangeAccent,
              ),
            ),
          ],
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
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return TransactionActivityListContainer(
              index: index,
              transactionActivity: TransactionActivity(
                empName: "Luthfi Izhariman",
                status: "Draft Created",
                date: "00:00 - 31 Sept 2023",
                comment:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut accumsan enim est, sit amet tincidunt odio placerat ut. Donec vel sem non sapien congue venenatis in eu elit. Ut metus felis, ullamcorper id purus et, sollicitudin semper dolor.",
              ),
            );
          },
        ),
      ],
    );
  }
}
