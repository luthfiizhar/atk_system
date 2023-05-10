import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view_model/dashboard_view_model.dart/summary_cost_view_model.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalCostStatistic extends StatefulWidget {
  TotalCostStatistic({super.key});

  // GlobalModel globalModel;

  @override
  State<TotalCostStatistic> createState() => _TotalCostStatisticState();
}

class _TotalCostStatisticState extends State<TotalCostStatistic> {
  TotalCostStatModel totalCostStatModel = TotalCostStatModel();
  late GlobalModel globalModel;

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    totalCostStatModel.getSumCostValue(globalModel);
    globalModel.addListener(() async {
      totalCostStatModel.closeListener();
      totalCostStatModel.getSumCostValue(globalModel);
    });
  }

  @override
  void dispose() {
    super.dispose();
    globalModel.removeListener(() {});
    totalCostStatModel.closeListener();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: totalCostStatModel,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 350,
          minWidth: 350,
        ),
        decoration: cardDecoration,
        padding: cardPadding,
        child: Consumer<TotalCostStatModel>(builder: (context, model, child) {
          return model.costSummaryList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: eerieBlack),
                )
              : Column(
                  children: model.costSummaryList
                      .asMap()
                      .map(
                        (index, value) => MapEntry(
                          index,
                          statisticContainer(value, index),
                        ),
                      )
                      .values
                      .toList(),
                );
        }),
      ),
    );
  }

  Widget statisticContainer(CostSummaryCard info, int index) {
    return Column(
      children: [
        index == 0
            ? const SizedBox()
            : const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  color: grayx11,
                  thickness: 0.5,
                ),
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              info.title,
              style: helveticaText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              formatCurrency.format(info.value),
              style: helveticaText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                info.dir == "up"
                    ? const Icon(
                        Icons.arrow_drop_up,
                        color: orangeAccent,
                        size: 24,
                      )
                    : const Icon(
                        Icons.arrow_drop_down,
                        color: greenAcent,
                        size: 24,
                      ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "${info.percentage.toString()} %",
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: info.dir == "up" ? orangeAccent : greenAcent,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "from last month",
                  style: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
