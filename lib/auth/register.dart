// register.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/config/myColors.dart';
import 'package:food_app/screens/home/home_screen.dart';

import '../models/loginUser_model.dart';
import '../models/user_model.dart';
import 'package:email_auth/email_auth.dart';

import '../widgets/verify_email.dart';





class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {



  final _auth=FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String gender;
  String groupValue = "male";

  FocusNode _passFocusNode = FocusNode();
  FocusNode _confirmFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  bool _obscureText = true;
  bool _obscureText1= true;
  @override
  void dispose() {
    // _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/background.png",
            fit: BoxFit.fill,
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
            padding: const EdgeInsets.only(left: 80, top: 10),
            child: Container(
                alignment: Alignment.center,
                height: 230,
                width: 230,
                child: Image.asset("assets/bg.png")),
          ),

          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 100,left: 10, right: 10),
              child: Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      //email
                      //Name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _nameTextController,
                          validator: (value) {
                            if (value.isEmpty || value.length<5) {
                              return "Please fill your name";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Full Name",
                              prefixIcon: Icon(
                                Icons.person,
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
//Radio Button
//                         Container(
//                           // color: Colors.white.withOpacity(0.4),
//                           // decoration: BoxDecoration(borderRadius: ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 0),
//                                     child: ListTile(
//                                         title: Text(
//                                           'Male',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         trailing: Radio(
//                                             value: "male",
//                                             groupValue: groupValue,
//                                             onChanged: (e) => valueChanged(e))),
//                                   )),
//                               Expanded(
//                                   child: ListTile(
//                                       title: Text(
//                                         'Female',
//                                         textAlign: TextAlign.end,
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       trailing: Radio(
//                                           value: "female",
//                                           groupValue: groupValue,
//                                           onChanged: (e) => valueChanged(e)))),
//                             ],
//                           ),
//                         ),
                      //Email
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_passFocusNode),//for next focusing
                          focusNode: _emailFocusNode,//for current focusing
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          //
                          validator: (value) {
                            if (value.isEmpty || !value.contains("@")) {

                              return "Please enter a valid Email";
                            }
                            String pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = new RegExp(pattern);
                            if (!regExp.hasMatch(value)){
                              return "Please make sure your Email format is correct";
                            }
                            else {
                              return null;
                            }
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: ()=>
                              FocusScope.of(context).requestFocus(_confirmFocusNode),
                          focusNode: _passFocusNode,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,

                          // validator: (value) {
                          //   if (value.isEmpty || value.length < 7) {
                          //     return "Please enter a valid password";
                          //   }
                          //   String pattern =
                          //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                          //   RegExp regExp = new RegExp(pattern);
                          //   if (!regExp.hasMatch(value)){
                          //     return "Please make sure your Password format is correct";
                          //   }
                          //   else {
                          //     return null;
                          //   }
                          // },
                          validator: (value) {
                            if (value.isEmpty || value.length < 7)  {

                              return "Please enter a valid Password";
                            }
                            String pattern =
                                r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{7,}$';
                            RegExp regExp = new RegExp(pattern);
                            if (!regExp.hasMatch(value)){
                              return "Must be least 7 characters with number and special character ";
                            }
                            else {
                              return null;
                            }
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
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //confirm
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=>
                          //

                          focusNode: _confirmFocusNode,
                          obscureText: _obscureText1,

                          keyboardType: TextInputType.visiblePassword,

                          controller: _confirmPasswordController,
                          validator: (value) {

                            if (value.isEmpty || value.length<7) {

                              return "Please enter a valid Password";
                            }
                            // String pattern =
                            //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';                            RegExp regExp = new RegExp(pattern);
                            // if (!regExp.hasMatch(value)){
                            //   return "Please enter a valid Password";
                            // }
                            if (_passTextController.text !=
                                _confirmPasswordController.text) {
                              return "Password doesnot match";
                            }
                            else {
                              return null;
                            }
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
                                    _obscureText1 = !_obscureText1;
                                  });

                                },
                                child: Icon(
                                  _obscureText1
                                      ? Icons.visibility_off//when obscure is true
                                      : Icons.visibility,//when obscure is false
                                  color: Colors.white,
                                ),
                              ),
                              hintText: "Confirm Password",
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
                        height: 40,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withOpacity(0.9),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {

                            signup(_emailTextController.text, _passTextController.text);

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
                                  "Register",
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
                        height: 30,
                      ),
                      RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Already have an account?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            TextSpan(text: "    "),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pop(context),
                                text: "Login",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ])),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
//radiobotton
  valueChanged(e) {
    setState(() {
      if (e == "male") {
        groupValue = e;
        gender=e;
      } else if (e == "female") {
        groupValue = e;
        gender=e;
      }
    });
  }
//signup function//
  void signup(String email, String password ) async{
    if(_loginFormKey.currentState.validate()==true){
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
        postDetailsToFirestore()

      }).catchError((e){
        Fluttertoast.showToast(msg: e.message);
      });
    }



  }
  postDetailsToFirestore() async
  {
    //calling our firestore
    //calling our user model
    //sending these values to firebase

    FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
    User user= _auth.currentUser;
    UserModel userModel=UserModel();
//writing the values
    userModel.userUid=user.uid;
    userModel.userEmail=user.email;
    userModel.userName=_nameTextController.text;


    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    // Fluttertoast.showToast(msg: "Account created succesfully");
    if(_loginFormKey.currentState.validate()==true) {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => VerifyEmailPage()), (
          route) => false);
    }
  }

}
