import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: screenWidth,
          maxWidth: screenWidth,
          minHeight: screenHeight,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    height: 215,
                    child: Image.asset(
                      "assets/maintenance_image.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  Text(
                    "Under Maintenance",
                    style: helveticaText.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    "The system is upgrading. We will back soon!",
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 20,
              child: SizedBox(
                height: 50,
                width: 450,
                child: Image.asset("assets/error_image.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
