import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:packagedeliveryapp/service/shared_pref.dart';
import 'package:packagedeliveryapp/service/widget_support.dart';
import 'package:timelines_plus/timelines_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? id;
  bool search = false;
  String? matchedAddress;
  int? matchedTrackerId;
  TextEditingController searchcontroller = new TextEditingController();

   String currentAddress = "Fetching location...";
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    getLocation();
    ontheload();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        currentAddress = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentAddress = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        currentAddress = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPosition = position;
    });

    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        currentAddress =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        currentAddress = "Error fetching address.";
      });
    }
  }

  getthesharedpref() async {
    id = await SharedpreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
  }

  Future<String?> getMatchingField(String userTrackerId) async {
    try {
      // Query Firestore where the tracker's ID matches the user input
      var querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(id)
              .collection("Order")
              .where('Track', isEqualTo: userTrackerId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return null; // No matching trackerId found
      }

      for (var doc in querySnapshot.docs) {
        var data = doc.data();

        // Check which field contains the trackerId
        for (var field in ['Track']) {
          if (data.containsKey(field) && data[field] == userTrackerId) {
            matchedAddress = data['DropOffAddress'] ?? 'No address found';
            matchedTrackerId = data['Tracker'];
            return field; // Return the matched field name
          }
        }
      }
      return null; // No field matched
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xff6053f8),
                            size: 30.0,
                          ),
                          Text(
                            "Current Location",
                            style: AppWidget.SimpleTextfeildStyle(),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.0),
                      Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        child: Text(
                         currentAddress,
                         overflow: TextOverflow.ellipsis,
                          style: AppWidget.HeadlineTextfeildStyle(20.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                height: MediaQuery.of(context).size.height / 2.2,
                decoration: BoxDecoration(
                  color: Color(0xff6053f8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    Text(
                      "Track your shipment",
                      style: AppWidget.WhiteTextfeildStyle(22.0),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "Please enter your tracking number",
                      style: AppWidget.DiffWhiteTextfeildStyle(),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: searchcontroller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter track number",
                          hintStyle: AppWidget.HeadlineTextfeildStyle(18.0),
                          prefixIcon: Icon(
                            Icons.track_changes,
                            color: Colors.red,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () async {
                              await getMatchingField(searchcontroller.text);
                              setState(() {
                                search = true;
                              });
                              print(matchedAddress);
                              print(matchedTrackerId);
                            },
                            child: Icon(Icons.search),
                          ),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                    ),
                    Spacer(),
                    Image.asset("images/home.png", height: 200),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
            search? Container(
                  margin: EdgeInsets.only(right: 10.0, left: 20.0),
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
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color(0xff6053f8),
                                size: 30.0,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                matchedAddress!,
                                style: AppWidget.NormalTextfeildStyle(20.0),
                              ),
                            ],
                          ),
                          Divider(),
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
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                    indicatorBuilder: (_, index) {
                                      if (index <= matchedTrackerId!) {
                                        return DotIndicator(
                                          color: Color(0xff6053f8),
                                          child: Icon(
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
                                              index < matchedTrackerId!
                                                  ? Color(0xff6053f8)
                                                  : Colors.grey,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ):
              Column(
              children: [
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                          left: 10.0,
                          top: 10.0,
                          bottom: 10.0,
                          right: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black38, width: 2.0),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "images/fast-delivery.png",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              children: [
                                Text(
                                  "Order a delivery",
                                  style: AppWidget.HeadlineTextfeildStyle(20.0),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.8,
                  
                                  child: Text(
                                    "We'll pick it up and deliver it across town quickly and securely.",
                                    textAlign: TextAlign.center,
                                    style: AppWidget.SlowSimpleTextfeildStyle(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
               
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      top: 10.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black38, width: 2.0),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/parcel.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          children: [
                            Text(
                              "Track a delivery",
                              style: AppWidget.HeadlineTextfeildStyle(20.0),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.8,

                              child: Text(
                                "Track your delivery in real-Time from pickup to drop-off.",
                                textAlign: TextAlign.center,
                                style: AppWidget.SlowSimpleTextfeildStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      left: 10.0,
                      top: 10.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black38, width: 2.0),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/delivery-bike.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          children: [
                            Text(
                              "Check delivery history",
                              style: AppWidget.HeadlineTextfeildStyle(20.0),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.8,

                              child: Text(
                                "Check your delivery history anytime to view details and stay organized.",
                                textAlign: TextAlign.center,
                                style: AppWidget.SlowSimpleTextfeildStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
               ],
              ),
              SizedBox(height: 30.0),
            ],
          ),
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
