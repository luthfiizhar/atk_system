import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/view/dashboard/main_page_header.dart';
import 'package:atk_system_ga/view/dashboard/summary_cost_bar_chart.dart';
import 'package:atk_system_ga/view/dashboard/total_cost_stat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  MapController mapController = MapController();
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
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 0,
      child: ConstrainedBox(
        constraints: pageContstraint,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 1200,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                DashboardHeader(),
                // MapContainer(),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 30,
                  children: const [TotalCostStatistic(), SummCostBarChart()],
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
