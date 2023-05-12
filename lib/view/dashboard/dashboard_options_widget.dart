import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardOptionsWidget extends StatefulWidget {
  const DashboardOptionsWidget({super.key});

  @override
  State<DashboardOptionsWidget> createState() => _DashboardOptionsWidgetState();
}

class _DashboardOptionsWidgetState extends State<DashboardOptionsWidget> {
  ApiService apiService = ApiService();
  late GlobalModel globalModel;
  List<BusinessUnit> businessUnit = [];
  String selectedBusinessUnit = "";
  String selectedRole = "";
  String selectedAreaName = "";
  String initRole = "";
  String initArea = "";
  String initBu = "";

  String selectedArea = "";
  List areaList = [
    {"value": 1, "name": "All Indonesia Region"},
    {"value": 2, "name": "Region ABC"},
    {"value": 3, "name": "Area ABC"},
    {"value": 4, "name": "Store ABC"}
  ];

  String selectedMonthName = "";
  String selectedMonth = "Jan";
  List monthList = [];

  String selectedYearName = "";
  String selectedYear = "2023";
  List yearList = [];

  TextEditingController _area = TextEditingController();
  OverlayEntry? areaOverlayEntry;
  GlobalKey areaKey = GlobalKey();
  LayerLink areaLayerLink = LayerLink();
  bool isOverlayAreaOpen = false;

  onClickArea(String id, String name, String role) {
    selectedArea = id;
    _area.text = name;
    selectedRole = role;
    selectedAreaName = name;
  }

