import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/view/transaction_list/export_excel_dialog.dart';
import 'package:atk_system_ga/view/transaction_list/filter_search_bar_transaction_list_page.dart';
import 'package:atk_system_ga/view/transaction_list/transaction_list_container.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:flutter/material.dart';

class TransactionListPage extends StatefulWidget {
  TransactionListPage({
    super.key,
    this.formType = "Request",
  });

  String formType;

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  SearchTerm searchTerm = SearchTerm();
  ApiService apiService = ApiService();
  TextEditingController _search = TextEditingController();
  FocusNode showPerRowsNode = FocusNode();

  bool isLoading = true;

  String role = "";

  String formType = "Supply Request";
  List typeList = [];

  double rowPerPage = 10;
  double firstPaginated = 0;
  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];
  List showPerPageList = ["5", "10", "20", "50", "100"];
  int resultRows = 0;

  List<Transaction> transactionList = [];

  onChangedTab(String value) {
    currentPaginatedPage = 1;
    searchTerm.formType = value;
    searchTerm.orderBy = "FormID";
    searchTerm.orderDir = "ASC";
    searchTerm.keywords = "";
    searchTerm.pageNumber = currentPaginatedPage.toString();
    _search.text = "";
    formType = value;
    updateList().then((value) {
      countPagination(resultRows);
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

  Future updateList() async {
    transactionList.clear();
    isLoading = true;
    setState(() {});
    return apiService.getTransactionList(searchTerm).then((value) {
      print(value);
      isLoading = false;
      if (value['Status'].toString() == "200") {
        List listResult = value['Data']['List'];
        resultRows = value['Data']['TotalRows'];
        for (var element in listResult) {
          transactionList.add(
            Transaction(
              formId: element["FormID"],
              reqId: element["RequestID"],
              category: element["FormCategory"],
              formType: element["FormType"],
              siteName: element["SiteName"],
              created: element["Created_At"],
              status: element["Status"],
              settlementId: element['SettlementID'],
              settlementStatus: element['SettlementStatus'],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
      setState(() {});
    }).onError((error, stackTrace) {
      print("error get transaction");
      print(error);
      isLoading = false;
      setState(() {});
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Error getTransaction',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  onTapHeader(String orderBy) {
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
    // setState(() {});
    updateList().then((value) {});
  }

  closeDetail(int index) {
    setState(() {
      transactionList[index].isExpanded = false;
    });
  }

  onClickList(int index) {
    for (var element in transactionList) {
      element.isExpanded = false;
    }
    if (!transactionList[index].isExpanded) {
      // print('if false');
      transactionList[index].isExpanded = true;
    } else if (transactionList[index].isExpanded) {
      // print('if true');
      transactionList[index].isExpanded = false;
    }
    setState(() {});
  }

  Future initType() async {
    if (widget.formType != "null") {
      formType = widget.formType;
    }
    searchTerm.formType = formType;
    searchTerm.orderBy = "FormID";
    searchTerm.orderDir = "ASC";
  }

  initTabCount() {
    apiService.getTabTransactionCount().then((value) {
      if (value["Status"].toString() == "200") {
        typeList = value['Data'];
        setState(() {});
      } else {}
    }).onError((error, stackTrace) {});
  }

  searchTransaction() {
    searchTerm.keywords = _search.text;
    currentPaginatedPage = 1;
    searchTerm.pageNumber = currentPaginatedPage.toString();

    updateList().then((value) {
      countPagination(resultRows);
    });
  }

  @override
  void initState() {
    super.initState();
    initType().then((value) {
      initTabCount();
      updateList().then((value) {
        countPagination(resultRows);
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            width: 1110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Transaction List',
                  style: helveticaText.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: eerieBlack,
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                FilterSearchBarTransactionList(
                  search: searchTransaction,
                  typeList: typeList,
                  updateList: onChangedTab,
                  searchController: _search,
                  type: formType,
                ),
                const SizedBox(
                  height: 30,
                ),
                formType == "Settlement"
                    ? headerTableSettlement()
                    : headerTable(),
                isLoading
                    ? const SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: eerieBlack,
                          ),
                        ),
                      )
                    : transactionList.isEmpty
                        ? EmptyTable(
                            text: "You don't have any transaction",
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: transactionList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return formType == "Settlement"
                                  ? TransactionListContainerSettlement(
                                      index: index,
                                      transaction: transactionList[index],
                                      onClick: onClickList,
                                      close: closeDetail,
                                    )
                                  : TransactionListContainer(
                                      index: index,
                                      transaction: transactionList[index],
                                      onClick: onClickList,
                                      close: closeDetail,
                                    );
                            },
                          ),
                const SizedBox(
                  height: 50,
                ),
                transactionList.isEmpty ? const SizedBox() : pagination(),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
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
              child: InkWell(
                onTap: () {
                  onTapHeader("FormID");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Request ID',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("FormID"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 165,
              child: InkWell(
                onTap: () {
                  onTapHeader("FormCategory");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Category',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("FormCategory"),
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
                        'Location',
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
              width: 165,
              child: InkWell(
                onTap: () {
                  onTapHeader("Created_At");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Created',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Created_At"),
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
                  onTapHeader("Status");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Status',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Status"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20,
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
        const SizedBox(
          height: 19,
        )
      ],
    );
  }

  Widget headerTableSettlement() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("FormID");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Settlement ID',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("FormID"),
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
                  onTapHeader("RequestID");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Request ID',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("requestID"),
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
                        'Location',
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
              width: 165,
              child: InkWell(
                onTap: () {
                  onTapHeader("Created_At");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Created',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Created_At"),
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
                  onTapHeader("Status");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Status',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Status"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20,
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
        const SizedBox(
          height: 19,
        )
      ],
    );
  }

  Widget pagination() {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      updateList().then((value) {
                        countPagination(resultRows);
                        showedPage = availablePage.take(5).toList();
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

                          // apiReq
                          //     .getMyBookingList(searchTerm)
                          //     .then((value) {
                          //   myBookList = value['Data']['List'];
                          //   countPagination(
                          //       value['Data']['TotalRows']);
                          // });
                          updateList();
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
                                    // apiReq
                                    //     .getMyBookingList(
                                    //         searchTerm)
                                    //     .then((value) {
                                    //   setState(() {
                                    //     myBookList =
                                    //         value['Data']['List'];
                                    //     countPagination(
                                    //         value['Data']
                                    //             ['TotalRows']);
                                    //   });
                                    // });
                                    updateList();
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
                        currentPaginatedPage = currentPaginatedPage + 1;
                        if (currentPaginatedPage == showedPage.last &&
                            currentPaginatedPage != availablePage.last) {
                          showedPage.removeAt(0);
                          showedPage.add(currentPaginatedPage + 1);
                        }
                        searchTerm.pageNumber = currentPaginatedPage.toString();

                        // apiReq
                        //     .getMyBookingList(searchTerm)
                        //     .then((value) {
                        //   myBookList = value['Data']['List'];
                        //   countPagination(
                        //       value['Data']['TotalRows']);
                        // });
                        updateList();
                        setState(() {});
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
