import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/models/main_page_model.dart';
import 'package:atk_system_ga/view/dashboard/popup_dialog/site_ranking_popup.dart';
import 'package:atk_system_ga/view/dashboard/show_more_icon.dart';
import 'package:atk_system_ga/view/dashboard/widget_icon.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/view_model/main_page_view_model.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SiteRankingWidget extends StatefulWidget {
  const SiteRankingWidget({super.key});

  @override
  State<SiteRankingWidget> createState() => _SiteRankingWidgetState();
}

class _SiteRankingWidgetState extends State<SiteRankingWidget> {
  SiteRankViewModel siteRankViewModel = SiteRankViewModel();
  late GlobalModel globalModel;
  FocusNode optionsNode = FocusNode();
  List sortOptions = [
    {"value": 1, "title": "Highest Cost"},
    {"value": 2, "title": "Lowest Cost"},
    {"value": 3, "title": "Highest Budget"},
    {"value": 4, "title": "Lowest Budget"},
    {"value": 5, "title": "Fastest Leadtime"},
    {"value": 6, "title": "Slowest Leadtime"},
  ];
  final List<String> items = List.generate(10, (index) => "${index + 1}");

  List<SiteRanking> rankItem = [
    SiteRanking(
      rank: "1",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "2",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "3",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "4",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "5",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "6",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "7",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "8",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "9",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
    SiteRanking(
      rank: "10",
      cost: 888888,
      siteName: "ST ACE EXPRESS GRAHA RAYA SILKTOWN",
    ),
  ];

  showMore() {
    showDialog(
      context: context,
      builder: (context) => SiteRankingPopup(
        option: selectedSort,
      ),
    );
  }

  int selectedSort = 1;
  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    siteRankViewModel.getHighestCost(globalModel).onError((error, stackTrace) {
      siteRankViewModel.closeListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: siteRankViewModel,
      child: Consumer<SiteRankViewModel>(builder: (context, model, child) {
        return Container(
          constraints: const BoxConstraints(
            maxWidth: double.infinity,
            minWidth: double.infinity,
          ),
          decoration: cardDecoration,
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 10,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TitleIcon(
                        icon: "assets/icons/site_rank_icon.png",
                      ),
                      Text(
                        "Site Ranking",
                        style: cardTitle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        child: BlackDropdown(
                            focusNode: optionsNode,
                            width: 250,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                            ),
                            onChanged: (value) {
                              selectedSort = value;
                              model.closeListener();
                              switch (selectedSort) {
                                case 1:
                                  model.getHighestCost(globalModel);
                                  break;
                                case 2:
                                  model.getLowestCost(globalModel);
                                  break;
                                case 3:
                                  model.getHighestBudget(globalModel);
                                  break;
                                case 4:
                                  model.getLowestBudget(globalModel);
                                  break;
                                case 5:
                                  model.getFastestLeadTime(globalModel);
                                  break;
                                case 6:
                                  model.getSlowestLeadTime(globalModel);
                                  break;
                                case 7:
                                  // model.getHighestCost(globalModel);
                                  break;
                                default:
                              }
                              optionsNode.unfocus();
                              setState(() {});
                            },
                            hintText: 'Sorting',
                            value: selectedSort,
                            items: sortOptions
                                .map((e) => DropdownMenuItem(
                                      value: e["value"],
                                      child: Text(
                                        e["title"],
                                        style: helveticaText.copyWith(),
                                      ),
                                    ))
                                .toList()),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ShowMoreIcon(
                        showMoreCallback: showMore,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 400,
                    maxHeight: 540,
                  ),
                  child: model.rankItem.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: eerieBlack,
                          ),
                        )
                      : LayoutBuilder(builder: (context, constraints) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: model.rankItem
                                            .take(5)
                                            .toList()
                                            .asMap()
                                            .map((index, e) => MapEntry(
                                                index,
                                                Column(
                                                  children: [
                                                    index == 0
                                                        ? const SizedBox()
                                                        : const SizedBox(
                                                            height: 30,
                                                          ),
                                                    Builder(builder: (context) {
                                                      // e.rank = index + 1;
                                                      switch (selectedSort) {
                                                        case 1:
                                                          return RankingItemCostContainer(
                                                            item: e,
                                                          );
                                                        case 2:
                                                          return RankingItemCostContainer(
                                                            item: e,
                                                          );
                                                        case 3:
                                                          return RankingItemBudgetContainer(
                                                            item: e,
                                                          );
                                                        case 4:
                                                          return RankingItemBudgetContainer(
                                                            item: e,
                                                          );
                                                        case 5:
                                                          return RankingItemLeadTimeContainer(
                                                            item: e,
                                                          );
                                                        case 6:
                                                          return RankingItemLeadTimeContainer(
                                                            item: e,
                                                          );
                                                        case 7:
                                                          return RankingItemSubmissionContainer(
                                                            item: e,
                                                          );
                                                        default:
                                                          return RankingItemCostContainer(
                                                            item: e,
                                                          );
                                                      }
                                                    }),
                                                  ],
                                                )))
                                            .values
                                            .toList(),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      // height: constraints.constrainHeight(),
                                      child: const VerticalDivider(
                                        width: 1,
                                        color: grayx11,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: model.rankItem.reversed
                                            .take(5)
                                            .toList()
                                            .reversed
                                            .toList()
                                            .asMap()
                                            .map((index, e) => MapEntry(
                                                index,
                                                Column(
                                                  children: [
                                                    index == 0
                                                        ? const SizedBox()
                                                        : const SizedBox(
                                                            height: 30,
                                                          ),
                                                    Builder(builder: (context) {
                                                      // e.rank = index + 6;
                                                      switch (selectedSort) {
                                                        case 1:
                                                          return RankingItemCostContainer(
                                                            item: e,
                                                          );
                                                        case 2:
                                                          return RankingItemCostContainer(
                                                            item: e,
                                                          );
                                                        case 3:
                                                          return RankingItemBudgetContainer(
                                                            item: e,
                                                          );
                                                        case 4:
                                                          return RankingItemBudgetContainer(
                                                            item: e,
                                                          );
                                                        case 5:
                                                          return RankingItemLeadTimeContainer(
                                                            item: e,
                                                          );
                                                        case 6:
                                                          return RankingItemLeadTimeContainer(
                                                            item: e,
                                                          );
                                                        case 7:
                                                          return RankingItemSubmissionContainer(
                                                            item: e,
                                                          );
                                                        default:
                                                          return RankingItemCostContainer(
                                                            item: e,
                                                          );
                                                      }
                                                    }),
                                                  ],
                                                )))
                                            .values
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class RankingItemCostContainer extends StatelessWidget {
  RankingItemCostContainer({super.key, SiteRanking? item})
      : item = item ?? SiteRanking();

  SiteRanking item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.rank.padLeft(2, "0"),
          style: helveticaText.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: orangeAccent,
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.siteName,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                formatCurrency.format(item.cost),
                style: helveticaText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: eerieBlack,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class RankingItemLeadTimeContainer extends StatelessWidget {
  RankingItemLeadTimeContainer({super.key, SiteRanking? item})
      : item = item ?? SiteRanking();

  SiteRanking item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.rank.toString().padLeft(2, "0"),
          style: helveticaText.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: orangeAccent,
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.siteName,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.reqTime!,
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: eerieBlack,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Request',
                        style: helveticaText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 75,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.settlementTime!,
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: eerieBlack,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Settlement',
                        style: helveticaText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class RankingItemSubmissionContainer extends StatelessWidget {
  RankingItemSubmissionContainer({super.key, SiteRanking? item})
      : item = item ?? SiteRanking();

  SiteRanking item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.rank.toString().padLeft(2, "0"),
          style: helveticaText.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: orangeAccent,
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.siteName,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0000',
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: eerieBlack,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Request',
                        style: helveticaText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 75,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0000',
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: eerieBlack,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Settlement',
                        style: helveticaText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class RankingItemBudgetContainer extends StatelessWidget {
  RankingItemBudgetContainer({super.key, SiteRanking? item})
      : item = item ?? SiteRanking();

  SiteRanking item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.rank.toString().padLeft(2, "0"),
          style: helveticaText.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: orangeAccent,
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.siteName,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatCurrency.format(item.budgetMonthly),
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: eerieBlack,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Monthly',
                        style: helveticaText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 75,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatCurrency.format(item.budgetAddition),
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: eerieBlack,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'Additional',
                        style: helveticaText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
