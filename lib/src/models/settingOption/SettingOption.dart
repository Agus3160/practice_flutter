import 'package:flutter/material.dart';

class SettingOption {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const SettingOption(
      {required this.title,
      required this.subtitle,
      required this.icon,
      this.onTap});
}
