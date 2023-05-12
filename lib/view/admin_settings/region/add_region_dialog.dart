import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class AddRegionDialog extends StatefulWidget {
  AddRegionDialog({super.key, Region? region, this.isEdit = false})
      : region = region ?? Region();

  Region region;
  bool isEdit;

  @override
  State<AddRegionDialog> createState() => _AddRegionDialogState();
}

class _AddRegionDialogState extends State<AddRegionDialog> {
  ApiService apiService = ApiService();
  TextEditingController _regionName = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String regionName = "";

  List businessUnitList = [];
  int selectedBusinessUnit = 1;

  getBUList() {
    apiService.getBUListDropdown().then((value) {
      if (value["Status"].toString() == "200") {
        businessUnitList = value["Data"];
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
          title: "Error getBUList",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBUList();
    if (widget.isEdit) {
      _regionName.text = widget.region.regionName;
      selectedBusinessUnit = int.parse(widget.region.businessUnitID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 540,
          maxWidth: 540,
        ),
        padding: const EdgeInsets.only(
          left: 40,
          right: 40,
          top: 35,
          bottom: 30,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Region Data",
                style: helveticaText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: eerieBlack,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Create or edit region data',
                style: helveticaText.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              inputField(
                "Region Name",
                widget: Expanded(
                  child: BlackInputField(
                    controller: _regionName,
                    enabled: true,
                    hintText: "Region name here ...",
                    maxLines: 1,
                    onSaved: (newValue) {
                      regionName = newValue.toString();
                    },
                    validator: (value) =>
                        value == "" ? "This field is required" : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              inputField(
                "Business Unit",
                widget: Expanded(
                  child: BlackDropdown(
                    items: businessUnitList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e["ID"],
                            child: Text(
                              e["CompanyName"],
                              style: helveticaText.copyWith(),
                            ),
                          ),
                        )
                        .toList(),
                    hintText: "Choose business unit",
                    onChanged: (value) {
                      selectedBusinessUnit = value;
                      setState(() {});
                    },
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
                    enabled: true,
                    value: widget.isEdit ? selectedBusinessUnit : null,
                    validator: (value) =>
                        value == null ? "This field is required" : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TransparentButtonBlack(
                    text: "Cancel",
                    disabled: false,
                    padding: ButtonSize().mediumSize(),
                    onTap: () {
                      Navigator.of(context).pop(0);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RegularButton(
                    text: "Confirm",
                    disabled: false,
                    padding: ButtonSize().mediumSize(),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ConfirmDialogBlack(
                            title: "Confirmation",
                            contentText: "Are you sure to add / edit Region?"),
                      ).then((value) {
                        if (value == 1) {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            Region regionData = Region();
                            regionData
                              ..regionName = regionName
                              ..businessUnitID =
                                  selectedBusinessUnit.toString();
                            if (widget.isEdit) {
                              regionData.regionId = widget.region.regionId;
                              apiService.updateRegion(regionData).then((value) {
                                if (value["Status"].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value["Title"],
                                      contentText: value["Message"],
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pop(1);
                                  });
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
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialogBlack(
                                    title: "Error addRegion",
                                    contentText: error.toString(),
                                    isSuccess: false,
                                  ),
                                );
                              });
                            } else {
                              apiService.addRegion(regionData).then((value) {
                                if (value["Status"].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value["Title"],
                                      contentText: value["Message"],
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pop(1);
                                  });
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
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialogBlack(
                                    title: "Error addRegion",
                                    contentText: error.toString(),
                                    isSuccess: false,
                                  ),
                                );
                              });
                            }
                          }
                        }
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField(String label, {Widget? widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 50,
          ),
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
        ),
        widget!,
      ],
    );
  }
}
