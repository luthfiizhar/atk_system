import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/export_dialog.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/top_requested__item_popup.dart';
import 'package:atk_system_ga/view/dashboard/show_more_icon.dart';
import 'package:atk_system_ga/view/dashboard/widget_icon.dart';
import 'package:atk_system_ga/view_model/dashboard_view_model.dart/total_requested_item_view_model.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/empty_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TopReqItemsWidget extends StatefulWidget {
  const TopReqItemsWidget({super.key});

  @override
  State<TopReqItemsWidget> createState() => _TopReqItemsWidgetState();
}

class _TopReqItemsWidgetState extends State<TopReqItemsWidget> {
  TopReqItemsViewModel topReqViewModel = TopReqItemsViewModel();
  late GlobalModel globalModel;

  GlobalKey iconKey = GlobalKey();

  showMore() {
    showDialog(
      context: context,
      builder: (context) => const TopRequestedItemPopup(),
    );
  }

  export() {
    showDialog(
      context: context,
      builder: (context) => ExportDashboardPopup(
        dataType: "Top Requested Item",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    topReqViewModel.getTopReqItems(globalModel);
    // globalModel.addListener(() {
    //   topReqViewModel.getTopReqItems(globalModel);
    // });
    globalModel.addListener(() {
      topReqViewModel.closeListener();
      topReqViewModel.getTopReqItems(globalModel);
    });
  }

  @override
  void dispose() {
    super.dispose();
    globalModel.removeListener(() {});
    topReqViewModel.closeListener();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: topReqViewModel,
      child: Consumer<TopReqItemsViewModel>(builder: (context, model, child) {
        return Container(
          constraints: const BoxConstraints(
            minWidth: 585,
            maxWidth: 585,
          ),
          padding: cardPadding,
          decoration: cardDecoration,
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
                        icon: "assets/icons/top_requested_icon.png",
                      ),
                      Text(
                        "Top Requested Item",
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
              model.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: eerieBlack,
                      ),
                    )
                  : model.topReqItems.isEmpty
                      ? EmptyTable(
                          text: "No item available right now",
                        )
                      : Container(
                          height: 270,
                          width: double.infinity,
                          child: SfCircularChart(
                            palette: const [
                              Color(0xFF491E0C),
                              Color(0xFF793315),
                              Color(0xFFA9471D),
                              Color(0xFFDA5B25),
                              Color(0xFFF26529),
                              Color(0xFFF3743E),
                              Color(0xFFF69369),
                              Color(0xFFF9B294),
                              Color(0xFFFBD1BF),
                              Color(0xFFFCE0D4),
                            ],
                            tooltipBehavior: TooltipBehavior(
                              activationMode: ActivationMode.singleTap,
                              tooltipPosition: TooltipPosition.auto,
                              color: white,
                              duration: 1500,
                              borderColor: white,
                              enable: true,
                              elevation: 0,
                              borderWidth: 0,
                              builder: (data, point, series, pointIndex,
                                  seriesIndex) {
                                TopRequestedItems dataList = data;
                                return Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                    minWidth: 180,
                                    maxHeight: 200,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: white,
                                    border: Border.all(
                                      color: platinum,
                                      width: 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Text(data),
                                      Text(
                                        dataList.name,
                                        style: helveticaText.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: eerieBlack,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Total: ${formatThousandNoDecimal.format(int.parse(dataList.qty))}",
                                        style: helveticaText.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: davysGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            series: [
                              PieSeries<TopRequestedItems, String>(
                                dataSource: model.topReqItems,
                                // pointColorMapper: (data, _) => data.color,
                                xValueMapper: (data, _) => data.name,
                                yValueMapper: (data, _) =>
                                    double.parse(data.qty),
                                enableTooltip: true,
                                dataLabelMapper: (datum, index) => datum.name,
                                dataLabelSettings: DataLabelSettings(
                                  textStyle: helveticaText.copyWith(
                                    fontSize: 12,
                                  ),
                                  isVisible: true,
                                  labelIntersectAction:
                                      LabelIntersectAction.shift,
                                  labelPosition: ChartDataLabelPosition.outside,
                                  // useSeriesColor: true,
                                  overflowMode: OverflowMode.trim,
                                ),
                              ),
                            ],
                          ),
                        )
              // : ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: model.topReqItems.take(5).length,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemBuilder: (context, index) {
              //       return Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           index == 0
              //               ? const SizedBox()
              //               : const Padding(
              //                   padding: EdgeInsets.symmetric(
              //                     vertical: 18,
              //                   ),
              //                   child: Divider(
              //                     thickness: 0.5,
              //                     color: grayx11,
              //                   ),
              //                 ),
              //           TopReqItemsContainer(
              //             items: model.topReqItems[index],
              //           ),
              //         ],
              //       );
              //     },
              //   ),
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
              text: formatThousandNoDecimal.format(int.parse(items.qty)),
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
