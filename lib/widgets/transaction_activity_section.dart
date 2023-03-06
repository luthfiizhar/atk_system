import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/transaction_activity_list.dart';
import 'package:flutter/material.dart';

class TransactionActivitySection extends StatelessWidget {
  TransactionActivitySection({
    super.key,
    List<TransactionActivity>? transactionActivity,
  }) : transactionActivity = transactionActivity ?? [];

  List<TransactionActivity> transactionActivity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Transaction Activity',
          style: helveticaText.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          itemCount: transactionActivity.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return TransactionActivityListContainer(
              index: index,
              transactionActivity: transactionActivity[index],
            );
          },
        ),
      ],
    );
  }
}
