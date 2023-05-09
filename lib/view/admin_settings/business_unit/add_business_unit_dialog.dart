import 'dart:convert';

import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddBusinessUnitDialog extends StatefulWidget {
  AddBusinessUnitDialog({
    super.key,
    BusinessUnit? businessUnit,
    this.isEdit = false,
  }) : businessUnit = businessUnit ?? BusinessUnit();
  BusinessUnit businessUnit;
  bool isEdit;

  @override
  State<AddBusinessUnitDialog> createState() => _AddBusinessUnitDialogState();
}

class _AddBusinessUnitDialogState extends State<AddBusinessUnitDialog> {
  ApiService apiService = ApiService();
  TextEditingController _businessUnitName = TextEditingController();
  final formKey = GlobalKey<FormState>();

  FocusNode businessUnitNameNode = FocusNode();

  String businessUnitName = "";
  String businessUnitId = "";

  String base64 = "";
  String fileName = "";

  Future getFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      for (var element in result.files) {
        if (element.size > 2097152) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialogBlack(
              title: 'File size to big',
              contentText: 'Please pick files less than 2 MB',
              isSuccess: false,
            ),
          );
          break;
        } else {
          String ext = element.extension!;
          String fileType = "image";
          if (ext == "pdf") {
            fileType = "application";
          }
          base64 =
              "data:$fileType/$ext;base64,${const Base64Encoder().convert(element.bytes!).toString()}";
          fileName = element.name;

          setState(() {});
        }
      }
    } else {
      // User canceled the picker
    }
  }

  remove() {
    base64 = "";
    fileName = "";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _businessUnitName.text = widget.businessUnit.name;
      businessUnitId = widget.businessUnit.businessUnitId;
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
          minWidth: 610,
          maxWidth: 610,
        ),
        padding: const EdgeInsets.only(
          right: 40,
          left: 40,
          bottom: 30,
          top: 35,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Business Unit Data",
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
                'Create or edit business unit information',
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
                "BU Name",
                widget: Expanded(
                  child: BlackInputField(
                    controller: _businessUnitName,
                    focusNode: businessUnitNameNode,
                    enabled: true,
                    hintText: 'Name here ...',
                    maxLines: 1,
                    validator: (value) =>
                        value == "" ? "This field is required" : null,
                    onSaved: (newValue) {
                      businessUnitName = newValue.toString();
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              inputField(
                "BU Photo",
                widget: base64 == ""
                    ? RegularButton(
                        text: "Attach Files",
                        disabled: false,
                        padding: ButtonSize().tableButton(),
                        onTap: () {
                          getFiles();
                        },
                      )
                    : Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        spacing: 10,
                        children: [
                          Text(
                            fileName,
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              remove();
                            },
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
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
                            contentText: "Are you sure to add / edit BU?"),
                      ).then((value) {
                        if (value == 1) {
                          if (formKey.currentState!.validate() &&
                              base64 != "") {
                            formKey.currentState!.save();
                            BusinessUnit businessUnitAdd = BusinessUnit();
                            businessUnitAdd.name = businessUnitName;
                            businessUnitAdd.photo = base64;
                            if (widget.isEdit) {
                              businessUnitAdd.businessUnitId =
                                  widget.businessUnit.businessUnitId;
                              apiService
                                  .updateBusinessUnit(businessUnitAdd)
                                  .then((value) {
                                if (value["Status"].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                        title: value["Title"],
                                        contentText: value["Message"]),
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
                                      title: "Error businessUnitAPI",
                                      contentText: error.toString()),
                                );
                              });
                            } else {
                              apiService
                                  .addBusinessUnit(businessUnitAdd)
                                  .then((value) {
                                if (value["Status"].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                        title: value["Title"],
                                        contentText: value["Message"]),
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
                                      title: "Error businessUnitAPI",
                                      contentText: error.toString()),
                                );
                              });
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialogBlack(
                                title: "Error Empty Photo",
                                contentText: "Please insert business unit logo",
                                isSuccess: false,
                              ),
                            );
                          }
                        }
                      });
                    },
                  ),
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
