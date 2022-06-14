import 'package:flutter/material.dart';
import 'package:food_app/config/colors.dart';
import 'package:food_app/models/product_model.dart';
import 'package:food_app/models/review_cart_model.dart';
import 'package:food_app/providers/review_cart_provider.dart';
import 'package:food_app/providers/wishlist_provider.dart';
import 'package:food_app/widgets/single_item.dart';
import 'package:provider/provider.dart';

class WishLsit extends StatefulWidget {
  @override
  _WishLsitState createState() => _WishLsitState();
}

class _WishLsitState extends State<WishLsit> {
  WishListProvider wishListProvider;
  showAlertDialog(BuildContext context, ProductModel delete) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        wishListProvider.deleteWishtList(delete.productId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("WishList Product"),
      content: Text("Are you sure you want to delete this Product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    wishListProvider = Provider.of(context);
    wishListProvider.getWishtListData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text(
          "WishList",
          style: TextStyle(color: Colors.yellow.shade50, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: wishListProvider.getWishList.length,
          itemBuilder: (context, index) {
            ProductModel data = wishListProvider.getWishList[index];
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SingleItem(
                  isBool: true,
                  wishList: true,

                  productImage: data.productImage ?? 'default',
                  productName: data.productName ?? 'default',
                  productPrice: data.productPrice ?? 'default',
                  productId: data.productId ?? 'default',
                  // productUnit: data.productUnit ?? 'default',
                  productQuantity: data.productQuantity ?? 'default',
                  onDelete: () {
                    showAlertDialog(context,data);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
