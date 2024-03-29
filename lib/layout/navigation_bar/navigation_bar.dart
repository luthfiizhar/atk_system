import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/navigation_bar/navigation_bar_item.dart';
import 'package:atk_system_ga/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class NavigationBarWeb extends StatefulWidget {
  NavigationBarWeb({
    super.key,
    this.index = 0,
  });

  int index;

  @override
  State<NavigationBarWeb> createState() => _NavigationBarWebState();
}

class _NavigationBarWebState extends State<NavigationBarWeb> {
  int index = 0;
  ApiService apiService = ApiService();
  List menuList = [];

  String role = "";
  bool isSysAdmin = false;

  void onHighlight(String route) {
    switch (route) {
      case "/home":
        changeHighlight(0);
        break;
    }
  }

  void changeHighlight(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    apiService.getUserData().then((value) {
      if (value['Status'].toString() == "200") {
        // isSysAdmin = value['Data']['SystemAdmin'];
        menuList = value["Data"]["MenuList"];
        setState(() {});
      } else {}
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(
        left: 16,
        right: 40,
      ),
      decoration: const BoxDecoration(
        color: white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  width: 155,
                  child: Image.asset(
                    'assets/navbarlogo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 13,
                  ),
                  child: SizedBox(
                    height: 32,
                    child: VerticalDivider(
                      color: davysGray,
                      thickness: 1.5,
                    ),
                  ),
                ),
                Text(
                  'GA Decentralization System',
                  style: helveticaText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: davysGray,
                  ),
                )
              ],
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            // spacing: 50,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Wrap(
                  spacing: 50,
                  children: menuList
                      .asMap()
                      .entries
                      .map(
                        (e) => NavigationItem(
                          title: e.value["Title"],
                          routeName: e.value["RouteName"],
                          selected: e.value["RouteName"] ==
                              GoRouter.of(context).location.replaceAll("/", ""),
                          onHighlight: onHighlight,
                        ),
                      )
                      .toList(),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 50),
              //   child: NavigationItem(
              //     title: 'Home',
              //     routeName: 'home',
              //     selected: index == 0,
              //     onHighlight: onHighlight,
              //   ),
              // ),
              // Visibility(
              //   visible: dashboardAccess,
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //       right: 50,
              //     ),
              //     child: NavigationItem(
              //       title: 'Dashboard',
              //       routeName: 'dashboard',
              //       selected: index == 2,
              //       onHighlight: onHighlight,
              //     ),
              //   ),
              // ),
              // Visibility(
              //   visible: settingAccess,
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //       right: 50,
              //     ),
              //     child: NavigationItem(
              //       title: 'Setting',
              //       routeName: 'admin_setting',
              //       selected: index == 1,
              //       onHighlight: onHighlight,
              //     ),
              //   ),
              // ),
              // NavigationItem(
              //   title: 'Logout',
              //   selected: false,
              // ),
              InkWell(
                onTap: () async {
                  var box = await Hive.openBox('userLogin');
                  box.delete('jwtToken');
                  jwtToken = "";
                  isTokenValid = false;
                  isSysAdmin = false;
                  isSystemAdmin = false;
                  settingAccess = false;
                  dashboardAccess = false;
                  isViewerOnly = false;
                  context.go('/login');
                  setState(() {});
                },
                child: Text(
                  'Logout',
                  style: navBarText.copyWith(
                    fontSize: 18,
                    color: sonicSilver,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
