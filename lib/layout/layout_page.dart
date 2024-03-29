import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/layout/footer.dart';
import 'package:atk_system_ga/layout/navigation_bar/navigation_bar.dart';
import 'package:atk_system_ga/models/main_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  MainModel mainModel = MainModel();

  _scrollListener(ScrollController scrollInfo, MainModel model) {
    if (mounted) {
      if (scrollInfo.offset == 0) {
        mainModel.setShadowActive(false);
        mainModel.setUpBotton(false);
        mainModel.setIsScrolling(false);
        mainModel.setScrollPosition(scrollInfo.offset);
        mainModel.setIsScrollAtEdge(false);
      } else {
        mainModel.setShadowActive(true);
        mainModel.setUpBotton(true);
        mainModel.setIsScrolling(true);
        mainModel.setScrollPosition(scrollInfo.offset);
        mainModel.setIsScrollAtEdge(false);
        if (scrollInfo.offset == scrollInfo.position.maxScrollExtent) {
          mainModel.setIsScrollAtEdge(true);
        }
      }
    }

    // widget.setDatePickerStatus!(false);
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      _scrollListener(scrollController, mainModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
      value: mainModel,
      child: Consumer<MainModel>(builder: (context, model, child) {
        return Scaffold(
          backgroundColor: white,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    // model.navbarShadow
                    BoxShadow(
                      blurRadius: !model.shadowActive ? 0 : 40,
                      offset: !model.shadowActive
                          ? const Offset(0, 0)
                          : const Offset(0, 0),
                      color: const Color.fromRGBO(29, 29, 29, 0.1),
                    )
                  ],
                ),
                child: NavigationBarWeb(
                  index: widget.index,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
