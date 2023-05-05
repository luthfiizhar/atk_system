import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/actual_price_item_popup.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/export_dialog.dart';
import 'package:atk_system_ga/view/dashboard/show_more_icon.dart';
import 'package:atk_system_ga/view/dashboard/widget_icon.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/view_model/main_page_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class ActualPricingItemWidget extends StatefulWidget {
  const ActualPricingItemWidget({super.key});

  @override
  State<ActualPricingItemWidget> createState() =>
      _ActualPricingItemWidgetState();
}

class _ActualPricingItemWidgetState extends State<ActualPricingItemWidget> {
  ActualPriceItemViewModel actualPriceItemViewModel =
      ActualPriceItemViewModel();
  CarouselController carouselController = CarouselController();
  late GlobalModel globalModel;

  showMore() {
    showDialog(
      context: context,
      builder: (context) => const ActualPriceItemPopup(),
    );
  }

  export() {
    showDialog(
      context: context,
      builder: (context) => ExportDashboardPopup(
        dataType: "Actual Price Item",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    actualPriceItemViewModel.getActualPriceItem(globalModel);
    globalModel.addListener(() {
      actualPriceItemViewModel.closeStream();
      actualPriceItemViewModel.getActualPriceItem(globalModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: actualPriceItemViewModel,
      child:
          Consumer<ActualPriceItemViewModel>(builder: (context, model, child) {
        return Container(
          padding: cardPadding,
          decoration: cardDecoration,
          constraints: const BoxConstraints(
            minWidth: 585,
            maxWidth: 585,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 10,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TitleIcon(
                        icon: "assets/icons/item_actual_icon.png",
                      ),
                      Text(
                        "Item Actual Price",
                        style: cardTitle,
                      ),
                    ],
                  ),
                  ShowMoreIcon(
                    showMoreCallback: showMore,
                    exportCallback: export,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              model.sliderList.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: eerieBlack,
                      ),
                    )
                  : CarouselSlider(
                      carouselController: carouselController,
                      disableGesture: true,
                      items: model.sliderList
                          .asMap()
                          .map(
                            (index, value) => MapEntry(
                              index,
                              ActualPriceItemContainer(
                                list: value,
                              ),
                            ),
                          )
                          .values
                          .toList(),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        // autoPlayAnimationDuration: const Duration(seconds: 15),
                        autoPlayInterval: const Duration(
                          seconds: 10,
                        ),
                        autoPlay: true,
                        height: 375,
                      ),
                    ),
              // const SizedBox(
              //   height: 25,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        carouselController.previousPage();
                      },
                      child: const Icon(Icons.chevron_left_sharp)),
                  InkWell(
                      onTap: () {
                        carouselController.nextPage();
                      },
                      child: const Icon(Icons.chevron_right_sharp))
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

class ActualPriceItemContainer extends StatelessWidget {
  ActualPriceItemContainer(
      {super.key, ActualPriceItem? item, List<ActualPriceItem>? list})
      : item = item ?? ActualPriceItem(),
        list = list ?? [];
  ActualPriceItem item;

  List<ActualPriceItem> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: list
            .asMap()
            .map(
              (index, value) => MapEntry(
                index,
                Column(
                  children: [
                    index == 0
                        ? const SizedBox()
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                              thickness: 0.5,
                              color: grayx11,
                            ),
                          ),
                    content(value),
                  ],
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }

  Widget content(ActualPriceItem content) {
    return SizedBox(
      height: 92,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                content.dir == "up"
                    ? const Icon(
                        Icons.arrow_drop_up_sharp,
                        color: orangeAccent,
                        size: 36,
                      )
                    : const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: greenAcent,
                        size: 36,
                      ),
                Text(
                  "${content.percentage} %",
                  style: helveticaText.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: content.dir == "up" ? orangeAccent : greenAcent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  content.itemName,
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: davysGray,
                    height: 1.375,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Base Price: ${formatCurrency.format(content.basePrice)}",
                  style: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "Avg. Actual Price: ",
                    style: helveticaText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      TextSpan(
                          text: formatCurrency.format(content.avgPrice),
                          style: helveticaText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color:
                                content.dir == "up" ? orangeAccent : greenAcent,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ))
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
