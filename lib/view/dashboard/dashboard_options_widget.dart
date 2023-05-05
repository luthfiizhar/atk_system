import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardOptionsWidget extends StatefulWidget {
  const DashboardOptionsWidget({super.key});

  @override
  State<DashboardOptionsWidget> createState() => _DashboardOptionsWidgetState();
}

class _DashboardOptionsWidgetState extends State<DashboardOptionsWidget> {
  late GlobalModel globalModel;
  List<BusinessUnit> businessUnit = [
    BusinessUnit(photo: "assets/ace_logo.png"),
  ];

  int selectedArea = 1;
  List areaList = [
    {"value": 1, "name": "All Indonesia Region"},
    {"value": 2, "name": "Region ABC"},
    {"value": 3, "name": "Area ABC"},
    {"value": 4, "name": "Store ABC"}
  ];

  int selectedMonth = 1;
  List monthList = [
    {"value": 1, "name": "January"},
    {"value": 2, "name": "February"},
    {"value": 3, "name": "Maret"},
    {"value": 4, "name": "April"},
    {"value": 5, "name": "May"},
    {"value": 6, "name": "June"},
    {"value": 7, "name": "July"},
    {"value": 8, "name": "August"},
    {"value": 9, "name": "September"},
    {"value": 10, "name": "October"},
    {"value": 11, "name": "November"},
    {"value": 12, "name": "December"},
    {"value": 13, "name": "Q1"},
    {"value": 14, "name": "Q2"},
    {"value": 15, "name": "Q3"},
    {"value": 16, "name": "Q4"}
  ];

  int selectedYear = 1;
  List yearList = [
    {"value": 1, "name": "2023"},
    {"value": 2, "name": "2022"},
    {"value": 3, "name": "2021"},
    {"value": 4, "name": "2020"},
  ];

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // elevation: 4,
      // borderRadius: BorderRadiusDirectional.circular(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 495,
          maxWidth: 495,
        ),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: platinum,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Business Unit Selection',
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Wrap(
              spacing: 20,
              runSpacing: 15,
              children: businessUnit
                  .asMap()
                  .map((key, value) => MapEntry(
                      key,
                      BusinessUnitSelection(
                        businessUnit: value,
                      )))
                  .values
                  .toList(),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Area Setting',
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            BlackDropdown(
              width: double.infinity,
              items: areaList
                  .map((e) => DropdownMenuItem(
                        value: e["value"],
                        child: Text(
                          e["name"],
                          style: helveticaText.copyWith(),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedArea = value;
                setState(() {});
              },
              hintText: "Choose Area",
              suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
              value: selectedArea,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Time Setting',
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                SizedBox(
                  width: 250,
                  child: BlackDropdown(
                    items: monthList
                        .map((e) => DropdownMenuItem(
                              value: e["value"],
                              child: Text(
                                e["name"],
                                style: helveticaText.copyWith(),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedMonth = value;
                      setState(() {});
                    },
                    hintText: "Choose Area",
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                    value: selectedMonth,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: BlackDropdown(
                      items: yearList
                          .map((e) => DropdownMenuItem(
                                value: e["value"],
                                child: Text(
                                  e["name"],
                                  style: helveticaText.copyWith(),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedYear = value;
                        setState(() {});
                      },
                      hintText: "Choose Area",
                      suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                      value: selectedYear,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TransparentButtonBlack(
                  text: "Cancel",
                  disabled: false,
                  onTap: () {
                    Navigator.of(context).pop(0);
                  },
                  padding: ButtonSize().mediumSize(),
                ),
                const SizedBox(
                  width: 10,
                ),
                RegularButton(
                  text: "Apply",
                  disabled: false,
                  onTap: () {
                    globalModel.setMonth(selectedMonth.toString());
                    globalModel.setYear(selectedYear.toString());
                  },
                  padding: ButtonSize().mediumSize(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BusinessUnitSelection extends StatelessWidget {
  BusinessUnitSelection({super.key, BusinessUnit? businessUnit})
      : businessUnit = businessUnit ?? BusinessUnit();

  BusinessUnit businessUnit;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: platinum,
            width: 1,
          ),
        ),
        child: businessUnit.photo == ""
            ? const SizedBox()
            // : CachedNetworkImage(
            //     imageUrl: businessUnit.photo,
            //   ),
            : Image.asset(
                businessUnit.photo,
                fit: BoxFit.contain,
              ));
  }
}
