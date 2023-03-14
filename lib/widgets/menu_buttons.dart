import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  MenuButton({
    super.key,
    this.assets,
    this.onTap,
    this.disabled = false,
    this.text = "",
    this.description = "",
  });

  VoidCallback? onTap;
  bool? disabled;
  String? assets;
  String text;
  String description;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return white;
    }
    return eerieBlack;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Color.fromARGB(0, 255, 255, 255),
      hoverColor: Color.fromARGB(0, 255, 255, 255),
      splashFactory: NoSplash.splashFactory,
      splashColor: Color.fromARGB(0, 255, 255, 255),
      onTap: onTap,
      child: SizedBox(
        width: 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 75,
            //   width: 75,
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       splashFactory: NoSplash.splashFactory,
            //       foregroundColor: MaterialStateProperty.resolveWith(getColor),
            //       backgroundColor:
            //           MaterialStateProperty.resolveWith<Color>((states) {
            //         return disabled! ? grayx11 : white;
            //       }),
            //       shape:
            //           MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
            //         if (states.contains(MaterialState.pressed)) {
            //           return RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             side: BorderSide(color: eerieBlack, width: 1),
            //           );
            //         }
            //         return RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10),
            //             side: const BorderSide(
            //               color: lightGray,
            //               width: 1,
            //             ));
            //       }),
            //       overlayColor: MaterialStateProperty.resolveWith<Color?>(
            //         (Set<MaterialState> states) {
            //           if (states.contains(MaterialState.pressed))
            //             return eerieBlack;
            //           // if (states.contains(MaterialState.hovered)) return davysGray;
            //           return null;
            //         },
            //       ),
            //       padding:
            //           MaterialStateProperty.resolveWith<EdgeInsets>((states) {
            //         return EdgeInsets.zero;
            //       }),
            //     ),
            //     onPressed: disabled! ? null : onTap,
            //     child: Center(
            //       child: ImageIcon(
            //         Image.asset(assets!).image,
            //         size: 35,
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                border: Border.all(
                  color: lightGray,
                  width: 1,
                ),
                color: white,
              ),
              child: Center(
                child: ImageIcon(
                  Image.asset(assets!).image,
                  size: 35,
                  color: davysGray,
                ),
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: helveticaText.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    description,
                    style: helveticaText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: sonicSilver,
                      height: 1.38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
