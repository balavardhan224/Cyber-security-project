import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LogInPage.dart';
import 'MyHomePage.dart';

class MailVerification extends StatefulWidget {
  const MailVerification({super.key});

  @override
  State<MailVerification> createState() => _MailVerificationState();
}

class _MailVerificationState extends State<MailVerification> {

  FirebaseAuth auth= FirebaseAuth.instance;
  late Timer _timer;
  late bool isVerified=false;

  Future<User?> user() async {
    FirebaseAuth auth= FirebaseAuth.instance;
    return auth.currentUser;
  }

  Future<User?> sendMail() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer)
    {
      User? user = FirebaseAuth.instance.currentUser;
      user?.reload();
      if(user!.emailVerified&!isVerified){
        isVerified=true;
        setState(() {

        });
      }
    });
  }
  //
  @override
  void initState() {
    // TODO: implement initState
    sendMail();
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }else if(snapshot.hasError){
              return const Text("Please check your internet connection!");
            }else if(snapshot.data!=null){
              print(snapshot.data);
              if(isVerified){
                return   Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.mail_lock_outlined,size: 60),
                    const SizedBox(height: 10),
                    const Text("Well Done! Your account has verified successfully",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                    Container(width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 10,left: 32,right: 32),
                      child: MaterialButton(elevation: 0,hoverColor: const Color(0xff2148C0).withOpacity(0.5),hoverElevation: 8,
                          color: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32),side: BorderSide(color: Colors.deepPurple)),
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>MyHomePage()));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.width*0.03, horizontal: MediaQuery.of(context).size.width*0.025),
                            child: const Text("Continue",
                              style: TextStyle(fontWeight: FontWeight.w600,color: Colors.deepPurple,fontSize: 18),
                            ),
                          )
                      ),
                    ),
                  ],
                );
              }else{
                return const Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.mail_lock_outlined,size: 60),
                    Padding(
                      padding:  EdgeInsets.only(left: 24,right: 24,top: 20),
                      child: Text("Verification mail has sent to your mail address! Please Verify to continue",
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,
                      ),
                    )
                ],);
              }
            }else{
              return const LogIN();
            }
          }
      ),
    );
  }
}
