import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/attachment_files.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: AttachmentFiles(),
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
                      onTap: () {},
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RegularButton(
                      text: 'Confirm',
                      disabled: false,
                      padding: ButtonSize().mediumSize(),
                      onTap: () {},
                    )
                  ],
                )
              ],
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
          'October - H001REGM102201',
          style: dialogFormNumberText,
        )
      ],
    );
  }
}
