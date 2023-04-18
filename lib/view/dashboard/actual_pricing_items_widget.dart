import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
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

  @override
  void initState() {
    super.initState();
    actualPriceItemViewModel.getActualPriceItem();
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
            minWidth: 500,
            maxWidth: 550,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item Actual Price',
                style: cardTitle,
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
                          seconds: 15,
                        ),
                        autoPlay: true,
                        height: 410,
                      ),
                    ),
              const SizedBox(
                height: 25,
              ),
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
                            padding: EdgeInsets.symmetric(vertical: 23),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: Row(
            children: [
              content.dir == "up"
                  ? const Icon(
                      Icons.arrow_drop_up_sharp,
                      color: orangeAccent,
                    )
                  : const Icon(
                      Icons.arrow_drop_down_sharp,
                      color: greenAcent,
                    ),
              Text(
                "${content.percentage} %",
                style: helveticaText.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: content.dir == "up" ? orangeAccent : greenAcent,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                content.itemName,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: davysGray,
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
    );
  }
}
