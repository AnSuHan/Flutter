import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  String googleRegister = "";

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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(googleRegister,
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        signInWithGoogle();
                      }, child: const Text("google sign in")
                  ),
                  ElevatedButton(
                      onPressed: () {
                        signOutWithGoogle();
                      }, child: const Text("google sign out")
                  ),
                ],
              ),
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

  Future<void> signInWithGoogle() async {
    try {
      // 구글 로그인 인증 객체 생성
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // 구글 계정 선택 창 표시
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        // Firebase에 구글 계정으로 로그인
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // 로그인 성공 시 처리
        final User? user = userCredential.user;
        setState(() {
          googleRegister = '로그인 사용자: ${user!.displayName}';
        });
      } else {
        // 구글 계정 선택 취소
        setState(() {
          googleRegister = '구글 로그인 취소됨';
        });
      }
    } catch (e) {
      // 오류 처리
      setState(() {
        googleRegister = '구글 로그인 실패: $e';
      });
    }
  }

  Future<void> signOutWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut(); // 구글 로그아웃 처리

    await FirebaseAuth.instance.signOut(); // Firebase Authentication 로그아웃 처리
    setState(() {
      googleRegister = '로그아웃 완료';
    });
  }
}
