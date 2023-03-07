import 'dart:math';

import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/widgets/search_input_field.dart';
import 'package:flutter/material.dart';

class FilterSearchBarTransactionList extends StatefulWidget {
  FilterSearchBarTransactionList({
    super.key,
    this.type = "Supplies Request",
    this.typeList,
    this.updateList,
    this.search,
    this.searchController,
  });

  Function? updateList;
  Function? search;
  List? typeList;
  String? type;
  TextEditingController? searchController;

  @override
  State<FilterSearchBarTransactionList> createState() =>
      _FilterSearchBarTransactionListState();
}

class _FilterSearchBarTransactionListState
    extends State<FilterSearchBarTransactionList> {
  bool onSelected = false;
  String? documentType;
  TextEditingController? _search = TextEditingController();

  List<Color> color = [blueAccent, greenAcent, orangeAccent, violetAccent];
  late int indexColor;
  late Color selectedColor = blueAccent;
  final _random = Random();

  void onHighlight(String type) {
    switch (type) {
      case "Supply Request":
        changeHighlight("Supply Request");
        widget.updateList!(type);
        break;
      case "Settlement":
        changeHighlight("Settlement");
        widget.updateList!(type);
        break;
    }
  }

  void changeHighlight(String type) {
    setState(() {
      // index = newIndex;
      documentType = type;
    });
  }

  @override
  void initState() {
    super.initState();
    documentType = widget.type;
    indexColor = _random.nextInt(color.length);
    selectedColor = color[indexColor];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
      padding: EdgeInsets.zero,
      height: 61,
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
                      children: widget.typeList!.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 50,
                          ),
                          child: FilterSearchBarTransactionListItem(
                            title: e['Name'],
                            type: e['Value'],
                            bookingCount: e['BookingCount'].toString(),
                            onHighlight: onHighlight,
                            color: selectedColor,
                            selected: documentType == e['Value'],
                          ),
                        );
                      }).toList(),
                      // children: [
                      //   FilterSearchBarTransactionListItem(
                      //     title: 'Meeting Room',
                      //     type: 'MeetingRoom',
                      //     onHighlight: onHighlight,
                      //     selected: index == 0,
                      //     color: selectedColor,
                      //   ),
                      //   const SizedBox(
                      //     width: 50,
                      //   ),
                      //   FilterSearchBarTransactionListItem(
                      //     title: 'Auditorium',
                      //     type: 'Auditorium',
                      //     onHighlight: onHighlight,
                      //     selected: index == 1,
                      //     color: selectedColor,
                      //   ),
                      //   const SizedBox(
                      //     width: 50,
                      //   ),
                      //   FilterSearchBarTransactionListItem(
                      //     title: 'Social Hub',
                      //     type: 'SocialHub',
                      //     onHighlight: onHighlight,
                      //     selected: index == 2,
                      //     color: selectedColor,
                      //   ),
                      // ],
                    ),
                  ),
                  Container(
                    width: 200,
                    // color: Colors.green,
                    // child: Text('haha'),
                    child: SearchInputField(
                      controller: widget.searchController!,
                      obsecureText: false,
                      enabled: true,
                      maxLines: 1,
                      hintText: 'Search here...',
                      onFieldSubmitted: (value) => widget.search!(),
                      prefixIcon: const ImageIcon(
                        AssetImage(
                          'assets/icons/search_icon.png',
                        ),
                        color: davysGray,
                      ),
                    ),
                  )
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
}

class FilterSearchBarTransactionListItem extends StatelessWidget {
  const FilterSearchBarTransactionListItem({
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
            child: Wrap(
              children: [
                Text(
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
                widget.bookingCount == "0"
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: sonicSilver,
                          ),
                          child: Text(
                            widget.bookingCount!,
                            style: helveticaText.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: culturedWhite,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
              ],
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
