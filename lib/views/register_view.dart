import 'package:cleanifi/constants/routes.dart';
import 'package:cleanifi/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("CLEANIFI REGISTER"),
      ),
      body: Column(
        children: [
          const Text("\n\n"),
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == "email-already-in-use") {
                  await showErrorDialog(
                    context,
                    "An account is already registered with this email.",
                  );
                } else if (e.code == "weak-password") {
                  await showErrorDialog(
                    context,
                    "Weak password",
                  );
                } else if (e.code == "invalid-email") {
                  await showErrorDialog(
                    context,
                    "Enter a valid email address.",
                  );
                } else {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                }
              } catch (e) {
                showErrorDialog(context, e.toString());
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already registered?\n        Login here!"))
        ],
      ),
    );
  }
}
