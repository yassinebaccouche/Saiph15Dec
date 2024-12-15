import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();

}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  String pseudo ="";
  @override
  void initState() {
    super.initState();
    getUserName();
  }
  void getUserName() async{
    DocumentSnapshot snap =  await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState((){
      pseudo =(snap.data() as Map<String,dynamic>)['pseudo'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$pseudo'),
      ),
    );
  }
}
