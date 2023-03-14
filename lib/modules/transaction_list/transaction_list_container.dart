import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
  ApiService apiService = ApiService();
  String role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService.getUserData().then((value) {
      role = value['Data']['Role'];
      setState(() {});
    });
  }

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
                        widget.transaction.siteName,
                        style: bodyTableLightText,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(
                      width: 165,
                      child: Text(
                        DateFormat('dd MMM yyyy')
                            .format(DateTime.parse(widget.transaction.created)),
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
                                fontSize: 14,
                                text: 'Detail',
                                disabled: false,
                                fontWeight: FontWeight.w700,
                                padding: ButtonSize().tableButton(),
                                onTap: () {
                                  if (widget.transaction.status == "Draft" &&
                                      role == "Store Admin") {
                                    context.goNamed(
                                      'supplies_request',
                                      params: {
                                        "formId": widget.transaction.formId,
                                      },
                                    );
                                  } else {
                                    context.goNamed(
                                      'request_order_detail',
                                      params: {
                                        "formId": widget.transaction.formId,
                                      },
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              widget.transaction.status == "Draft" ||
                                      widget.transaction.status == "Approved"
                                  ? const SizedBox()
                                  : widget.transaction.status ==
                                              "Waiting SM Approval" &&
                                          role != "Store Manager"
                                      ? const SizedBox()
                                      : widget.transaction.status ==
                                                  "Waiting OPS Approval" &&
                                              role != "Operation HO"
                                          ? const SizedBox()
                                          : RegularButton(
                                              text: 'Approve',
                                              fontSize: 14,
                                              disabled: false,
                                              padding:
                                                  ButtonSize().tableButton(),
                                              onTap: () {
                                                if (widget.transaction.status ==
                                                        "Waiting SM Approval" &&
                                                    role == "Store Manager") {
                                                  context.goNamed(
                                                    'approval_request',
                                                    params: {
                                                      "formId": widget
                                                          .transaction.formId,
                                                    },
                                                  );
                                                } else if (widget.transaction
                                                            .status ==
                                                        "Waiting OPS Approval" &&
                                                    role == "Operation HO") {
                                                  context.goNamed(
                                                    'approval_request',
                                                    params: {
                                                      "formId": widget
                                                          .transaction.formId,
                                                    },
                                                  );
                                                } else {
                                                  context.goNamed(
                                                    'request_order_detail',
                                                    params: {
                                                      "formId": widget
                                                          .transaction.formId,
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                              const SizedBox(
                                width: 10,
                              ),
                              widget.transaction.status == "Approved"
                                  ? widget.transaction.settlementStatus ==
                                              "Draft" &&
                                          role != "Store Admin"
                                      ? const SizedBox()
                                      : widget.transaction.settlementStatus ==
                                                  "Waiting SM Approval" &&
                                              role != "Store Manager"
                                          ? const SizedBox()
                                          : widget.transaction
                                                          .settlementStatus ==
                                                      "Waiting OPS Approval" &&
                                                  role != "Operation HO"
                                              ? const SizedBox()
                                              : widget.transaction
                                                          .settlementStatus ==
                                                      "Approved"
                                                  ? const SizedBox()
                                                  : RegularButton(
                                                      fontSize: 14,
                                                      text: 'Settle',
                                                      disabled: false,
                                                      padding: ButtonSize()
                                                          .tableButton(),
                                                      onTap: () {
                                                        if (widget.transaction
                                                                    .settlementStatus ==
                                                                "Draft" &&
                                                            role ==
                                                                "Store Admin") {
                                                          context.goNamed(
                                                            'settlement_request',
                                                            params: {
                                                              "formId": widget
                                                                  .transaction
                                                                  .settlementId,
                                                            },
                                                          );
                                                        } else if (widget
                                                                    .transaction
                                                                    .settlementStatus ==
                                                                "Waiting SM Approval" &&
                                                            role ==
                                                                "Store Manager") {
                                                          context.goNamed(
                                                            'approval_settlement',
                                                            params: {
                                                              "formId": widget
                                                                  .transaction
                                                                  .settlementId,
                                                            },
                                                          );
                                                        } else if (widget
                                                                    .transaction
                                                                    .settlementStatus ==
                                                                "Waiting OPS Approval" &&
                                                            role ==
                                                                "Operation HO") {
                                                          context.goNamed(
                                                            'approval_settlement',
                                                            params: {
                                                              "formId": widget
                                                                  .transaction
                                                                  .settlementId,
                                                            },
                                                          );
                                                        } else {
                                                          context.goNamed(
                                                            'settlement_detail',
                                                            params: {
                                                              "formId": widget
                                                                  .transaction
                                                                  .settlementId,
                                                            },
                                                          );
                                                        }
                                                      },
                                                    )
                                  : const SizedBox(),
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

class TransactionListContainerSettlement extends StatefulWidget {
  TransactionListContainerSettlement({
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
  State<TransactionListContainerSettlement> createState() =>
      _TransactionListContainerStateSettlement();
}

class _TransactionListContainerStateSettlement
    extends State<TransactionListContainerSettlement> {
  ApiService apiService = ApiService();
  String role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService.getUserData().then((value) {
      role = value['Data']['Role'];
      setState(() {});
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: "Error getUserData",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

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
                    Expanded(
                      child: Text(
                        widget.transaction.reqId,
                        style: bodyTableLightText,
                      ),
                    ),
                    // SizedBox(
                    //   width: 165,
                    //   child: Text(
                    //     widget.transaction.category,
                    //     style: bodyTableLightText,
                    //   ),
                    // ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.transaction.siteName,
                        style: bodyTableLightText,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(
                      width: 165,
                      child: Text(
                        DateFormat('dd MMM yyyy')
                            .format(DateTime.parse(widget.transaction.created)),
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
                                fontSize: 14,
                                text: 'Detail',
                                disabled: false,
                                fontWeight: FontWeight.w700,
                                padding: ButtonSize().tableButton(),
                                onTap: () {
                                  // context.goNamed(
                                  //   'setlement_request',
                                  //   params: {
                                  //     "formId": widget.transaction.formId,
                                  //   },
                                  // );
                                  if (widget.transaction.status == "Draft" &&
                                      role == "Store Admin") {
                                    context.goNamed(
                                      'settlement_request',
                                      params: {
                                        "formId": widget.transaction.formId,
                                      },
                                    );
                                  } else {
                                    context.goNamed(
                                      'settlement_detail',
                                      params: {
                                        "formId": widget.transaction.formId,
                                      },
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              (widget.transaction.status ==
                                              "Waiting SM Approval" ||
                                          widget.transaction.status ==
                                              "Waiting OPS Approval") &&
                                      role != "Store Admin"
                                  ? widget.transaction.status ==
                                              "Waiting SM Approval" &&
                                          role != "Store Manager"
                                      ? const SizedBox()
                                      : widget.transaction.status ==
                                                  "Waiting OPS Approval" &&
                                              role != "Operation HO"
                                          ? const SizedBox()
                                          : RegularButton(
                                              fontSize: 14,
                                              text: 'Approve',
                                              disabled: false,
                                              padding:
                                                  ButtonSize().tableButton(),
                                              onTap: () {
                                                if (widget.transaction.status ==
                                                        "Waiting SM Approval" &&
                                                    role == "Store Manager") {
                                                  context.goNamed(
                                                    'approval_settlement',
                                                    params: {
                                                      "formId": widget
                                                          .transaction.formId,
                                                    },
                                                  );
                                                } else if (widget.transaction
                                                            .status ==
                                                        "Waiting OPS Approval" &&
                                                    role == "Operation HO") {
                                                  context.goNamed(
                                                    'approval_settlement',
                                                    params: {
                                                      "formId": widget
                                                          .transaction.formId,
                                                    },
                                                  );
                                                } else {
                                                  context.goNamed(
                                                    'settlement_detail',
                                                    params: {
                                                      "formId": widget
                                                          .transaction.formId,
                                                    },
                                                  );
                                                }
                                              },
                                            )
                                  : const SizedBox(),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              // widget.transaction.status == "Approved"
                              //     ? RegularButton(
                              //         text: 'Settle',
                              //         disabled: false,
                              //         padding: ButtonSize().tableButton(),
                              //         onTap: () {
                              //           context.goNamed(
                              //             'setllement_request',
                              //             params: {
                              //               "formId": widget.transaction.formId,
                              //             },
                              //           );
                              //         },
                              //       )
                              //     : const SizedBox(),
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
