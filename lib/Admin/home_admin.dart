import 'package:flutter/material.dart';
import 'package:packagedeliveryapp/Admin/manage_users.dart';
import 'package:packagedeliveryapp/Admin/order_admin.dart';
import 'package:packagedeliveryapp/service/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6053f8),
      body: Container(
        margin: EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Home Admin",
                style: AppWidget.WhiteTextfeildStyle(32.0),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 180.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminOrder()));
                      },
                      child: Container(
                         margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2.0), borderRadius: BorderRadius.circular(20)),
                           
                            child: Row(
                          
                              children: [
                                Image.asset(
                                  "images/parcel.png",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 30.0,),
                           
                                  Text("Manage\nOrders", style: AppWidget.HeadlineTextfeildStyle(28.0),textAlign: TextAlign.center,),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios_rounded, size: 30.0,)
                          
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 90.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageUsers()));
                      },
                      child: Container(
                         margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2.0), borderRadius: BorderRadius.circular(20)),
                           
                            child: Row(
                          
                              children: [
                                Image.asset(
                                  "images/admin.png",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 30.0,),
                           
                                  Text("Manage\nUsers", style: AppWidget.HeadlineTextfeildStyle(28.0),textAlign: TextAlign.center,),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios_rounded, size: 30.0,)
                          
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
