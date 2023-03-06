import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/functions/api_request.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/dialogs.dart';
import 'package:atk_system_ga/widgets/menu_buttons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();
  String date = "";
  String formId = "";

  @override
  void initState() {
    super.initState();
    apiService.getDateTime().then((value) {
      date = value["Data"]["Date"];
      date = DateFormat("EEEE, dd MMM yyyy").format(DateTime.parse(date));
      setState(() {});
    });
  }

  Future createOrderMonthly() async {
    apiService.createTransaction("Monthly").then((value) {
      print(value);
      if (value["Status"].toString() == "200") {
        formId = value["Data"]["FormID"];
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        ).then((value) {
          context.goNamed(
            'supplies_request',
            params: {"formId": formId},
          );
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: "Error createTransaction",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 0,
      location: '/',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 120,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            infoSection(),
            const SizedBox(
              height: 80,
            ),
            menuSection(),
          ],
        ),
      ),
    );
  }

  Widget infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Supplies Decentralization',
              style: helveticaText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Edward Evannov - 151839',
              style: helveticaText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Role: Supervisor',
              style: helveticaText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: eerieBlack,
              ),
            ),
          ],
        ),
        Text(
          date,
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: eerieBlack,
          ),
        ),
      ],
    );
  }

  Widget menuSection() {
    return Wrap(
      spacing: 50,
      children: [
        MenuButton(
          disabled: false,
          assets: 'assets/icons/shopping_cart.png',
          text: 'Order Supplies',
          onTap: () {
            // context.goNamed('supplies_request');
            createOrderMonthly().then((value) {});
          },
        ),
        MenuButton(
          disabled: false,
          assets: 'assets/icons/add_list.png',
          text: 'Order Additional Supplies',
          onTap: () {},
        ),
        MenuButton(
          disabled: false,
          assets: 'assets/icons/list_view.png',
          text: 'Transaction List',
          onTap: () {
            context.goNamed(
              'transaction_list',
              // params: {"type": "Request"},
              extra: "Request",
            );
          },
        ),
        MenuButton(
          disabled: false,
          assets: 'assets/icons/list_view.png',
          text: 'Settlement',
          onTap: () {
            context.goNamed(
              'transaction_list',
              // params: {"type": "Settlement"},
              extra: "Settlement",
            );
          },
        ),
      ],
    );
  }
}
