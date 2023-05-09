import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view/admin_settings/business_unit/add_business_unit_dialog.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BusinessUnitListContainer extends StatefulWidget {
  BusinessUnitListContainer({
    super.key,
    BusinessUnit? businessUnit,
    Function? updateList,
    this.menu = "",
  })  : businessUnit = businessUnit ?? BusinessUnit(),
        updateList = updateList ?? (() {});

  BusinessUnit businessUnit;
  Function updateList;
  String menu;

  @override
  State<BusinessUnitListContainer> createState() =>
      _BusinessUnitListContainerState();
}

class _BusinessUnitListContainerState extends State<BusinessUnitListContainer> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        isHover = true;
        setState(() {});
      },
      onExit: (event) {
        isHover = false;
        setState(() {});
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 210,
          maxWidth: 210,
          minHeight: 235,
          maxHeight: 235,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: platinum, width: 1),
              ),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    pictureWidget(),
                    const SizedBox(
                      height: 25,
                    ),
                    nameWidget(),
                  ],
                ),
              ),
            ),
            isHover
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: RegularButton(
                            text: 'Edit',
                            disabled: false,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddBusinessUnitDialog(
                                  isEdit: true,
                                  businessUnit: widget.businessUnit,
                                ),
                              ).then((value) {
                                widget.updateList(widget.menu);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 120,
                          child: DeleteButton(
                            text: 'Delete',
                            disabled: false,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => const ConfirmDialogBlack(
                                  title: "Confirmation",
                                  contentText: "Are you sure to delete BU?",
                                ),
                              ).then((value) {
                                if (value == 1) {
                                  ApiService apiService = ApiService();
                                  apiService
                                      .deleteBusinssUnit(widget.businessUnit)
                                      .then((value) {
                                    if (value["Status"].toString() == "200") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogBlack(
                                            title: value["Title"],
                                            contentText: value["Message"]),
                                      ).then((value) {
                                        widget.updateList(widget.menu);
                                      });
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogBlack(
                                          title: value["Title"],
                                          contentText: value["Message"],
                                          isSuccess: false,
                                        ),
                                      );
                                    }
                                  }).onError((error, stackTrace) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: "Error deleteBU",
                                        contentText: error.toString(),
                                      ),
                                    );
                                  });
                                }
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget pictureWidget() {
    return SizedBox(
      width: 160,
      height: 120,
      child: CachedNetworkImage(
        imageUrl: widget.businessUnit.photo,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget nameWidget() {
    return Text(
      widget.businessUnit.name,
      style: helveticaText.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: davysGray,
      ),
      textAlign: TextAlign.center,
    );
  }
}
