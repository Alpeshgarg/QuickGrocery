
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:packagedeliveryapp/service/widget_support.dart';
import 'package:packagedeliveryapp/service/database.dart';
import 'package:packagedeliveryapp/service/shared_pref.dart';
import 'package:packagedeliveryapp/service/widget_support.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id;
  bool current = true, past = false;
  int currentStep = 0;

  getontheload()async{
    id= await SharedpreferenceHelper().getUserId();
    OrderStream= await DatabaseMethods().getUserOrders(id!);
    setState(() {
      
    });
    print(id);
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

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
                currentStep=ds["Tracker"];
                return Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xff6053f8),
                                size: 30.0,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                ds["DropOffAddress"],
                                style: AppWidget.NormalTextfeildStyle(20.0),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Image.asset(
                                "images/parcel.png",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: FixedTimeline.tileBuilder(
                                  builder: TimelineTileBuilder.connected(
                                    contentsAlign: ContentsAlign.alternating,
                                    connectionDirection:
                                        ConnectionDirection.before,
                                    itemCount: 5,
                                    contentsBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          _getStatusText(index),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                    indicatorBuilder: (_, index) {
                                      if (index <= currentStep) {
                                        return DotIndicator(
                                          color: const Color(0xff6053f8),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        );
                                      } else {
                                        return OutlinedDotIndicator(
                                          borderWidth: 3,
                                          size: 24,
                                        );
                                      }
                                    },
                                    connectorBuilder:
                                        (_, index, ___) => SolidLineConnector(
                                          color:
                                              index < currentStep
                                                  ? const Color(0xff6053f8)
                                                  : Colors.grey,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6053f8),
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Order page",
                style: AppWidget.WhiteTextfeildStyle(24),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        current
                            ? Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "images/currentorder.png",
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "Current\nOrders",
                                      textAlign: TextAlign.center,
                                      style: AppWidget.HeadlineTextfeildStyle(
                                        25.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : GestureDetector(
                              onTap: () async{
                                current = true;
                                past = false;
                                OrderStream= await DatabaseMethods().getUserOrders(id!);
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "images/currentorder.png",
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "Current\nOrders",
                                      textAlign: TextAlign.center,
                                      style: AppWidget.NormalTextfeildStyle(
                                        24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        past
                            ? Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "images/delivery-man.png",
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "Past\nOrders",
                                      textAlign: TextAlign.center,
                                      style: AppWidget.HeadlineTextfeildStyle(
                                        25.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : GestureDetector(
                              onTap: () async{
                                current = false;
                                past = true;
                                 OrderStream= await DatabaseMethods().getUserPastOrders(id!);
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "images/delivery-man.png",
                                      height: 130,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "Past\nOrders",
                                      textAlign: TextAlign.center,
                                      style: AppWidget.NormalTextfeildStyle(
                                        24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/2.2,
                      child: allOrder()),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(int index) {
    switch (index) {
      case 0:
        return "Driver on the way to pickup point";
      case 1:
        return "Driver has arrived to pickup point";
      case 2:
        return "Parcel collected";
      case 3:
        return "Driver on the way to delivery destination";
      case 4:
        return "Parcel delivered";

      default:
        return "";
    }
  }
}
