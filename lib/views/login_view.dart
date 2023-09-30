import 'package:cleanifi/constants/routes.dart';
import 'package:cleanifi/services/auth/auth_exceptions.dart';
import 'package:cleanifi/services/auth/auth_service.dart';
import 'package:cleanifi/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController
      _email; // `late` means no value for now but surely
  late final TextEditingController
      _password; // I'll have some value in the future.

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("CLEANIFI LOGIN"),
      ),
      body: Column(
        children: [
          const Text("LEAVE THE CLEANING IN OUR HANDS AND DO YOUR WORK\n\n"),
          TextField(
            controller: _email,
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                // devtools.log(userCredential.toString());
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // user's email is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  // user's email is not verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  "The user was not found.",
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Incorrect password",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Authentication error",
                );
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("    Not registered?\nCreate account now"))
        ],
      ),
    );
  }
}