  OverlayEntry areaOverlay() {
    RenderBox? renderBox =
        areaKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Stack(
              children: [
                ModalBarrier(
                  onDismiss: () {
                    if (isOverlayAreaOpen) {
                      if (areaOverlayEntry!.mounted) {
                        areaOverlayEntry!.remove();
                      }
                      // areaNode.unfocus();
                      isOverlayAreaOpen = false;
                    }
                  },
                ),
                Positioned(
                  // left: offset.dx,
                  // top: offset.dy + size.height + 10,
                  width: size.width,
                  child: CompositedTransformFollower(
                    showWhenUnlinked: false,
                    offset: Offset(0.0, size.height + 5.0),
                    link: areaLayerLink,
                    child: Material(
                      elevation: 4.0,
                      color: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AreaSettingContainer(
                        onClick: onClickArea,
                        closeOverlay: closeOverlay,
                        initArea: initArea,
                        initBU: initBu,
                        initRole: initRole,
                      ),
                    ),
                  ),
                ),
              ],
            ));
  }

  initBusinessUnitList() {
    apiService.dashboardOptBusinessUnitList().then((value) {
      if (value["Status"].toString() == "200") {
        List result = value["Data"];

        for (var element in result) {
          businessUnit.add(
            BusinessUnit(
                name: element["CompanyName"],
                businessUnitId: element["ID"].toString(),
                photo: element["CompanyLogo"]),
          );
        }
        for (var element in businessUnit) {
          if (element.businessUnitId == globalModel.businessUnit) {
            element.isSelected = true;
          }
        }
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
      setState(() {});
    }).onError((error, stackTrace) {});
  }

  selectBu(String id) {
    for (var element in businessUnit) {
      element.isSelected = false;
    }

    for (var element in businessUnit) {
      if (element.businessUnitId == id) {
        element.isSelected = true;
        selectedBusinessUnit = id.toString();
      }
    }
    print(selectedBusinessUnit);
    setState(() {});
  }

  closeOverlay() {
    if (isOverlayAreaOpen) {
      if (areaOverlayEntry!.mounted) {
        areaOverlayEntry!.remove();
      }
      // areaNode.unfocus();
      isOverlayAreaOpen = false;
    }
  }

  initMonthList() {
    apiService.dashboardOptMonthList(globalModel.businessUnit).then((value) {
      if (value["Status"].toString() == "200") {
        monthList = value["Data"];
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
      setState(() {});
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: "Error getMonthList",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  initYearList() {
    apiService.dashboardOptYearList(globalModel.businessUnit).then((value) {
      if (value["Status"].toString() == "200") {
        yearList = value["Data"];
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
      setState(() {});
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: "Error getMonthList",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    initBusinessUnitList();
    initMonthList();
    initYearList();
    _area.text = globalModel.initAreaName;
    selectedBusinessUnit = globalModel.businessUnit;
    selectedRole = globalModel.role;
    selectedMonth = globalModel.month;
    selectedYear = globalModel.year;
    selectedArea = globalModel.areaId;
    initRole = globalModel.initRole;
    initArea = globalModel.initAreaId;
    initBu = globalModel.initBusinessUnit;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // elevation: 4,
      // borderRadius: BorderRadiusDirectional.circular(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          if (isOverlayAreaOpen) {
            if (areaOverlayEntry!.mounted) {
              areaOverlayEntry!.remove();
            }
            // areaNode.unfocus();
            isOverlayAreaOpen = false;
          }
        },
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
                          selectBu: selectBu,
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
              Container(
                key: areaKey,
                // onTap: () {},
                child: CompositedTransformTarget(
                  link: areaLayerLink,
                  child: CustomInputField(
                    controller: _area,
                    // focusNode: siteNode,
                    enabled: true,
                    hintText: 'Choose Site',
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: eerieBlack,
                    ),
                    onTap: () {
                      if (isOverlayAreaOpen) {
                        isOverlayAreaOpen = false;
                        if (areaOverlayEntry!.mounted) {
                          areaOverlayEntry!.remove();
                        }
                      } else {
                        areaOverlayEntry = areaOverlay();
                        Overlay.of(context).insert(areaOverlayEntry!);
                        isOverlayAreaOpen = true;
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
              // BlackDropdown(
              //   width: double.infinity,
              //   items: areaList
              //       .map((e) => DropdownMenuItem(
              //             value: e["value"],
              //             child: Text(
              //               e["name"],
              //               style: helveticaText.copyWith(),
              //             ),
              //           ))
              //       .toList(),
              //   onChanged: (value) {
              //     selectedArea = value;
              //     setState(() {});
              //   },
              //   hintText: "Choose Area",
              //   suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
              //   value: selectedArea,
              // ),
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
                      maxHeight: 300,
                      items: monthList
                          .map((e) => DropdownMenuItem(
                                value: e["MonthName"],
                                child: Text(
                                  e["MonthFullName"],
                                  style: helveticaText.copyWith(),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedMonth = value;
                        setState(() {});
                      },
                      hintText: "Choose Month",
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
                                  value: e["Year"].toString(),
                                  child: Text(
                                    e["Year"].toString(),
                                    style: helveticaText.copyWith(),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          selectedYear = value.toString();
                          setState(() {});
                        },
                        hintText: "Choose Year",
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
                      globalModel.setBusinessUnit(selectedBusinessUnit);
                      globalModel.setMonth(selectedMonth.toString());
                      globalModel.setYear(selectedYear.toString());
                      globalModel.setAreaId(selectedArea.toString());
                      globalModel.setRole(selectedRole.toString());
                      globalModel.setAreaName(selectedAreaName.toString());
                      Navigator.of(context).pop();
                    },
                    padding: ButtonSize().mediumSize(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BusinessUnitSelection extends StatelessWidget {
  BusinessUnitSelection({
    super.key,
    BusinessUnit? businessUnit,
    this.selectBu,
  }) : businessUnit = businessUnit ?? BusinessUnit();

  BusinessUnit businessUnit;
  Function? selectBu;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        selectBu!(businessUnit.businessUnitId);
      },
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: businessUnit.isSelected ? greenAcent : platinum,
            width: 1,
          ),
        ),
        child: businessUnit.photo == ""
            ? const SizedBox()
            : CachedNetworkImage(
                imageUrl: businessUnit.photo,
                fit: BoxFit.contain,
              ),
        // : Image.asset(
        //     businessUnit.photo,
        //     fit: BoxFit.contain,
        //   ),
      ),
    );
  }
}

class AreaSettingContainer extends StatefulWidget {
  AreaSettingContainer({
    super.key,
    Function? onClick,
    Function? closeOverlay,
    this.initRole = "",
    this.initBU = "",
    this.initArea = "",
    this.maxWidth = 200,
  })  : onClick = onClick ?? (() {}),
        closeOverlay = closeOverlay ?? (() {});

  Function onClick;
  Function closeOverlay;
  double maxWidth;
  String initRole;
  String initBU;
  String initArea;

  @override
  State<AreaSettingContainer> createState() => _AreaSettingContainerState();
}

class _AreaSettingContainerState extends State<AreaSettingContainer> {
  ApiService apiService = ApiService();
  late GlobalModel globalModel;
  TextEditingController _search = TextEditingController();
  List areaList = [];

  getData() {
    apiService
        .dashboardOptAreaList(
            widget.initRole, widget.initArea, widget.initBU, _search.text)
        .then((value) {
      if (value["Status"].toString() == "200") {
        areaList = value["Data"];
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
      setState(() {});
    }).onError((error, stackTrace) {});
  }

  search() {
    getData();
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 200,
        maxWidth: 500,
        maxHeight: 300,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 25,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _search,
            cursorColor: davysGray,
            onFieldSubmitted: (value) {
              search();
            },
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: sonicSilver, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: sonicSilver,
                    width: 0.5,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  weight: 300,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 0,
                ),
                hintText: 'Search here ...',
                hintStyle: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: sonicSilver,
                )),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: areaList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: InkWell(
                          onTap: () {
                            widget.onClick(
                                areaList[index]["ID"],
                                areaList[index]["Name"],
                                areaList[index]["Role"]);
                            widget.closeOverlay();
                          },
                          child: Text(
                            areaList[index]["Name"],
                            style: helveticaText.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
