import 'package:cleanifi/constants/routes.dart';
import 'package:cleanifi/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        title: const Text("Login"),
      ),
      body: Column(
        children: [
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
                // final userCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // devtools.log(userCredential.toString());
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  await showErrorDialog(
                    context,
                    "The user was not found.\nThat's all we know.",
                  );
                  // devtools.log("The user was not found. That's all we know.");
                } else if (e.code == "wrong-password") {
                  // devtools.log("Incorrect password.");
                  await showErrorDialog(
                    context,
                    "Incorrect password",
                  );
                } else {
                  // devtools.log("Something else happend.");
                  // devtools.log(e.code);
                  await showErrorDialog(
                    context,
                    "Error: ${e.code}",
                  );
                }
              }

              catch (e) {
                await showErrorDialog(context, e.toString(),);
              }

               //catch (e) {
              //   print("Something bad happend.");
              //   print(e);
              //   print(e.runtimeType);
              // }
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

