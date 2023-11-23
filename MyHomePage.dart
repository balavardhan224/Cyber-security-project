import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as Key;
import 'LogInPage.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final db=FirebaseFirestore.instance;
  late int unLock=-1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.deepPurple,
      title: const Text("Authentication",style: TextStyle(color: Colors.white),),
      actions: [
        IconButton(onPressed: (){
          FirebaseAuth auth= FirebaseAuth.instance;
          auth.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>LogIN()));
        }, icon: Icon(Icons.logout,color: Colors.white,))
      ],
    ),
      body: StreamBuilder(stream:db.collection("Users").snapshots(),builder: (context, snapshot) {
        if(snapshot.hasData){
          return ListView.builder(shrinkWrap: true,itemCount: snapshot.data?.docs.length,itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text("${snapshot.data?.docs[index].data()['name']}",style:const TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("${snapshot.data?.docs[index].data()['mail']}"),
                ),
                const Divider()
              ],
            );
          });
        }else{
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
