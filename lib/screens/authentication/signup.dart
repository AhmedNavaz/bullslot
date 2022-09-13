import 'package:bullslot/controllers/authController.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/navigation.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthController authController = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Sign up',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                ListTile(
                  minLeadingWidth: 20,
                  contentPadding: const EdgeInsets.only(left: 0, right: 0),
                  leading: Icon(
                    Icons.alternate_email_outlined,
                    color: Colors.grey[600],
                  ),
                  title: TextFormField(
                    controller: _emailController,
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
                        borderSide:
                            BorderSide(color: Colors.grey[600]!, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[600]!, width: 0.5),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                              r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  minLeadingWidth: 20,
                  contentPadding: const EdgeInsets.only(left: 0, right: 0),
                  leading: Icon(Icons.person_outline, color: Colors.grey[600]),
                  title: TextFormField(
                    controller: _nameController,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      hintText: 'Full Name',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.grey[600]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[600]!, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[600]!, width: 0.5),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  minLeadingWidth: 20,
                  contentPadding: const EdgeInsets.only(left: 0, right: 0),
                  leading: Icon(Icons.lock_outline, color: Colors.grey[600]),
                  title: TextFormField(
                    controller: _passwordController,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _toggle();
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey[400],
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(top: 10),
                      hintText: 'Password',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.grey[600]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[600]!, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[600]!, width: 0.5),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'By signing up, you agree to our ',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14,
                            height: 1.5,
                          ),
                    ),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: primaryColor,
                            fontSize: 14,
                            height: 1.5,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                              Uri.parse("https://warmmatch.com/?page_id=113"));
                        },
                    ),
                    TextSpan(
                      text: ' and ',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14,
                            height: 1.5,
                          ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: primaryColor,
                            fontSize: 14,
                            height: 1.5,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                              Uri.parse("https://warmmatch.com/?page_id=52"));
                        },
                    ),
                  ]),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      authController.signUp(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim());
                    }
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      secondaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Creating account...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: secondaryColor),
                                ),
                              ]),
                        )
                      : Text(
                          'Signup',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontSize: 20),
                        ),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Joined us before? ',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                    ),
                    TextSpan(
                      text: 'Login',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: primaryColor, fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          navigationController.authSheetController
                              .animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.decelerate);
                        },
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
