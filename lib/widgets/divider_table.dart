import 'package:atk_system_ga/constant/colors.dart';
import 'package:flutter/material.dart';

class DividerTable extends StatefulWidget {
  const DividerTable({super.key});

  @override
  State<DividerTable> createState() => _DividerTableState();
}

class _DividerTableState extends State<DividerTable> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Divider(
        color: grayx11,
        thickness: 0.5,
      ),
    );
  }
}
