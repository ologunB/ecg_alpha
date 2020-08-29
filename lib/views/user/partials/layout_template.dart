import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/user/home/home_view.dart';
import 'package:ecgalpha/views/user/orders/order_view.dart';
import 'package:ecgalpha/views/user/profile/profile_view.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutTemplate extends StatefulWidget {
  int pageSelectedIndex = 0;
  String fromWhere = "rfe";
  LayoutTemplate({this.pageSelectedIndex, this.fromWhere});
  @override
  _LayoutTemplateState createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends State<LayoutTemplate> {
  final List<Widget> pages = [
    HomeView(
      key: PageStorageKey('Page7'),
    ),
    OrdersView(
      key: PageStorageKey('Page8'),
    ),
    ProfileView(
      key: PageStorageKey('Page9'),
    )
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  int pageSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: pages[widget.fromWhere == "investment" ? 1 : pageSelectedIndex],
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 15,
          onTap: (i) {
            setState(() {
              widget.fromWhere = "er";
              pageSelectedIndex = i;
              widget.pageSelectedIndex = i;
            });
          },
          currentIndex:
              widget.fromWhere == "investment" ? 1 : pageSelectedIndex,
          selectedItemColor: Styles.appPrimaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
                icon: Icon(EvaIcons.home),
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )),
            BottomNavigationBarItem(
                icon: Icon(EvaIcons.creditCard),
                title: Text("Investment",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
            BottomNavigationBarItem(
                icon: Icon(EvaIcons.person),
                title: Text("Profile",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
          ]),
    );
  }
}
