import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/attachment_files.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';

class ApproveDialogSuppliesReq extends StatefulWidget {
  ApproveDialogSuppliesReq({
    super.key,
    Transaction? transaction,
  }) : transaction = transaction ?? Transaction();

  Transaction transaction;

  @override
  State<ApproveDialogSuppliesReq> createState() =>
      _ApproveDialogSuppliesReqState();
}

class _ApproveDialogSuppliesReqState extends State<ApproveDialogSuppliesReq> {
  TextEditingController _comment = TextEditingController();

  ApiService apiService = ApiService();

  String comment = "";

  List<Attachment> attachment = [];

  bool isLoading = false;

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
                    'Do you want to confirm this request?',
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
                          activity: widget.transaction.activity,
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
                          if (!isLoading) {
                            Navigator.of(context).pop(0);
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      isLoading
                          ? const CircularProgressIndicator(
                              color: eerieBlack,
                            )
                          : RegularButton(
                              text: 'Confirm',
                              disabled: false,
                              padding: ButtonSize().mediumSize(),
                              onTap: () {
                                isLoading = true;
                                setState(() {});
                                formKey.currentState!.save();
                                widget.transaction.activity
                                    .add(TransactionActivity());
                                widget.transaction.activity.first.comment =
                                    comment
                                        .replaceAll("\n", "\\n")
                                        .replaceAll('"', '\\"');

                                for (var element in attachment) {
                                  widget.transaction.activity.first
                                      .submitAttachment
                                      .add('"${element.file}"');
                                }

                                print(widget.transaction);
                                apiService
                                    .approveSuppliesRequest(widget.transaction)
                                    .then((value) {
                                  isLoading = false;
                                  setState(() {});
                                  if (value["Status"].toString() == "200") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                        isSuccess: true,
                                      ),
                                    ).then((value) {
                                      Navigator.of(context).pop(1);
                                    });
                                  } else if (value["Status"].toString() ==
                                      "401") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                        isSuccess: false,
                                      ),
                                    );
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
                                  isLoading = false;
                                  setState(() {});
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const AlertDialogBlack(
                                      title: "Error submitSuppliesRequest",
                                      contentText: "No internet connection",
                                      isSuccess: false,
                                    ),
                                  );
                                });
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
          'Approval Confirmation',
          style: dialogTitleText,
        ),
        Text(
          '${widget.transaction.month} - ${widget.transaction.formId}',
          style: dialogFormNumberText,
        )
      ],
    );
  }
}
