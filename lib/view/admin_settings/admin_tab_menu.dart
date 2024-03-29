import 'dart:math';

import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/models/admin_page_class.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:flutter/material.dart';

class AdminMenuSearchBar extends StatefulWidget {
  AdminMenuSearchBar({
    super.key,
    this.type = "Site",
    this.menuList,
    this.updateList,
    this.search,
    this.searchController,
  });

  Function? updateList;
  Function? search;
  List<AdminMenu>? menuList;
  String? type;
  TextEditingController? searchController;

  @override
  State<AdminMenuSearchBar> createState() => _AdminMenuSearchBarState();
}

class _AdminMenuSearchBarState extends State<AdminMenuSearchBar> {
  bool onSelected = false;
  String? menuValue;
  TextEditingController? _search = TextEditingController();

  List<Color> color = [blueAccent, greenAcent, orangeAccent, violetAccent];
  late int indexColor;
  late Color selectedColor = blueAccent;
  final _random = Random();

  String role = "";

  void onHighlight(String type) {
    switch (type) {
      case "Site":
        changeHighlight("Site");
        widget.updateList!(type);
        break;
      case "User":
        changeHighlight("User");
        widget.updateList!(type);
        break;
      case "Item":
        changeHighlight("Item");
        widget.updateList!(type);
        break;
      case "BusinessUnit":
        changeHighlight("BusinessUnit");
        widget.updateList!(type);
        break;
      case "Region":
        changeHighlight("Region");
        widget.updateList!(type);
        break;
      case "Area":
        changeHighlight("Area");
        widget.updateList!(type);
        break;
    }
  }

  void changeHighlight(String type) {
    setState(() {
      // index = newIndex;
      menuValue = type;
    });
  }

  @override
  void initState() {
    super.initState();
    menuValue = widget.type;
    indexColor = _random.nextInt(color.length);
    selectedColor = color[indexColor];
    ApiService apiService = ApiService();
    // apiService.getUserData().then((value) {
    //   if (value["Status"].toString() == "200") {
    //     role = value["Data"]["Role"];
    //   }
    // });
    // for (var element in widget.menuList!) {
    //   if (element.value == "BusinessUnit") {
    //     element.isShowed = role == "System Admin" ? true : false;
    //   }
    // }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: sonicSilver,
      padding: EdgeInsets.zero,
      height: 67,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: grayx11,
                  width: 0.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // bottom: 0,
            // left: 0,
            child: Container(
              // color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // width: 500,
                    child: Row(
                      children: widget.menuList!.map((e) {
                        return Visibility(
                          visible: e.isShowed,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 50,
                            ),
                            child: AdminMenuSearchBarItem(
                              title: e.name,
                              type: e.value,
                              bookingCount: 0.toString(),
                              onHighlight: onHighlight,
                              color: selectedColor,
                              selected: menuValue == e.value,
                            ),
                          ),
                        );
                      }).toList(),
                      // children: [
                      //   AdminMenuSearchBarItem(
                      //     title: 'Meeting Room',
                      //     type: 'MeetingRoom',
                      //     onHighlight: onHighlight,
                      //     selected: index == 0,
                      //     color: selectedColor,
                      //   ),
                      //   const SizedBox(
                      //     width: 50,
                      //   ),
                      //   AdminMenuSearchBarItem(
                      //     title: 'Auditorium',
                      //     type: 'Auditorium',
                      //     onHighlight: onHighlight,
                      //     selected: index == 1,
                      //     color: selectedColor,
                      //   ),
                      //   const SizedBox(
                      //     width: 50,
                      //   ),
                      //   AdminMenuSearchBarItem(
                      //     title: 'Social Hub',
                      //     type: 'SocialHub',
                      //     onHighlight: onHighlight,
                      //     selected: index == 2,
                      //     color: selectedColor,
                      //   ),
                      // ],
                    ),
                  ),
                  // SizedBox(
                  //   width: 200,
                  //   child: SearchInputField(
                  //     controller: widget.searchController!,
                  //     obsecureText: false,
                  //     enabled: true,
                  //     maxLines: 1,
                  //     hintText: 'Search here...',
                  //     onFieldSubmitted: (value) => widget.search!(widget.type),
                  //     prefixIcon: const ImageIcon(
                  //       AssetImage(
                  //         'assets/icons/search_icon.png',
                  //       ),
                  //       color: davysGray,
                  //     ),
                  //   ),
                  // )
                  // Expanded(
                  //   child: Container(
                  //     //   child: WhiteInputField(
                  //     //     controller: _search!,
                  //     //     enabled: true,
                  //     //     obsecureText: false,
                  //     //   ),
                  //     child: Text('haha'),
                  //   ),
                  // ),

                  // BlackInputField(
                  //   controller: _search!,
                  //   enabled: true,
                  //   obsecureText: false,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  siteListAddButton(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: orangeAccent,
              size: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Add Site',
              style: helveticaText.copyWith(
                fontSize: 16,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: orangeAccent,
              ),
            )
          ],
        ),
      ),
    );
  }

  userListAddButton(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: orangeAccent,
              size: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Add User',
              style: helveticaText.copyWith(
                fontSize: 16,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: orangeAccent,
              ),
            )
          ],
        ),
      ),
    );
  }

  itemListAddButton(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: orangeAccent,
              size: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Add Item',
              style: helveticaText.copyWith(
                fontSize: 16,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: orangeAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AdminMenuSearchBarItem extends StatelessWidget {
  const AdminMenuSearchBarItem({
    super.key,
    this.title,
    this.type,
    this.selected,
    this.onHighlight,
    this.color,
    this.bookingCount,
  });

  final String? title;
  final String? type;
  final bool? selected;
  final Function? onHighlight;
  final Color? color;
  final String? bookingCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onHighlight!(type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
        child: FilterSearchBarInteractiveText(
          text: title,
          selected: selected,
          color: color!,
          bookingCount: bookingCount!,
        ),
      ),
    );
  }
}

