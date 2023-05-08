import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class AddAreaDialog extends StatefulWidget {
  AddAreaDialog({
    super.key,
    Area? area,
    this.isEdit = false,
  }) : area = area ?? Area();

  Area area;
  bool isEdit;

  @override
  State<AddAreaDialog> createState() => _AddAreaDialogState();
}

class _AddAreaDialogState extends State<AddAreaDialog> {
  TextEditingController _areaName = TextEditingController();

  final formKey = GlobalKey<FormFieldState>();

  String areaName = "";
  String selectedRegion = "";

  List regionList = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 522,
          minWidth: 522,
        ),
        padding: const EdgeInsets.only(
          right: 40,
          left: 40,
          bottom: 30,
          top: 35,
        ),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Area Data",
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
                'Create or edit area information',
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
                "Area Name",
                widget: Expanded(
                  child: BlackInputField(
                    controller: _areaName,
                    enabled: true,
                    hintText: 'Area name here ...',
                    onSaved: (newValue) {
                      areaName = newValue.toString();
                    },
                    maxLines: 1,
                    validator: (value) =>
                        value == "" ? "This field is required" : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                "Region",
                widget: SizedBox(
                  width: 250,
                  child: BlackDropdown(
                    items: regionList
                        .map(
                          (e) => const DropdownMenuItem(
                            child: Text(""),
                          ),
                        )
                        .toList(),
                    hintText: "Choose region",
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                    ),
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
                            contentText: "Are you sure to add / edit Area?"),
                      ).then((value) {});
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
        SizedBox(
          width: 125,
          child: Padding(
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
        ),
        widget!,
      ],
    );
  }
}
