import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/controllers/authController.dart';
import 'package:bullslot/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../widgets/formField.dart';

class CustomRequestScreen extends StatelessWidget {
  CustomRequestScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  TextEditingController slotController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  DatabaseMethods databaseMethods = DatabaseMethods();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Custom Request',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: Text('Kindly fill the form below to proceed.',
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                formField(
                  title: 'Slots',
                  controller: slotController,
                  hintText: 'Enter ny number of slots',
                  inputType: TextInputType.number,
                ),
                formField(
                  title: 'Contact',
                  controller: phoneController,
                  hintText: 'Enter your phone/whatsapp number',
                  inputType: TextInputType.number,
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 10,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Explain your request in detail',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 14, color: Colors.grey.shade500),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                    ),
                    labelText: 'Description',
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field can\'t be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sending your request...'),
                        ),
                      );
                      databaseMethods
                          .sendRequest(
                        int.parse(slotController.text),
                        authController.localUser.value.name!,
                        authController.localUser.value.email!,
                        descriptionController.text,
                        phoneController.text,
                      )
                          .then((value) {
                        navigationController.goBack();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                  ),
                  child: const Text('Submit Request'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
