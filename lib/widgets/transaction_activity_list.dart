import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:flutter/material.dart';

class TransactionActivityListContainer extends StatelessWidget {
  TransactionActivityListContainer({
    super.key,
    TransactionActivity? transactionActivity,
    this.index = 0,
  }) : transactionActivity = transactionActivity ?? TransactionActivity();

  TransactionActivity transactionActivity;
  int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        index == 0
            ? const SizedBox()
            : const SizedBox(
                height: 30,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: sonicSilver,
              ),
              child: Center(
                child: Text(
                  transactionActivity.empName.characters.first,
                  style: helveticaText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: white,
                    height: 1.15,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactionActivity.empName,
                    style: helveticaText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${transactionActivity.status} - ${transactionActivity.date}",
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: sonicSilver,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Comment: ',
                      style: helveticaText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: davysGray,
                        height: 1.38,
                      ),
                      children: [
                        TextSpan(
                          text: transactionActivity.comment,
                          style: helveticaText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: davysGray,
                            height: 1.38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class AttachmentTransactionItem extends StatefulWidget {
  AttachmentTransactionItem({
    super.key,
    Attachment? attachment,
  }) : attachment = attachment ?? Attachment();

  Attachment attachment;

  @override
  State<AttachmentTransactionItem> createState() =>
      _AttachmentTransactionItemState();
}

class _AttachmentTransactionItemState extends State<AttachmentTransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
