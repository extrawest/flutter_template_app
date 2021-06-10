import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template_app/theme/theme.dart';

/// [CustomTextField] text field that can be as single line as multiline

class CustomTextField extends StatelessWidget {
  final bool obscure;
  final TextInputType? keyboardType;
  final String? textHint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? changeCallback;
  final TextInputAction? action;

  final String? suffixText;
  final Function()? suffixCallback;

  final Function()? fieldSubmitted;

  final String? Function(String? value)? validator;
  final List<TextInputFormatter>? inputFormatterList;

  final double elevation;
  final Color underlayColor;
  final int minLines;
  final int maxLines;

  const CustomTextField(
      {Key? key,
      this.obscure = false,
      this.keyboardType,
      this.textHint,
      this.controller,
      this.focusNode,
      this.changeCallback,
      this.action,
      this.suffixText,
      this.suffixCallback,
      this.fieldSubmitted,
      this.validator,
      this.elevation = 0,
      this.inputFormatterList,
      this.underlayColor = Colors.transparent,
      this.minLines = 1,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      color: underlayColor,
      elevation: elevation,
      child: TextFormField(
        obscureText: obscure,
        inputFormatters: inputFormatterList ?? [],
        autocorrect: false,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        onChanged: changeCallback,
        textInputAction: action,
        minLines: minLines,
        maxLines: maxLines,
        onFieldSubmitted: (_) => fieldSubmitted?.call(),
        style: Theme.of(context).textTheme.bodyText1,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(22, 24, 12, 16),
          hintText: textHint,
          errorMaxLines: 2,
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkRed, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkRed, width: 3),
            borderRadius: BorderRadius.circular(18),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(width: 1, color: Theme.of(context).accentColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18), borderSide: BorderSide(width: 1)),
        ),
      ),
    );
  }
}
