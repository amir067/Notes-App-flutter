import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          title: const Text("Login"),
          backgroundColor: const Color.fromARGB(255, 107, 65, 114),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(
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
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  width: 2),
                            ),
                            border: OutlineInputBorder(),
                            //focusedBorder:OutlineInputBorder(borderSide: BorderSide(width: 1))
                          ),
                        ),
                      ),

                      //Spacing
                      const SizedBox(height: 10),

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
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  width: 2),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: sizedBoxWidth,
                        height: sizedBoxHeight,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 107, 65, 114)),
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try {
                                final userCredential = await FirebaseAuth
                                    .instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password);
                                // ignore: avoid_print
                                print(userCredential);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == "user-not-found") {
                                  print("User not found");
                                } else if (e.code == "wrong-password") {
                                  print("Wrong password");
                                } else {
                                  print("Something wrong happened");
                                  print(e.code);
                                }
                              }
                            },
                            child: const Text('Login')),
                      ),
                    ],
                  ),
                );
              default:
                return const Text("Loading...");
            }
          },
        ));
  }
}