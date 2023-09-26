import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String mainText;
  final VoidCallback onCustomPressed;
  final double widthPorcentage;
  final double? height;

  const CustomElevatedButton(
      {super.key,
      this.height,
      required this.mainText,
      required this.onCustomPressed,
      required this.widthPorcentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: MediaQuery.of(context).size.width * widthPorcentage,
        child: ElevatedButton(
          onPressed: onCustomPressed,
          child: Text(mainText),
        ));
  }
}
