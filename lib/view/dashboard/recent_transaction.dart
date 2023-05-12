import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/export_dialog.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/recent_transaction_popup.dart';
import 'package:atk_system_ga/view/dashboard/show_more_icon.dart';
import 'package:atk_system_ga/view/dashboard/widget_icon.dart';
import 'package:atk_system_ga/view_model/dashboard_view_model.dart/recent_transaction_view_model.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

class RecentTransactionWidget extends StatefulWidget {
  const RecentTransactionWidget({super.key});

  @override
  State<RecentTransactionWidget> createState() =>
      _RecentTransactionWidgetState();
}

class _RecentTransactionWidgetState extends State<RecentTransactionWidget> {
  SearchTerm searchTerm = SearchTerm(orderBy: "SiteName", orderDir: "ASC");
  RecentTransactionViewModel recentTransactionViewModel =
      RecentTransactionViewModel();
  late GlobalModel globalModel;

  GlobalKey iconKey = GlobalKey();

  onTapHeader(String orderBy, RecentTransactionViewModel model) {
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
      switch (orderBy) {
        case "SiteName":
          if (searchTerm.orderDir == "ASC") {
            model.listRecTransaction.sort(
              (a, b) => a.siteName.compareTo(b.siteName),
            );
          } else {
            model.listRecTransaction.sort(
              (a, b) => b.siteName.compareTo(a.siteName),
            );
          }
          break;
        case "Type":
          if (searchTerm.orderDir == "ASC") {
            model.listRecTransaction.sort(
              (a, b) => a.type.compareTo(b.type),
            );
          } else {
            model.listRecTransaction.sort(
              (a, b) => b.type.compareTo(a.type),
            );
          }
          break;
        case "Cost":
          if (searchTerm.orderDir == "ASC") {
            model.listRecTransaction.sort(
              (a, b) => a.cost.compareTo(b.cost),
            );
          } else {
            model.listRecTransaction.sort(
              (a, b) => b.cost.compareTo(a.cost),
            );
          }
          break;
        case "DateTime":
          if (searchTerm.orderDir == "ASC") {
            model.listRecTransaction.sort(
              (a, b) => a.date.compareTo(b.date),
            );
          } else {
            model.listRecTransaction.sort(
              (a, b) => b.date.compareTo(a.date),
            );
          }
          break;
        default:
      }
      searchTerm.orderBy = orderBy;
      // updateTable().then((value) {});
    });
  }

  showMoreDialog() {
    showDialog(
      context: context,
      builder: (context) => RecentTransactionPopUp(),
    );
  }

  export() {
    showDialog(
      context: context,
      builder: (context) => ExportDashboardPopup(
        dataType: "Recent Transaction",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    recentTransactionViewModel.getRecentTransaction(globalModel);
    globalModel.addListener(() {
      recentTransactionViewModel.closeListener();
      recentTransactionViewModel.getRecentTransaction(globalModel);
    });
  }

  @override
  void dispose() {
    super.dispose();
    globalModel.removeListener(() {});
    recentTransactionViewModel.closeListener();
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
                  Wrap(
                    spacing: 10,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TitleIcon(
                        icon: "assets/icons/recent_transaction_icon.png",
                      ),
                      Text(
                        "Recent Transaction",
                        style: cardTitle,
                      ),
                    ],
                  ),
                  // Text(
                  //   'Recent Transaction',
                  //   style: helveticaText.copyWith(
                  //     fontSize: 22,
                  //     fontWeight: FontWeight.w700,
                  //     color: eerieBlack,
                  //   ),
                  // ),
                  ShowMoreIcon(
                    exportCallback: export,
                    showMoreCallback: showMoreDialog,
                  ),
                  // InkWell(
                  //     onTap: () {
                  //       RenderBox? renderBox = iconKey.currentContext!
                  //           .findRenderObject() as RenderBox?;
                  //       var size = renderBox!.size;
                  //       var offset = renderBox.localToGlobal(Offset.zero);
                  //       showMenu(
                  //           context: context,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           position: RelativeRect.fromLTRB(
                  //               offset.dx, offset.dy + 30, offset.dx, 0),
                  //           items: [
                  //             PopupMenuItem(
                  //               onTap: () {
                  //                 Future.delayed(
                  //                   const Duration(seconds: 0),
                  //                   () => showDialog(
                  //                     context: context,
                  //                     builder: (context) =>
                  //                         RecentTransactionPopUp(),
                  //                   ),
                  //                 );
                  //               },
                  //               child: Text(
                  //                 'Show More',
                  //                 style: helveticaText.copyWith(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w300,
                  //                   color: davysGray,
                  //                 ),
                  //               ),
                  //             ),
                  //             PopupMenuItem(
                  //               onTap: () {},
                  //               child: Text(
                  //                 'Export',
                  //                 style: helveticaText.copyWith(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w300,
                  //                   color: davysGray,
                  //                 ),
                  //               ),
                  //             ),
                  //           ]);
                  //     },
                  //     child: Icon(key: iconKey, Icons.more_vert_sharp)),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              headerTable(model),
              model.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: eerieBlack,
                      ),
                    )
                  : model.listRecTransaction.isEmpty
                      ? EmptyTable(
                          text: "There is no transaction available right now",
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: model.listRecTransaction.length,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: RecentTransactionItems(
                                    recents: model.listRecTransaction[index],
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

  Widget headerTable(RecentTransactionViewModel model) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  onTapHeader("SiteName", model);
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
                  onTapHeader("Type", model);
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
            SizedBox(
              width: 190,
              child: InkWell(
                onTap: () {
                  onTapHeader("Cost", model);
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
              width: 175,
              child: InkWell(
                onTap: () {
                  onTapHeader("Date", model);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date Time',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Date"),
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
          height: 8,
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
    return InkWell(
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        final host = html.window.location.host;
        final path = html.window.location.pathname;
        html.WindowBase popUpWindow;
        if (recents.type == "Monthly Supply Request" ||
            recents.type == "Monthly Additional Request") {
          popUpWindow = html.window.open(
              'http://$host$path#/transaction_list/request_detail/${recents.formId}',
              '');
        } else {
          popUpWindow = html.window.open(
            'http://$host$path#/transaction_list/settlement_detail/${recents.formId}',
            '',
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              recents.siteName,
              style: normal,
            ),
          ),
          SizedBox(
            width: 250,
            child: Text(
              recents.type,
              style: light,
            ),
          ),
          SizedBox(
            width: 190,
            child: Text(
              formatCurrency.format(recents.cost),
              style: light,
            ),
          ),
          SizedBox(
              width: 175,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recents.date,
                    style: normal,
                  ),
                  const SizedBox(
                    height: 7,
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
      ),
    );
  }
}
