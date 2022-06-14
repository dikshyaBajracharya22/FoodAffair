import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/config/colors.dart';
import 'package:food_app/config/myColors.dart';
import 'package:food_app/models/order_model.dart';
import 'package:food_app/providers/check_out_provider.dart';
import 'package:food_app/providers/product_provider.dart';
import 'package:food_app/providers/user_provider.dart';
import 'package:food_app/screens/product_overview/product_overview.dart';
import 'package:food_app/screens/home/singal_product.dart';
import 'package:food_app/screens/review_cart/review_cart.dart';
import 'package:food_app/screens/search/search.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../auth/login.dart';
import '../../models/user_model.dart';
import 'drawer_side.dart';

class HomeScreen extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;
  final String productDescription;
  int productQuantity;
  String firstName;
  String lastName;
  String mobileNo;
  // String scoirty;
  String street;

  HomeScreen({
    this.productId, this.productImage, this.productName, this.productPrice, this.productDescription, this.productQuantity,
    this.firstName,
    this.lastName,
    this.mobileNo,
    // this.scoirty,
    this.street
});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  Future signOut() async {
    await _googleSignIn.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignInDemo()),
            (route) => false));
  }

  //1. to get data from firebase-
  User user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  ProductProvider productProvider;
  CheckoutProvider checkoutProvider;

//=============Special Product=========//
  Widget _buildHerbsProduct(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Our Special', style: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.w500),),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Search(
                        search: productProvider.getHerbsProductDataList,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'view all',
                      style: TextStyle(color: Colors.yellow.shade900, fontSize: 15),
                    ),
                   Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: productProvider.getHerbsProductDataList.map(
              (herbsProductData) {
                return SingalProduct(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductOverview(
                          productId: herbsProductData.productId,
                          productPrice: herbsProductData.productPrice,
                          productName: herbsProductData.productName,
                          productImage: herbsProductData.productImage,
                          productDescription:
                              herbsProductData.productDescription,
                          // firstName:checkoutProvider.,
                          // lastName: checkoutProvider.deliveryAddressModel.lastName,
                          // mobileNo: checkoutProvider.deliveryAddressModel.mobileNo,
                          // street: checkoutProvider.deliveryAddressModel.street,
                        ),
                      ),
                    );
                  },
                  productId: herbsProductData.productId,
                  productPrice: herbsProductData.productPrice,
                  productImage: herbsProductData.productImage,
                  productName: herbsProductData.productName,
                  productUnit: herbsProductData,
                );
              },
            ).toList(),
            // children: [

            // ],
          ),
        ),
      ],
    );
  }
//=============Non Veg Product=========//
  Widget _buildFreshProduct(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Non Veg Items', style: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Search(
                        search: productProvider.getFreshProductDataList,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'view all',
                      style: TextStyle(color: Colors.yellow.shade900,fontSize: 15 ),
                    ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            //get products from firebase using provider
            children: productProvider.getFreshProductDataList.map(
              (freshProductData) {

                return SingalProduct(  //home product section in this page

                  onTap: () {
                    //product overview description page

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductOverview(
                          productId: freshProductData.productId,
                          productImage: freshProductData.productImage,
                          productName: freshProductData.productName,
                          productPrice: freshProductData.productPrice,
                          productDescription:
                              freshProductData.productDescription,
                          // firstName:checkoutProvider.deliveryAddressModel.firstName,
                          // lastName: checkoutProvider.deliveryAddressModel.lastName,
                          // mobileNo: checkoutProvider.deliveryAddressModel.mobileNo,
                          // street: checkoutProvider.deliveryAddressModel.street,
                        ),
                      ),
                    );
                  },

                  productId: freshProductData.productId,
                  productImage: freshProductData.productImage,
                  productName: freshProductData.productName,
                  productPrice: freshProductData.productPrice,
                  productUnit: freshProductData,
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
//=============Veg Product=========//
  Widget _buildRootProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Veg Items', style: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.w500)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Search(
                        search: productProvider.getRootProductDataList,
                      ),

                    ),
                  );
                },
                child: Row(
                  children: [

                    Text(
                      'view all',
                      style: TextStyle(color: Colors.yellow.shade900, fontSize: 15),
                    ),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: productProvider.getRootProductDataList.map(
              (rootProductData) {
                return SingalProduct(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductOverview(
                          productId: rootProductData.productId,
                          productImage: rootProductData.productImage,
                          productName: rootProductData.productName,
                          productPrice: rootProductData.productPrice,
                          productDescription:
                              rootProductData.productDescription,
                          // firstName:checkoutProvider.deliveryAddressModel.firstName,
                          // lastName: checkoutProvider.deliveryAddressModel.lastName,
                          // mobileNo: checkoutProvider.deliveryAddressModel.mobileNo,
                          // street: checkoutProvider.deliveryAddressModel.street,
                        ),
                      ),
                    );
                  },
                  productId: rootProductData.productId,
                  productImage: rootProductData.productImage,
                  productName: rootProductData.productName,
                  productPrice: rootProductData.productPrice,
                  productUnit: rootProductData,

                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
// ===============initializing provider==============
  @override
  void initState() {
    ProductProvider initproductProvider = Provider.of(context, listen: false);

    initproductProvider.fatchHerbsProductData();
    initproductProvider.fatchFreshProductData();
    initproductProvider.fatchRootProductData();
    super.initState();


//logout
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of(context);
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();
    return Scaffold(
      drawer: DrawerSide(
        userProvider: userProvider,
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.yellow.shade100),
        backgroundColor: Colors.red.shade900,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.yellow.shade100, fontSize: 17),
        ),
        actions: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.red.shade900,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        Search(search: productProvider.gerAllProductSearch),
                  ),
                );
              },
              icon: Icon(
                Icons.search,
                size: 20,
                color: Colors.yellow.shade100,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReviewCart(

                      orderId: productProvider.productModel.productId,
                      productImagee: productProvider.productModel.productImage,
                      productNamee:productProvider.productModel.productName,
                      productPricee: productProvider.productModel.productPrice,
                      productQuantityy: productProvider.productModel.productQuantity ,
                      // firstName: "default",
                      // lastName: widget.lastName,
                      // mobileNo: widget.mobileNo,
                      // // scoirty: widget.scoirty,
                      // street: widget.street,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.red.shade900,
                radius: 15,
                child: Icon(
                  Icons.shopping_cart,
                  size: 19,
                  color: Colors.yellow.shade100,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                showDialog(

                    context: context,
                    builder: (cntx) {
                      return AlertDialog(

                        backgroundColor: Colors.grey.shade200,
                        title: Text("Logout", style: TextStyle(color: Colors.red.shade900),),
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
                                      child: Text("Logout",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),),
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

              icon: Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(
          children: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Search(
                      search: productProvider.getRootProductDataList,
                    ),
                  ),
                );
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS12YRwvV3lxqIix22kyTgmbhrJw88hIsaXng&usqp=CAU'),
                  ),
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 120, bottom: 10),
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade900,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'FoodAffair',
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      shadows: [
                                        BoxShadow(
                                            color: Colors.green,
                                            blurRadius: 10,
                                            offset: Offset(3, 3))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 7),
                              child: Text(
                                '30% Off',
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.yellow.shade100,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'On all Veg items',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            _buildHerbsProduct(context),
            _buildRootProduct(),
            _buildFreshProduct(context),
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
