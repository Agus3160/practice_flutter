import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/src/presentation/CustomWidgets/CustomTextFormField.dart';

class AddTitleOverlay extends StatefulWidget {
  const AddTitleOverlay({super.key});

  @override
  State<AddTitleOverlay> createState() => _AddTitleOverlayState();
}

class _AddTitleOverlayState extends State<AddTitleOverlay> {
  final key = GlobalKey<FormState>();
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * .2,
            maxHeight: MediaQuery.of(context).size.height * .5,
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CupertinoButton(
                        onPressed: onBack,
                        child: const Icon(Icons.close),
                      ),
                      const Expanded(
                        child: Text(
                          'Titulo de la conversación',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      CupertinoButton(
                        onPressed: onSave,
                        child: const Icon(Icons.done),
                      ),
                    ],
                  ),
                  CustomTextFormField(
                    controller: controller,
                    enableValidation: true,
                    validator: (v) {
                      v!.isEmpty ? 'Fill the field' : null;
                      return null;
                    },
                    label: 'Nombre de la conversación',
                    placeHolder: 'ingrese el nombre para su conversación',
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBack() => Navigator.of(context).pop();

  void onSave() {
    if (!key.currentState!.validate()) return;
    Navigator.of(context).pop(controller.text.trim());
  }
}
