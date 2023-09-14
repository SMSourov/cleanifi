import 'package:cleanifi/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                      try {
                        final email = _email.text;
                        final password = _password.text;
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: password);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "user-not-found") {
                          print("The user was not found. That's all we know.");
                        }
                        else if (e.code == "wrong-password") {
                          print("Incorrect password.");
                        }
                        else {
                          print("Something else happend.");
                          print(e.code);
                        }
                       } //catch (e) {
                      //   print("Something bad happend.");
                      //   print(e);
                      //   print(e.runtimeType);
                      // }
                    },
                    child: const Text("Login"),
                  ),
                ],
              );
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
