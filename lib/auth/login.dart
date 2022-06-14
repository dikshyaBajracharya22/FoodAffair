import 'dart:async';
import 'dart:convert' show json;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/auth/register.dart';
import 'package:food_app/auth/sign_in.dart';
import 'package:food_app/config/myColors.dart';
import 'package:food_app/screens/home/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'forgotpassword.dart';

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passTextController = TextEditingController();

  FocusNode _passFocusNode = FocusNode();
  bool _obscureText = true;

  //2.To integrate login auth with firebase /1 in main.dart
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

//google signin======//
  Future<void> _signOut() async {
    await _auth.signOut();
    // await _googleSignIn.signOut();
  }

  Future<User> _googleSignUp() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;
      // print("signed in " + user?.displayName);

      return user;
    } catch (e) {
      print(e.toString());
    }
  }

///////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          "assets/background.png",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        //to decrease the opacity of bg
        Container(
          color: Colors.black.withOpacity(0.9),
          width: double.infinity,
          height: double.infinity,
        ),
        //logo
        Padding(
          padding: const EdgeInsets.only(left: 75, top: 30),
          child: Container(
            alignment: Alignment.center,
              height: 230,
              width: 230,
              child: Image.asset("assets/bg.png")),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // margin: EdgeInsets.only(top: 150),
                    child: ListView(
                      children: [
                        //email
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            validator: (value) {
                              if (value.isEmpty || !value.contains("@")) {
                                String pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regExp = new RegExp(pattern);
                                if (!regExp.hasMatch(value))
                                  return "Please make sure your Email is correct";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _emailTextController.text = value;
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white70,
                                ),
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //pw
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=>
                          //     ,
                          focusNode: _passFocusNode,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              String pattern =
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                              RegExp regExp = new RegExp(pattern);
                              if (!regExp.hasMatch(value))
                                return "Please make sure your password is correct";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _passTextController.text = value;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green.withOpacity(0.9),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              //4.To integrate login auth with firebase
                              signIn(_emailTextController.text,
                                  _passTextController.text);
                            },
                            color: CustomColors.primaryColor,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.login,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),

                        Container(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.background,
                                  fontSize: 14),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()));
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "Dont have an account ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          TextSpan(text: "    "),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp())),
                              text: "Register",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ])),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                              color: Colors.grey,
                            )),
                            Text(
                              "OR",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.grey,
                            )),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          // margin: EdgeInsets.symmetric(horizontal: 70),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                primary: Colors.red.shade800),
                            onPressed: () {
                              _googleSignUp().then((value) =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomeScreen())));
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/google.png',
                                    height: 25,
                                    width: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Sign In With Google")
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Text("Other Sign in Options", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        //for google signup
      ],
    ));
  }

//3.To integrate login auth with firebase
  void signIn(String email, String password) async {
    if (_loginFormKey.currentState.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }
}
