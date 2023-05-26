import 'package:chat_group/pages/auth/login_page.dart';
import 'package:chat_group/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "", password = "", fullName = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                      child: Form(
                        key: formKey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Chatter",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 50),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Create your account new to chat and expiore",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              Image.asset("assets/register.png"),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Full Name",
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                onChanged: (value) {
                                  fullName = value;
                                },
                                validator: (v) {
                                  return (v!.isEmpty)
                                      ? "Please enter your full name"
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Email",
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                onChanged: (value) {
                                  email = value;
                                },
                                validator: (v) {
                                  return (!v!.isEmail || v!.isEmpty)
                                      ? "Please enter valid email"
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(
                                  labelText: "Password",
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                onChanged: (value) {
                                  password = value;
                                },
                                validator: (v) {
                                  return (v!.length < 6 || v!.isEmpty)
                                      ? "Password must be at least 6 characters"
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    register();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text.rich(TextSpan(
                                  text: "Already have an account? ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: [
                                    TextSpan(
                                        text: "Login now",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreenReplace(
                                                context, const LoginPage());
                                          })
                                  ]))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        if (_isLoading)
          Scaffold(
            backgroundColor: Colors.white.withOpacity(0.5),
            body: const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,

              ),
            ),
          ),
      ],
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {

      setState(() {
        _isLoading = true;
      });
      AuthController controller = AuthController.instance;
      await controller.register(fullName, email, password).then((value)  {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
