import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:flutter/material.dart';

class TransactionInfoSection extends StatelessWidget {
  TransactionInfoSection({
    super.key,
    this.title = "Order Supplies",
    Transaction? transaction,
  }) : transaction = transaction ?? Transaction();

  String title;
  Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$title - ${transaction.month} - ${transaction.formId}',
          style: helveticaText.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: eerieBlack,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            text: 'Site: ',
            style: infoTextLight,
            children: [
              TextSpan(
                text: transaction.siteName,
                style: infoTextBold,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
            text: 'Site Area: ',
            style: infoTextLight,
            children: [
              TextSpan(
                text: '${transaction.siteArea} m2',
                style: infoTextBold,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
            text: 'Status: ',
            style: infoTextLight,
            children: [
              TextSpan(
                text: transaction.status,
                style: infoTextBold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
