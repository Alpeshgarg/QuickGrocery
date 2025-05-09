import 'package:flutter/material.dart';
import 'package:packagedeliveryapp/pages/home.dart';
import 'package:packagedeliveryapp/pages/order.dart';
import 'package:packagedeliveryapp/pages/post.dart';
import 'package:packagedeliveryapp/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late Home homePage;
  late Order order;
  late Profile profilePage;
  late PostPage postPage;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = const Home();
    postPage = const PostPage();
    order = const Order();
    profilePage = const Profile();
    

    pages = [homePage,postPage, order, profilePage];
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.white, size: 34.0),
          Icon(Icons.post_add, color: Colors.white, size: 34.0),
          Icon(Icons.shopping_bag, color: Colors.white, size: 34.0),
          Icon(Icons.person, color: Colors.white, size: 34.0),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}