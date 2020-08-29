import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/user/partials/create_investment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_order_page.dart';

class OrdersView extends StatefulWidget {
  OrdersView({Key key}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          elevation: 1.0,
          bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.grey[500],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Styles.appPrimaryColor),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Pending",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Confirmed",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Cancelled",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
          title: Text(
            "My Orders",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: TabBarView(children: [
            CustomOrderPage(
                type: "Pending", color: Styles.appPrimaryColor, theUID: MY_UID),
            CustomOrderPage(
                type: "Confirmed", color: Colors.green, theUID: MY_UID),
            CustomOrderPage(
                type: "Cancelled", color: Colors.red, theUID: MY_UID)
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Styles.appPrimaryColor,
          onPressed: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => CreateInvestment()));
          },
          child: Icon(Icons.add, size: 30),
        ),
      ),
    );
  }
}
