import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:packagedeliveryapp/service/constant.dart';
import 'package:packagedeliveryapp/service/database.dart';
import 'package:packagedeliveryapp/service/shared_pref.dart';
import 'package:packagedeliveryapp/service/widget_support.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController pickupaddress = new TextEditingController();
  TextEditingController pickupusername = new TextEditingController();
  TextEditingController pickupphpone = new TextEditingController();
  TextEditingController dropoffaddress = new TextEditingController();
  TextEditingController dropoffusername = new TextEditingController();
  TextEditingController dropoffphone = new TextEditingController();
  String? email, id;

  getthesharedpref()async{
    email= await SharedpreferenceHelper().getUserEmail();
    id= await SharedpreferenceHelper().getUserId();
    setState(() {
      
    });
  }

  ontheload()async{
    await getthesharedpref();
    setState(() {
      
    });
  }

  late Razorpay _razorpay;
  int total = 0;

  @override
  void dispose() {
    _razorpay.clear(); // Clean up the Razorpay instance
    super.dispose();
  }

  void openCheckout(String amount, String email) {
    var options = {
      'key': RazorPayKey, 
      'amount': amount, // Amount in paise (50000 = ₹500)
      'name': 'Package Delivery App',
      'description': 'Payment for your order',
      'prefill': {'email': email},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String tracknumber= randomAlphaNumeric(10);
    String orderId= randomAlphaNumeric(10);
    Map<String, dynamic> userOrderMap={
      "PickUpAddress": pickupaddress.text,
      "PickUpUserName": pickupusername.text,
      "PickUpPhone": pickupphpone.text,
      "DropOffAddress": dropoffaddress.text,
      "DropOffUserName": dropoffusername.text,
      "DropOffPhone": dropoffphone.text,
      "OrderId": orderId,
      "Track": tracknumber,
      "Tracker":-1,
      "UserId": id,

    };
    await DatabaseMethods().addUserOrder(userOrderMap, id!,orderId);
    await DatabaseMethods().addAdminOrder(userOrderMap, orderId);
     ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Order Placed Successfully!",
              style: AppWidget.WhiteTextfeildStyle(20),
            ),
          ));
  }

  // Do something when payment succeeds
  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failure: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6053f8),
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Add Package",
                style: AppWidget.WhiteTextfeildStyle(24),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "images/delivery-truck.png",
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(height: 40.0),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pick-up details",
                              style: AppWidget.NormalTextfeildStyle(24.0),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color(0xff6053f8),
                                  size: 30.0,
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextField(
                                    controller: pickupaddress,
                                    decoration: InputDecoration(
                                      hintText: "Enter Pick-up Address",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Color(0xff6053f8),
                                  size: 30.0,
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextField(
                                    controller: pickupusername,
                                    decoration: InputDecoration(
                                      hintText: "Enter User Name",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Color(0xff6053f8),
                                  size: 30.0,
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextField(
                                    controller: pickupphpone,
                                    decoration: InputDecoration(
                                      hintText: "Enter Phone number",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Drop-off details",
                              style: AppWidget.NormalTextfeildStyle(24.0),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color(0xff6053f8),
                                  size: 30.0,
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextField(
                                    controller: dropoffaddress,
                                    decoration: InputDecoration(
                                      hintText: "Enter Drop-off Address",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Color(0xff6053f8),
                                  size: 30.0,
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextField(
                                    controller: dropoffusername,
                                    decoration: InputDecoration(
                                      hintText: "Enter User Name",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Color(0xff6053f8),
                                  size: 30.0,
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: TextField(
                                    controller: dropoffphone,
                                    decoration: InputDecoration(
                                      hintText: "Enter Phone number",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        padding: EdgeInsets.only(
                          left: 30.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        margin: EdgeInsets.only(right: 20.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Total Price",
                                  style: AppWidget.NormalTextfeildStyle(18.0),
                                ),
                                Text(
                                  "\u20B9500",
                                  style: AppWidget.HeadlineTextfeildStyle(28.0),
                                ),
                              ],
                            ),
                            SizedBox(width: 50.0),
                            GestureDetector(
                              onTap: () {
                                if(pickupaddress.text!="" && pickupusername.text!="" && pickupaddress.text!="" && pickupphpone.text!="" && pickupusername.text!=""){
                                openCheckout("50000",email!);
                                } else{
                                   ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Please Fill Complete Details!",
              style: AppWidget.WhiteTextfeildStyle(20),
            ),
          ));
                                }
                              },
                              child: Container(
                                height: 60,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xff6053f8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "Place Order",
                                    style: AppWidget.WhiteTextfeildStyle(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 80.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
