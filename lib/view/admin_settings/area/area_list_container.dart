import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:flutter/material.dart';

class AreaListContainer extends StatefulWidget {
  AreaListContainer({
    super.key,
    Area? area,
    this.index = 0,
    this.onClick,
    this.close,
    this.updateList,
    this.menu = "",
  }) : area = area ?? Area();

  Area area;
  int index;
  Function? onClick;
  Function? close;
  Function? updateList;
  String menu;

  @override
  State<AreaListContainer> createState() => _AreaListContainerState();
}

class _AreaListContainerState extends State<AreaListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index == 0
            ? const SizedBox()
            : const Divider(
                color: grayx11,
                thickness: 0.5,
              ),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (widget.area.isExpanded) {
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
                      width: 135,
                      child: Row(
                        children: [
                          Text(
                            widget.area.areaId,
                            style: helveticaText.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: davysGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.area.areaName,
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.area.regionName,
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      child: widget.area.isExpanded
                          ? const Icon(Icons.keyboard_arrow_down_sharp)
                          : const Icon(
                              Icons.keyboard_arrow_right_sharp,
                            ),
                    ),
                  ],
                ),
                widget.area.isExpanded
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
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) => AddSiteDialog(
                                  //     isEdit: true,
                                  //     site: widget.site,
                                  //   ),
                                  // ).then((value) {
                                  //   if (value == 1) {
                                  //     widget.updateList!(widget.menu);
                                  //   }
                                  // });
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
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) => const ConfirmDialogBlack(
                                  //     title: "Confirmation",
                                  //     contentText: "Are you sure to delete site?",
                                  //   ),
                                  // ).then((value) {
                                  //   if (value == 1) {
                                  //     ApiService apiService = ApiService();
                                  //     apiService
                                  //         .deleteSite(widget.site.siteId)
                                  //         .then((value) {
                                  //       if (value['Status'].toString() == "200") {
                                  //         showDialog(
                                  //           context: context,
                                  //           builder: (context) => AlertDialogBlack(
                                  //             title: value['Title'],
                                  //             contentText: value['Message'],
                                  //           ),
                                  //         ).then((value) {
                                  //           widget.updateList!(widget.menu);
                                  //         });
                                  //       } else {
                                  //         showDialog(
                                  //           context: context,
                                  //           builder: (context) => AlertDialogBlack(
                                  //             title: value['Title'],
                                  //             contentText: value['Message'],
                                  //             isSuccess: false,
                                  //           ),
                                  //         );
                                  //       }
                                  //     }).onError((error, stackTrace) {
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (context) => const AlertDialogBlack(
                                  //           title: "Error deleteSite",
                                  //           contentText: "No internet connection",
                                  //           isSuccess: false,
                                  //         ),
                                  //       );
                                  //     });
                                  //   }
                                  // });
                                },
                              ),
                            )
                          ],
                        ))
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
