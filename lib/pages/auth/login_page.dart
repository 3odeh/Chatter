import 'package:chat_group/pages/auth/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../service/auth_service.dart';
import '../../widgets/widgets.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "", password = "";

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
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
                        "Login new to see what the are talking!",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Image.asset("assets/login.png"),
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
                          return (v!.length < 6 || v.isEmpty)
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
                            login();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                                text: "Register here",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreenReplace(
                                        context, const RegisterPage());
                                  })
                          ]))
                    ],
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
          )
      ],
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {

      setState(() {
        _isLoading = true;
      });
      AuthController controller = AuthController.instance;
      await controller.login( email, password).then((value)  {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
