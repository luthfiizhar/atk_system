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
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.topReqItems.take(5).length,
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
              text: formatThousand.format(int.parse(items.qty)),
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
