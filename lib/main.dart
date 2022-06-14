import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_app/auth/sign_in.dart';
import 'package:food_app/auth/try.dart';
import 'package:food_app/config/colors.dart';
import 'package:food_app/providers/check_out_provider.dart';
import 'package:food_app/providers/product_provider.dart';
import 'package:food_app/providers/review_cart_provider.dart';
import 'package:food_app/providers/user_provider.dart';
import 'package:food_app/providers/wishlist_provider.dart';
import 'package:food_app/screens/home/home_screen.dart';
import 'package:food_app/widgets/verify_email.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';

import 'auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //1 .to use provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ReviewCartProvider>(
          create: (context) => ReviewCartProvider(),
        ),
        ChangeNotifierProvider<WishListProvider>(
          create: (context) => WishListProvider(),
        ),
        ChangeNotifierProvider<CheckoutProvider>(
          create: (context) => CheckoutProvider(),
        ),
      ],


      child:KhaltiScope(
        publicKey: "test_public_key_675a4ee046924e999607841b5e3e56dd",
        builder: (context, navigatorKey){
          return  MaterialApp(
            navigatorKey: navigatorKey,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: const[
              KhaltiLocalizations.delegate,
            ],
            theme: ThemeData(
                fontFamily: "Poppins",
                primaryColor: primaryColor,
                scaffoldBackgroundColor: scaffoldBackgroundColor),
            debugShowCheckedModeBanner: false,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  return VerifyEmailPage();
                }else {
                  return SignInDemo();
                }
              },
            ),
          );
        }
      )




    );

  }
}