// class FilterSearchBarInteractiveItem extends MouseRegion {
//   static final appContainer =
//       html.window.document.querySelectorAll('flt-glass-pane')[0];

//   // bool selected;

//   FilterSearchBarInteractiveItem({
//     Widget? child,
//     String? text,
//     bool? selected,
//     String? type,
//     Color color = blueAccent,
//     String? bookingCount,
//   }) : super(
//           onHover: (PointerHoverEvent evt) {
//             appContainer.style.cursor = 'pointer';
//           },
//           onExit: (PointerExitEvent evt) {
//             appContainer.style.cursor = 'default';
//           },
//           child: FilterSearchBarInteractiveText(
//               text: text!,
//               selected: selected!,
//               color: color,
//               bookingCount: bookingCount),
//         );
// }

class FilterSearchBarInteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;
  final Color color;
  final String? bookingCount;

  FilterSearchBarInteractiveText(
      {@required this.text,
      this.selected,
      this.color = blueAccent,
      this.bookingCount});

  @override
  FilterSearchBarInteractiveTextState createState() =>
      FilterSearchBarInteractiveTextState();
}

class FilterSearchBarInteractiveTextState
    extends State<FilterSearchBarInteractiveText> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide.none,
                right: BorderSide.none,
                top: BorderSide.none,
                bottom: _hovering
                    ? BorderSide(
                        color: widget.color,
                        width: 3,
                        style: BorderStyle.solid,
                      )
                    : (widget.selected!)
                        ? BorderSide(
                            color: widget.color,
                            width: 3,
                            style: BorderStyle.solid,
                          )
                        : BorderSide.none,
              ),
            ),
            child: Text(
              widget.text!,
              style: _hovering
                  ? filterSearchBarText.copyWith(
                      color: widget.color, //eerieBlack,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    )
                  : (widget.selected!)
                      ? filterSearchBarText.copyWith(
                          color: widget.color,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        )
                      : filterSearchBarText.copyWith(
                          color: davysGray,
                          fontWeight: FontWeight.w300,
                          height: 1.3,
                        ),
            ),
          ),
        ),
      ),
    );
  }

  _hovered(bool hovered) {
    setState(() {
      _hovering = hovered;
    });
  }
}
