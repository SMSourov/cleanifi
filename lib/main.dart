import 'package:cleanifi/firebase_options.dart';
import 'package:cleanifi/views/login_view.dart';
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
      home: const HomaPage(),
    ),
  );
}

class HomaPage extends StatelessWidget {
  const HomaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // print(FirebaseAuth.instance.currentUser);
              // final user = FirebaseAuth.instance.currentUser;
              // print(user);
              // if (user?.emailVerified ?? false) {
              //   // print("You are a verified user.");
              //   const Text("Your email is verified.");
              // } else {
              //   // print("You need to virify your email.");
              //   return const VerifyEmailView();
              // }
              // return const Text("done");
              return const LoginView();
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const Text("Kindly verify your email address."),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send email verification")),
        ],
      );
  }
}
