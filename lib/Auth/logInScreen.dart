// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:students_app/Auth/buttonOfLogIn&SignUp.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:students_app/MainPage/mainPage.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late String email;
  late String password;
  late String userName;
  late String profilePicture;

  late String emailGoogle;
  late String userNameGoogle;
  late String profilePictureGoogle;

  bool loginLoading = false;
  bool _obscureAction = true;

  final _Auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: loginLoading,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/FacultyOfScience.png"),
              fit: BoxFit.cover,
              opacity: 0.2),
        ),
        child: ListView(children: [
          const SizedBox(height: 250),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 30,
            ),
            Form(
              child: Column(children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'email',
                    labelText: 'email',
                    labelStyle: TextStyle(color: Colors.white70),
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(
                      Icons.supervised_user_circle_sharp,
                      color: Colors.white70,
                    ),
                    fillColor: Colors.black38,
                    filled: false,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: Colors.white54, width: 1.5)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: _obscureAction,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'password',
                    labelText: 'password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon:
                        const Icon(Icons.password, color: Colors.white70),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureAction = !_obscureAction;
                        });
                      },
                      icon: const Icon(Icons.visibility, color: Colors.white70),
                    ),
                    fillColor: Colors.black38,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.white54, width: 1.5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Row(children: [
              const SizedBox(width: 15),
              const Text(
                "Don't have an account ?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('signUpScreen');
                },
                child: const Text(
                  'SignUp',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ]),
            ButtonOfLogInSignUp(
              title: 'Log in',
              onPressed: () async {
                setState(() {
                  loginLoading = true;
                });
                try {
                  await _Auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  setState(() {
                    loginLoading = false;
                  });
                  var snackBar = const SnackBar(
                    content: Text(
                      textAlign: TextAlign.center,
                      'Login successfully!',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.black54,
                    width: 200,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPage(
                              name: 'null',
                              email: email,
                              photo:
                                  'https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.shutterstock.com%2Fimage-vector%2Fdefault-avatar-profile-icon-grey-260nw-518740753.jpg&tbnid=x7HEvqKT8T9RoM&vet=12ahUKEwjQp7vplOj-AhVsvicCHVIqAO8QMygNegUIARCGAg..i&imgrefurl=https%3A%2F%2Fwww.shutterstock.com%2Fsearch%2Fdefault-avatar&docid=6L4rRZ5kjHPQ7M&w=260&h=280&q=default%20image%20icon&ved=2ahUKEwjQp7vplOj-AhVsvicCHVIqAO8QMygNegUIARCGAg')));
                } on SocketException {
                  print("error connection");
                } catch (e) {
                  setState(() {
                    loginLoading = false;
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        title: const Text("Error"),
                        titleTextStyle:
                            const TextStyle(color: Colors.redAccent),
                        content: Text(
                          '${e}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        ),
                        backgroundColor: Colors.white70,
                      );
                    },
                  ); // Only catches an exception of type `Exception`.
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Or connect using',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      loginLoading = true;
                    });
                    await _googleSignIn.signIn().then((value) {
                      setState(() {
                        emailGoogle = value!.email;
                        userNameGoogle = value.displayName!;
                        profilePictureGoogle = value.photoUrl!;
                      });
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(
                                name: userNameGoogle,
                                email: emailGoogle,
                                photo: profilePictureGoogle)));
                    setState(() {
                      loginLoading = false;
                    });
                  },
                  child: const Text(
                    'Google',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ]),
        ]),
      ),
    ));
  }
}
