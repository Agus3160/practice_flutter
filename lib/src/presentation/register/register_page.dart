import 'package:flutter/material.dart';
import 'package:project/src/presentation/CustomWidgets/CustomImageIcon.dart';
import '../CustomWidgets/CustomTextFormField.dart';
import '../CustomWidgets/CustomElevatedButton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/src/utils/utils.dart';
import 'package:project/src/presentation/CustomWidgets/CustomPreloader.dart';
import 'package:project/src/presentation/CustomWidgets/CustomSnackBarMessages.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true;
  final formKey = GlobalKey<FormState>();
  final supa = getIt.get<SupabaseClient>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CustomImageIcon(width: 128, imgUrl: 'assets/img/chat.webp'),
              Form(
                key: formKey,
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 25, bottom: 25),
                    child: CustomTextFormField(
                        label: 'Email',
                        placeHolder: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email),
                        enableValidation: true,
                        validator: (email) =>
                            CustomTextFormField.validatorEmail(email),
                        controller: emailController),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: CustomTextFormField(
                        placeHolder: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock),
                        obscureText: passToggle,
                        enableValidation: true,
                        validator: (pswd) =>
                            CustomTextFormField.validatorPassword(pswd),
                        suffix: InkWell(
                          onTap: changeToggle,
                          child: Icon(passToggle
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        controller: passwordController),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: CustomElevatedButton(
                      mainText: 'Sign Up',
                      onCustomPressed: onSignUp,
                      widthPorcentage: 0.5,
                    ),
                  ),
                ]),
              ),
            ],
          )),
    );
  }

  void changeToggle() {
    setState(() {
      passToggle = !passToggle;
    });
  }

  void onSignUp() async {
    final preloader = CustomPreloader(context);
    if (!formKey.currentState!.validate()) return;
    try {
      preloader.showPreloader();
      final r = await supa.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      log.d(r.session);
      log.d(r.user);
    } on Exception catch (e) {
      await preloader.hidePreloader();
      if (!mounted) return;
      CustomSnackBarMessages.errorMessage(context, e.toString());
      return;
    }
    if (!mounted) return;
    await preloader.hidePreloader();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
  }
}
