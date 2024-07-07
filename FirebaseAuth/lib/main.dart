import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Auth());
}

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthState();
  }
}

class _AuthState extends State<Auth> {
  String authState = "";
  String registerEmailState = "";
  String emailLoginOutState = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(authState,
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance
                      .authStateChanges()
                      .listen((User? user) {
                    if (user == null) {
                      setState(() {
                        authState = 'User is currently signed out!';
                      });
                    } else {
                      setState(() {
                        authState = 'User is signed in!';
                      });
                    }
                  });
                }, child: const Text("auth State")
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(registerEmailState,
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    registerEmail();
                  }, child: const Text("register Email")
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(emailLoginOutState,
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        loginEmail();
                      }, child: const Text("login")
                  ),
                  ElevatedButton(
                      onPressed: () {
                        logoutEmail();
                      }, child: const Text("logout")
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerEmail() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "abcd@gmail.com",
        password: "qwerty1234",
      );
      setState(() {
        registerEmailState = 'Registered user: ${userCredential.user!.uid}';
      });
    } catch (e) {
      setState(() {
        registerEmailState = 'Failed to register: $e';
      });
    }
  }

  Future<void> loginEmail() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "abcd@gmail.com",
        password: "qwerty1234",
      );
      setState(() {
        emailLoginOutState = 'login user: ${userCredential.user!.uid}';
      });
    } catch (e) {
      setState(() {
        emailLoginOutState = 'Failed to login: $e';
      });
    }
  }

  Future<void> logoutEmail() async {
    try {
      FirebaseAuth.instance.signOut();
      setState(() {
        emailLoginOutState = 'success logout';
      });
    } catch (e) {
      setState(() {
        emailLoginOutState = 'Failed to logout: $e';
      });
    }
  }
}
