import 'package:flutter/material.dart';
import 'package:project/CustomWidgets/CustomElevatedButton.dart';
import 'package:project/CustomWidgets/CustomTextFormField.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(children: [
                CustomTextFormField(
                    placeHolder: 'Enter another name',
                    enableValidation: false,
                    controller: nameController)
              ]),
            ),
          ),
          CustomElevatedButton(mainText: 'LogOut', onCustomPressed: onLogOut)
        ]),
      ),
    );
  }

  void onLogOut() {
    print('hola');
  }
}
