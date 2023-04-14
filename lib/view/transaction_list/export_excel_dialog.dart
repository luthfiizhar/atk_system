import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/custom_date_picker.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

class ExportExcelDialog extends StatefulWidget {
  const ExportExcelDialog({super.key});

  @override
  State<ExportExcelDialog> createState() => _ExportExcelDialogState();
}

class _ExportExcelDialogState extends State<ExportExcelDialog> {
  TextEditingController _date = TextEditingController();

  List<DateTime?> selectedDate = [
    DateTime.now(),
    DateTime.now().add(
      const Duration(days: 1),
    ),
  ];

  OverlayEntry? datePickerOverlayEntry;
  GlobalKey datePickerKey = GlobalKey();
  LayerLink datePickerLayerLink = LayerLink();
  bool isOverlayDatePickerOpen = false;

  OverlayEntry dateOverlay() {
    RenderBox? renderBox =
        datePickerKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        // left: offset.dx,
        // top: offset.dy + size.height + 10,
        width: size.width,
        child: CompositedTransformFollower(
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          link: datePickerLayerLink,
          child: Material(
            elevation: 4.0,
            color: white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomDatePicker(
              rangeDatePickerValue: selectedDate,
              onChangedDate: onDatePicked,
            ),
          ),
        ),
      ),
    );
  }

  onDatePicked(List<DateTime?> value) {
    if (value.length > 1) {
      if (value.first!.year == value.last!.year) {
        if (value.first!.month == value.last!.month) {
          _date.text =
              "${DateFormat('dd').format(DateTime.parse(value.first.toString()))} - ${DateFormat('dd MMM yyyy').format(DateTime.parse(value.last.toString()))}";
        } else {
          _date.text =
              "${DateFormat('dd MMM').format(DateTime.parse(value.first.toString()))} - ${DateFormat('dd MMM yyyy').format(DateTime.parse(value.last.toString()))}";
        }
      } else {
        _date.text =
            "${DateFormat('dd MMM yyyy').format(DateTime.parse(value.first.toString()))} - ${DateFormat('dd MMM yyyy').format(DateTime.parse(value.last.toString()))}";
      }
      if (value.first == value.last) {
        _date.text = DateFormat('dd MMM yyyy')
            .format(DateTime.parse(value.first.toString()));
      }
      if (isOverlayDatePickerOpen) {
        if (datePickerOverlayEntry!.mounted) {
          datePickerOverlayEntry!.remove();
          isOverlayDatePickerOpen = false;
        }
      }
    } else {
      _date.text = DateFormat('dd MMM yyyy')
          .format(DateTime.parse(value.first.toString()));
    }
    selectedDate = value;
    // print(selectedDate);
  }

  download(String string, String fileName) {
    html.AnchorElement anchorElement =
        html.document.createElement('a') as html.AnchorElement;

    anchorElement.href = string;
    anchorElement.download = string.split("/").last;
    anchorElement.style.display = "none";
    anchorElement.target = '_blank';
    anchorElement.setAttribute("download", fileName);
    html.document.body!.children.add(anchorElement);
    anchorElement.click();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 250,
          minWidth: 385,
          maxWidth: 385,
        ),
        child: GestureDetector(
          onTap: () {
            if (isOverlayDatePickerOpen) {
              if (datePickerOverlayEntry!.mounted) {
                datePickerOverlayEntry!.remove();
                isOverlayDatePickerOpen = false;
              }
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 35,
                bottom: 30,
                left: 40,
                right: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Export Data",
                    style: helveticaText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Select Date",
                    style: helveticaText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    key: datePickerKey,
                    child: CompositedTransformTarget(
                      link: datePickerLayerLink,
                      child: GestureDetector(
                        onTap: () {
                          // print("tap");
                          if (isOverlayDatePickerOpen) {
                            if (datePickerOverlayEntry!.mounted) {
                              datePickerOverlayEntry!.remove();
                              isOverlayDatePickerOpen = false;
                            }
                          } else {
                            datePickerOverlayEntry = dateOverlay();
                            Overlay.of(context).insert(datePickerOverlayEntry!);
                            isOverlayDatePickerOpen = true;
                          }
                          setState(() {});
                        },
                        child: CustomInputField(
                          controller: _date,
                          enabled: false,
                          hintText: 'Choose',
                          suffixIcon:
                              const Icon(Icons.keyboard_arrow_down_sharp),
                        ),
                      ),
                    ),
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
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        padding: ButtonSize().smallSize(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RegularButton(
                        text: 'Export',
                        disabled: false,
                        onTap: () {
                          ApiService apiService = ApiService();
                          apiService
                              .exportTransactionList(
                                  DateFormat("yyyy-M-dd")
                                      .format(selectedDate.first!),
                                  DateFormat("yyyy-M-dd")
                                      .format(selectedDate.last!))
                              .then((value) {
                            if (value['Status'].toString() == "200") {
                              download(value['Data']['File'],
                                  value['Data']['FileName'] ?? "donwload");
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialogBlack(
                                  title: value['Title'],
                                  contentText: value['Message'],
                                  isSuccess: false,
                                ),
                              );
                            }
                          }).onError((error, stackTrace) {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialogBlack(
                                title: "Error exportTransaction",
                                contentText: "No internet connection",
                                isSuccess: false,
                              ),
                            );
                          });
                        },
                        padding: ButtonSize().smallSize(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
