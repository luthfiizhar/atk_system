import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionListContainer extends StatefulWidget {
  TransactionListContainer({
    super.key,
    Transaction? transaction,
    this.index = 0,
    this.close,
    this.onClick,
  }) : transaction = transaction ?? Transaction();

  Transaction transaction;
  int index;
  Function? close;
  Function? onClick;

  @override
  State<TransactionListContainer> createState() =>
      _TransactionListContainerState();
}

class _TransactionListContainerState extends State<TransactionListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index == 0
            ? const SizedBox()
            : const Divider(
                color: davysGray,
                thickness: 0.5,
              ),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.transaction.isExpanded) {
              widget.close!(widget.index);
            } else {
              widget.onClick!(widget.index);
            }
          },
          child: Container(
            padding: widget.index == 0
                ? const EdgeInsets.only(
                    bottom: 18,
                  )
                : const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.transaction.formId,
                        style: bodyTableNormalText,
                      ),
                    ),
                    SizedBox(
                      width: 165,
                      child: Text(
                        widget.transaction.category,
                        style: bodyTableLightText,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.transaction.location,
                        style: bodyTableLightText,
                      ),
                    ),
                    SizedBox(
                      width: 165,
                      child: Text(
                        widget.transaction.created,
                        style: bodyTableLightText,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.transaction.status,
                        style: bodyTableLightText,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: widget.transaction.isExpanded
                          ? const Icon(
                              Icons.keyboard_arrow_down_sharp,
                            )
                          : const Icon(
                              Icons.keyboard_arrow_right_sharp,
                            ),
                    ),
                  ],
                ),
                widget.transaction.isExpanded
                    ? Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TransparentBorderedBlackButton(
                                text: 'Detail',
                                disabled: false,
                                fontWeight: FontWeight.w700,
                                padding: ButtonSize().mediumSize(),
                                onTap: () {},
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              RegularButton(
                                text: 'Approve',
                                disabled: false,
                                padding: ButtonSize().mediumSize(),
                                onTap: () {
                                  context.goNamed(
                                    'approval_request',
                                    params: {
                                      "formId": widget.transaction.formId,
                                    },
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
