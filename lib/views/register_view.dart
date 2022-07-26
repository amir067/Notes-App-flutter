import "dart:developer" as devtools show log;

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../main.dart';

import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double sizedBoxWidth = 300;
    const double sizedBoxHeight = 50;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: const Color.fromARGB(255, 107, 65, 114),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Email
            SizedBox(
              width: sizedBoxWidth,
              height: sizedBoxHeight,
              child: TextField(
                controller: _email,
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 167, 167, 167), width: 2),
                  ),
                  border: OutlineInputBorder(),
                  //focusedBorder:OutlineInputBorder(borderSide: BorderSide(width: 1))
                ),
              ),
            ),

            //Spacing
            createSpace(10),

            //Password
            SizedBox(
              width: sizedBoxWidth,
              height: sizedBoxHeight,
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _password,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 167, 167, 167), width: 2),
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),

            //Spacing
            createSpace(10),

            //Text Button
            SizedBox(
              width: sizedBoxWidth,
              height: sizedBoxHeight,
              child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 107, 65, 114)),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase()
                          .createUser(email: email, password: password);

                      AuthService.firebase().sendVerification();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamed(verifyRoute);
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(
                        context,
                        "Email already in use",
                      );
                    } on ConnectionFailedAuthException {
                      await showErrorDialog(
                        context,
                        "Could not connect to server check if your device is connected to the internet.",
                      );
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        "Weak Password",
                      );
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        "Invalid email",
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Failed to register",
                      );
                    }
                  },
                  child: const Text('Register')),
            ),
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text("Already registered? Login"))
          ],
        ),
      ),
    );
  }
}
