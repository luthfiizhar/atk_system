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
  });

  VoidCallback? onTap;
  bool? disabled;
  String? assets;
  String text;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return eerieBlack;
    }
    return culturedWhite;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            foregroundColor: MaterialStateProperty.resolveWith(getColor),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return disabled! ? grayx11 : eerieBlack;
            }),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
              return const CircleBorder();
            }),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return white;
                if (states.contains(MaterialState.hovered)) return davysGray;
                return null;
              },
            ),
            padding: MaterialStateProperty.resolveWith<EdgeInsets>((states) {
              return const EdgeInsets.all(37.5);
            }),
          ),
          onPressed: disabled! ? null : onTap,
          child: ImageIcon(
            Image.asset(assets!).image,
            size: 75,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          text,
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: eerieBlack,
          ),
        )
      ],
    );
  }
}
