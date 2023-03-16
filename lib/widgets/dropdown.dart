import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
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
        width: 120,
        height: 39,
      ),
      // buttonWidth: 120,
      // buttonHeight: 39,
      value: value,
      focusNode: focusNode,
      // isExpanded: true,
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
        // icon: suffixIcon,
      ),
      iconStyleData: IconStyleData(
        icon: suffixIcon!,
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

      hint: Text(
        hintText!,
        style: const TextStyle(
          fontFamily: 'Helvetica',
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
      // dropdownDecoration: ,
      // offset: const Offset(0, -20),
    );
    ;
  }
}

class SearchDropDown extends StatelessWidget {
  SearchDropDown({
    super.key,
    required List<DropdownMenuItem<String>>? items,
    required this.value,
    required this.onChanged,
    this.hintText = "Search",
    this.suffixIcon,
  }) : items = items ?? [];

  TextEditingController searchController = TextEditingController();
  List<DropdownMenuItem<String>> items;
  List<double>? customHeights;
  dynamic value;
  ValueChanged? onChanged;
  String hintText;
  Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        iconStyleData: IconStyleData(
          icon: suffixIcon!,
        ),
        hint: Text(
          hintText,
          style: helveticaText.copyWith(
            fontSize: 14,
            color: eerieBlack,
          ),
        ),
        items: items,
        value: value,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          width: 500,
          height: 39,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: davysGray,
              width: 1,
            ),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: 500,
          offset: const Offset(2, 0),
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
        dropdownSearchData: DropdownSearchData(
          searchController: searchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 0,
                ),
                hintText: 'Search here ...',
                hintStyle: TextStyle(fontSize: 12),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: davysGray,
                  ),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return (item.value.toString().contains(searchValue));
          },
        ),
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            searchController.clear();
          }
        },
      ),
    );
  }
}
