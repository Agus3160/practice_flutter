import 'package:flutter/material.dart';

class CustomPreloader {
  final BuildContext context;
  CustomPreloader(this.context);

  Future hidePreloader() async {
    Navigator.pop(context);
  }

  Future showPreloader() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }
}
