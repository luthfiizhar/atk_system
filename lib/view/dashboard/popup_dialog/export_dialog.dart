import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

class ExportDashboardPopup extends StatefulWidget {
  ExportDashboardPopup({super.key, this.dataType = "", s});

  String dataType;

  @override
  State<ExportDashboardPopup> createState() => _ExportDashboardPopupState();
}

class _ExportDashboardPopupState extends State<ExportDashboardPopup> {
  ApiService apiService = ApiService();
  late GlobalModel globalModel;
  int selectedMonth = 1;
  String selectedMonthString = "January";
  List monthOption = [
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

  int selectedYear = 0;
  String selectedYearName = "";
  List yearOption = [];

  download(String string, String fileName) {
    html.AnchorElement anchorElement =
        html.document.createElement('a') as html.AnchorElement;

    anchorElement.href = string;
    anchorElement.download = string.split("/").last;
    anchorElement.style.display = "none";
    anchorElement.target = '_blank';
    anchorElement.setAttribute("download", fileName);
    html.document.body!.children.add(anchorElement);
    anchorElement.click();
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      int yearNow = DateTime.now().year;
      for (var i = 0; i < 4; i++) {
        var year = yearNow - i;
        yearOption.add({"value": i, "name": "$year"});
      }

      selectedYear = 0;
      for (var element in yearOption) {
        if (selectedYear == element["value"]) {
          selectedYearName = element["name"];
        }
      }
      print("Years $yearOption");
      print("initYear index $selectedYear");
      print("initYear name $selectedYearName");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 475,
          maxWidth: 475,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const Icon(
                  Icons.file_download_outlined,
                  color: orangeAccent,
                  size: 26,
                ),
                Text(
                  "Export Data",
                  style: helveticaText.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
              text: TextSpan(
                  text: "Data Type: ",
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: eerieBlack,
                  ),
                  children: [
                    TextSpan(
                      text: widget.dataType,
                      style: helveticaText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: eerieBlack,
                      ),
                    )
                  ]),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Data Period",
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: BlackDropdown(
                    width: 250,
                    enabled: true,
                    items: monthOption.map((e) {
                      return DropdownMenuItem(
                        value: e["value"],
                        child: Text(
                          e["name"],
                          style: helveticaText.copyWith(),
                        ),
                      );
                    }).toList(),
                    hintText: 'Choose',
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                    ),
                    onChanged: (value) {
                      selectedMonth = value;
                      for (var element in monthOption) {
                        if (value == element["value"]) {
                          selectedMonthString = element["name"];
                        }
                      }
                    },
                    value: selectedMonth,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 140,
                  child: BlackDropdown(
                    width: 140,
                    enabled: true,
                    items: yearOption.map((e) {
                      return DropdownMenuItem(
                        value: e["value"],
                        child: Text(
                          e["name"],
                          style: helveticaText.copyWith(),
                        ),
                      );
                    }).toList(),
                    hintText: 'Choose',
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                    ),
                    onChanged: (value) {
                      for (var element in yearOption) {
                        if (value == element["value"]) {
                          selectedYearName = element["name"];
                        }
                      }
                      print(selectedYearName);
                    },
                    value: selectedYear,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TransparentButtonBlack(
                  text: "Close",
                  disabled: false,
                  padding: ButtonSize().mediumSize(),
                  onTap: () {
                    Navigator.of(context).pop(0);
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
                RegularButton(
                  text: "Export",
                  disabled: false,
                  padding: ButtonSize().mediumSize(),
                  onTap: () {
                    apiService
                        .exportDashboard(
                      widget.dataType,
                      selectedMonth.toString(),
                      selectedYearName,
                      globalModel,
                    )
                        .then((value) {
                      if (value["Status"].toString() == "200") {
                        download(
                            value["Data"]["File"], value["Data"]["FileName"]);
                        Navigator.of(context).pop(1);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialogBlack(
                            title: value["Title"],
                            contentText: value["Message"],
                            isSuccess: false,
                          ),
                        );
                      }
                    }).onError((error, stackTrace) {
                      print(error);
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
