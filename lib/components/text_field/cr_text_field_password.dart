import 'package:flutter/material.dart';
import '../../constants/app_color.dart';

class CrTextFieldPassword extends StatefulWidget {
  const CrTextFieldPassword({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? hintText;
  // final Icon? prefixIcon;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  // final bool readOnly;

  @override
  State<CrTextFieldPassword> createState() => _CrTextFieldPasswordState();
}

class _CrTextFieldPasswordState extends State<CrTextFieldPassword> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );

    return Stack(
      children: [
        Container(
          height: 48.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: AppColor.shadow,
                offset: Offset(0.0, 3.0),
                blurRadius: 6.0,
              ),
            ],
          ),
        ),
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: !showPassword,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.6),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            border: outlineInputBorder(AppColor.red),
            focusedBorder: outlineInputBorder(AppColor.blue),
            enabledBorder: outlineInputBorder(AppColor.grey.withOpacity(0.1)),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppColor.grey),
            labelText: widget.hintText,
            prefixIcon: const Icon(Icons.password, color: AppColor.grey),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => showPassword = !showPassword),
              child: showPassword
                  ? Icon(Icons.remove_red_eye_rounded,
                      color: AppColor.brown.withOpacity(0.68))
                  : const Icon(Icons.remove_red_eye_outlined,
                      color: AppColor.green),
            ),
            errorStyle: const TextStyle(color: AppColor.red),
          ),
        ),
      ],
    );
  }
}
