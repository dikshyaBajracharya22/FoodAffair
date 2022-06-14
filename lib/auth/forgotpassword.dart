import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/auth/login.dart';
import 'package:food_app/config/myColors.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();

  @override
  void dispose() {
    // _animationController.dispose();
    _emailTextController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.red.shade900,
      // ),

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
            color: Colors.black.withOpacity(0.8),
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 50,
              left: 7,
              child: IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInDemo()));
                },
            icon: Icon(Icons.arrow_back, size: 30,color: Colors.white,),
          )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      //Email
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          //for current focusing
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          //
                          validator: (value) {
                            if (value.isEmpty || !value.contains("@")) {
                              return "Please enter a valid Email";
                            }
                            // String pattern =
                            //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            // RegExp regExp = new RegExp(pattern);
                            // if (!regExp.hasMatch(value)){
                            //   return "Please make sure your Email is correct";
                            // }
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

                      Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.withOpacity(0.9),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            resetPassword();
                            // signup(_emailTextController.text, _passTextController.text);
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
                                  "Reset Password",
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
                      SizedBox(height: 15,),

                      Container(

                       child: Row(

                         children: [

                           Container(
                           margin: EdgeInsets.all(10),
                             child: ElevatedButton(onPressed: (){
                               Navigator.pop(context);
                             }, child: Text("Go Back",style: TextStyle(color: Colors.white),), style:ElevatedButton.styleFrom(primary: Colors.red.shade800)),
                           )
                         ],
                       ),
                      )
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

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password Reset Email Sent"),
        duration: Duration(milliseconds: 1800),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        duration: Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      Navigator.pop(context);
      // Utils.showSnackBar(e.message);
    }
  }
}
