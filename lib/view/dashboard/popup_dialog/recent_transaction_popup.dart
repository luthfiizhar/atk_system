import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/export_dialog.dart';
import 'package:atk_system_ga/view/dashboard/recent_transaction.dart';
import 'package:atk_system_ga/view/dashboard/widget_icon.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactionPopUp extends StatefulWidget {
  const RecentTransactionPopUp({super.key});

  @override
  State<RecentTransactionPopUp> createState() => _RecentTransactionPopUpState();
}

class _RecentTransactionPopUpState extends State<RecentTransactionPopUp> {
  late GlobalModel globalModel;
  SearchTerm searchTerm = SearchTerm();
  TextEditingController _search = TextEditingController();

  ApiService apiService = ApiService();

  FocusNode showPerRowsNode = FocusNode();

  double rowPerPage = 10;
  double firstPaginated = 0;
  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];
  List showPerPageList = ["5", "10", "20", "50", "100"];
  int resultRows = 0;

  List<RecentTransactionTable> recTransList = [];

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

  Future getData() {
    recTransList.clear();
    return apiService
        .dashboardRecentTransactionDetail(searchTerm, globalModel)
        .then((value) {
      print(value);
      if (value["Status"].toString() == "200") {
        List listResult = value["Data"]["List"];
        resultRows = value["Data"]["TotalRows"];
        for (var element in listResult) {
          recTransList.add(
            RecentTransactionTable(
              formId: element["FormID"],
              siteName: element["SiteName"],
              type: element["Type"],
              date: element["Date"],
              time: element["Time"],
              cost: element["Cost"],
            ),
          );
        }
      } else {}
      setState(() {});
    }).onError((error, stackTrace) {});
  }

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
      getData().then((value) {});
      // updateTable().then((value) {});
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
    // TODO: implement initState
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);

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
                        icon: "assets/icons/recent_transaction_icon.png",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Recent Transaction",
                            style: cardTitle,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              '-',
                              style: helveticaText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: davysGray,
                              ),
                            ),
                          ),
                          Text(
                            '${globalModel.month} ${globalModel.year}, ${globalModel.areaId}',
                            style: helveticaText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
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
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: RecentTransactionItems(
                          recents: recTransList[index],
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
                                dataType: "Recent Transaction",
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
            SizedBox(
              width: 190,
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
              width: 175,
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
                      // apiReq
                      //     .getMyBookingList(searchTerm)
                      //     .then((value) {
                      //   myBookList = value['Data']['List'];
                      //   countPagination(value['Data']['TotalRows']);
                      //   showedPage = availablePage.take(5).toList();
                      // });
                      // updateList().then((value) {
                      //   countPagination(resultRows);
                      //   showedPage = availablePage.take(5).toList();
                      // });
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

                          getData().then((value) {
                            countPagination(resultRows);
                          });

                          // apiReq
                          //     .getMyBookingList(searchTerm)
                          //     .then((value) {
                          //   myBookList = value['Data']['List'];
                          //   countPagination(
                          //       value['Data']['TotalRows']);
                          // });
                          // updateList();
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
                                    getData().then((value) {
                                      setState(() {});
                                    });
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
                          getData().then((value) {
                            setState(() {});
                          });
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
