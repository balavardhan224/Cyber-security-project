import 'dart:developer';
import 'package:authentication/LogInPage.dart';
import 'package:authentication/mailVerify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'MyHomePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC1lyjmQXYQ6YzOujhBDwwoUHMOQET3giU",
      appId: "1:109271194214:android:0a58fdba45779c686caba7",
      messagingSenderId: "109271194214",
      projectId: "authentication-21049",
    ),
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Future<User?> user() async {
    FirebaseAuth auth= FirebaseAuth.instance;
    return auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<User?>(
          future: user(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }else if(snapshot.hasError){
              return const Text("Please check your internet connection!");
            }else if(snapshot.data!=null){
              if(snapshot.data!.emailVerified){
                return const MyHomePage();
              }else{
                return const MailVerification();
              }
            }else{
            return const LogIN();
            }
          }
      ),
    );
  }
}

