import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class CustomTextField extends StatelessWidget {
  Color? borderColor;
  String? hintText;
  String? labelText;
  TextStyle? hintStyle;
  TextStyle? labelStyle;
  Widget? prefixIcon;
  Widget? suffixIcon;
  int? maxLines;
  TextEditingController? controller;
  String? Function(String?)? validator;
  TextInputType? keyboardInputType;
  bool? obscureText;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;

  CustomTextField({
    this.controller,
    this.validator,
    this.borderColor,
    this.hintText,
    this.labelText,
    this.hintStyle,
    this.labelStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.keyboardInputType,
    this.obscureText,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Theme.of(context).indicatorColor),
      maxLines: maxLines ?? 1,
      keyboardType: keyboardInputType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      obscuringCharacter: '*',
      controller: controller,
      validator: validator,
      cursorColor: AppColors.greyColor,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.greyColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.greyColor,
            width: 1,
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        hintStyle: hintStyle ?? AppStyles.medium16Gray,
        labelStyle: labelStyle ?? AppStyles.medium16Gray,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
