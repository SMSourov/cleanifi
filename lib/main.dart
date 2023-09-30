import 'package:cleanifi/constants/routes.dart';
import 'package:cleanifi/firebase_options.dart';
import 'package:cleanifi/services/auth/auth_service.dart';
import 'package:cleanifi/views/login_view.dart';
import 'package:cleanifi/views/notes_view.dart';
import 'package:cleanifi/views/register_view.dart';
import 'package:cleanifi/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            devtools.log(user.toString());
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
                // Text("Email is verified");
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            // return const Text("Loading...");
            return const CircularProgressIndicator();
        }
      },
    );
  }
}


