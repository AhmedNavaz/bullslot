import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../controllers/authController.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthController _authController = Get.put(AuthController());
  TextEditingController resetEmailController = TextEditingController();

  bool emailSent = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Reset Password',
          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Forgot\nPassword?',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  emailSent
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.green.withOpacity(0.2),
                              ),
                              child: Text(
                                  "Password Reset Link has been sent to ${resetEmailController.text}.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 1.5,
                                          fontSize: 14,
                                          color: Colors.white)),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.red.withOpacity(0.2),
                              ),
                              child: Text(
                                  "Note: Check spam if you don't see it in your inbox.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          height: 1.5,
                                          fontSize: 14,
                                          color: Colors.white)),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                                "Don't worry! It happens. Please enter the email address associated with your account.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        height: 1.5,
                                        fontSize: 14,
                                        color: Colors.white)),
                            const SizedBox(height: 30),
                            ListTile(
                              minLeadingWidth: 20,
                              contentPadding:
                                  const EdgeInsets.only(left: 0, right: 0),
                              leading: Icon(
                                Icons.alternate_email_outlined,
                                color: Colors.grey[600],
                              ),
                              title: TextFormField(
                                controller: resetEmailController,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  hintText: 'Email',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.grey[600]),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey[600]!, width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey[600]!, width: 0.5),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                _authController
                                    .resetPassword(
                                        resetEmailController.text.trim())
                                    .then((value) {
                                  setState(() {
                                    emailSent = value;
                                    _isLoading = false;
                                  });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(400, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? Center(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  accentColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Sending...',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    color: secondaryColor,
                                                  ),
                                            ),
                                          ]),
                                    )
                                  : Text(
                                      'Reset',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(fontSize: 20),
                                    ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
