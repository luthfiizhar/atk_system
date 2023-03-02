import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/layout/navigation_bar/navigation_bar_item.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(
        left: 16,
        right: 40,
      ),
      decoration: BoxDecoration(
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
          Wrap(
            // mainAxisAlignment: MainAxisAlignment.end,
            spacing: 50,
            children: [
              NavigationItem(
                title: 'Home',
                routeName: '/home',
                selected: index == 0,
                onHighlight: onHighlight,
              ),
              NavigationItem(
                title: 'Logout',
                selected: false,
              ),
            ],
          )
        ],
      ),
    );
  }
}
