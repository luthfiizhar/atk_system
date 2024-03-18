import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/export_dialog.dart';
import 'package:atk_system_ga/view/dashboard/widget_icon.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRequestedItemPopup extends StatefulWidget {
  const TopRequestedItemPopup({super.key});

  @override
  State<TopRequestedItemPopup> createState() => _TopRequestedItemPopupState();
}

class _TopRequestedItemPopupState extends State<TopRequestedItemPopup> {
  SearchTerm searchTerm =
      SearchTerm(orderBy: "TotalRequested", orderDir: "DESC");
  ApiService apiService = ApiService();
  TextEditingController _search = TextEditingController();
  late GlobalModel globalModel;
  FocusNode showPerRowsNode = FocusNode();

  double rowPerPage = 10;
  double firstPaginated = 0;
  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];
  List showPerPageList = ["5", "10", "20", "50", "100"];
  int resultRows = 0;

  List<TopRequestedItems> listItem = [];

  bool isLoading = true;

  search() {
    searchTerm.keywords = _search.text;
    currentPaginatedPage = 1;
    searchTerm.pageNumber = currentPaginatedPage.toString();

    getData().then((value) {
      countPagination(resultRows);
    });
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
      searchTerm.orderBy = orderBy;
      getData().then((value) {});
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

  Future getData() {
    isLoading = true;
    setState(() {});
    return apiService
        .dashboardTopRequestedItemDetail(searchTerm, globalModel)
        .then((value) {
      isLoading = false;
      if (value["Status"].toString() == "200") {
        dynamic listResult = value["Data"]["List"];
        resultRows = value["Data"]["TotalRows"];
        List<TopRequestedItems> itemResult = [];
        for (var element in listResult) {
          itemResult.add(
            TopRequestedItems(
              rank: element["Order"].toString(),
              name: element["ItemName"],
              qty: element["TotalRequested"].toString(),
              totalCost: element["TotalCost"].toString(),
            ),
          );
        }
        listItem = itemResult;
      } else {}
      setState(() {});
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  @override
  void initState() {
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
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
          ),
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
                        icon: "assets/icons/top_requested_icon.png",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Top Requested Item",
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
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listItem.length,
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: TopRequestedItemPopupContainer(
                                item: listItem[index],
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
                                dataType: "Top Requested Item",
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
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("TotalRequested");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Requested',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("TotalRequested"),
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
                width: 110,
                child: BlackDropdown(
                  focusNode: showPerRowsNode,
                  dropdownWidth: 110,
                  width: 75,
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

class TopRequestedItemPopupContainer extends StatelessWidget {
  TopRequestedItemPopupContainer({
    super.key,
    TopRequestedItems? item,
  }) : item = item ?? TopRequestedItems();

  TopRequestedItems item;

  TextStyle normalText = helveticaText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: davysGray,
  );

  TextStyle lightText = helveticaText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: davysGray,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.rank,
                  style: normalText,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: normalText,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formatThousandNoDecimal.format(int.parse(item.qty)),
                  style: lightText,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formatCurrency.format(int.parse(item.totalCost)),
                  style: lightText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 50,
        ),
      ],
    );
  }
}
