import 'package:authentication/mailVerify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as Key;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LogInPage.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: Colors.black));
  bool passwordVisible = false;

  @override
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
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
              "Welcome!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const Text(
              "Welcome! Please enter your registration details",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 12, top: 32, left: 32, right: 32),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    contentPadding: const EdgeInsets.only(
                        left: 8, right: 32, top: 4, bottom: 4),
                    hintText: "Enter Name",
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: const TextStyle(color: Colors.black38)),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 12, top: 12, left: 32, right: 32),
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
                obscureText: passwordVisible,
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
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
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
              child: AbsorbPointer(
                absorbing: mail.text.isNotEmpty && password.text.isNotEmpty
                    ? false
                    : true,
                child: MaterialButton(
                    elevation: 0,
                    hoverColor: const Color(0xff2148C0).withOpacity(0.5),
                    hoverElevation: 8,
                    color: mail.text.isNotEmpty && password.text.isNotEmpty
                        ? Colors.deepPurple
                        : Colors.deepPurple.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: _register,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.03,
                          horizontal:
                              MediaQuery.of(context).size.width * 0.025),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 18),
                      ),
                    )),
              ),
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
                        MaterialPageRoute(builder: (builder) => LogIN()));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.03,
                        horizontal: MediaQuery.of(context).size.width * 0.025),
                    child: const Text(
                      "Login",
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

  _register() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
        barrierDismissible: false);
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: mail.text, password: password.text)
        .then((value) {
      value.user!.sendEmailVerification();
      CollectionReference reference =
          FirebaseFirestore.instance.collection("Users");
      reference.doc(value.user!.uid).set({
        "name": name.text,
        "mail": mail.text,
        "password": encrypt(password.text.toString())
      }).then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (builder) => const MailVerification()));
      });
    }).catchError((onError) {
      Navigator.pop(context);
      print(onError.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${onError.toString()}"),
        backgroundColor: Colors.redAccent,
        showCloseIcon: true,
        closeIconColor: Colors.white,
      ));
    });
  }

  String encrypt(String password) {
    final key = Key.Key.fromSecureRandom(32);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }
}
