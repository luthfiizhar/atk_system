import 'dart:convert';

import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

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
  bool isHover = false;
  downloadAttachment(String string, String fileName) {
    html.AnchorElement anchorElement =
        html.document.createElement('a') as html.AnchorElement;

    anchorElement.href = string;
    anchorElement.download = string.split("/").last;
    anchorElement.style.display = "none";
    anchorElement.target = '_blank';
    anchorElement.setAttribute("download", fileName);
    html.document.body!.children.add(anchorElement);
    anchorElement.click();

//     final bytes = utf8.encode(string);
//     final blob = html.Blob([bytes]);
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final anchor = html.document.createElement('a') as html.AnchorElement
//       ..href = url
//       ..style.display = 'none'
//       ..download = widget.attachment.file.split("/").last;
//     html.document.body!.children.add(anchor);

// // download
//     anchor.click();

// cleanup
    // html.document.body!.children.remove(anchor);
    // html.Url.revokeObjectUrl(url);
  }

  openImage() {}

  @override
  Widget build(BuildContext context) {
    print("File-> ${widget.attachment.file}");
    return widget.attachment.type == "image"
        ? CachedNetworkImage(
            imageUrl: widget.attachment.file,
            imageBuilder: (context, imageProvider) {
              return imageContainer(imageProvider);
            },
          )
        : pdfContainer();
  }

  Widget imageContainer(ImageProvider<Object> imageProvider) {
    return MouseRegion(
      onEnter: (event) {
        isHover = true;
        setState(() {});
      },
      onExit: (event) {
        isHover = false;
        setState(() {});
      },
      child: Stack(
        children: [
          Container(
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
          ),
          isHover
              ? Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Wrap(
                      spacing: 15,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => PictureDetail(
                                urlImage: widget.attachment.file,
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.fullscreen,
                            color: culturedWhite,
                            size: 40,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            downloadAttachment(widget.attachment.file,
                                widget.attachment.fileName);
                          },
                          child: const Icon(
                            Icons.file_download_outlined,
                            color: culturedWhite,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget pdfContainer() {
    return Container(
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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.description,
                        color: sonicSilver,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          widget.attachment.fileName,
                          // widget.attachment.file.split("/").last,
                          style: helveticaText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: spanishGray,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 18,
            right: 20,
            child: InkWell(
              onTap: () {
                downloadAttachment(
                    widget.attachment.file, widget.attachment.fileName);
              },
              child: const Icon(
                Icons.file_download_outlined,
                color: sonicSilver,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
