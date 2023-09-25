import 'package:cleanifi/constants/routes.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CLEANIFI"),
      ),
      body: Column(
        children: [
          const Text("LEAVE THE CLEANING IN OUR HANDS AND DO YOUR WORK"),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
          }, child: const Text("Login"),)
        ],
      ),
    );
  }
}