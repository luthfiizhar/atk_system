import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/view_model/main_page_view_model.dart';
import 'package:atk_system_ga/widgets/dropdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummCostBarChart extends StatefulWidget {
  const SummCostBarChart({super.key});

  @override
  State<SummCostBarChart> createState() => _SummCostBarChartState();
}

class _SummCostBarChartState extends State<SummCostBarChart> {
  CostSummaryBarChartModel barChartModel = CostSummaryBarChartModel();
  List yearOptions = ["2023", "2022", "2021", "2020", "2019"];
  String selectedYear = "2023";

  FocusNode yearOptionsNode = FocusNode();

  int touchedGroupIndex = -1;

  String xToMonth(int value) {
    switch (value.toInt()) {
      case 0:
        return 'Jan';
      case 1:
        return 'Feb';
      case 2:
        return 'Mar';
      case 3:
        return 'Apr';
      case 4:
        return 'May';
      case 5:
        return 'Jun';
      case 6:
        return 'Jul';
      case 7:
        return 'Aug';
      case 8:
        return 'Sep';
      case 9:
        return 'Okt';
      case 10:
        return 'Nov';
      case 11:
        return 'Dec';
      default:
        return '';
    }
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    text = xToMonth(value.toInt());
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: helveticaText.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    TextStyle style = helveticaText.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w300,
      color: davysGray,
    );
    var interval = barChartModel.maxY ~/ 5;
    List<double> intervalList = [];
    String displayInterval = "";
    for (int i = 1; i <= 5; i++) {
      double batasAtas = i * interval.toDouble();
      intervalList.add(batasAtas);
    }

    intervalList.forEach((element) {
      if (value == element) {
        displayInterval = compactFormatNumber.format(element);
      }
    });

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        displayInterval,
        style: style,
      ),
    );
  }

  BarChartGroupData initBar(
    int x,
    double budget,
    double cost, {
    bool isThouced = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: budget,
          color: spanishGray,
          width: 14,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(0),
          ),
          borderSide:
              isThouced ? const BorderSide(color: spanishGray, width: 2) : null,
        ),
        BarChartRodData(
            toY: cost,
            color: orangeAccent,
            width: 14,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ),
            borderSide: isThouced
                ? const BorderSide(color: orangeAccent, width: 2)
                : null),
      ],
      showingTooltipIndicators:
          touchedGroupIndex == x && (budget != 0 || cost != 0) ? [0] : [],
    );
  }

  @override
  void initState() {
    super.initState();
    barChartModel.getSumCostBar();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: barChartModel,
      child:
          Consumer<CostSummaryBarChartModel>(builder: (context, model, child) {
        return Container(
          constraints: const BoxConstraints(
            // maxHeight: 400,
            minWidth: 780,
            maxWidth: 800,
          ),
          padding: cardPadding,
          decoration: cardDecoration,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Cost Summary',
                      style: helveticaText.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: eerieBlack,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Wrap(
                        spacing: 30,
                        children: [
                          legend(
                            'Budget',
                            spanishGray,
                          ),
                          legend(
                            'Cost',
                            orangeAccent,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 125,
                        child: TransparentDropdown(
                          items: yearOptions.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.toString(),
                                style: helveticaText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: davysGray,
                                ),
                              ),
                            );
                          }).toList(),
                          hintText: 'Choose Year',
                          focusNode: yearOptionsNode,
                          suffixIcon:
                              const Icon(Icons.keyboard_arrow_down_sharp),
                          onChanged: (value) {},
                          enabled: true,
                          value: selectedYear,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: 280,
                width: double.infinity,
                child: model.summCostBarChart.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: eerieBlack,
                        ),
                      )
                    : BarChart(
                        BarChartData(
                          maxY: model.maxY.toDouble() + 250000,
                          minY: 0,
                          groupsSpace: 3,
                          barGroups:
                              model.summCostBarChart.asMap().entries.map((e) {
                            final index = e.key;
                            final data = e.value;
                            return initBar(index, data.budget.toDouble(),
                                data.cost.toDouble(),
                                isThouced: index == touchedGroupIndex);
                          }).toList(),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barTouchData: BarTouchData(
                            enabled: true,
                            handleBuiltInTouches: false,
                            touchTooltipData: BarTouchTooltipData(
                              maxContentWidth: 150,
                              tooltipBgColor: white,
                              tooltipMargin: 10,
                              tooltipRoundedRadius: 10,
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              tooltipBorder:
                                  const BorderSide(color: platinum, width: 1),
                              tooltipPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20,
                              ),
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                String month = xToMonth(groupIndex);
                                String year = selectedYear;
                                double percentage = (group.barRods[1].toY /
                                        group.barRods[0].toY) *
                                    100;
                                return BarTooltipItem(
                                  "$month $year",
                                  helveticaText.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: eerieBlack,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.start,
                                  children: [
                                    const TextSpan(
                                      text: "\n\n",
                                    ),
                                    TextSpan(
                                      text:
                                          'Cost: ${formatCurrency.format(group.barRods[1].toY)}\n',
                                      style: helveticaText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: davysGray,
                                        height: 1.8,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Budget: ${formatCurrency.format(group.barRods[0].toY)}\n',
                                      style: helveticaText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: davysGray,
                                        height: 1.8,
                                      ),
                                    ),
                                    TextSpan(
                                        text: 'Budget has been used by ',
                                        style: helveticaText.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: davysGray,
                                          height: 1.8,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                '${percentage.toStringAsFixed(2)} %',
                                            style: helveticaText.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: orangeAccent,
                                            ),
                                          ),
                                        ]),
                                  ],
                                );
                              },
                            ),
                            touchCallback: (event, response) {
                              if (event.isInterestedForInteractions &&
                                  response != null &&
                                  response.spot != null) {
                                setState(() {
                                  touchedGroupIndex =
                                      response.spot!.touchedBarGroupIndex;
                                });
                              } else {
                                setState(() {
                                  touchedGroupIndex = -1;
                                });
                              }
                            },
                          ),
                          gridData: FlGridData(
                            drawVerticalLine: false,
                            horizontalInterval: model.maxY / 5,
                          ),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: bottomTitles,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 55,
                                interval: model.maxY / 5,
                                getTitlesWidget: leftTitles,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget legend(String title, Color color) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        Container(
          height: 13,
          width: 13,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        Text(
          title,
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        )
      ],
    );
  }
}