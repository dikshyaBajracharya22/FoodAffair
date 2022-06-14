import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/config/colors.dart';
import 'package:food_app/providers/user_provider.dart';
import 'package:food_app/screens/home/home_screen.dart';
import 'package:food_app/screens/my_profile/my_profile.dart';
import 'package:food_app/screens/review_cart/review_cart.dart';
import 'package:food_app/screens/wishList/wish_list.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../../auth/login.dart';
import '../../models/user_model.dart';

class DrawerSide extends StatefulWidget {
  UserProvider userProvider;
  DrawerSide({this.userProvider});
  @override
  _DrawerSideState createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
//Logout of google
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  Future signOut() async {
    await _googleSignIn.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInDemo()),(route) => false));
  }
  //upto here


  //1. to get data from firebase-
  User user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  dynamic file;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }
  Widget listTile({String title, IconData iconData, Function onTap}) {
    return Container(
      height: 50,
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          iconData,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;
    return Drawer(
      child: Container(
        color: Colors.grey.shade300,
        child: ListView(
          children: [
            Container(
              color: Colors.red.shade900,
              child: DrawerHeader(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 43,
                        backgroundColor: Colors.white54,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade100,

                          backgroundImage: NetworkImage(
                            "${loggedInUser.userImage}" ??
                            "https://s3.envato.com/files/328957910/vegi_thumb.png",
                          ),
                          radius: 40,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${loggedInUser.userName}",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          ),
                          Text(
                            "${loggedInUser.userEmail}",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.yellow.shade50),
                          ),//   userData.userEmail,style: TextStyle(color: Colors.yellow.shade50),
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            listTile(
              iconData: Icons.home_outlined,

              title: "Home",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            listTile(
              iconData: Icons.shop_outlined,
              title: "Review Cart",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReviewCart(),
                  ),
                );
              },
            ),
            // listTile(
            //   iconData: Icons.person_outlined,
            //   title: "My Profile",
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => MyProfile(userProvider:widget.userProvider),
            //       ),
            //     );
            //   },
            // ),

            listTile(
                iconData: Icons.favorite_outline,
                title: "Wishlist",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WishLsit(),
                    ),
                  );
                }),

            InkWell(
                onTap: () {
                  showDialog(

                      context: context,
                      builder: (cntx) {
                        return AlertDialog(

                          backgroundColor: Colors.grey.shade200,
                          title: Text("Logout", style: TextStyle(color: Colors.red.shade900)),
                          content: Container(
                            // color: Colors.red,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Do you really want to logout?"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    RaisedButton(

                                        child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),),
                                        color: Colors.yellow.shade800,

                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    RaisedButton(
                                        child: Text("LogOut",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),),
                                        color: Colors.red.shade900,
                                        onPressed: (){
                                          signOut();
                                          logout(context);

                                        }
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },

                child: listTile(iconData: Icons.logout, title: "LogOut")),
            listTile(iconData: Icons.format_quote_outlined, title: "FAQs"),
            SizedBox(height: 40),
            Container(
              height: 350,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Contact Support"),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Call us:"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("+923352580282"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text("Mail us:"),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "dikshyabajracharya01@gmail.com",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignInDemo()));
  }
}
