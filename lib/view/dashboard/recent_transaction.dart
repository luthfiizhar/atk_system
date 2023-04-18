import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/view_model/main_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactionWidget extends StatefulWidget {
  const RecentTransactionWidget({super.key});

  @override
  State<RecentTransactionWidget> createState() =>
      _RecentTransactionWidgetState();
}

class _RecentTransactionWidgetState extends State<RecentTransactionWidget> {
  SearchTerm searchTerm = SearchTerm();
  RecentTransactionViewModel recentTransactionViewModel =
      RecentTransactionViewModel();

  List<RecentTransactionTable> recTransList = [
    RecentTransactionTable(
      siteName: "ST INFORMA PURI MALL JKT",
      type: "Additional Settlement",
      cost: 30000000,
      date: "24 Sep 2023",
      time: "12:07",
    ),
    RecentTransactionTable(
      siteName: "ST INFORMA PURI MALL JKT",
      type: "Additional Settlement",
      cost: 30000000,
      date: "24 Sep 2023",
      time: "12:07",
    ),
    RecentTransactionTable(
      siteName: "ST INFORMA PURI MALL JKT",
      type: "Additional Settlement",
      cost: 30000000,
      date: "24 Sep 2023",
      time: "12:07",
    ),
  ];

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

      // switch (orderBy) {
      //   case "Price":
      //     if (searchTerm.orderDir == "ASC") {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => a.item.basePrice.compareTo(b.item.basePrice),
      //       );
      //     } else {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => b.item.basePrice.compareTo(a.item.basePrice),
      //       );
      //     }
      //     break;
      //   case "ItemName":
      //     if (searchTerm.orderDir == "ASC") {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => a.item.itemName.compareTo(b.item.itemName),
      //       );
      //     } else {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => b.item.itemName.compareTo(a.item.itemName),
      //       );
      //     }
      //     break;
      //   case "Quantity":
      //     if (searchTerm.orderDir == "ASC") {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => a.item.qty.compareTo(b.item.qty),
      //       );
      //     } else {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => b.item.qty.compareTo(a.item.qty),
      //       );
      //     }
      //     break;
      //   case "TotalPrice":
      //     if (searchTerm.orderDir == "ASC") {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => a.item.totalPrice.compareTo(b.item.totalPrice),
      //       );
      //     } else {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => b.item.totalPrice.compareTo(a.item.totalPrice),
      //       );
      //     }
      //     break;
      //   case "Unit":
      //     if (searchTerm.orderDir == "ASC") {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => a.item.unit.compareTo(b.item.unit),
      //       );
      //     } else {
      //       requestViewModel.filterItemsContainer.sort(
      //         (a, b) => b.item.unit.compareTo(a.item.unit),
      //       );
      //     }
      //     break;
      //   default:
      // }
      searchTerm.orderBy = orderBy;
      // updateTable().then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recentTransactionViewModel,
      child: Consumer<RecentTransactionViewModel>(
          builder: (context, model, child) {
        return Container(
          constraints: const BoxConstraints(
            maxWidth: double.infinity,
            minWidth: double.infinity,
          ),
          decoration: cardDecoration,
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transaction',
                    style: helveticaText.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              headerTable(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recTransList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      index == 0
                          ? const SizedBox()
                          : const Divider(
                              thickness: 0.5,
                              color: grayx11,
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: RecentTransactionItems(
                          recents: recTransList[index],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }),
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
                  onTapHeader("SiteName");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Site Name',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("SiteName"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 250,
              child: InkWell(
                onTap: () {
                  onTapHeader("Type");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Type',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Type"),
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
                  onTapHeader("Cost");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cost',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Cost"),
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
                  onTapHeader("DateTime");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'DateTime',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("DateTime"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20,
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

class RecentTransactionItems extends StatelessWidget {
  RecentTransactionItems({super.key, RecentTransactionTable? recents})
      : recents = recents ?? RecentTransactionTable();

  RecentTransactionTable recents;

  TextStyle normal = helveticaText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: davysGray,
  );

  TextStyle light = helveticaText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: davysGray,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text(
              recents.siteName,
              style: normal,
            )),
        SizedBox(
          width: 250,
          child: Text(
            recents.type,
            style: light,
          ),
        ),
        Expanded(
          child: Text(
            formatCurrency.format(recents.cost),
            style: light,
          ),
        ),
        SizedBox(
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recents.date,
                  style: normal,
                ),
                Text(
                  recents.time,
                  style: light.copyWith(
                    color: sonicSilver,
                  ),
                ),
              ],
            )),
        const SizedBox(
          width: 20,
          child: Icon(
            Icons.keyboard_arrow_right_sharp,
          ),
        )
      ],
    );
  }
}
