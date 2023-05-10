import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/material.dart';

class ShowMoreIcon extends StatelessWidget {
  ShowMoreIcon({
    super.key,
    Function? showMoreCallback,
    Function? exportCallback,
    GlobalKey? iconKey,
  })  : iconKey = iconKey ?? GlobalKey(),
        showMoreCallback = showMoreCallback ?? (() {}),
        exportCallback = exportCallback ?? (() {});

  GlobalKey iconKey;
  Function showMoreCallback;
  Function exportCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          RenderBox? renderBox =
              iconKey.currentContext!.findRenderObject() as RenderBox?;
          var size = renderBox!.size;
          var offset = renderBox.localToGlobal(Offset.zero);
          showMenu(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              position: RelativeRect.fromLTRB(
                  offset.dx, offset.dy + 30, offset.dx, 0),
              items: [
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => showMoreCallback(),
                    );
                  },
                  child: Text(
                    'Show More',
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => exportCallback(),
                    );
                  },
                  child: Text(
                    'Export',
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
              ]);
        },
        child: Icon(key: iconKey, Icons.more_vert_sharp));
  }
}
