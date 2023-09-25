import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String mainText;
  final VoidCallback onCustomPressed;
  const CustomElevatedButton(
      {super.key, required this.mainText, required this.onCustomPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          onPressed: onCustomPressed,
          child: Text(mainText),
        ));
  }
}
