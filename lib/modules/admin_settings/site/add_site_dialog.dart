import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSiteDialog extends StatefulWidget {
  AddSiteDialog({
    super.key,
    Site? site,
    this.isEdit = false,
  }) : site = site ?? Site();

  Site site;
  bool isEdit;
  @override
  State<AddSiteDialog> createState() => _AddSiteDialogState();
}

class _AddSiteDialogState extends State<AddSiteDialog> {
  ApiService apiService = ApiService();
  final formKey = GlobalKey<FormState>();

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

  String siteId = "";
  String siteName = "";
  int siteArea = 0;
  int monthlyBudget = 0;
  int additionalBudget = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      widget.site.oldSiteId = widget.site.siteId;
      _siteId.text = widget.site.siteId;
      _siteName.text = widget.site.siteName;
      // _siteArea.text = widget.site.siteArea.toString();
      // _monthlyBudget.text = widget.site.monthlyBudget.toString();
      // _additionalBudget.text = widget.site.additionalBudget.toString();
      _siteArea.value = ThousandsSeparatorInputFormatter().formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(
            text: widget.site.siteArea.toString(),
          ));
      _monthlyBudget.value =
          ThousandsSeparatorInputFormatter().formatEditUpdate(
              TextEditingValue.empty,
              TextEditingValue(
                text: widget.site.monthlyBudget.toString(),
              ));
      _additionalBudget.value =
          ThousandsSeparatorInputFormatter().formatEditUpdate(
              TextEditingValue.empty,
              TextEditingValue(
                text: widget.site.additionalBudget.toString(),
              ));
    } else {
      _monthlyBudget.text = "0";
      _additionalBudget.text = "0";
      _siteArea.text = "0";
    }

    _monthlyBudget.addListener(() {
      if (_monthlyBudget.text == "") {
        _monthlyBudget.text = "0";
        _monthlyBudget.selection = TextSelection.fromPosition(
            TextPosition(offset: _monthlyBudget.text.length));
      }
      setState(() {});
    });
    _additionalBudget.addListener(() {
      if (_additionalBudget.text == "") {
        _additionalBudget.text = "0";
        _additionalBudget.selection = TextSelection.fromPosition(
            TextPosition(offset: _additionalBudget.text.length));
      }
      setState(() {});
    });
    _siteArea.addListener(() {
      if (_siteArea.text == "") {
        _siteArea.text = "0";
        _siteArea.selection = TextSelection.fromPosition(
            TextPosition(offset: _siteArea.text.length));
      }
      setState(() {});
    });
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              right: 40,
              left: 40,
              top: 35,
              bottom: 30,
            ),
            child: Form(
              key: formKey,
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
                        focusNode: siteIdNode,
                        enabled: true,
                        hintText: 'ID here...',
                        maxLines: 1,
                        validator: (value) =>
                            value == "" ? "This field is required." : null,
                        onSaved: (newValue) {
                          siteId = newValue.toString();
                        },
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
                        focusNode: siteNameNode,
                        enabled: true,
                        hintText: 'Name here...',
                        maxLines: 1,
                        validator: (value) =>
                            value == "" ? "This field is required." : null,
                        onSaved: (newValue) {
                          siteName = newValue.toString();
                        },
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
                        focusNode: siteAreaNode,
                        enabled: true,
                        hintText: 'Area here...',
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp(
                                  r'^0+') //users can't type 0 at 1st position
                              ),
                          ThousandsSeparatorInputFormatter()
                        ],
                        validator: (value) =>
                            value == "0" ? "This field is required." : null,
                        onSaved: (newValue) {
                          siteArea = int.parse(
                              newValue.toString().replaceAll(".", ""));
                        },
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
                        focusNode: monthlyBudgetNode,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp(
                                  r'^0+') //users can't type 0 at 1st position
                              ),
                          ThousandsSeparatorInputFormatter()
                        ],
                        validator: (value) =>
                            value == "0" ? "This field is required." : null,
                        onSaved: (newValue) {
                          monthlyBudget = int.parse(
                              newValue.toString().replaceAll(".", ""));
                        },
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
                        focusNode: additionalBudgetNode,
                        enabled: true,
                        hintText: 'Budget here...',
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp(
                                  r'^0+') //users can't type 0 at 1st position
                              ),
                          ThousandsSeparatorInputFormatter()
                        ],
                        validator: (value) =>
                            value == "0" ? "This field is required." : null,
                        onSaved: (newValue) {
                          additionalBudget = int.parse(
                              newValue.toString().replaceAll(".", ""));
                        },
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
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        padding: ButtonSize().mediumSize(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RegularButton(
                        text: 'Confirm',
                        disabled: false,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            showDialog(
                              context: context,
                              builder: (context) => const ConfirmDialogBlack(
                                title: 'Confirmation',
                                contentText: 'Are you sure to add / edit site?',
                              ),
                            ).then((value) {
                              if (value) {
                                Site saveSite = Site();
                                saveSite.siteId = siteId;
                                saveSite.siteName = siteName;
                                saveSite.siteArea = siteArea;
                                saveSite.monthlyBudget = monthlyBudget;
                                saveSite.additionalBudget = additionalBudget;
                                if (widget.isEdit) {
                                  saveSite.oldSiteId = widget.site.oldSiteId;
                                  apiService.updateSite(saveSite).then((value) {
                                    if (value['Status'].toString() == "200") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogBlack(
                                          title: value['Title'],
                                          contentText: value['Message'],
                                        ),
                                      ).then((value) {
                                        Navigator.of(context).pop(true);
                                      });
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
                                  }).onError((error, stackTrace) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const AlertDialogBlack(
                                        title: "Erro updateSite",
                                        contentText: "No internet connection",
                                        isSuccess: false,
                                      ),
                                    );
                                  });
                                } else {
                                  apiService.addSite(saveSite).then((value) {
                                    if (value['Status'].toString() == "200") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogBlack(
                                          title: value['Title'],
                                          contentText: value['Message'],
                                        ),
                                      ).then((value) {
                                        Navigator.of(context).pop(true);
                                      });
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
                                  }).onError((error, stackTrace) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const AlertDialogBlack(
                                        title: "Erro addSite",
                                        contentText: "No internet connection",
                                        isSuccess: false,
                                      ),
                                    );
                                  });
                                }
                              }
                            });
                          }
                        },
                        padding: ButtonSize().mediumSize(),
                      )
                    ],
                  )
                ],
              ),
            ),
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
