import 'package:flutter/material.dart';

class CustomSnackBarMessages {
  static errorMessage(BuildContext context, String message) {
    return (ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 170, 50, 42),
              borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Column(children: [
            const Text(
              'Error !',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(message,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(211, 159, 159, 1),
                )),
          ])),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    )));
  }
}
