import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/widgets/appdrawer.dart';
import 'package:firebasetest/widgets/homeAppbar.dart';
import 'package:firebasetest/widgets/home_body.dart';
import 'package:flutter/material.dart';

class Home_Screen extends StatefulWidget {
  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late Size size;



  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: App_Drawer(size: size, auth: auth),
      appBar: Home_AppBar(),
      body: Home_Body(),
    );
  }
}
