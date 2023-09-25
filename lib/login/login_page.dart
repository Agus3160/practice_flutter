import 'package:flutter/material.dart';
import 'package:project/CustomWidgets/CustomImageIcon.dart';
import '../CustomWidgets/CustomTextFormField.dart';
import '../CustomWidgets/CustomElevatedButton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/utils/utils.dart';
import 'package:project/CustomWidgets/CustomPreloader.dart';
import 'package:project/CustomWidgets/CustomSnackBarMessages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final supa = getIt.get<SupabaseClient>();

  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                        enableValidation: true,
                        prefixIcon: const Icon(Icons.email),
                        validator: (email) =>
                            CustomTextFormField.validatorPassword(email),
                        controller: emailController),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: CustomTextFormField(
                        placeHolder: 'Enter your password',
                        enableValidation: true,
                        label: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        obscureText: passToggle,
                        suffix: InkWell(
                          onTap: changeToggle,
                          child: Icon(passToggle
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        validator: (pswd) =>
                            CustomTextFormField.validatorPassword(pswd),
                        controller: passwordController),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: CustomElevatedButton(
                      mainText: 'Login',
                      onCustomPressed: onLogin,
                      widthPorcentage: 0.5,
                    ),
                  ),
                ]),
              ),
              TextButton(onPressed: onRegister, child: const Text('Register'))
            ],
          )),
    );
  }

  void onLogin() async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!mounted) return;
    if (!formKey.currentState!.validate()) return;

    final preloader = CustomPreloader(context);

    try {
      preloader.showPreloader();
      final response = await supa.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (!mounted) return;
      await preloader.hidePreloader();
      if (response.session == null) return;
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/splash',
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      await preloader.hidePreloader();
      if (!mounted) return;
      CustomSnackBarMessages.errorMessage(context, e.message);
    } on Exception catch (e) {
      if (!mounted) return;
      await preloader.hidePreloader();
      if (!mounted) return;
      CustomSnackBarMessages.errorMessage(context, 'From exception $e');
    }
    return;
  }

  void onRegister() => Navigator.pushNamed(
        context,
        '/register',
      );

  void changeToggle() {
    setState(() {
      passToggle = !passToggle;
    });
  }
}
