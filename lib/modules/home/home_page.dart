import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/custom_behavior.dart';
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

  String name = "";
  String nip = "";
  String role = "";
  String photo = "";

  ScrollController toDoListScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    apiService.getDateTime().then((value) {
      date = value["Data"]["Date"];
      date = DateFormat("EEEE, dd MMM yyyy").format(DateTime.parse(date));
      setState(() {});
    });
    apiService.getUserData().then((value) {
      if (value["Status"].toString() == "200") {
        name = value["Data"]["EmpName"];
        nip = value["Data"]["EmpNIP"];
        role = value["Data"]["Role"];
        photo = value["Data"]["Photo"];
        setState(() {});
      } else {}
    });
  }

  Future createOrderMonthly() async {
    apiService.createTransaction("Monthly").then((value) {
      print(value);
      if (value["Status"].toString() == "200") {
        String status = value['Data']['Status'];
        formId = value["Data"]["FormID"];
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        ).then((value) {
          if (status == "Draft") {
            context.goNamed(
              'supplies_request',
              params: {"formId": formId},
            );
          } else {
            context.goNamed(
              'request_order_detail',
              params: {"formId": formId},
            );
          }
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
            // const SizedBox(
            //   height: 75,
            // ),
            // toDoListSection(),
            // const SizedBox(
            //   height: 100,
            // )
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
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  color: davysGray,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name - $nip',
                      style: helveticaText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        height: 1.75,
                        color: davysGray,
                      ),
                    ),
                    Text(
                      'Role: $role',
                      style: helveticaText.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: sonicSilver,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                SizedBox(
                  height: 46,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: sonicSilver,
                            // size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            date,
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Text(
            //   'Edward Evannov - 151839',
            //   style: helveticaText.copyWith(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w300,
            //     color: eerieBlack,
            //   ),
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            // Text(
            //   'Role: Supervisor',
            //   style: helveticaText.copyWith(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w300,
            //     color: eerieBlack,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget menuSection() {
    return Wrap(
      spacing: 100,
      runSpacing: 40,
      children: [
        MenuButton(
          disabled: false,
          assets: 'assets/icons/menu_cart.png',
          description: 'Create monthly supplies order based on your site needs',
          text: 'Order Supplies',
          onTap: () {
            // context.goNamed('supplies_request');
            createOrderMonthly().then((value) {});
          },
        ),
        MenuButton(
          disabled: false,
          assets: 'assets/icons/menu_list_icon.png',
          text: 'Transaction List',
          description: 'List of your monthly / additional supplies transaction',
          onTap: () {
            context.goNamed(
              'transaction_list',
              extra: "Supply Request",
            );
          },
        ),
        MenuButton(
          disabled: false,
          assets: 'assets/icons/menu_add.png',
          text: 'Order Additional Supplies',
          description:
              'Ask for additional supplies that you’ve missed in monthly order',
          onTap: () {},
        ),
        MenuButton(
          disabled: false,
          assets: 'assets/icons/menu_check.png',
          text: 'Settlement',
          description: 'Settle you approved transaction',
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

  Widget toDoListSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 25,
        left: 25,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: platinum,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'To Do List',
                  style: helveticaText.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: eerieBlack,
                  ),
                ),
              ),
              Wrap(
                spacing: 5,
                children: [
                  InkWell(
                    onTap: () {
                      double offset = toDoListScroll.offset - 100.0;
                      toDoListScroll.animateTo(offset,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.linear);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_left_sharp,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      double offset = toDoListScroll.offset + 100.0;
                      toDoListScroll.animateTo(offset,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.linear);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_right_sharp,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 45,
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 190,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                controller: toDoListScroll,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: Container(
                      width: 380,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
