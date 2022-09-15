import 'package:bullslot/constants/navigation.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../widgets/formField.dart';

class CustomRequestScreen extends StatelessWidget {
  CustomRequestScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController noOfSlotsController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

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
                title: 'Name',
                controller: nameController,
                hintText: 'Enter you name',
              ),
              formField(
                title: 'Contact',
                controller: phoneController,
                hintText: 'Enter your phone/whatsapp number with country code',
                inputType: TextInputType.number,
              ),
              formField(
                title: 'Slots',
                controller: noOfSlotsController,
                hintText: 'How many slots you want to buy?',
              ),
              formField(
                title: 'Description',
                controller: descriptionController,
                hintText: 'Explain your request briefly',
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  navigationController.goBack();
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
    );
  }
}
