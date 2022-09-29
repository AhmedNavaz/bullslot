import 'package:bullslot/models/user.dart';
import 'package:bullslot/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/navigation.dart';
import '../controllers/authController.dart';
import '../widgets/formField.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    nameController.text = authController.localUser.value.name ?? '';
    phoneController.text = authController.localUser.value.phone ?? '';
    addressController.text = authController.localUser.value.address ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
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
                  title: 'Name',
                  controller: nameController,
                  hintText: 'Enter your name',
                ),
                const SizedBox(height: 10),
                formField(
                  title: 'Phone',
                  controller: phoneController,
                  hintText: 'Enter your phone number',
                ),
                const SizedBox(height: 10),
                formField(
                  title: 'Address',
                  controller: addressController,
                  hintText: 'Enter your address',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Updating your profile...'),
                        ),
                      );
                      databaseMethods
                          .updateUserInfo(UserLocal(
                        id: authController.localUser.value.id,
                        name: nameController.text,
                        phone: phoneController.text,
                        address: addressController.text,
                        email: authController.localUser.value.email,
                      ))
                          .then((value) {
                        databaseMethods
                            .getUser(authController.localUser.value.id!)
                            .then((value) {
                          authController.localUser.value = value;
                        }).then((value) {
                          navigationController.goBack();
                        });
                      });
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
