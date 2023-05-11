import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/view/dashboard/actual_pricing_items_widget.dart';
import 'package:atk_system_ga/view/dashboard/dashboard_options_widget.dart';
import 'package:atk_system_ga/view/dashboard/main_page_header.dart';
import 'package:atk_system_ga/view/dashboard/recent_transaction.dart';
import 'package:atk_system_ga/view/dashboard/site_ranking_widget.dart';
import 'package:atk_system_ga/view/dashboard/summary_cost_bar_chart.dart';
import 'package:atk_system_ga/view/dashboard/top_requested_items_widget.dart';
import 'package:atk_system_ga/view/dashboard/total_cost_stat.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  MapController mapController = MapController();
  late GlobalModel globalModel;
  ApiService apiService = ApiService();

  OverlayEntry? optionsOverlayEntry;
  GlobalKey optionsKey = GlobalKey();
  LayerLink optionsLayerLink = LayerLink();
  bool isOverlayOptionsOpen = false;

  bool isOptionsVisible = false;

  OverlayEntry OptionsOverlay() {
    RenderBox? renderBox =
        optionsKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
            // top: offset.dy + size.height + 10,
            width: 485,
            child: CompositedTransformFollower(
              showWhenUnlinked: false,
              offset: Offset(-350, size.height),
              link: optionsLayerLink,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: Material(
                  elevation: 4.0,
                  color: white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const DashboardOptionsWidget(),
                ),
              ),
            )));
  }

  showOptionsOverlay() {
    if (isOverlayOptionsOpen) {
      if (optionsOverlayEntry!.mounted) {
        optionsOverlayEntry!.remove();
      }
      isOverlayOptionsOpen = false;
    } else {
      isOverlayOptionsOpen = true;
      optionsOverlayEntry = OptionsOverlay();
      Overlay.of(context).insert(optionsOverlayEntry!);
    }
  }

  closeOverlay() {
    if (isOverlayOptionsOpen) {
      if (optionsOverlayEntry!.mounted) {
        optionsOverlayEntry!.remove();
      }
      isOverlayOptionsOpen = false;
    }
  }

  openOptions() {
    if (isOptionsVisible) {
      isOptionsVisible = false;
    } else {
      isOptionsVisible = true;
    }
    setState(() {});
  }

  closeOptions() {
    isOptionsVisible = false;
    setState(() {});
  }

  final notFilledPoints = <LatLng>[
    LatLng(51.5, -0.09),
    LatLng(53.3498, -6.2603),
    LatLng(48.8566, 2.3522),
  ];

  final filledPoints = <LatLng>[
    LatLng(55.5, -0.09),
    LatLng(54.3498, -6.2603),
    LatLng(52.8566, 2.3522),
  ];

  final notFilledDotedPoints = <LatLng>[
    LatLng(49.29, -2.57),
    LatLng(51.46, -6.43),
    LatLng(49.86, -8.17),
    LatLng(48.39, -3.49),
  ];

  final filledDotedPoints = <LatLng>[
    LatLng(46.35, 4.94),
    LatLng(46.22, -0.11),
    LatLng(44.399, 1.76),
  ];

  final labelPoints = <LatLng>[
    LatLng(60.16, -9.38),
    LatLng(60.16, -4.16),
    LatLng(61.18, -4.16),
    LatLng(61.18, -9.38),
  ];

  final labelRotatedPoints = <LatLng>[
    LatLng(59.77, -10.28),
    LatLng(58.21, -10.28),
    LatLng(58.21, -7.01),
    LatLng(59.77, -7.01),
    LatLng(60.77, -6.01),
  ];

  final holeOuterPoints = <LatLng>[
    LatLng(50, -18),
    LatLng(50, -14),
    LatLng(54, -14),
    LatLng(54, -18),
  ];

  final holeInnerPoints = <LatLng>[
    LatLng(51, -17),
    LatLng(51, -16),
    LatLng(52, -16),
    LatLng(52, -17),
  ];

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: globalModel,
      child: Consumer<GlobalModel>(builder: (context, model, child) {
        return LayoutPageWeb(
          index: 0,
          child: ConstrainedBox(
            constraints: pageContstraint,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 1200,
                child: Stack(
                  children: [
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       globalModel.setAreaId("RM2");
                        //       // print(globalModel.areaId);
                        //     },
                        //     child: Text('Check')),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       globalModel.setAreaId("RM3");
                        //       // print(globalModel.areaId);
                        //     },
                        //     child: Text('Check2')),
                        DashboardHeader(
                          showOverlay: openOptions,
                          unitKey: optionsKey,
                          optionLayerLink: optionsLayerLink,
                          closeOverlay: closeOptions,
                        ),
                        // MapContainer(),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: 30,
                          runSpacing: 30,
                          children: [
                            TotalCostStatistic(),
                            SummCostBarChart(),
                            TopReqItemsWidget(),
                            ActualPricingItemWidget(),
                            RecentTransactionWidget(),
                            Visibility(
                                visible:
                                    model.role != "StoreManager" ? true : false,
                                child: SiteRankingWidget()),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                    Visibility(
                      visible: isOptionsVisible,
                      child: Positioned(
                        top: 120,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: DashboardOptionsWidget(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
