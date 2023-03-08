import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
            transactionActivity.photo == ""
                ? Container(
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
                  )
                : CachedNetworkImage(
                    imageUrl: transactionActivity.photo,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sonicSilver,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
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
                  transactionActivity.attachment.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 10,
                            runSpacing: 10,
                            children: transactionActivity.attachment.map((e) {
                              return AttachmentTransactionItem(
                                attachment: e,
                              );
                            }).toList(),
                          ),
                        )
                      : const SizedBox(),
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
    print("File-> ${widget.attachment.file}");
    return widget.attachment.type == "image"
        ? CachedNetworkImage(
            imageUrl: widget.attachment.file,
            imageBuilder: (context, imageProvider) {
              return Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: platinum,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          )
        : Container(
            width: 200,
            height: 125,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: spanishGray,
                width: 0.5,
              ),
              color: white,
            ),
          );
  }
}
