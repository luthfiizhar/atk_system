import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/view/dashboard/dashboard_options_widget.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatefulWidget {
  DashboardHeader({
    super.key,
    Function? showOverlay,
    Function? closeOverlay,
    required this.unitKey,
    required this.optionLayerLink,
  })  : showOverlay = showOverlay ?? (() {}),
        closeOverlay = closeOverlay ?? (() {});

  GlobalKey unitKey;
  LayerLink optionLayerLink;
  Function showOverlay;
  Function closeOverlay;

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 33),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          greetingsAndName(),
          companyAndDate(),
        ],
      ),
    );
  }

  Widget greetingsAndName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning,',
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Melvin Zimmerman',
          style: helveticaText.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: eerieBlack,
          ),
        )
      ],
    );
  }

  Widget companyAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'PT. Ace Hardware Indonesia, Tbk',
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'September 2023',
              style: helveticaText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          onTap: () {
            // widget.showOverlay();
            showDialog(
              context: context,
              builder: (context) => const DashboardOptionsWidget(),
            );
          },
          child: Container(
            height: 65,
            width: 65,
            key: widget.unitKey,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: platinum,
                  width: 1,
                )),
            child: Image.asset(
              'assets/ace_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
    );
  }
}
