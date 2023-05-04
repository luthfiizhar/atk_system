import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/view/dashboard/dashboard_options_widget.dart';
import 'package:atk_system_ga/view_model/global_model.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  late GlobalModel globalModel;

  ApiService apiService = ApiService();

  String month = "";
  int year = 2023;

  String greeting = "";

  setGreeting(String value) {
    greeting = value;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    globalModel = Provider.of<GlobalModel>(context, listen: false);
    final DateTime now = DateTime.now();
    if (now.hour >= 5 && now.hour < 12) {
      setGreeting('Good Morning');
    } else if (now.hour >= 12 && now.hour < 17) {
      setGreeting('Good Afternoon');
    } else if (now.hour >= 17 && now.hour < 21) {
      setGreeting('Good Evening');
    } else if (now.hour >= 21 || now.hour < 5) {
      setGreeting('Good Night');
    }
    apiService.getUserData().then((value) {
      if (value["Status"].toString() == "200") {
        globalModel.setEmpName(value["Data"]["EmpName"]);
        globalModel.setCompanyName(value["Data"]["CompanyName"]);
        month = DateFormat("MMMM").format(DateTime.now());
        year = DateTime.now().year;
        globalModel.setMonth(month);
        globalModel.setYear(year.toString());
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value["Title"],
            contentText: value["Message"],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: globalModel,
      child: Consumer<GlobalModel>(builder: (context, model, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 33),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              greetingsAndName(model.empName),
              companyAndDate(model.companyName, model.month, model.year),
            ],
          ),
        );
      }),
    );
  }

  Widget greetingsAndName(
    String name,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
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
          name,
          style: helveticaText.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: eerieBlack,
          ),
        )
      ],
    );
  }

  Widget companyAndDate(String company, String month, String year) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              globalModel.companyName,
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
              '$month $year',
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
