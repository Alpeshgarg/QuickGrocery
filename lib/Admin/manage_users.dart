import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:packagedeliveryapp/service/database.dart';
import 'package:packagedeliveryapp/service/widget_support.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {

getontheload()async{
  userStream= await DatabaseMethods().getAllUsers();
  setState(() {
    
  });
}

@override
void initState() {
  super.initState();
  getontheload();
}



  Stream? userStream;

  Widget allUsers() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                return Container(
                  
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "images/boy.jpg",
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: Color(0xff6053f8)),
                              SizedBox(width: 10.0),
                              Text(
                                ds["Name"],
                                style: AppWidget.NormalTextfeildStyle(20.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            children: [
                              Icon(Icons.mail, color: Color(0xff6053f8)),
                              SizedBox(width: 10.0),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.0,
                                child: Text(
                                  ds["Email"],
                                  style: AppWidget.NormalTextfeildStyle(17.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          GestureDetector(
                            onTap: ()async{
                              await DatabaseMethods().deleteuser(ds.id);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Remove",
                                style: AppWidget.WhiteTextfeildStyle(18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
      backgroundColor: Color(0xff6053f8),
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                      child: Icon(Icons.arrow_back, color: Colors.black,size: 30.0,),),
                  ),
                    SizedBox(width: MediaQuery.of(context).size.width/8,),
                  Center(
                    child: Text(
                      "Manage Users",
                      style: AppWidget.WhiteTextfeildStyle(28.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(children: [SizedBox(height: 30.0),
               Expanded(
                  
                  child: allUsers())]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
