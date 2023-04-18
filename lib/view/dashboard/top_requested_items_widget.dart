import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view_model/main_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class TopReqItemsWidget extends StatefulWidget {
  const TopReqItemsWidget({super.key});

  @override
  State<TopReqItemsWidget> createState() => _TopReqItemsWidgetState();
}

class _TopReqItemsWidgetState extends State<TopReqItemsWidget> {
  TopReqItemsViewModel topReqViewModel = TopReqItemsViewModel();

  @override
  void initState() {
    super.initState();
    topReqViewModel.getTopReqItems();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: topReqViewModel,
      child: Consumer<TopReqItemsViewModel>(builder: (context, model, child) {
        return Container(
          constraints: const BoxConstraints(
            minWidth: 500,
            maxWidth: 600,
          ),
          padding: cardPadding,
          decoration: cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Top Requested Item",
                style: cardTitle,
              ),
              const SizedBox(
                height: 30,
              ),
              model.topReqItems.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: eerieBlack,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.topReqItems.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == 0
                                ? const SizedBox()
                                : const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    child: Divider(
                                      thickness: 0.5,
                                      color: grayx11,
                                    ),
                                  ),
                            TopReqItemsContainer(
                              items: model.topReqItems[index],
                            ),
                          ],
                        );
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }
}

class TopReqItemsContainer extends StatelessWidget {
  TopReqItemsContainer({super.key, TopRequestedItems? items})
      : items = items ?? TopRequestedItems();

  TopRequestedItems items = TopRequestedItems();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          items.name,
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
              text: items.qty,
              style: helveticaText.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: orangeAccent,
              ),
              children: [
                TextSpan(
                  text: ' unit requested',
                  style: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    color: davysGray,
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}
