import 'dart:math';

import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/item_class.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/modules/admin_settings/admin_tab_menu.dart';
import 'package:atk_system_ga/modules/admin_settings/item/item_list_container.dart';
import 'package:atk_system_ga/modules/admin_settings/site/add_site_dialog.dart';
import 'package:atk_system_ga/modules/admin_settings/site/site_list_container.dart';
import 'package:atk_system_ga/modules/admin_settings/user/user_list_container.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminSettingPage extends StatefulWidget {
  const AdminSettingPage({super.key});

  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  SearchTerm searchTerm = SearchTerm();
  ApiService apiService = ApiService();
  TextEditingController _search = TextEditingController();
  FocusNode showPerRowsNode = FocusNode();

  List<Site> siteList = [
    Site(
      siteId: 'H301',
      siteName: 'ST INFORMA PURI MALL JKT',
      siteArea: 4000,
      monthlyBudget: 3000000,
      additionalBudget: 1500000,
    ),
    Site(
      siteId: 'H301',
      siteName: 'ST INFORMA PURI MALL JKT',
      siteArea: 4000,
      monthlyBudget: 3000000,
      additionalBudget: 1500000,
    ),
  ];

  List<User> userList = [
    User(
        nip: '1111111',
        name: 'Eerling Haaland',
        siteId: 'HO',
        role: 'System Admin'),
    User(
        nip: '1111111',
        name: 'Eerling Haaland',
        siteId: 'HO',
        role: 'System Admin'),
    User(
        nip: '1111111',
        name: 'Eerling Haaland',
        siteId: 'HO',
        role: 'System Admin'),
  ];

  List<Item> itemList = [
    Item(itemName: 'AAAAAA', unit: 'EA', basePrice: 10000),
    Item(itemName: 'AAAAAA', unit: 'EA', basePrice: 10000),
    Item(itemName: 'AAAAAA', unit: 'EA', basePrice: 10000),
  ];

  bool isLoading = true;

  String role = "";

  String menu = "Site";
  List menuList = [
    {"value": "Site", "name": "Site List"},
    {"value": "User", "name": "User List"},
    {"value": "Item", "name": "Item List"},
  ];

  final List<String> items = [
    'A_Item1',
    'A_Item2',
    'A_Item3',
    'A_Item4',
    'B_Item1',
    'B_Item2',
    'B_Item3',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
    'luthfi',
  ];

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  double rowPerPage = 10;
  double firstPaginated = 0;
  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];
  List showPerPageList = ["5", "10", "20", "50", "100"];
  int resultRows = 0;

  onChangedTab(String value) {
    currentPaginatedPage = 1;
    // searchTerm.formType = value;
    searchTerm.orderBy = "FormID";
    searchTerm.orderDir = "ASC";
    searchTerm.keywords = "";
    searchTerm.pageNumber = currentPaginatedPage.toString();
    _search.text = "";
    menu = value;
    // updateList().then((value) {
    //   countPagination(resultRows);
    //   setState(() {});
    // });
    setState(() {});
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

  onTapHeader(String orderBy, String menu) {
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
    updateList(menu);
    setState(() {});
  }

  Future nothing() async {}

  Future updateList(String menu) {
    switch (menu) {
      case "Site":
        return apiService.getAdminPageSiteList(searchTerm).then((value) {});
      case "User":
        return apiService.getAdminPageUserList(searchTerm).then((value) {});
      case "Item":
        return apiService.getAdminPageItemList(searchTerm).then((value) {});
      default:
        return nothing();
    }
  }

  onClickListSite(int index) {
    for (var element in siteList) {
      element.isExpanded = false;
    }
    if (!siteList[index].isExpanded) {
      siteList[index].isExpanded = true;
    } else if (siteList[index].isExpanded) {
      siteList[index].isExpanded = false;
    }
    setState(() {});
  }

  closeSiteListDetail(int index) {
    siteList[index].isExpanded = false;
    setState(() {});
  }

  onClickListUser(int index) {
    for (var element in userList) {
      element.isExpanded = false;
    }
    if (!userList[index].isExpanded) {
      userList[index].isExpanded = true;
    } else if (userList[index].isExpanded) {
      userList[index].isExpanded = false;
    }
    setState(() {});
  }

  closeUserListDetail(int index) {
    userList[index].isExpanded = false;
    setState(() {});
  }

  onClickListItem(int index) {
    for (var element in itemList) {
      element.isExpanded = false;
    }
    if (!itemList[index].isExpanded) {
      itemList[index].isExpanded = true;
    } else if (itemList[index].isExpanded) {
      itemList[index].isExpanded = false;
    }
    setState(() {});
  }

  closeItemListDetail(int index) {
    itemList[index].isExpanded = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 1,
      child: ConstrainedBox(
        constraints: pageContstraint,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 1100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Setting',
                  style: helveticaText.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: eerieBlack,
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                AdminMenuSearchBar(
                  search: () {},
                  menuList: menuList,
                  updateList: onChangedTab,
                  searchController: _search,
                  type: menu,
                ),
                const SizedBox(
                  height: 25,
                ),
                //Add Button
                Row(
                  children: [
                    Builder(
                      builder: (context) {
                        switch (menu) {
                          case "Site":
                            return addButtonSite(context);
                          case "User":
                            return addButtonUser(context);
                          case "Item":
                            return addButtonItem(context);
                          default:
                            return SizedBox();
                        }
                      },
                    ),
                  ],
                ),

                //End Add Button
                const SizedBox(
                  height: 25,
                ),
                //Table
                Builder(
                  builder: (context) {
                    switch (menu) {
                      case "Site":
                        return siteListTable(menu);
                      case "User":
                        return userListTable(menu);
                      case "Item":
                        return itemListTable(menu);
                      default:
                        return SizedBox();
                    }
                  },
                ),
                //End Table
                const SizedBox(
                  height: 50,
                ),
                //Pagination
                pagination(),
                //End Pagination
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

  Widget addButtonSite(BuildContext context) {
    return Column(
      children: [
        CustomRegularButton(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AddSiteDialog(),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                size: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Add Site',
                style: helveticaText.copyWith(
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
        SearchDropDown(
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {},
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: eerieBlack,
          ),
        )
      ],
    );
  }

  Widget addButtonUser(BuildContext context) {
    return CustomRegularButton(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 20,
      ),
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.add,
            size: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Add User',
            style: helveticaText.copyWith(
              fontSize: 16,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
    ;
  }

  Widget addButtonItem(BuildContext context) {
    return CustomRegularButton(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 20,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AddSiteDialog(),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.add,
            size: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Add Item',
            style: helveticaText.copyWith(
              fontSize: 16,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  Widget pagination() {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));
    return Container(
      child: Row(
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
                        // updateList().then((value) {
                        //   countPagination(resultRows);
                        //   showedPage = availablePage.take(5).toList();
                        // });
                      });
                    },
                    value: searchTerm.max,
                    items: showPerPageList.map((e) {
                      return DropdownMenuItem(
                        child: Text(e),
                        value: e,
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
                                        currentPaginatedPage =
                                            showedPage[index];
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
                                    },
                              child: Container(
                                width: 35,
                                height: 35,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 8.5,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      showedPage[index] == currentPaginatedPage
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
                      Icons.chevron_right_sharp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget siteListTable(String menu) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 150,
              child: InkWell(
                onTap: () {
                  onTapHeader("SiteID", menu);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Site ID',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("SiteID"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // flex: 2,
              child: InkWell(
                onTap: () {
                  onTapHeader("SiteName", menu);
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
              width: 350,
              child: InkWell(
                onTap: () {
                  onTapHeader("MonthlyBudget", menu);
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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) => SiteListContainer(
            index: index,
            close: closeSiteListDetail,
            onClick: onClickListSite,
            site: siteList[index],
          ),
        )
      ],
    );
  }

  Widget userListTable(String menu) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 135,
              child: InkWell(
                onTap: () {
                  onTapHeader("EmpNIP", menu);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'NIP',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("EmpNIP"),
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
                  onTapHeader("EmpName", menu);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Name',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("EmpName"),
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
                  onTapHeader("SiteID", menu);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Site ID',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("SiteID"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // width: 150,
              child: InkWell(
                onTap: () {
                  onTapHeader("Role", menu);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Role',
                        style: headerTableTextStyle,
                      ),
                    ),
                    iconSort("Role"),
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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: userList.length,
          itemBuilder: (context, index) => UserListContainer(
            index: index,
            close: closeUserListDetail,
            onClick: onClickListUser,
            user: userList[index],
          ),
        )
      ],
    );
  }

  Widget itemListTable(String menu) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  onTapHeader("ItemName", menu);
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
              width: 170,
              child: InkWell(
                onTap: () {
                  onTapHeader("Unit", menu);
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
            SizedBox(
              width: 210,
              child: InkWell(
                onTap: () {
                  onTapHeader("Price", menu);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Price',
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
            const Expanded(
              child: SizedBox(),
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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemList.length,
          itemBuilder: (context, index) => ItemListContainer(
            index: index,
            close: closeItemListDetail,
            onClick: onClickListItem,
            item: itemList[index],
          ),
        )
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
