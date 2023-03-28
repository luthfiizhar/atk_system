import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({
    super.key,
    List<DateTime?>? rangeDatePickerValue,
    this.onChangedDate,
  }) : rangeDatePickerValue = rangeDatePickerValue ?? [];

  List<DateTime?> rangeDatePickerValue;
  Function? onChangedDate;

  CalendarDatePicker2Config config = CalendarDatePicker2Config(
    calendarType: CalendarDatePicker2Type.range,
    dayTextStyle: helveticaText,
    yearTextStyle: helveticaText,
    todayTextStyle: helveticaText,
    selectedDayTextStyle: helveticaText.copyWith(color: white),
    selectedYearTextStyle: helveticaText.copyWith(color: white),
    weekdayLabelTextStyle: helveticaText,
    controlsTextStyle: helveticaText,
    selectedDayHighlightColor: eerieBlack,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      child: CalendarDatePicker2(
        config: config,
        value: rangeDatePickerValue,
        onDisplayedMonthChanged: (value) {
          // print(value);
          if (rangeDatePickerValue.length == 1) {}
        },
        onValueChanged: (dates) {
          rangeDatePickerValue = dates;
          // print(dates);
          onChangedDate!(dates);
        },
      ),
    );
  }
}
