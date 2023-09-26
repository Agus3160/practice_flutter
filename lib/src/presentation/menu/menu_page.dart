import 'package:flutter/material.dart';
import 'package:project/src/presentation/CustomWidgets/CustomElevatedButton.dart';
import 'package:project/src/presentation/CustomWidgets/CustomPreloader.dart';
import 'package:project/src/presentation/CustomWidgets/CustomSnackBarMessages.dart';
import 'package:project/src/presentation/CustomWidgets/CustomTextFormField.dart';
import 'package:project/src/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  TextEditingController nameController = TextEditingController();
  final supabase = getIt.get<SupabaseClient>();
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
          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16),
              child: CustomElevatedButton(
                  height: 64,
                  mainText: 'LogOut',
                  onCustomPressed: onLogOut,
                  widthPorcentage: 0.25))
        ]),
      ),
    );
  }

  void onLogOut() async {
    final CustomPreloader preloader = CustomPreloader(context);
    try {
      preloader.showPreloader();
      await supabase.auth.signOut();
      if (!mounted) return;
      await preloader.hidePreloader();
    } on Exception catch (e) {
      // ignore: use_build_context_synchronously
      CustomSnackBarMessages.errorMessage(context, e.toString());
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
