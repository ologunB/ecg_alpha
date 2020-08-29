import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/admin/payout/custom_payout_page.dart';
import 'package:flutter/material.dart';

class PayoutView extends StatefulWidget {
  PayoutView({Key key}) : super(key: key);

  @override
  _PayoutViewState createState() => _PayoutViewState();
}

class _PayoutViewState extends State<PayoutView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              ]),
          title: Text(
            "Today's Payout",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: TabBarView(children: [
            CustomPayoutPage(color: Styles.appPrimaryColor, type: "Unpaid"),
            CustomPayoutPage(color: Styles.appPrimaryColor, type: "Paid"),
          ]),
        ),
      ),
    );
  }
}
