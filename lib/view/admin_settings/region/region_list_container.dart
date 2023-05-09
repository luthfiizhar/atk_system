import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view/admin_settings/region/add_region_dialog.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class RegionListContainer extends StatefulWidget {
  RegionListContainer({
    super.key,
    Region? region,
    this.index = 0,
    this.onClick,
    this.close,
    this.menu = "",
    this.updateList,
  }) : region = region ?? Region();

  Region region;
  int index;
  String menu;
  Function? onClick;
  Function? close;
  Function? updateList;

  @override
  State<RegionListContainer> createState() => _RegionListContainerState();
}

class _RegionListContainerState extends State<RegionListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index != 0
            ? const Divider(
                thickness: 0.5,
                color: grayStone,
              )
            : const SizedBox(),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (widget.region.isExpanded) {
              widget.close!(widget.index);
            } else {
              widget.onClick!(widget.index);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        widget.region.regionId,
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: davysGray,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.region.regionName,
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 75,
                      child: !widget.region.isExpanded
                          ? const Icon(Icons.keyboard_arrow_right_sharp)
                          : const Icon(Icons.keyboard_arrow_down_sharp),
                    ),
                  ],
                ),
                widget.region.isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 120,
                              child: RegularButton(
                                text: 'Edit',
                                disabled: false,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AddRegionDialog(
                                      isEdit: true,
                                      region: widget.region,
                                    ),
                                  ).then((value) {
                                    if (value == 1) {
                                      widget.updateList!(widget.menu);
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 120,
                              child: DeleteButton(
                                text: 'Delete',
                                disabled: false,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const ConfirmDialogBlack(
                                      title: "Confirmation",
                                      contentText:
                                          "Are you sure to delete site?",
                                    ),
                                  ).then((value) {
                                    if (value == 1) {
                                      ApiService apiService = ApiService();
                                      apiService
                                          .deleteRegion(widget.region)
                                          .then((value) {
                                        if (value['Status'].toString() ==
                                            "200") {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialogBlack(
                                              title: value['Title'],
                                              contentText: value['Message'],
                                            ),
                                          ).then((value) {
                                            widget.updateList!(widget.menu);
                                          });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialogBlack(
                                              title: value['Title'],
                                              contentText: value['Message'],
                                              isSuccess: false,
                                            ),
                                          );
                                        }
                                      }).onError((error, stackTrace) {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialogBlack(
                                            title: "Error deleteRegion",
                                            contentText:
                                                "No internet connection",
                                            isSuccess: false,
                                          ),
                                        );
                                      });
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ))
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
