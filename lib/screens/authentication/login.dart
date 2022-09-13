import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/navigation.dart';
import '../../controllers/authController.dart';
import '../../router/routerGenerator.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthController _authController = Get.find<AuthController>();

  bool _obscureText = true;
  bool _isLoading = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      _authController.signIn(
          _emailController.text.trim(), _passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Login',
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
                  leading: Icon(
                    Icons.lock_outline,
                    color: Colors.grey[600],
                  ),
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
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      navigationController.navigateTo(forgotPassword);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: primaryColor, fontSize: 15),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _login();
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
                                const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      secondaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Logging In...',
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
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontSize: 20),
                        ),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'New to Bullslot? ',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                    ),
                    TextSpan(
                      text: 'Register',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: primaryColor, fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          navigationController.authSheetController
                              .animateToPage(0,
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
