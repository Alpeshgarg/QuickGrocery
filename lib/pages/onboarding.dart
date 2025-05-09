import 'package:flutter/material.dart';
import 'package:packagedeliveryapp/service/widget_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(children: [
        Image.asset("images/onboarding.png"),
        
        const SizedBox(height: 20,),

        Text("Track your parcel\nfrom anywhere",
        textAlign: TextAlign.center, 
        style: AppWidget.HeadlineTextfeildStyle(30),),


        const SizedBox(height: 30,),


        Text("Check the progress of your deliveries", style: AppWidget.SimpleTextfeildStyle(),),

        const SizedBox(height: 30,),

        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: MediaQuery.of(context).size.width/1.7,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xfff8ae39), borderRadius: BorderRadius.circular(40),
            ),
            child: Center(child: Text("Track Now",style: AppWidget.WhiteTextfeildStyle(18),)),
          ),
        )




      ],
      ),
      ),
    );
  }
}