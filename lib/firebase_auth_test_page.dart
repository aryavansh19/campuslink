import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthTestPage extends StatefulWidget {
  const FirebaseAuthTestPage({super.key});

  @override
  State<FirebaseAuthTestPage> createState() => _FirebaseAuthTestPageState();
}

class _FirebaseAuthTestPageState extends State<FirebaseAuthTestPage> {
  String status = "Not signed in yet";

  Future<void> _signInAnon() async {
    setState(() {
      status = "Signing in...";
    });

    try {
      await FirebaseAuth.instance.signInAnonymously();
      setState(() {
        status = "✅ Anonymous sign-in successful!";
      });
    } catch (e) {
      setState(() {
        status = "❌ Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Auth Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInAnon,
              child: const Text("Test Anonymous Sign-In"),
            ),
          ],
        ),
      ),
    );
  }
}
