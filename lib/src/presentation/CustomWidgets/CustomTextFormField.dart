import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  static isFieldEmpty(value, res) {
    if (value!.isEmpty) {
      return res;
    }
  }

  static String? validatorEmail(value) {
    isFieldEmpty(value, 'Enter the email');
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatorPassword(value) {
    isFieldEmpty(value, 'Enter the password');
    if (value!.length < 6) {
      return 'Min of chars is 6';
    }
    return null;
  }

  const CustomTextFormField(
      {super.key,
      required this.placeHolder,
      required this.enableValidation,
      required this.controller,
      this.validator,
      this.keyboardType,
      this.prefixIcon,
      this.suffix,
      this.onFieldSubmitted,
      this.textInputAction,
      this.label,
      this.obscureText = false});

  final TextEditingController? controller;
  final String placeHolder;
  final bool enableValidation;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffix;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String? label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        validator: enableValidation ? validator : null,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: placeHolder,
          prefixIcon: prefixIcon,
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
