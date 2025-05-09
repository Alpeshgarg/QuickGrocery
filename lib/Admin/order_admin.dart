import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:packagedeliveryapp/service/database.dart';
import 'package:packagedeliveryapp/service/widget_support.dart';

class AdminOrder extends StatefulWidget {
  const AdminOrder({super.key});

  @override
  State<AdminOrder> createState() => _AdminOrderState();
}

class _AdminOrderState extends State<AdminOrder> {
  Stream? OrderStream;

  Widget allOrder() {
    return StreamBuilder(
      stream: OrderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return ds["Tracker"] == 4
                    ? Container()
                    : Container(
                      margin: EdgeInsets.only(bottom: 30.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: EdgeInsets.only(left: 20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0),
                              Center(
                                child: Image.asset(
                                  "images/parcel.png",
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                "Drop-Off Details :",
                                style: AppWidget.HeadlineTextfeildStyle(20.0),
                              ),
                              Text(
                                "Address : " + ds["DropOffAddress"],
                                style: AppWidget.NormalTextfeildStyle(18.0),
                              ),
                              Text(
                                "Name : " + ds["DropOffUserName"],
                                style: AppWidget.NormalTextfeildStyle(18.0),
                              ),
                              Text(
                                "Phone : " + ds["DropOffPhone"],
                                style: AppWidget.NormalTextfeildStyle(18.0),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                "PickUp Details :",
                                style: AppWidget.HeadlineTextfeildStyle(20.0),
                              ),
                              Text(
                                "Address : " + ds["PickUpAddress"],
                                style: AppWidget.NormalTextfeildStyle(18.0),
                              ),
                              Text(
                                "Name : " + ds["PickUpUserName"],
                                style: AppWidget.NormalTextfeildStyle(18.0),
                              ),
                              Text(
                                "Phone : " + ds["PickUpPhone"],
                                style: AppWidget.NormalTextfeildStyle(18.0),
                              ),
                              SizedBox(height: 20.0),
                              ds["Tracker"] >= 0
                                  ? Material(
                                    elevation: 3.0,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                30,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                2,
                                            child: Text(
                                              "Driver on the way to pickup point",
                                              textAlign: TextAlign.center,
                                              style:
                                                  AppWidget.WhiteTextfeildStyle(20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : GestureDetector(
                                    onTap: () async {
                                      if (ds["Tracker"] == -1) {
                                        int updatedtracker = ds["Tracker"];
                      
                                        updatedtracker = updatedtracker + 1;
                                        await DatabaseMethods()
                                            .updateAdminTracker(
                                              ds.id,
                                              updatedtracker,
                                            );
                                        await DatabaseMethods().updateUserTracker(
                                          ds["UserId"],
                                          updatedtracker,
                                          ds["OrderId"],
                                        );
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                            1.5,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Driver on the way to pickup point",
                                            textAlign: TextAlign.center,
                                            style: AppWidget.WhiteTextfeildStyle(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              SizedBox(height: 20.0),
                              ds["Tracker"] >= 1
                                  ? Material(
                                    elevation: 3.0,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                30,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                2,
                                            child: Text(
                                              "Driver has arrived to pickup point",
                                              textAlign: TextAlign.center,
                                              style:
                                                  AppWidget.WhiteTextfeildStyle(
                                                    20.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : GestureDetector(
                                    onTap: () async {
                                      if (ds["Tracker"] == 0) {
                                        int updatedtracker = ds["Tracker"];
                      
                                        updatedtracker = updatedtracker + 1;
                                        await DatabaseMethods()
                                            .updateAdminTracker(
                                              ds.id,
                                              updatedtracker,
                                            );
                                                await DatabaseMethods().updateUserTracker(
                                          ds["UserId"],
                                          updatedtracker,
                                          ds["OrderId"],
                                        );
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                            1.5,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Driver has arrived to pickup point",
                                            textAlign: TextAlign.center,
                                            style: AppWidget.WhiteTextfeildStyle(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              SizedBox(height: 20.0),
                              ds["Tracker"] >= 2
                                  ? Material(
                                    elevation: 3.0,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                30,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                2,
                                            child: Text(
                                              "Parcel collected",
                                              textAlign: TextAlign.center,
                                              style:
                                                  AppWidget.WhiteTextfeildStyle(
                                                    20.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : GestureDetector(
                                    onTap: () async {
                                      if (ds["Tracker"] == 1) {
                                        int updatedtracker = ds["Tracker"];
                      
                                        updatedtracker = updatedtracker + 1;
                                        await DatabaseMethods()
                                            .updateAdminTracker(
                                              ds.id,
                                              updatedtracker,
                                            );
                                                await DatabaseMethods().updateUserTracker(
                                          ds["UserId"],
                                          updatedtracker,
                                          ds["OrderId"],
                                        );
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                            1.5,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Parcel collected",
                                            textAlign: TextAlign.center,
                                            style: AppWidget.WhiteTextfeildStyle(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              SizedBox(height: 20.0),
                              ds["Tracker"] >= 3
                                  ? Material(
                                    elevation: 3.0,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                30,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                2,
                                            child: Text(
                                              "Driver on the way to delivery destination",
                                              textAlign: TextAlign.center,
                                              style:
                                                  AppWidget.WhiteTextfeildStyle(
                                                    20.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : GestureDetector(
                                    onTap: () async {
                                      if (ds["Tracker"] == 2) {
                                        int updatedtracker = ds["Tracker"];
                      
                                        updatedtracker = updatedtracker + 1;
                                        await DatabaseMethods()
                                            .updateAdminTracker(
                                              ds.id,
                                              updatedtracker,
                                            );
                                                await DatabaseMethods().updateUserTracker(
                                          ds["UserId"],
                                          updatedtracker,
                                          ds["OrderId"],
                                        );
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                            1.5,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Driver on the way to delivery destination",
                                            textAlign: TextAlign.center,
                                            style: AppWidget.WhiteTextfeildStyle(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              SizedBox(height: 20.0),
                              ds["Tracker"] >= 4
                                  ? Material(
                                    elevation: 3.0,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                30,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Container(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width /
                                                2,
                                            child: Text(
                                              "Parcel delivered",
                                              textAlign: TextAlign.center,
                                              style:
                                                  AppWidget.WhiteTextfeildStyle(
                                                    20.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : GestureDetector(
                                    onTap: () async {
                                      if (ds["Tracker"] == 3) {
                                        int updatedtracker = ds["Tracker"];
                      
                                        updatedtracker = updatedtracker + 1;
                                        await DatabaseMethods()
                                            .updateAdminTracker(
                                              ds.id,
                                              updatedtracker,
                                            );
                                                await DatabaseMethods().updateUserTracker(
                                          ds["UserId"],
                                          updatedtracker,
                                          ds["OrderId"],
                                        );
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width /
                                            1.5,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Parcel delivered",
                                            textAlign: TextAlign.center,
                                            style: AppWidget.WhiteTextfeildStyle(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    );
              },
            )
            : Container();
      },
    );
  }

  getontheload() async {
    OrderStream = await DatabaseMethods().getAdminOrders();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
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
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.only(left: 20.0),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(60)),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,size: 30.0,)),
                ),
                SizedBox(width: MediaQuery.of(context).size.width/5,),
                Center(
                  child: Text(
                    "All Orders",
                    style: AppWidget.WhiteTextfeildStyle(24.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Container(height: 500, child: allOrder()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
