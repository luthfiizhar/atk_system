import 'dart:convert';
import 'dart:io';

import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AttachmentFiles extends StatefulWidget {
  AttachmentFiles({
    super.key,
    List? files,
    this.addFiles,
  }) : files = files ?? [];

  List files;
  Function? addFiles;

  @override
  State<AttachmentFiles> createState() => _AttachmentFilesState();
}

class _AttachmentFilesState extends State<AttachmentFiles> {
  String base64 = "";
  String fileName = "";
  List files = [];

  Future getFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    if (result != null) {
      // print(result);

      for (var element in result.files) {
        if (element.size > 2000) {
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
            fileType = "file";
          }
          String base64 =
              "data:$fileType/$ext;base64,${Base64Encoder().convert(element.bytes!).toString()}";
          widget.files.add(base64);
          print(widget.files);
        }
      }

      // List<File> files =
      //     result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
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
                  'No file',
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: sonicSilver,
                  ),
                ))
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        RegularButton(
          text: 'Attach Picture',
          disabled: false,
          padding: ButtonSize().mediumSize(),
          onTap: () async {
            getFiles();
          },
        ),
      ],
    );
  }
}
