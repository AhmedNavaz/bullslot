import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/controllers/authController.dart';
import 'package:bullslot/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/formField.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Contact Us',
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
                formField(
                  title: 'Title',
                  controller: titleController,
                  hintText: 'What is your query about?',
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 10,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: 'Explain your query in detail',
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
                formField(
                  title: 'Contact Number',
                  controller: phoneController,
                  hintText: 'Phone Number/Watsapp Number',
                  inputType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sending your query...'),
                        ),
                      );
                      databaseMethods
                          .sendMessage(
                        authController.localUser.value.name!,
                        authController.localUser.value.email!,
                        titleController.text,
                        descriptionController.text,
                        phoneController.text,
                      )
                          .then((value) {
                        navigationController.goBack();
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
