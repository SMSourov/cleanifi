import 'package:cleanifi/firebase_options.dart';
import 'package:cleanifi/views/login_view.dart';
import 'package:cleanifi/views/register_view.dart';
import 'package:cleanifi/views/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: const RegisterView(),
      home: const HomePage(),
      routes: {
        "/login/": (context) => const LoginView(),
        "/register/": (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // print(FirebaseAuth.instance.currentUser);
            final user = FirebaseAuth.instance.currentUser;
            // print(user);
            if (user != null) {
              if (user.emailVerified) {
                print("Email is verified.");
                // Text("Email is verified");
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const Text("Done");
          default:
            // return const Text("Loading...");
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
