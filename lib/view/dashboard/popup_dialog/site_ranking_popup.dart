import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/export_dialog.dart';
import 'package:atk_system_ga/view/dashboard/widget_icon.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SiteRankingPopup extends StatefulWidget {
  SiteRankingPopup({
    super.key,
    this.option = 1,
  });

  int option;

  @override
  State<SiteRankingPopup> createState() => _SiteRankingPopupState();
}

class _SiteRankingPopupState extends State<SiteRankingPopup> {
  ApiService apiService = ApiService();
  SearchTerm searchTerm = SearchTerm(orderDir: "ASC");
  TextEditingController _search = TextEditingController();
  late GlobalModel globalModel;
  FocusNode showPerRowsNode = FocusNode();
  FocusNode optionsNode = FocusNode();

  bool isLoading = true;

  double rowPerPage = 10;
  double firstPaginated = 0;
  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];
  List showPerPageList = ["5", "10", "20", "50", "100"];
  int resultRows = 0;

  String dataType = "Lowes Cost";

  int selectedSort = 7;

  List sortOptions = [
    {"value": 7, "title": "Cost vs Budget"},
    {"value": 1, "title": "Highest Cost"},
    {"value": 2, "title": "Lowest Cost"},
    {"value": 3, "title": "Highest Budget"},
    {"value": 4, "title": "Lowest Budget"},
    {"value": 5, "title": "Fastest Leadtime"},
    {"value": 6, "title": "Slowest Leadtime"},
  ];

  List<SiteRanking> itemList = [];
  onTapHeader(String orderBy) {
    setState(() {
      setDataType();
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
      searchTerm.orderBy = orderBy;
      getData().then((value) {});
      // updateTable().then((value) {});
    });
  }

  setDataType() {
    switch (selectedSort) {
      case 1:
        dataType = "Highest Cost";
        break;
      case 2:
        dataType = "Lowest Cost";
        break;
      case 3:
        dataType = "Highest Budget";
        break;
      case 4:
        dataType = "Lowest Budget";
        break;
      case 5:
        dataType = "Fastest Leadtime";
        break;
      case 6:
        dataType = "Slowest Leadtime";
        break;
      case 7:
        dataType = "Cost vs Budget";
        break;
      default:
        dataType = "Cost vs Budget";
    }
  }

  Future getData() {
    isLoading = true;
    setDataType();
    setState(() {});
    return apiService
        .dashboardSiteRanking(searchTerm, globalModel, dataType)
        .then((value) {
      isLoading = false;
      if (value["Status"].toString() == "200") {
        List<SiteRanking> temp = [];
        List itemResult = value["Data"]["List"];
        resultRows = value["Data"]["TotalRows"];

        for (var element in itemResult) {
          temp.add(SiteRanking(
            siteName: element["SiteName"],
            rank: element["Order"].toString(),
            cost: element["TotalCost"] ?? 0,
            budgetAddition: element["AdditionalBudget"] ?? 0,
            budgetMonthly: element["MonthlyBudget"] ?? 0,
            percentageCompare: element["Percentage"] ?? 0.0,
            reqTime: element["RequestTime"] ?? "",
            settlementTime: element["SettlementTime"] ?? "",
            budgetCompare: element["Budget"] ?? 0,
            costCompare: element["Cost"] ?? 0,
          ));
        }
        itemList = temp;

        print("LIST -> $itemList");
        setState(() {});
      } else {
        String status = value["Status"];
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value["Title"],
            contentText: value["Message"],
            isSuccess: false,
          ),
        ).then((value) {
          if (status == "401") {}
        });
      }
      // setState(() {});
    }).onError((error, stackTrace) {
      isLoading = false;
      setState(() {});
    });
  }

  countPagination(int totalRow) {
    setState(() {
      availablePage.clear();
      if (totalRow == 0) {
        currentPaginatedPage = 1;
        showedPage = [1];
        availablePage = [1];
      }
      var totalPage = totalRow / int.parse(searchTerm.max);
      for (var i = 0; i < totalPage.ceil(); i++) {
        availablePage.add(i + 1);
      }
      showedPage = availablePage.take(5).toList();
    });
  }

  search() {
    searchTerm.keywords = _search.text;
    currentPaginatedPage = 1;
    searchTerm.pageNumber = currentPaginatedPage.toString();

    getData().then((value) {
      countPagination(resultRows);
    });
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    selectedSort = widget.option;
    getData().then((value) {
      countPagination(resultRows);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 1100,
            maxWidth: 1200,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 35,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                        icon: "assets/icons/site_rank_icon.png",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Site Ranking",
                            style: cardTitle,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              '-',
                              style: helveticaText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: davysGray,
                              ),
                            ),
                          ),
                          Text(
                            '${globalModel.month} ${globalModel.year}, ${globalModel.areaId}',
                            style: helveticaText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: davysGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 295,
                    child: SearchInputField(
                      controller: _search,
                      enabled: true,
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search here ...",
                      maxLines: 1,
                      onFieldSubmitted: (value) {
                        search();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              headerTable(),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: eerieBlack,
                      ),
                    )
                  : itemList.isEmpty
                      ? EmptyTable(
                          text: "Item rank is not available right now",
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: itemList.length,
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
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: SiteRankDetailListContainer(
                                    item: itemList[index],
                                    option: selectedSort,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pagination(),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TransparentButtonBlack(
                          text: 'Cancel',
                          disabled: false,
                          onTap: () {
                            Navigator.of(context).pop(0);
                          },
                          padding: ButtonSize().mediumSize(),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        RegularButton(
                          text: 'Export',
                          disabled: false,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => ExportDashboardPopup(
                                dataType: "Site Ranking - $dataType",
                              ),
                            );
                          },
                          padding: ButtonSize().mediumSize(),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headerTable() {
    switch (selectedSort) {
      case 1:
        return costHeader();
      case 2:
        return costHeader();
      case 3:
        return budgetHeader();
      case 4:
        return budgetHeader();
      case 5:
        return leadTimeHeader();
      case 6:
        return leadTimeHeader();
      case 7:
        return comparisonHeader();
      default:
        return const SizedBox();
    }
  }

  Widget costHeader() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 75,
              child: InkWell(
                onTap: () {
                  onTapHeader("Order");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Order"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
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
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("TotalCost");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Cost',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("TotalCost"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 50,
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

  Widget budgetHeader() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 75,
              child: InkWell(
                onTap: () {
                  onTapHeader("Order");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Order"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
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
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("MonthlyBudget");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Monthly Budget',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("MonthlyBudget"),
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
                  onTapHeader("AdditionalBudget");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Additional Budget',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("AdditionalBudget"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(
            //   width: 20,
            // )
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

  Widget leadTimeHeader() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 75,
              child: InkWell(
                onTap: () {
                  onTapHeader("Order");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Order"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
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
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("RequestTime");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Request Leadtime',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("RequestTime"),
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
                  onTapHeader("SettlementTime");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Settlement Leadtime',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("SettlementTime"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(
            //   width: 20,
            // )
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

  Widget comparisonHeader() {
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
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("Percentage");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Usage',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Percentage"),
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
                  onTapHeader("Budget");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Budget',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Budget"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(
            //   width: 20,
            // )
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

  Widget pagination() {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // color: Colors.amber,
          width: 220,
          child: Row(
            children: [
              Text(
                'Show:',
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 120,
                child: BlackDropdown(
                  focusNode: showPerRowsNode,
                  onChanged: (value) {
                    setState(() {
                      currentPaginatedPage = 1;
                      searchTerm.pageNumber = "1";
                      searchTerm.max = value!.toString();
                      getData().then((value) {
                        countPagination(resultRows);
                      });
                    });
                  },
                  value: searchTerm.max,
                  items: showPerPageList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: eerieBlack,
                        ),
                      ),
                    );
                  }).toList(),
                  // DropdownMenuItem(
                  //   child: Text('10'),
                  //   value: 10,
                  // ),
                  // DropdownMenuItem(
                  //   child: Text('50'),
                  //   value: 50,
                  // ),
                  // DropdownMenuItem(
                  //   child: Text('100'),
                  //   value: 100,
                  // ),
                  enabled: true,
                  hintText: 'Choose',
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: eerieBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Container(
          child: Row(
            children: [
              InkWell(
                onTap: currentPaginatedPage - 1 > 0
                    ? () {
                        setState(() {
                          currentPaginatedPage = currentPaginatedPage - 1;
                          if (availablePage.length > 5 &&
                              currentPaginatedPage == showedPage[0] &&
                              currentPaginatedPage != 1) {
                            showedPage.removeLast();
                            showedPage.insert(0, currentPaginatedPage - 1);
                          }
                          searchTerm.pageNumber =
                              currentPaginatedPage.toString();
                          getData().then((value) {});
                        });
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(
                    //   color: grayx11,
                    //   width: 1,
                    // ),
                  ),
                  child: const Icon(
                    Icons.chevron_left_sharp,
                  ),
                ),
              ),
              // const SizedBox(
              //   width: 10,
              // ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: paginationWidth, //275,
                height: 35,
                child: Row(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: showedPage.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: InkWell(
                            onTap: currentPaginatedPage == showedPage[index]
                                ? null
                                : () {
                                    setState(() {
                                      currentPaginatedPage = showedPage[index];
                                      if (availablePage.length > 5 &&
                                          index == showedPage.length - 1) {
                                        if (currentPaginatedPage !=
                                            availablePage.last) {
                                          showedPage.removeAt(0);
                                          showedPage
                                              .add(currentPaginatedPage + 1);
                                        }
                                      }
                                      if (availablePage.length > 5 &&
                                          index == 0 &&
                                          currentPaginatedPage != 1) {
                                        showedPage.removeLast();
                                        showedPage.insert(
                                            0, currentPaginatedPage - 1);
                                      }
                                    });
                                    searchTerm.pageNumber =
                                        currentPaginatedPage.toString();
                                    getData().then((value) {});
                                  },
                            child: Container(
                              width: 35,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 8.5,
                              ),
                              decoration: BoxDecoration(
                                color: showedPage[index] == currentPaginatedPage
                                    ? eerieBlack
                                    : null,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  showedPage[index].toString(),
                                  style: helveticaText.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    color: showedPage[index] ==
                                            currentPaginatedPage
                                        ? culturedWhite
                                        : davysGray,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Visibility(
                      visible: availablePage.length <= 5 ||
                              currentPaginatedPage == availablePage.last
                          ? false
                          : true,
                      child: Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 8.5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '...',
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              color: davysGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: currentPaginatedPage != availablePage.last
                    ? () {
                        setState(() {
                          currentPaginatedPage = currentPaginatedPage + 1;
                          if (currentPaginatedPage == showedPage.last &&
                              currentPaginatedPage != availablePage.last) {
                            showedPage.removeAt(0);
                            showedPage.add(currentPaginatedPage + 1);
                          }
                          searchTerm.pageNumber =
                              currentPaginatedPage.toString();

                          getData().then((value) {});
                        });
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(
                    //   color: grayx11,
                    //   width: 1,
                    // ),
                  ),
                  child: const Icon(
                    Icons.chevron_right_sharp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SiteRankDetailListContainer extends StatelessWidget {
  SiteRankDetailListContainer({super.key, SiteRanking? item, this.option = 1})
      : item = item ?? SiteRanking();

  SiteRanking item;
  int option;

  TextStyle light = helveticaText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: eerieBlack,
  );

  TextStyle normal = helveticaText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: davysGray,
  );

  @override
  Widget build(BuildContext context) {
    switch (option) {
      case 1:
        return costContainer();
      case 2:
        return costContainer();
      case 3:
        return budgetContainer();
      case 4:
        return budgetContainer();
      case 5:
        return timeContainer();
      case 6:
        return timeContainer();
      case 7:
        return comparisonContainer();
      default:
        return costContainer();
    }
  }

  Widget costContainer() {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(
            item.rank,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: davysGray,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            item.siteName,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: davysGray,
            ),
          ),
        ),
        Expanded(
          child: Text(
            formatCurrency.format(item.cost),
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: eerieBlack,
            ),
          ),
        ),
        const SizedBox(
          width: 50,
        )
      ],
    );
  }

  Widget budgetContainer() {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(
            item.rank,
            style: normal,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            item.siteName,
            style: normal,
          ),
        ),
        Expanded(
          child: Text(
            formatCurrency.format(item.budgetMonthly),
            style: light,
          ),
        ),
        Expanded(
          child: Text(
            formatCurrency.format(item.budgetAddition),
            style: light,
          ),
        ),
      ],
    );
  }

  Widget timeContainer() {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Row(
            children: [
              Text(
                item.rank,
                style: normal,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            item.siteName,
            style: normal,
          ),
        ),
        Expanded(
          child: Text(
            item.reqTime!,
            style: light,
          ),
        ),
        Expanded(
          child: Text(
            item.settlementTime!,
            style: light,
          ),
        ),
      ],
    );
  }

  Widget comparisonContainer() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            item.siteName,
            style: normal,
          ),
        ),
        Expanded(
          child: Text(
            formatCurrency.format(item.costCompare),
            style: light,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 25,
                child: LayoutBuilder(builder: (context, constraint) {
                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.5),
                          color: platinumDark,
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        width: constraint.maxWidth *
                            (item.percentageCompare! / 100),
                        decoration: BoxDecoration(
                          borderRadius: item.percentageCompare! < 100
                              ? BorderRadius.circular(5.5)
                              : BorderRadius.circular(5.5),
                          color: orangeAccent,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(
                width: 13,
              ),
              Text(
                "${item.percentageCompare} %",
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: orangeAccent,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Text(
            formatCurrency.format(item.budgetCompare),
            style: light,
          ),
        ),
        // const SizedBox(
        //   width: 20,
        // )
      ],
    );
  }
}
