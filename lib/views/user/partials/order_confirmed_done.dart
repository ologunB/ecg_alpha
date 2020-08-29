import 'package:ecgalpha/views/partials/custom_button.dart';
import 'package:ecgalpha/views/user/partials/layout_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderConfirmedDone extends StatefulWidget {
  @override
  _OrderConfirmedDoneState createState() => _OrderConfirmedDoneState();
}

class _OrderConfirmedDoneState extends State<OrderConfirmedDone> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 5000)).then((val) {
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => LayoutTemplate(
                    pageSelectedIndex: 1,
                    fromWhere: "investment",
                  ),
              fullscreenDialog: true));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/confirmed.png"),
            SizedBox(height: 30),
            Text(
              "Order Confirmed, In queue for processing",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 28),
            ),
            SizedBox(height: 30),
            CustomButton(
              title: "Orders",
              onPress: () {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => LayoutTemplate(
                            pageSelectedIndex: 1, fromWhere: "investment"),
                        fullscreenDialog: true));
              },
            )
          ],
        ),
      ),
    );
  }
}
