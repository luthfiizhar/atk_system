import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/layout/footer.dart';
import 'package:atk_system_ga/layout/navigation_bar/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LayoutPageWeb extends StatefulWidget {
  LayoutPageWeb({
    super.key,
    required this.child,
    this.location = "/",
    this.index = 0,
  });

  Widget child;
  String location;
  int index;

  @override
  State<LayoutPageWeb> createState() => _LayoutPageWebState();
}

class _LayoutPageWebState extends State<LayoutPageWeb> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NavigationBarWeb(
              index: widget.index,
            ),
            ConstrainedBox(
              constraints: pageContstraint.copyWith(
                minHeight: screenHeight - 145,
              ),
              child: widget.child,
            ),
            const FooterWeb(),
          ],
        ),
      ),
    );
  }
}
