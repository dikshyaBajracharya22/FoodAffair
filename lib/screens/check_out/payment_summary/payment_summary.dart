import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/config/colors.dart';
import 'package:food_app/models/delivery_address_model.dart';
import 'package:food_app/providers/review_cart_provider.dart';
import 'package:food_app/screens/check_out/delivery_details/single_delivery_item.dart';
import 'package:food_app/screens/check_out/payment_summary/my_google_pay.dart';
import 'package:food_app/screens/check_out/payment_summary/order_item.dart';
import 'package:food_app/screens/home/home_screen.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/check_out_provider.dart';
import 'khalti_payment.dart';

class PaymentSummary extends StatefulWidget {

  final DeliveryAddressModel deliverAddressList;
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
  PaymentSummary({
    this.deliverAddressList,
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

  @override
  _PaymentSummaryState createState() => _PaymentSummaryState();
}

enum AddressTypes {
  Home,
  OnlinePayment,
}

class _PaymentSummaryState extends State<PaymentSummary> {
  var myType = AddressTypes.Home;

  @override
  Widget build(BuildContext context) {

    print(widget.orderId);
    print(widget.mobileNo);
    CheckoutProvider checkoutProvider = Provider.of(context);
    ReviewCartProvider reviewCartProvider = Provider.of(context);
    reviewCartProvider.getReviewCartData();
    CheckoutProvider deliveryAddressProvider = Provider.of(context);
    deliveryAddressProvider.getDeliveryAddressData();

    double discount = 10;
    double discountValue;
    double shippingChanrge = 50;
    double total = 0;
    double totalPrice = reviewCartProvider.getTotalPrice();
    if (totalPrice > 300) {
      discountValue = (totalPrice * discount) / 100;
      total = totalPrice - discountValue;
    }

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text(
          "Payment Summary",
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: ListTile(
        title: Text("Total Amount"),
        subtitle: Text(
          "\Rs ${total +shippingChanrge  ?? totalPrice}",
          style: TextStyle(
            color: Colors.green[900],
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        trailing: Container(
          width: 160,
          child: MaterialButton(
            onPressed: () {
              if(myType==AddressTypes.Home){
                checkoutProvider.addPlaceOderData(
                    orderId: widget.orderId,
                    productImagee: widget.productImagee,
                    productNamee: widget.productNamee,
                    productPricee: widget.productPricee,
                    productQuantityy: 1,
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    mobileNo: widget.mobileNo,
                    // scoirty: widget.scoirty,
                    street: widget.street
                );
                Fluttertoast.showToast(msg: "Your Order has been placed succesfully!!", backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16);
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return HomeScreen();
                }));
              }

           else if(myType == AddressTypes.OnlinePayment){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>KhaltiPaymentPage()));
              }

                  // ? Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) => MyGooglePay(
                  //         total: total,
                  //       ),
                  //     ),
                  //   )
           // ?

              // : Container();
            },

            child: Text(
              "Place Order",
              style: TextStyle(
                color: textColor,
              ),
            ),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SingleDeliveryItem(
                  address:
                      "aera, ${widget.deliverAddressList.aera}, street, ${widget.deliverAddressList.street}, society ${widget.deliverAddressList.scoirty}, pincode ${widget.deliverAddressList.pinCode}",
                  title:
                      "${widget.deliverAddressList.firstName} ${widget.deliverAddressList.lastName}",
                  number: widget.deliverAddressList.mobileNo,
                  addressType: widget.deliverAddressList.addressType ==
                          "AddressTypes.Home"
                      ? "Home"
                      : widget.deliverAddressList.addressType ==
                              "AddressTypes.Other"
                          ? "Other"
                          : "Work",
                ),
                Divider(),
                ExpansionTile(
                  children: reviewCartProvider.getReviewCartDataList.map((e) {
                    return OrderItem(
                      e: e,
                    );
                  }).toList(),
                  title: Text(
                      "Order Items ${reviewCartProvider.getReviewCartDataList.length}"),
                ),
                Divider(),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Sub Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "\Rs ${totalPrice }",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Shipping Charge",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "\Rs $shippingChanrge",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  minVerticalPadding: 5,
                  leading: Text(
                    "Compen Discount",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    "\Rs $discountValue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Text("Payment Options"),
                ),
                RadioListTile(
                  value: AddressTypes.Home,
                  groupValue: myType,
                  title: Text("Home"),
                  onChanged: (AddressTypes value) {
                    setState(() {
                      myType = value;
                    });
                  },
                  secondary: Icon(
                    Icons.work,
                    color: primaryColor,
                  ),
                ),
                RadioListTile(
                  value: AddressTypes.OnlinePayment,
                  groupValue: myType,
                  title: Text("OnlinePayment"),
                  onChanged: (AddressTypes value) {
                    setState(() {
                      myType = value;
                    });
                  },
                  secondary: Icon(
                    Icons.devices_other,
                    color: primaryColor,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );

  }
}
