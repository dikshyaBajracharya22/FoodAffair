import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/config/colors.dart';
import 'package:food_app/models/delivery_address_model.dart';
import 'package:food_app/models/review_cart_model.dart';
import 'package:food_app/providers/check_out_provider.dart';
import 'package:food_app/providers/review_cart_provider.dart';
import 'package:food_app/screens/check_out/delivery_details/delivery_details.dart';
import 'package:food_app/widgets/single_item.dart';
import 'package:provider/provider.dart';
//getting data from single_item.dart
class ReviewCart extends StatelessWidget {
  String orderId;
  String productImagee;
  String productNamee;
  int productPricee;
  int productQuantityy;
  String firstName;
  String lastName;
  String mobileNo;
  // String scoirty;
  String street;
  ReviewCart({
    this.orderId,
    this.productImagee,
    this.productNamee,
    this.productPricee,
    this.productQuantityy,
    this.firstName,
    this.lastName,
    this.mobileNo,
    // this.scoirty,
    this.street
});
  CheckoutProvider checkoutProvider;

  ReviewCartProvider reviewCartProvider;
  showAlertDialog(BuildContext context, ReviewCartModel delete) {
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
        reviewCartProvider.reviewCartDataDelete(delete.cartId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cart Product"),
      content: Text("Are you sure you want to delete this product?"),
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
    //review cart provider
    reviewCartProvider = Provider.of<ReviewCartProvider>(context);
    reviewCartProvider.getReviewCartData();
    return Scaffold(
      bottomNavigationBar: ListTile(
        title: Text("Total Amount"),
        subtitle: Text(
          "\Rs ${reviewCartProvider.getTotalPrice()}",
          style: TextStyle(
            color: Colors.green[900],
          ),
        ),
        trailing: Container(
          width: 160,
          child: MaterialButton(
            child: Text("Submit"),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            onPressed: () {
              if(reviewCartProvider.getReviewCartDataList.isEmpty){
                return Fluttertoast.showToast(msg: "No Cart Data Found");
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DeliveryDetails(
                      orderId: orderId,
                      productImagee: productImagee,
                      productNamee: productNamee,
                      productPricee: productPricee,
                      productQuantityy: productQuantityy,
                      firstName: "dikshya",
                      lastName: "bajracharya",
                      mobileNo: "9808872719",
                      // scoirty: scoirty,
                      street: "satdobato"

                  ),
                ),
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text(
          "Review Cart",
          style: TextStyle(color: Colors.yellow.shade50, fontSize: 18),
        ),
      ),
      body: reviewCartProvider.getReviewCartDataList.isEmpty
          ? Center(
              child: Text("NO DATA"),
            )
      //to display from firebase ro screen
          : ListView.builder(
              itemCount: reviewCartProvider.getReviewCartDataList.length,
              itemBuilder: (context, index) {
                ReviewCartModel data =
                    reviewCartProvider.getReviewCartDataList[index];
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SingleItem(
                      isBool: true,// isBool is true so shows cart in single_item.dart
                      wishList: false,
                      productImage: data.cartImage,
                      productName: data.cartName,
                      productPrice: data.cartPrice,
                      productId: data.cartId,
                      productQuantity: data.cartQuantity,
                      // productUnit: data.cartUnit,
                      onDelete: () {
                        showAlertDialog(context, data);
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }
}
