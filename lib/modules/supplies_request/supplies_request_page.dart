import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/models/search_term.dart';
import 'package:atk_system_ga/modules/supplies_request/supplies_request_class.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:flutter/material.dart';

class SuppliesRequestPage extends StatefulWidget {
  SuppliesRequestPage({
    super.key,
    SuppliesRequest? suppliesRequest,
    this.isAdditional = false,
  }) : suppliesRequest = suppliesRequest ?? SuppliesRequest();

  SuppliesRequest suppliesRequest;
  bool isAdditional;

  @override
  State<SuppliesRequestPage> createState() => _SuppliesRequestPageState();
}

class _SuppliesRequestPageState extends State<SuppliesRequestPage> {
  TextEditingController _search = TextEditingController();
  SearchTerm searchTerm = SearchTerm();

  TextStyle infoTextLight = helveticaText.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: eerieBlack,
  );

  TextStyle infoTextBold = helveticaText.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: eerieBlack,
  );

  TextStyle headerTableTextStyle = helveticaText.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: davysGray,
  );

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Order Supplies - October - H001REGM102201',
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
      ],
    );
  }

  Widget iconSort(String orderBy) {
    return SizedBox(
      width: 20,
      height: 25,
      // child: Stack(
      //   children: [
      //     Visibility(
      //       visible:
      //           searchTerm.orderBy == orderBy && searchTerm.orderDir == "DESC"
      //               ? false
      //               : true,
      //       child: const Positioned(
      //         top: 0,
      //         left: 0,
      //         child: Icon(
      //           Icons.keyboard_arrow_down_sharp,
      //           size: 16,
      //         ),
      //       ),
      //     ),
      //     Visibility(
      //       visible:
      //           searchTerm.orderBy == orderBy && searchTerm.orderDir == "ASC"
      //               ? false
      //               : true,
      //       child: const Positioned(
      //         bottom: 0,
      //         left: 0,
      //         child: Icon(
      //           Icons.keyboard_arrow_up_sharp,
      //           size: 16,
      //         ),
      //       ),
      //     )
      //   ],
      // ),
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
