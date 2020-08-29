import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/admin/orders/order_view.dart';
import 'package:ecgalpha/views/admin/payout/payout_view.dart';
import 'package:ecgalpha/views/admin/settings/settings_page.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home/admin_home_view.dart';

class AdminLayoutTemplate extends StatefulWidget {
  @override
  _AdminLayoutTemplateState createState() => _AdminLayoutTemplateState();
}

class _AdminLayoutTemplateState extends State<AdminLayoutTemplate> {
  int pageSelectedIndex = 0;

  final List<Widget> pages = [
    AdminHomeView(
      key: PageStorageKey('Page1'),
    ),
    OrdersView(
      key: PageStorageKey('Page2'),
    ),
    PayoutView(
      key: PageStorageKey('Page3'),
    ),
    SettingsView(
      key: PageStorageKey('Page4'),
    )
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: pages[pageSelectedIndex],
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 15,
          onTap: (i) {
            setState(() {
              pageSelectedIndex = i;
            });
          },
          currentIndex: pageSelectedIndex,
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
                title: Text("Investments",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
            BottomNavigationBarItem(
                icon: Icon(EvaIcons.briefcase),
                title: Text("Payouts",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
            BottomNavigationBarItem(
                icon: Icon(EvaIcons.settings),
                title: Text("Settings",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
          ]),
    );
  }
}
