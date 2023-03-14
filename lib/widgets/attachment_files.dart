import 'dart:convert';
import 'dart:io';

import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/transaction_class.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AttachmentFiles extends StatefulWidget {
  AttachmentFiles({
    super.key,
    List<Attachment>? files,
    this.addFiles,
    Transaction? transaction,
    List<TransactionActivity>? activity,
  })  : transaction = transaction ?? Transaction(),
        files = files ?? [],
        activity = activity ?? [];

  List<Attachment> files;
  Function? addFiles;
  Transaction transaction;
  List<TransactionActivity> activity;

  @override
  State<AttachmentFiles> createState() => _AttachmentFilesState();
}

class _AttachmentFilesState extends State<AttachmentFiles> {
  String base64 = "";
  String fileName = "";
  List<Attachment> files = [];

  Future getFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    if (result != null) {
      print(result.files.first.size);

      for (var element in result.files) {
        if (element.size > 2097152) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialogBlack(
              title: 'File size to big',
              contentText: 'Please pick files less than 2 MB',
              isSuccess: false,
            ),
          );
          break;
        } else {
          String ext = element.extension!;
          String fileType = "image";
          if (ext == "pdf") {
            fileType = "application";
          }
          String base64 =
              "data:$fileType/$ext;base64,${const Base64Encoder().convert(element.bytes!).toString()}";
          widget.files.add(Attachment(
            file: base64,
            fileName: element.name,
            type: ext,
          ));
          files.add(Attachment(
            file: base64,
            fileName: element.name,
            type: ext,
          ));
          // widget.activity.first.submitAttachment.add(base64);
          // widget.transaction.activity.first.submitAttachment.add(base64);
          // print(widget.files);
          setState(() {});
        }
      }

      // List<File> files =
      //     result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
  }

  removeFile(int index) {
    files.removeAt(index);
    widget.files.removeAt(index);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // files = widget.files;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Attachment ",
            style: helveticaText.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: eerieBlack,
            ),
            children: [
              TextSpan(
                text: "(max 2 MB)",
                style: helveticaText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: eerieBlack,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          // direction: Axis.vertical,
          children: widget.files
              .asMap()
              .map(
                (index, element) => MapEntry(
                  index,
                  AttachmentItemText(
                    index: index,
                    fileName: element.fileName,
                    remove: removeFile,
                  ),
                ),
              )
              .values
              .toList(),
        ),
        const SizedBox(
          height: 16,
        ),
        RegularButton(
          text: 'Attach Files',
          disabled: false,
          padding: ButtonSize().mediumSize(),
          onTap: () {
            getFiles();
          },
        ),
      ],
    );
  }
}

class AttachmentItemText extends StatelessWidget {
  AttachmentItemText({
    super.key,
    this.index = 0,
    this.fileName = "",
    this.remove,
  });

  String fileName;
  Function? remove;
  int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            remove!(index);
          },
          child: const Icon(
            Icons.close_sharp,
            size: 16,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          fileName,
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: sonicSilver,
          ),
        ))
      ],
    );
  }
}
