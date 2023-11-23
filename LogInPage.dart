import 'package:authentication/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MyHomePage.dart';

class LogIN extends StatefulWidget {
  const LogIN({super.key});

  @override
  State<LogIN> createState() => _LogINState();
}

class _LogINState extends State<LogIN> {
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();

  var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: Colors.black));
  bool passwordVisible1 = false;

  @override
  void initState() {
    super.initState();
    passwordVisible1 = true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const Text(
              "Welcome Back! Please enter your login credential",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 12, top: 32, left: 32, right: 32),
              child: TextField(
                controller: mail,
                decoration: InputDecoration(
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    contentPadding: const EdgeInsets.only(
                        left: 8, right: 32, top: 4, bottom: 4),
                    hintText: "Register Email",
                    labelText: 'Register Email',
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: const TextStyle(color: Colors.black38)),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 12, top: 12, left: 32, right: 32),
              child: TextField(
                controller: password,
                obscureText: passwordVisible1,
                decoration: InputDecoration(
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    contentPadding: const EdgeInsets.only(
                        left: 8, right: 32, top: 4, bottom: 4),
                    hintText: "Password",
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible1
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible1 = !passwordVisible1;
                          },
                        );
                      },
                    ),
                    hintStyle: const TextStyle(color: Colors.black38)),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 30, left: 32, right: 32),
              child: MaterialButton(
                  elevation: 0,
                  hoverColor: const Color(0xff2148C0).withOpacity(0.5),
                  hoverElevation: 8,
                  color: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: _logIn,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.03,
                        horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 10, left: 32, right: 32),
              child: MaterialButton(
                  elevation: 0,
                  hoverColor: const Color(0xff2148C0).withOpacity(0.5),
                  hoverElevation: 8,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: BorderSide(color: Colors.deepPurple)),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) => Register()));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.03,
                        horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                          fontSize: 18),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _logIn() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
        barrierDismissible: false);
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: mail.text, password: password.text)
        .then((value) {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (builder) => const MyHomePage()));
    }).catchError((onError) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${onError.toString()}"),
        backgroundColor: Colors.redAccent,
        showCloseIcon: true,
        closeIconColor: Colors.white,
      ));
    });
  }
}
