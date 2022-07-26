import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import "dart:developer" as devtools show log;

const double sizedBoxWidth = 300;
const double sizedBoxHeight = 300;

//Creates an empty sized box for sapce
SizedBox createSpace(double height) {
  return SizedBox(height: height);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primaryColor: const Color.fromARGB(255, 31, 31, 31),
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyRoute: (context) => const VerifyEmailView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                devtools.log(user.toString());
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            dynamic loadingCircle;
            if (Platform.isIOS) {
              devtools.log("We are on IOS");
              loadingCircle = const CupertinoActivityIndicator();
            } else {
              loadingCircle = const CircularProgressIndicator();
            }
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 180, 180, 180),
              body: Center(
                child: SizedBox(
                  width: sizedBoxWidth,
                  height: sizedBoxHeight,
                  child: Center(child: loadingCircle),
                ),
              ),
            );
        }
      },
    );
  }
}
