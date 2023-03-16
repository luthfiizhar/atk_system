import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationItem extends StatelessWidget {
  final String? title;
  final String? routeName;
  final bool? selected;
  final Function? onHighlight;

  const NavigationItem({
    @required this.title,
    this.routeName,
    this.selected,
    this.onHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(routeName!);
        onHighlight!(routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
        child: InteractiveText(
          text: title,
          selected: selected,
        ),
      ),
    );
  }
}

// class InteractiveNavItem extends MouseRegion {
//   static final appContainer =
//       html.window.document.querySelectorAll('flt-glass-pane')[0];

//   // bool selected;

//   InteractiveNavItem(
//       {Widget? child,
//       String? text,
//       bool? selected,
//       String? routeName,
//       GlobalKey? key})
//       : super(
//           onHover: (PointerHoverEvent evt) {
//             appContainer.style.cursor = 'pointer';
//           },
//           onExit: (PointerExitEvent evt) {
//             appContainer.style.cursor = 'default';
//           },
//           child: InteractiveText(text: text!, selected: selected!),
//         );
// }

class InteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;

  InteractiveText({@required this.text, this.selected});

  @override
  InteractiveTextState createState() => InteractiveTextState();
}

class InteractiveTextState extends State<InteractiveText> {
  bool _hovering = false;
  bool onSelected = false;

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
            padding: EdgeInsets.zero,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     color: _hovering
            //         ? eerieBlack
            //         : (widget.selected!)
            //             ? eerieBlack
            //             : Colors.transparent),
            child: Text(
              widget.text!,
              style: _hovering
                  ? navBarText.copyWith(
                      fontSize: 18,
                      color: davysGray,
                      fontWeight: FontWeight.w400)
                  : (widget.selected!)
                      ? navBarText.copyWith(
                          fontSize: 18,
                          color: davysGray,
                          fontWeight: FontWeight.w400)
                      : navBarText.copyWith(
                          fontSize: 18,
                          color: sonicSilver,
                          fontWeight: FontWeight.w300),
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
