import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/layout/footer.dart';
import 'package:atk_system_ga/layout/navigation_bar/navigation_bar.dart';
import 'package:atk_system_ga/models/main_model.dart';
import 'package:atk_system_ga/view/admin_settings/admin_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminSettingLayoutPageWeb extends StatefulWidget {
  AdminSettingLayoutPageWeb({
    super.key,
    required this.child,
    this.location = "",
    this.index = 0,
    this.menu = "",
    this.menuIndex = 0,
  });

  String menu;
  Widget child;
  String location;
  int index;
  int menuIndex;

  @override
  State<AdminSettingLayoutPageWeb> createState() =>
      _AdminSettingLayoutPageWebState();
}

class _AdminSettingLayoutPageWebState extends State<AdminSettingLayoutPageWeb> {
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

  onChanged(int index) {
    widget.menuIndex = index;
    setState(() {});
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
    // print(widget.location);
    // switch (widget.location) {
    //   case "/setting/item":
    //     widget.menuIndex = 0;
    //     break;
    //   case "/setting/site":
    //     widget.menuIndex = 1;
    //     break;
    //   case "/setting/user":
    //     widget.menuIndex = 2;
    //     break;
    //   default:
    // }
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
                        // child: widget.child,
                        child: ConstrainedBox(
                          constraints: pageContstraint,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 120,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Settings',
                                  style: helveticaText.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SettingPageMenu(
                                    //   index: widget.menuIndex,
                                    //   menu: widget.menu,
                                    //   onChanged: onChanged,
                                    // ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: screenHeight - 145,
                                        ),
                                        child: LayoutBuilder(
                                          builder: (context, constraint) {
                                            return Container(
                                              height: constraint.minHeight,
                                              // width: 300,
                                              // color: greenAcent,
                                              child: widget.child,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
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
