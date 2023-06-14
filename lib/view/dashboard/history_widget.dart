import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/export_dialog.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/history_popup.dart';
import 'package:atk_system_ga/view/dashboard/show_more_icon.dart';
import 'package:atk_system_ga/view/dashboard/widget_icon.dart';
import 'package:atk_system_ga/view_model/dashboard_view_model.dart/history_view_model.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:flutter/material.dart';
import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:provider/provider.dart';
import "dart:html" as html;

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  SearchTerm searchTerm = SearchTerm(
    orderBy: "UpdatedBy",
    orderDir: "DESC",
  );
  late GlobalModel globalModel;
  HistoryViewModel historyViewModel = HistoryViewModel();
  FocusNode optionsNode = FocusNode();
  List sortOptions = [
    {"value": 1, "title": "Budget History"},
  ];

  int selectedSort = 1;

  export() {
    showDialog(
      context: context,
      builder: (context) => ExportDashboardPopup(
        dataType: "History - Budget",
      ),
    );
  }

  showMore() {
    showDialog(
      context: context,
      builder: (context) => HistoryPopupDialog(),
    );
  }

  onTapHeader(String orderBy, HistoryViewModel model) {
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
            model.listHistory.sort(
              (a, b) => a.siteName.compareTo(b.siteName),
            );
          } else {
            model.listHistory.sort(
              (a, b) => b.siteName.compareTo(a.siteName),
            );
          }
          break;
        case "Monthly":
          if (searchTerm.orderDir == "ASC") {
            model.listHistory.sort(
              (a, b) => a.budgetMonthly.compareTo(b.budgetMonthly),
            );
          } else {
            model.listHistory.sort(
              (a, b) => b.budgetMonthly.compareTo(a.budgetMonthly),
            );
          }
          break;
        case "Additional":
          if (searchTerm.orderDir == "ASC") {
            model.listHistory.sort(
              (a, b) => a.budgetAdditional.compareTo(b.budgetAdditional),
            );
          } else {
            model.listHistory.sort(
              (a, b) => b.budgetAdditional.compareTo(a.budgetAdditional),
            );
          }
          break;
        case "UpdatedBy":
          if (searchTerm.orderDir == "ASC") {
            model.listHistory.sort(
              (a, b) => a.updatedBy.compareTo(b.updatedBy),
            );
          } else {
            model.listHistory.sort(
              (a, b) => b.updatedBy.compareTo(a.updatedBy),
            );
          }
          break;
        default:
      }
      searchTerm.orderBy = orderBy;
      // updateTable().then((value) {});
    });
  }

  closeDetail(int index) {
    // setState(() {
    historyViewModel.listHistory[index].isExpanded = false;
    // });
    setState(() {});
  }

  onClickList(int index) {
    for (var element in historyViewModel.listHistory) {
      element.isExpanded = false;
    }
    if (!historyViewModel.listHistory[index].isExpanded!) {
      // print('if false');
      historyViewModel.listHistory[index].isExpanded = true;
    } else if (historyViewModel.listHistory[index].isExpanded!) {
      // print('if true');
      historyViewModel.listHistory[index].isExpanded = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    historyViewModel.getBudgetHistory(globalModel);
    globalModel.addListener(() {
      historyViewModel.closeListener();
      historyViewModel.getBudgetHistory(globalModel);
    });
  }

  @override
  void dispose() {
    super.dispose();
    globalModel.removeListener(() {});
    historyViewModel.closeListener();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: historyViewModel,
      child: Consumer<HistoryViewModel>(builder: (context, model, child) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 10,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TitleIcon(
                        icon: "assets/icons/history.png",
                      ),
                      Text(
                        "Site Ranking",
                        style: cardTitle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        child: BlackDropdown(
                            focusNode: optionsNode,
                            width: 250,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                            ),
                            onChanged: (value) {},
                            hintText: 'Sorting',
                            value: selectedSort,
                            items: sortOptions
                                .map((e) => DropdownMenuItem(
                                      value: e["value"],
                                      child: Text(
                                        e["title"],
                                        style: helveticaText.copyWith(),
                                      ),
                                    ))
                                .toList()),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ShowMoreIcon(
                        showMoreCallback: showMore,
                        exportCallback: export,
                      ),
                    ],
                  ),
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
                  : model.listHistory.isEmpty
                      ? EmptyTable(
                          text: "There is no transaction available right now",
                        )
                      : ListView.builder(
                          itemCount: model.listHistory.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                index == 0
                                    ? const SizedBox()
                                    : const Divider(
                                        color: grayx11,
                                        thickness: 1,
                                      ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: HistoryWidgetListContainer(
                                    history: model.listHistory[index],
                                    index: index,
                                    expand: onClickList,
                                    close: closeDetail,
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

  Widget headerTable(HistoryViewModel model) {
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
              width: 190,
              child: InkWell(
                onTap: () {
                  onTapHeader("Monthly", model);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Monthly',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Monthly"),
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
                  onTapHeader("Additional", model);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Additional',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Additional"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: InkWell(
                onTap: () {
                  onTapHeader("UpdatedBy", model);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Updated By',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("UpdatedBy"),
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

class HistoryWidgetListContainer extends StatefulWidget {
  HistoryWidgetListContainer({
    super.key,
    HistoryTable? history,
    this.index = 0,
    this.expand,
    this.close,
  }) : history = history ?? HistoryTable();

  HistoryTable history;
  Function? expand;
  Function? close;
  int index;

  @override
  State<HistoryWidgetListContainer> createState() =>
      _HistoryWidgetListContainerState();
}

class _HistoryWidgetListContainerState
    extends State<HistoryWidgetListContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      hoverColor: Colors.transparent,
      onTap: () {
        if (widget.history.isExpanded!) {
          widget.close!(widget.index);
        } else {
          widget.expand!(widget.index);
        }
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.history.siteName,
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: davysGray,
                  ),
                ),
              ),
              SizedBox(
                width: 190,
                child: Text(
                  formatCurrency.format(widget.history.budgetMonthly),
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ),
              SizedBox(
                width: 190,
                child: Text(
                  formatCurrency.format(widget.history.budgetAdditional),
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ),
              SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.history.updatedBy,
                      style: helveticaText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: davysGray,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      widget.history.updatedDateTime,
                      style: helveticaText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: davysGray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
                child: widget.history.isExpanded!
                    ? const Icon(Icons.keyboard_arrow_down_sharp)
                    : const Icon(
                        Icons.keyboard_arrow_right_sharp,
                      ),
              )
            ],
          ),
          !widget.history.isExpanded!
              ? const SizedBox()
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                text: "Note: ",
                                style: helveticaText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: orangeAccent,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.history.note,
                                    style: helveticaText.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        RegularButton(
                          text: "See Attachment",
                          disabled: false,
                          fontSize: 14,
                          padding: ButtonSize().tableButton(),
                          onTap: () {
                            html.AnchorElement anchorElement = html.document
                                .createElement('a') as html.AnchorElement;

                            anchorElement.href = widget.history.file;
                            anchorElement.download =
                                widget.history.file.split("/").last;
                            anchorElement.style.display = "none";
                            anchorElement.target = '_blank';
                            anchorElement.setAttribute(
                                "download", "${widget.history.fileName}");
                            html.document.body!.children.add(anchorElement);
                            anchorElement.click();
                          },
                        )
                      ],
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
