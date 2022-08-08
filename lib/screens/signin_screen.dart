import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasetest/consts.dart';
import 'package:firebasetest/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Signin_Screen extends StatefulWidget {
  @override
  State<Signin_Screen> createState() => _Signin_ScreenState();
}

class _Signin_ScreenState extends State<Signin_Screen> {
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController vercodecontroller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool codesent = false;
  String myVerifactionid = '-1';


  @override
  initState(){
    super.initState();
    if(auth.currentUser != null){
      Future.delayed(const Duration(milliseconds: 500),(){
        navigator();
      });
    }
  }

  navigator(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
      return Home_Screen();
    },),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppcolor,
        title: const Text('Sign in'),
      ),
      body: Container(
        color: kBackcolor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 25),
              TextField(
                  style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                controller: phonecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Enter Your Phone Number',
                hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 25),
              Visibility(
                visible: codesent,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: vercodecontroller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'XXXX',
                      hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async{
                    await onButtonpressed();
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Text(codesent == true ? 'Submit' : 'Next'),),),
            ],
          ),
        ),
      ),
    );
  }

  onButtonpressed() async{
    String phone = '+98${phonecontroller.text}';
    String code = vercodecontroller.text;
    if(codesent == false){
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async{
          await auth.signInWithCredential(credential);
          print('------------------------------------------------------- \n complet');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          print('------------------------------------------------------- \n failed');
        },
        codeSent: (String verificationId, int? resendToken) async{
          print('------------------------------------------------------- \n code sent');
          myVerifactionid = verificationId;
          setState((){
            codesent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }//
    else{
      if(myVerifactionid != '-1'){
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: myVerifactionid, smsCode: code);

        UserCredential userCredential = await auth.signInWithCredential(credential);
        print('------------------------------------------------- \n ${userCredential.user} \n ${auth.currentUser}');
        navigator();
      }
      else{
        print('sth is wrong');
      }
    }
  }
}
