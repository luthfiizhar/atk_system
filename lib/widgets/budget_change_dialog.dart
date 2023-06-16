import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/attachment_files.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class BudgetChangeDialog extends StatefulWidget {
  BudgetChangeDialog({super.key, Site? site}) : site = site ?? Site();

  Site site;

  @override
  State<BudgetChangeDialog> createState() => _BudgetChangeDialogState();
}

class _BudgetChangeDialogState extends State<BudgetChangeDialog> {
  TextEditingController _comment = TextEditingController();

  ApiService apiService = ApiService();

  String comment = "";

  List<Attachment> attachment = [];

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 805,
          maxWidth: 805,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 40,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  titleSection(),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Do you want to change budget for this site?',
                    style: helveticaText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 450,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Comment",
                              style: helveticaText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: eerieBlack,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            BlackInputField(
                              controller: _comment,
                              enabled: true,
                              maxLines: 4,
                              hintText: "Comment here ...",
                              onSaved: (newValue) {
                                comment = newValue.toString();
                              },
                              validator: (value) => value == ""
                                  ? "Please input your invoice numbere here."
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: AttachmentFiles(
                          files: attachment,
                          activity: widget.site.activity,
                          isSingleFile: true,
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
                        text: 'Cancel',
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
                        text: 'Confirm',
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          if (attachment.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialogBlack(
                                title: "Failed",
                                contentText:
                                    "Please attach your transaction bills.",
                                isSuccess: false,
                              ),
                            );
                          } else {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              showDialog(
                                context: context,
                                builder: (context) => const ConfirmDialogBlack(
                                  title: 'Confirmation',
                                  contentText:
                                      'Are you sure to edit site budget?',
                                ),
                              ).then((value) {
                                if (value == 1) {
                                  widget.site.note = comment;
                                  widget.site.activity
                                      .add(TransactionActivity());
                                  widget.site.activity.first.comment = comment;

                                  for (var element in attachment) {
                                    widget.site.activity.first.submitAttachment
                                        .add('"${element.file}"');
                                  }
                                  Navigator.of(context).pop(1);
                                }
                              });
                            }
                          }
                        },
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

  Widget titleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Budget Change Confirmation',
          style: dialogTitleText,
        ),
        // Text(
        //   '${widget.transaction.month} - ${widget.transaction.formId}',
        //   style: dialogFormNumberText,
        // )
      ],
    );
  }
}
