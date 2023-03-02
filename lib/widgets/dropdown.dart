import 'package:atk_system_ga/constant/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BlackDropdown extends StatelessWidget {
  BlackDropdown({
    required this.items,
    this.hintText,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
    this.onTap,
    this.value,
    this.customHeights,
  });

  final List<DropdownMenuItem<dynamic>>? items;
  final String? hintText;
  final FocusNode? focusNode;
  final ValueChanged? onChanged;
  final FormFieldValidator? validator;
  Widget? suffixIcon = Icon(Icons.keyboard_arrow_down_sharp);
  final bool? enabled;
  final VoidCallback? onTap;
  final dynamic value;
  final List<double>? customHeights;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      buttonStyleData: const ButtonStyleData(
        height: 40,
      ),
      isExpanded: true,
      value: value,
      focusNode: focusNode,
      items: items,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: sonicSilver,
            width: 1,
          ),
          color: culturedWhite,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        customHeights: customHeights,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
      ),
      iconStyleData: IconStyleData(
        icon: suffixIcon!,
        openMenuIcon: suffixIcon,
      ),
      // customItemsHeights: customHeights,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: grayx11,
            width: 1,
          ),
        ),
        fillColor: enabled!
            ? focusNode!.hasFocus
                ? culturedWhite
                : Colors.transparent
            : platinum,
        filled: true,
        isDense: true,
        // isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: lightGray,
        ),
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 0,
          bottom: 12,
        ),
        // suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
      ),
      // itemPadding: const EdgeInsets.only(
      //   left: 20,
      //   right: 20,
      // ),
      // icon: suffixIcon,
      hint: Text(
        hintText!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
      ),
      // buttonPadding: EdgeInsets.only(
      //   right: 5,
      //   left: 5,
      //   top: 0,
      //   bottom: 0,
      // ),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        fontFamily: 'Helvetica',
      ),
      // buttonDecoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(5),
      //   border: Border.all(
      //     color: eerieBlack,
      //     width: 1,
      //   ),
      //   color: culturedWhite,
      // ),

      // offset: const Offset(0, -20),
    );
  }
}
