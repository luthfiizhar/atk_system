import 'package:atk_system_ga/constant/colors.dart';
import 'package:atk_system_ga/constant/text_style.dart';
import 'package:flutter/material.dart';

class SearchInputField extends StatefulWidget {
  SearchInputField({
    required this.controller,
    this.hintText,
    // this.focusNode,
    this.obsecureText = false,
    this.onSaved,
    this.suffixIcon,
    this.validator,
    required this.enabled,
    this.onTap,
    this.maxLines,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.fontSize = 16,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? hintText;
  // final FocusNode? focusNode;
  final bool? obsecureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator? validator;
  final Widget? suffixIcon;
  final bool? enabled;
  final VoidCallback? onTap;
  ValueChanged<String>? onFieldSubmitted;
  ValueChanged<String>? onChanged;
  int? maxLines;
  Widget? prefixIcon;
  double fontSize;
  FocusNode focusNode = FocusNode();

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: widget.focusNode.hasFocus
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
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        onSaved: widget.onSaved,
        enabled: widget.enabled,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obsecureText!,
        cursorColor: eerieBlack,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5),
            borderSide: const BorderSide(
              color: grayx11,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5),
            borderSide: const BorderSide(
              color: grayx11,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5),
            borderSide: const BorderSide(
              color: davysGray,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5),
            borderSide: const BorderSide(
              color: grayx11,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.5),
            borderSide: const BorderSide(
              color: orangeAccent,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(
            color: orangeAccent,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          fillColor: widget.enabled!
              ? widget.focusNode.hasFocus
                  ? culturedWhite
                  : Colors.transparent
              : platinum,
          filled: true,
          // isDense: true,
          isCollapsed: true,
          focusColor: culturedWhite,
          hintText: widget.hintText,
          hintStyle: helveticaText.copyWith(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w300,
            color: sonicSilver,
          ),
          contentPadding: const EdgeInsets.only(
            right: 15,
            left: 15,
            top: 17,
            bottom: 15,
          ),
          suffixIcon: widget.suffixIcon,
          suffixIconColor: eerieBlack,
          prefixIcon: widget.prefixIcon,
        ),
        style: helveticaText.copyWith(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
      ),
    );
  }
}
