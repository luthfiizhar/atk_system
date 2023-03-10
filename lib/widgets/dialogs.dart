import 'dart:convert';

import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertDialogBlack extends StatelessWidget {
  const AlertDialogBlack({
    required this.title,
    required this.contentText,
    this.isSuccess = true,
  });

  final String? title;
  final String? contentText;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: eerieBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: MediaQuery.of(context).size.width < 1200
          ? const EdgeInsets.symmetric(
              horizontal: 13,
            )
          : null,
      child: MediaQuery.of(context).size.width < 1200
          ? mobile(context)
          : desktop(context),
    );
  }

  Widget mobile(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: double.infinity,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title!,
              style: helveticaText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isSuccess ? greenAcent : orangeAccent,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              contentText!,
              style: helveticaText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: WhiteRegularButton(
                    text: 'Ok',
                    disabled: false,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget desktop(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 560,
        minWidth: 385,
        minHeight: 200,
        maxHeight: double.infinity,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        child: Stack(
          children: [
            Container(
              // color: Colors.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Wrap(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title!,
                        style: titlePageAlertDialog.copyWith(
                          color: isSuccess ? greenAcent : orangeAccent,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        contentText!,
                        style: bodyTextAlertDialog.copyWith(
                          color: culturedWhite,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     // SizedBox(),
                  //     TransparentButtonWhite(
                  //       text: 'Cancel',
                  //       onTap: () {},
                  //       padding: ButtonSize().smallSize(),
                  //     ),
                  //     const SizedBox(
                  //       width: 15,
                  //     ),
                  //     WhiteRegularButton(
                  //       text: 'Confirm',
                  //       onTap: () {},
                  //       padding: ButtonSize().smallSize(),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(),
                  // TransparentButtonWhite(
                  //   text: 'Cancel',
                  //   onTap: () {
                  //     Navigator.of(context).pop(false);
                  //   },
                  //   padding: ButtonSize().mediumSize(),
                  // ),

                  WhiteRegularButton(
                    text: 'OK',
                    onTap: () {
                      Navigator.pop(context);
                    },
                    padding: ButtonSize().mediumSize(),
                    disabled: false,
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

class TokenExpiredDialog extends StatelessWidget {
  const TokenExpiredDialog({
    required this.title,
    required this.contentText,
    this.isSuccess = false,
  });

  final String? title;
  final String? contentText;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: eerieBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          minWidth: 385,
          minHeight: 200,
          maxHeight: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Stack(
            children: [
              Container(
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title!,
                          style: titlePageAlertDialog.copyWith(
                            color: isSuccess ? greenAcent : orangeAccent,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contentText!,
                          style: bodyTextAlertDialog.copyWith(
                            color: culturedWhite,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     // SizedBox(),
                    //     TransparentButtonWhite(
                    //       text: 'Cancel',
                    //       onTap: () {},
                    //       padding: ButtonSize().smallSize(),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     WhiteRegularButton(
                    //       text: 'Confirm',
                    //       onTap: () {},
                    //       padding: ButtonSize().smallSize(),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(),
                    // TransparentButtonWhite(
                    //   text: 'Cancel',
                    //   onTap: () {
                    //     Navigator.of(context).pop(false);
                    //   },
                    //   padding: ButtonSize().mediumSize(),
                    // ),

                    WhiteRegularButton(
                      text: 'OK',
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/login');
                      },
                      padding: ButtonSize().mediumSize(),
                      disabled: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

class PictureDetail extends StatelessWidget {
  PictureDetail({
    super.key,
    // this.image = Uint8List.fromList([]),
    this.urlImage,
  });

  Uint8List image = Uint8List.fromList([
    67,
    58,
    92,
    108,
    97,
    114,
    97,
    103,
    111,
    110,
    92,
    119,
    119,
    119,
    92,
    103,
    115,
    115,
    92,
    112,
    117,
    98,
    108,
    105,
    99,
    92,
    47,
    116,
    114,
    97,
    110,
    115,
    97,
    99,
    116,
    105,
    111,
    110,
    115,
    47,
    72,
    51,
    48,
    49,
    83,
    85,
    80,
    77,
    48,
    51,
    50,
    51,
    48,
    49,
    47,
    67,
    54,
    112,
    69,
    49,
    56,
    121,
    121,
    95,
    50,
    48,
    50,
    51,
    48,
    51,
    49,
    48,
    49,
    48,
    51,
    56,
    53,
    56,
    95,
    49,
    46,
    106,
    112,
    101,
    103
  ]);
  String? urlImage;

  Map<String, String> requestHeader = {
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Access-Control-Allow-Origin': '*'
  };

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.
    return Dialog(child: Image.memory(image)
        // : Image.network(urlImage!, fit: BoxFit.cover),
        );
  }
}
