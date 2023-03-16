import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:flutter/material.dart';

class SiteListContainer extends StatefulWidget {
  SiteListContainer({
    super.key,
    Site? site,
    this.index = 0,
    this.onClick,
    this.close,
  }) : site = site ?? Site();

  Site site;
  int index;
  Function? onClick;
  Function? close;
  @override
  State<SiteListContainer> createState() => _SiteListContainerState();
}

class _SiteListContainerState extends State<SiteListContainer> {
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
          onTap: () {
            if (widget.site.isExpanded) {
              widget.close!(widget.index);
            } else {
              widget.onClick!(widget.index);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 19),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        widget.site.siteId,
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    Expanded(
                      // flex: 2,
                      child: Text(
                        widget.site.siteName,
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      child: Text(
                        formatCurrency.format(widget.site.monthlyBudget),
                        style: helveticaText.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: !widget.site.isExpanded
                          ? const Icon(
                              Icons.keyboard_arrow_right_sharp,
                            )
                          : const Icon(
                              Icons.keyboard_arrow_down_sharp,
                            ),
                    ),
                  ],
                ),
                !widget.site.isExpanded
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 50,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "Site Area: ",
                                    style: helveticaText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "${formatThousand.format(widget.site.siteArea)} m2",
                                        style: helveticaText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: davysGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: "Additional Budget: ",
                                    style: helveticaText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: formatCurrency.format(
                                            widget.site.additionalBudget),
                                        style: helveticaText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: davysGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: RegularButton(
                                    text: 'Edit',
                                    disabled: false,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: RegularButton(
                                    text: 'Delete',
                                    disabled: false,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    onTap: () {},
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
