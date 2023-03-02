import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/constraints.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:atk_system_ga/layout/layout_page.dart';
import 'package:atk_system_ga/widgets/buttons.dart';
import 'package:atk_system_ga/widgets/menu_buttons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          'Thursday, 15 Sept 2022',
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
            context.goNamed('supplies_request');
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
