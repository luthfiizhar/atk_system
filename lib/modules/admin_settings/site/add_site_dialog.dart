import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class AddSiteDialog extends StatefulWidget {
  const AddSiteDialog({super.key});

  @override
  State<AddSiteDialog> createState() => _AddSiteDialogState();
}

class _AddSiteDialogState extends State<AddSiteDialog> {
  TextEditingController _siteId = TextEditingController();
  TextEditingController _siteName = TextEditingController();
  TextEditingController _siteArea = TextEditingController();
  TextEditingController _monthlyBudget = TextEditingController();
  TextEditingController _additionalBudget = TextEditingController();

  FocusNode siteIdNode = FocusNode();
  FocusNode siteNameNode = FocusNode();
  FocusNode siteAreaNode = FocusNode();
  FocusNode monthlyBudgetNode = FocusNode();
  FocusNode additionalBudgetNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    siteIdNode.removeListener(() {});
    siteNameNode.removeListener(() {});
    siteAreaNode.removeListener(() {});
    monthlyBudgetNode.removeListener(() {});
    additionalBudgetNode.removeListener(() {});

    siteIdNode.dispose();
    siteNameNode.dispose();
    siteAreaNode.dispose();
    monthlyBudgetNode.dispose();
    additionalBudgetNode.dispose();

    _siteId.dispose();
    _siteName.dispose();
    _siteArea.dispose();
    _monthlyBudget.dispose();
    _additionalBudget.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 500,
          minWidth: 780,
          maxWidth: 780,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            right: 40,
            left: 40,
            top: 35,
            bottom: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Site Data",
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
                'Create or edit site data',
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
                'Site ID',
                widget: SizedBox(
                  width: 200,
                  child: BlackInputField(
                    controller: _siteId,
                    enabled: true,
                    hintText: 'ID here...',
                    maxLines: 1,
                    validator: (value) =>
                        value == "" ? "This field is required." : null,
                    onSaved: (newValue) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                'Site Name',
                widget: Flexible(
                  flex: 1,
                  child: BlackInputField(
                    controller: _siteName,
                    enabled: true,
                    hintText: 'Name here...',
                    maxLines: 1,
                    validator: (value) =>
                        value == "" ? "This field is required." : null,
                    onSaved: (newValue) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                'Site Area (m2)',
                widget: SizedBox(
                  width: 200,
                  child: BlackInputField(
                    controller: _siteArea,
                    enabled: true,
                    hintText: 'Area here...',
                    maxLines: 1,
                    validator: (value) =>
                        value == "" ? "This field is required." : null,
                    onSaved: (newValue) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                'Monthly Budget',
                widget: SizedBox(
                  width: 300,
                  child: BlackInputField(
                    controller: _monthlyBudget,
                    prefixIcon: SizedBox(
                      child: Center(
                        widthFactor: 0.0,
                        child: Text(
                          'Rp',
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: eerieBlack,
                          ),
                        ),
                      ),
                    ),
                    enabled: true,
                    hintText: 'Budget here...',
                    maxLines: 1,
                    validator: (value) =>
                        value == "" ? "This field is required." : null,
                    onSaved: (newValue) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                'Additional Budget',
                widget: SizedBox(
                  width: 300,
                  child: BlackInputField(
                    // prefix: Text('Rp'),
                    // prefixText: 'Rp',
                    prefixIcon: SizedBox(
                      child: Center(
                        widthFactor: 0.0,
                        child: Text(
                          'Rp',
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: eerieBlack,
                          ),
                        ),
                      ),
                    ),
                    controller: _additionalBudget,
                    enabled: true,
                    hintText: 'Budget here...',
                    maxLines: 1,
                    validator: (value) =>
                        value == "" ? "This field is required." : null,
                    onSaved: (newValue) {},
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
                    text: 'Cancel',
                    disabled: false,
                    onTap: () {},
                    padding: ButtonSize().mediumSize(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RegularButton(
                    text: 'Confirm',
                    disabled: false,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ConfirmDialogBlack(
                          title: 'Confirmation',
                          contentText: 'Are you sure to add / edit site?',
                        ),
                      );
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

  Widget inputField(String label, {Widget? widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 50,
          ),
          child: SizedBox(
            width: 150,
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
