import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlackInputField extends StatefulWidget {
  BlackInputField({
    required this.controller,
    this.hintText,
    FocusNode? focusNode,
    this.obsecureText = false,
    this.onSaved,
    this.suffixIcon,
    this.validator,
    required this.enabled,
    this.onTap,
    this.maxLines = 1,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.fontSize = 16,
    this.textInputAction,
    this.inputFormatters,
    this.onEditingComplete,
    this.onChanged,
    this.prefixText = "",
    this.contentPadding =
        const EdgeInsets.only(right: 15, left: 15, top: 18, bottom: 15),
    Widget? prefix,
  })  : focusNode = focusNode ?? FocusNode(),
        prefix = prefix ?? SizedBox();

  final TextEditingController controller;
  final String? hintText;
  FocusNode? focusNode;
  final bool? obsecureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator? validator;
  final Widget? suffixIcon;
  final bool? enabled;
  final VoidCallback? onTap;
  final String prefixText;
  Widget? prefix;
  ValueChanged<String>? onFieldSubmitted;
  ValueChanged<String>? onChanged;
  int? maxLines;
  Widget? prefixIcon;
  VoidCallback? onEditingComplete;
  TextInputAction? textInputAction;
  double fontSize;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry contentPadding;

  @override
  State<BlackInputField> createState() => _BlackInputFieldState();
}

class _BlackInputFieldState extends State<BlackInputField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: widget.focusNode!.hasFocus
            ? const [
                BoxShadow(
                  blurRadius: 40,
                  offset: Offset(0, 10),
                  // blurStyle: BlurStyle.outer,
                  color: Color.fromRGBO(29, 29, 29, 0.2),
                )
              ]
            : null,
      ),
      child: TextFormField(
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: widget.onEditingComplete,
        mouseCursor: widget.enabled! ? null : SystemMouseCursors.click,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onSaved: widget.onSaved,
        enabled: widget.enabled,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obsecureText!,
        cursorColor: eerieBlack,
        maxLines: widget.maxLines,
        inputFormatters: widget.inputFormatters,
        onTap: widget.onTap,
        decoration: InputDecoration(
          // prefix: widget.prefix!,
          prefixText: widget.prefixText,
          prefixStyle: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: eerieBlack,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: grayx11,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: orangeAccent,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(
            color: orangeAccent,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            overflow: TextOverflow.clip,
          ),
          fillColor: widget.enabled!
              ? widget.focusNode!.hasFocus
                  ? culturedWhite
                  : Colors.transparent
              : platinum,
          filled: true,
          // isDense: true,
          isCollapsed: true,
          focusColor: culturedWhite,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w300,
            color: sonicSilver,
          ),
          contentPadding: widget.contentPadding,
          suffixIcon: widget.suffixIcon,
          suffixIconColor: eerieBlack,
          prefixIcon: widget.prefixIcon,
        ),
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  CustomInputField({
    required this.controller,
    this.hintText,
    FocusNode? focusNode,
    this.obsecureText = false,
    this.onSaved,
    this.suffixIcon,
    this.validator,
    required this.enabled,
    this.onTap,
    this.maxLines = 1,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.fontSize = 16,
    this.textInputAction,
    this.inputFormatters,
    this.onEditingComplete,
    this.onChanged,
    this.prefixText = "",
    this.contentPadding =
        const EdgeInsets.only(right: 15, left: 15, top: 18, bottom: 15),
    Widget? prefix,
  })  : focusNode = focusNode ?? FocusNode(),
        prefix = prefix ?? SizedBox();

  final TextEditingController controller;
  final String? hintText;
  FocusNode? focusNode;
  final bool? obsecureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator? validator;
  final Widget? suffixIcon;
  final bool? enabled;
  final VoidCallback? onTap;
  final String prefixText;
  Widget? prefix;
  ValueChanged<String>? onFieldSubmitted;
  ValueChanged<String>? onChanged;
  int? maxLines;
  Widget? prefixIcon;
  VoidCallback? onEditingComplete;
  TextInputAction? textInputAction;
  double fontSize;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry contentPadding;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: widget.focusNode!.hasFocus
            ? const [
                BoxShadow(
                  blurRadius: 40,
                  offset: Offset(0, 10),
                  // blurStyle: BlurStyle.outer,
                  color: Color.fromRGBO(29, 29, 29, 0.2),
                )
              ]
            : null,
      ),
      child: TextFormField(
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: widget.onEditingComplete,
        enableInteractiveSelection: false,
        readOnly: true,
        mouseCursor: SystemMouseCursors.click,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onSaved: widget.onSaved,
        enabled: widget.enabled,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obsecureText!,
        cursorColor: eerieBlack,
        maxLines: widget.maxLines,
        inputFormatters: widget.inputFormatters,
        onTap: widget.onTap,
        decoration: InputDecoration(
          // prefix: widget.prefix!,
          prefixText: widget.prefixText,
          prefixStyle: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: eerieBlack,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: grayx11,
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
              color: davysGray,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: orangeAccent,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(
            color: orangeAccent,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            overflow: TextOverflow.clip,
          ),
          fillColor: widget.enabled!
              ? widget.focusNode!.hasFocus
                  ? culturedWhite
                  : Colors.transparent
              : platinum,
          filled: true,
          // isDense: true,
          isCollapsed: true,
          enabled: widget.enabled!,
          focusColor: culturedWhite,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w300,
            color: sonicSilver,
          ),
          contentPadding: widget.contentPadding,
          suffixIcon: widget.suffixIcon,
          suffixIconColor: eerieBlack,
          prefixIcon: widget.prefixIcon,
        ),
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.'; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
          newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
