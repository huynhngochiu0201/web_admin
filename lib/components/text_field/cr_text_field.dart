import 'package:flutter/material.dart';
import '../../constants/app_color.dart';

class CrTextField extends StatelessWidget {
  const CrTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
    this.labelText,
    this.height = 48.6,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final Icon? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      validator: validator,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        fontSize: 16,
        color: AppColor.black,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: prefixIcon,
              )
            : null,
        errorStyle: const TextStyle(
          color: AppColor.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        border: _buildBorder(AppColor.grey.withOpacity(0.3)),
        enabledBorder: _buildBorder(AppColor.grey.withOpacity(0.3)),
        focusedBorder: _buildBorder(AppColor.blue),
        errorBorder: _buildBorder(AppColor.red),
        focusedErrorBorder: _buildBorder(AppColor.red),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.2),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
