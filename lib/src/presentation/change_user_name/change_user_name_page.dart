import 'package:flutter/material.dart';
import 'package:project/src/presentation/CustomWidgets/CustomElevatedButton.dart';
import 'package:project/src/presentation/CustomWidgets/CustomPreloader.dart';
import 'package:project/src/presentation/CustomWidgets/CustomSnackBarMessages.dart';
import 'package:project/src/presentation/CustomWidgets/CustomTextFormField.dart';
import 'package:project/src/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangeUserNamePage extends StatefulWidget {
  const ChangeUserNamePage({super.key});

  @override
  State<ChangeUserNamePage> createState() => _ChangeUserNamePageState();
}

class _ChangeUserNamePageState extends State<ChangeUserNamePage> {
  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newLastNameController = TextEditingController();
  String titleMessage = 'Enter the new name that you want to use.';
  final supabase = getIt.get<SupabaseClient>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Form(
                      key: formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              titleMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            CustomTextFormField(
                                placeHolder: 'Enter your new name',
                                label: 'New Name',
                                enableValidation: true,
                                validator: (value) =>
                                    CustomTextFormField.isFieldEmpty(
                                        value, 'Enter a name'),
                                controller: newNameController),
                            CustomTextFormField(
                                placeHolder: 'Enter your new last name',
                                label: 'New Last Name',
                                enableValidation: true,
                                validator: (value) =>
                                    CustomTextFormField.isFieldEmpty(
                                        value, 'Enter a last name'),
                                controller: newLastNameController),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomElevatedButton(
                                    height: 48,
                                    mainText: 'Back',
                                    onCustomPressed: onBack,
                                    widthPorcentage: .25),
                                CustomElevatedButton(
                                    height: 48,
                                    mainText: 'Change',
                                    onCustomPressed: onChange,
                                    widthPorcentage: .25)
                              ],
                            )
                          ]))))),
    );
  }

  void onBack() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void onChange() async {
    if (!formKey.currentState!.validate()) return;

    final String currentId = supabase.auth.currentUser!.id;
    final String newName = newNameController.text.trim();
    final String newLastName = newLastNameController.text.trim();
    final CustomPreloader preloader = CustomPreloader(context);

    try {
      preloader.showPreloader();
      await supabase
          .from('profiles')
          .update({'first_name': newName, 'last_name': newLastName}).eq(
              'id', currentId);
    } on Exception catch (e) {
      await preloader.hidePreloader();
      if (!mounted) return;
      CustomSnackBarMessages.errorMessage(context, e.toString());
      return;
    }
    if (!mounted) return;
    await preloader.hidePreloader();
    if (!mounted) return;
    CustomSnackBarMessages.doneMessage(
        context, 'The username has benn changed.');
    setState(() {
      titleMessage = 'Your actual name is: $newName $newLastName';
    });
  }
}
