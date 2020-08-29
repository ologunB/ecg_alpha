import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecgalpha/models/investment.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/utils/toast.dart';
import 'package:ecgalpha/views/admin/orders/order_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PendingOrderItem extends StatefulWidget {
  final Investment investment;
  final Color color;
  final String type;

  const PendingOrderItem(
      {Key key,
      @required this.investment,
      @required this.color,
      @required this.type})
      : super(key: key);

  @override
  _PendingOrderItemState createState() => _PendingOrderItemState();
}

class _PendingOrderItemState extends State<PendingOrderItem> {
  @override
  Widget build(BuildContext context) {
    Color color = widget.color;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => OrderDetails(
                      investment: widget.investment,
                      color: color,
                      type: widget.type,
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      widget.investment.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
                Icon(
                  Icons.payment,
                  color: color,
                ),
                SizedBox(width: 10),
                Text(
                  "₦${commaFormat.format(double.parse(widget.investment.amount))}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Divider(),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return StatefulBuilder(
                            builder: (context, _setState) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                ),
                                child: AlertDialog(
                                  title: Center(
                                    child: Text(
                                      isLoading
                                          ? "Processing"
                                          : "Do you want to cancel the order?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: Container(
                                    height: 0,
                                    width: 0,
                                    child: isLoading
                                        ? Container(
                                            alignment: Alignment.center,
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator())
                                        : Container(),
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              Navigator.pop(context);
                                            },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          isLoading ? "" : "CANCEL",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              cancelOrder(
                                                  widget.investment, _setState);
                                            },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          isLoading ? "" : "YES",
                                          style: TextStyle(
                                              color: Styles.appPrimaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "CANCEL",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Styles.appPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return StatefulBuilder(
                            builder: (context, _setState) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                ),
                                child: AlertDialog(
                                  title: Center(
                                    child: Text(
                                      isLoading
                                          ? "Processing"
                                          : "Do you want to confirm the order?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: Container(
                                    height: 0,
                                    width: 0,
                                    child: isLoading
                                        ? Container(
                                            alignment: Alignment.center,
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator())
                                        : Container(),
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              Navigator.pop(context);
                                            },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          isLoading ? "" : "CANCEL",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              processOrder(
                                                  widget.investment, _setState);
                                            },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          isLoading ? "" : "YES",
                                          style: TextStyle(
                                              color: Styles.appPrimaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "CONFIRM",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                height: 4,
                thickness: 6,
              ),
            )
          ],
        ),
      ),
    );
  }

  void processOrder(Investment item, _setState) {
    _setState(() {
      isLoading = true;
    });

    Firestore.instance
        .collection("Admin")
        .document(item.date)
        .collection("Transactions")
        .document("Confirmed")
        .collection(MY_UID)
        .document(item.userUid)
        .get()
        .then((document) {
      String amount;
      if (document == null) {
        amount = "0";
      } else {
        amount = document.data["Amount"];
      }

      double newAmount = double.parse(item.amount) + double.parse(amount);

      Map<String, Object> adminData = Map();
      adminData.putIfAbsent("Name", () => item.name);
      adminData.putIfAbsent("Date", () => item.date);
      adminData.putIfAbsent("Amount", () => newAmount.floor().toString());
      adminData.putIfAbsent("userUid", () => item.userUid);
      adminData.putIfAbsent("adminUid", () => item.adminUid);
      adminData.putIfAbsent(
          "Timestamp", () => DateTime.now().millisecondsSinceEpoch);
      adminData.putIfAbsent("id", () => item.id);
      adminData.putIfAbsent("Confirmed By", () => MY_NAME);
      adminData.putIfAbsent("pop", () => item.pop);

      Map<String, Object> adminConfirmedData = Map();
      adminConfirmedData.putIfAbsent("Name", () => item.name);
      adminConfirmedData.putIfAbsent("Date", () => next7Date());
      adminConfirmedData.putIfAbsent(
          "Amount", () => newAmount.floor().toString());
      adminConfirmedData.putIfAbsent("userUid", () => item.userUid);
      adminConfirmedData.putIfAbsent("adminUid", () => item.adminUid);
      adminConfirmedData.putIfAbsent(
          "Timestamp", () => DateTime.now().millisecondsSinceEpoch);
      adminConfirmedData.putIfAbsent("id", () => item.id);
      adminConfirmedData.putIfAbsent("Confirmed By", () => MY_NAME);
      adminConfirmedData.putIfAbsent("pop", () => item.pop);

      Map<String, Object> userData = Map();
      userData.putIfAbsent("Name", () => item.name);
      userData.putIfAbsent("Date", () => item.date);

      userData.putIfAbsent("Amount", () => item.amount);
      userData.putIfAbsent("userUid", () => item.userUid);
      userData.putIfAbsent("adminUid", () => item.adminUid);
      userData.putIfAbsent("pop", () => item.pop);
      userData.putIfAbsent(
          "Timestamp", () => DateTime.now().millisecondsSinceEpoch);
      userData.putIfAbsent("id", () => item.id);
      userData.putIfAbsent("Confirmed By", () => MY_NAME);

      String notiID = "NOT" + DateTime.now().millisecondsSinceEpoch.toString();
      String message =
          "Your investment of ₦${item.amount} has been confirmed. wait for next 7 days. Thanks for investing in us.";

      Map<String, Object> notiData = Map();
      notiData.putIfAbsent("Message", () => message);
      notiData.putIfAbsent("Date", () => presentDateTime());
      notiData.putIfAbsent("userUid", () => item.userUid);
      notiData.putIfAbsent(
          "Timestamp", () => DateTime.now().millisecondsSinceEpoch);

      Firestore.instance
          .collection("Transactions")
          .document("Confirmed")
          .collection(item.userUid) // user confirmed
          .document(item.id)
          .setData(userData)
          .then((val) {
        Firestore.instance
            .collection("Admin")
            .document(item.date)
            .collection("Transactions")
            .document("Confirmed")
            .collection(MY_UID) // payout pending
            .document(item.userUid)
            .setData(adminData)
            .then((a) {
          Firestore.instance
              .collection("Admin")
              .document(next7Date())
              .collection("Transactions")
              .document("Unpaid")
              .collection(MY_UID) // admin confirmed
              .document(item.userUid)
              .setData(adminConfirmedData)
              .then((a) {
            _setState(() {
              isLoading = false;
            });
            /* setState(() {
              isLoading = false;
            });*/
            Navigator.pop(context);
            showToast("Order has been Confirmed ", context);
          });
        });
      });

      Firestore.instance
          .collection("Transactions")
          .document("Expecting")
          .collection(item.userUid) // user expecting
          .document(next7Date())
          .setData(adminData)
          .then((a) {
        Firestore.instance
            .collection("Admin")
            .document(item.date)
            .collection("Transactions")
            .document("Pending")
            .collection(MY_UID)
            .document(item.id)
            .delete()
            .then((a) {
          Firestore.instance
              .collection("Utils")
              .document("Notification")
              .collection(item.userUid)
              .document(notiID)
              .setData(notiData);
          Firestore.instance
              .collection("Transactions")
              .document("Pending")
              .collection(item.userUid)
              .document(item.id)
              .delete()
              .then((a) {
            /*       _setState(() {
              isLoading = false;
            });
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
            */
            Toast.show("Almost done", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          });
        });
      });
    }).catchError((e) {
      showToast(e, context);
    });
  }

  void cancelOrder(Investment item, _setState) {
    Map<String, Object> userData = Map();
    userData.putIfAbsent("Name", () => item.name);
    userData.putIfAbsent("Date", () => item.date);
    userData.putIfAbsent("Amount", () => item.amount);
    userData.putIfAbsent("userUid", () => item.userUid);
    userData.putIfAbsent("adminUid", () => item.adminUid);
    userData.putIfAbsent(
        "Timestamp", () => DateTime.now().millisecondsSinceEpoch);
    userData.putIfAbsent("id", () => item.id);
    userData.putIfAbsent("Confirmed By", () => MY_NAME);
    userData.putIfAbsent("pop", () => item.pop);

    _setState(() {
      isLoading = true;
    });

    String notiID = "SUP" + DateTime.now().millisecondsSinceEpoch.toString();
    String message =
        "Your investment of ₦${item.amount} has been Cancelled. Contact support to know more...";

    Map<String, Object> notiData = Map();
    notiData.putIfAbsent("Message", () => message);
    notiData.putIfAbsent("Date", () => presentDateTime());
    notiData.putIfAbsent("userUid", () => item.userUid);
    notiData.putIfAbsent(
        "Timestamp", () => DateTime.now().millisecondsSinceEpoch);

    Firestore.instance
        .collection("Admin")
        .document(item.date)
        .collection("Transactions")
        .document("Cancelled")
        .collection(MY_UID)
        .document(item.userUid)
        .setData(userData)
        .then((a) {
      Firestore.instance
          .collection("Transactions")
          .document('Cancelled')
          .collection(item.userUid)
          .document(item.id)
          .setData(userData)
          .then((a) {
        Firestore.instance
            .collection("Admin")
            .document(item.date)
            .collection("Transactions")
            .document("Pending")
            .collection(item.adminUid)
            .document(item.id)
            .delete();
        Firestore.instance
            .collection("Transactions")
            .document("Pending")
            .collection(item.userUid)
            .document(item.id)
            .delete();
        Firestore.instance
            .collection("Utils")
            .document("Notification")
            .collection(item.userUid)
            .document(notiID)
            .setData(notiData);
        _setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        showToast("Order has been Cancelled", context);
      });
    });
  }

  bool isLoading = false;
}
