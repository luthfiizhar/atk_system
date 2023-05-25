import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/material.dart';

class FooterWeb extends StatelessWidget {
  const FooterWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: culturedWhite,
      ),
      child: Center(
        child: Text(
          '© 2023 Facility Management. All Rights Reserved.',
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
      ),
      // child: Stack(
      //   children: [
      //     Positioned(
      //       top: 10,
      //       left: 40,
      //       child: Container(
      //         width: 170,
      //         height: 55,
      //         child: Image.asset(
      //           'assets/navbarlogo.png',
      //           fit: BoxFit.contain,
      //         ),
      //       ),
      //     ),
      //     const Positioned(
      //       // alignment: Alignment.center,
      //       top: 28,
      //       left: 100,
      //       right: 100,
      //       child: Align(
      //         alignment: Alignment.center,
      //         child: Text(
      //           '@Copyright Kawan Lama Group 2022. All Rights Reserved.',
      //           style: TextStyle(
      //             fontSize: 16,
      //             color: davysGray,
      //             fontWeight: FontWeight.w300,
      //             height: 1.15,
      //           ),
      //         ),
      //       ),
      //     ),
      //     const Positioned(
      //       top: 28,
      //       right: 40,
      //       child: Text(
      //         'Facility Management. 2022.',
      //         style: TextStyle(
      //           fontSize: 16,
      //           color: davysGray,
      //           fontWeight: FontWeight.w300,
      //           height: 1.15,
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
