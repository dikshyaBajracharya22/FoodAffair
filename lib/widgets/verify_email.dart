import 'dart:async';
// verify email
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/screens/home/home_screen.dart';

import '../auth/login.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),


            (_) => checkEmailVerified(),
      );

    }

  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signOut() async {
    await _auth.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInDemo()),(route) => false));
    deleteUser();

  }
  Future deleteUser() async{
    User user = await FirebaseAuth.instance.currentUser;
    user.delete();

  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user.sendEmailVerification();

      setState(() => canResendEmail = true);
      // await Future.delayed(Duration(seconds: 1));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomeScreen()
      : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text("Verify Email"),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A verification email has been sent to your email.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    primary: Colors.green.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),

                onPressed:  sendVerificationEmail ,
                icon: Icon(
                  Icons.email,
                  size: 32,
                ),
                label: Text(
                  "Resend Email",
                  style: TextStyle(fontSize: 24,),

                )),
            SizedBox(
              height: 15,
            ),



            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    primary: Colors.red.shade800,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                icon: Icon(
                  Icons.email,
                  size: 32,
                ),
                label: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  deleteUser();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInDemo()));
                }




            ),

            SizedBox(
              height: 10,
            ),

          ],
        ),
      ));
}


