import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PickSiteDialog extends StatefulWidget {
  const PickSiteDialog({
    super.key,
    this.formCategory = "Monthly",
  });

  final String formCategory;
  @override
  State<PickSiteDialog> createState() => _PickSiteDialogState();
}

class _PickSiteDialogState extends State<PickSiteDialog> {
  String selectedBuilding = "";
  List buildingList = [];

  String formId = "";

  Future createOrder() async {
    String nextRoute = "";
    ApiService()
        .createTransactionElite(widget.formCategory, selectedBuilding)
        .then((value) {
      // print(value);
      if (value["Status"].toString() == "200") {
        String status = value['Data']['Status'];
        formId = value["Data"]["FormID"];
        nextRoute = value['Data']['Link'];
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        ).then((value) {
          context.goNamed(nextRoute, params: {
            "formId": formId,
          });
          // if (status == "Draft") {
          //   context.goNamed(
          //     'supplies_request',
          //     params: {"formId": formId},
          //   );
          // } else {
          //   context.goNamed(
          //     'request_order_detail',
          //     params: {"formId": formId},
          //   );
          // }
        });
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
          title: "Error createTransaction",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  Future createOrderAdditional() async {
    String nextRoute = "";
    ApiService()
        .createTransactionElite("Additional", selectedBuilding)
        .then((value) {
      // print(value);
      if (value["Status"].toString() == "200") {
        String status = value['Data']['Status'];
        formId = value["Data"]["FormID"];
        nextRoute = value['Data']['Link'];
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        ).then((value) {
          context.goNamed(nextRoute, params: {
            "formId": formId,
          });
          // if (status == "Draft") {
          //   context.goNamed(
          //     'supplies_request',
          //     params: {"formId": formId},
          //   );
          // } else {
          //   context.goNamed(
          //     'request_order_detail',
          //     params: {"formId": formId},
          //   );
          // }
        });
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
          title: "Error createTransaction",
          contentText: "No internet connection",
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    ApiService().getEliteSite().then((value) {
      if (value["Status"].toString() == "200") {
        buildingList = value["Data"];
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            contentText: value["Message"],
            title: value["Title"],
            isSuccess: false,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // elevation: 4,
      // borderRadius: BorderRadiusDirectional.circular(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 495,
            maxWidth: 495,
          ),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: platinum,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Site',
                style: helveticaText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: eerieBlack,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SearchDropDown(
                itemList: buildingList,
                items: buildingList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e["ID"].toString(),
                        child: Text(e["Name"]),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedBuilding = value;
                },
                hintText: "Pilih disini",
                // value: tempFilter.buildingId,
                searchFunction: (item, searchValue) {
                  final myItem = buildingList.firstWhere((element) =>
                      element["ID"].toString() == item.value.toString());
                  return myItem["Name"]
                      .toString()
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TransparentButtonBlack(
                    text: "Cancel",
                    disabled: false,
                    onTap: () {
                      Navigator.of(context).pop(0);
                    },
                    padding: ButtonSize().mediumSize(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RegularButton(
                    text: "Create",
                    disabled: false,
                    onTap: () {
                      createOrder();
                    },
                    padding: ButtonSize().mediumSize(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
