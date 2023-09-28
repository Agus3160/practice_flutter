import 'package:flutter/material.dart';
import 'package:project/src/presentation/CustomWidgets/CustomElevatedButton.dart';
import 'package:project/src/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project/src/presentation/CustomWidgets/CustomPreloader.dart';
import 'package:project/src/presentation/CustomWidgets/CustomSnackBarMessages.dart';
import 'package:project/src/presentation/CustomWidgets/CustomTextFormField.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final key = GlobalKey<FormState>();
  final supabase = getIt.get<SupabaseClient>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: CustomTextFormField(
                          controller: firstNameController,
                          label: "Name",
                          enableValidation: true,
                          validator: (v) => validatorName(v),
                          keyboardType: TextInputType.name,
                          placeHolder: 'Enter your name',
                        )),
                    CustomTextFormField(
                      controller: lastNameController,
                      label: "Last Name",
                      enableValidation: true,
                      validator: (v) => validatorLastName(v),
                      keyboardType: TextInputType.name,
                      placeHolder: 'Enter your last name',
                    )
                  ],
                ),
                CustomElevatedButton(
                  mainText: 'Complete Profile',
                  onCustomPressed: onComplete,
                  widthPorcentage: 0.5,
                )
              ],
            ),
          )),
    );
  }

  String? validatorName(v) {
    if (v.isEmpty) {
      return "Enter a name";
    }
    return null;
  }

  String? validatorLastName(v) {
    if (v.isEmpty) {
      return "Enter a last name";
    }
    return null;
  }

  void onComplete() async {
    if (!key.currentState!.validate()) return;
    CustomPreloader preloader = CustomPreloader(context);
    try {
      preloader.showPreloader();
      final data = {
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'id': supabase.auth.currentUser!.id,
      };
      await supabase.from('profiles').insert(data);
      await supabase.auth.updateUser(
        UserAttributes(
          data: {'profile_completed': true},
        ),
      );
      if (!mounted) return;
      await preloader.hidePreloader();
    } on Exception catch (e) {
      await preloader.hidePreloader();
      if (!mounted) return;
      CustomSnackBarMessages.errorMessage(context, e.toString());
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
  }
}
