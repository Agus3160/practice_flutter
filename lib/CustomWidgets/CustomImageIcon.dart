import 'package:flutter/material.dart';

class CustomImageIcon extends StatelessWidget {
  final String imgUrl;
  final double width;

  const CustomImageIcon({super.key, required this.width, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Image(width: width, image: AssetImage(imgUrl));
  }
}
