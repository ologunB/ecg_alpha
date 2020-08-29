import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecgalpha/models/investment.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeView extends StatefulWidget {
  AdminHomeView({Key key}) : super(key: key);

  @override
  _AdminHomeViewState createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> uid, email, name, type, bName, aName, bNum, image;

  @override
  void initState() {
    super.initState();

    uid = _prefs.then((prefs) {
      return (prefs.getString('uid') ?? "customerUID");
    });
    email = _prefs.then((prefs) {
      return (prefs.getString('email') ?? "customerEmail");
    });
    name = _prefs.then((prefs) {
      return (prefs.getString('name') ?? "customerName");
    });
    bName = _prefs.then((prefs) {
      return (prefs.getString('Bank Name') ?? "bankName");
    });
    aName = _prefs.then((prefs) {
      return (prefs.getString('Account Name') ?? "accName");
    });
    bNum = _prefs.then((prefs) {
      return (prefs.getString('Account Number') ?? "accNum");
    });
    image = _prefs.then((prefs) {
      return (prefs.getString('image') ?? "image");
    });

    doAssign();
  }

  void doAssign() async {
    MY_NAME = await name;
    MY_UID = await uid;
    MY_EMAIL = await email;
    MY_ACCOUNT_NUMBER = await bNum;
    MY_BANK_ACCOUNT_NAME = await aName;
    MY_BANK_NAME = await bName;
    MY_IMAGE = await image;
  }

  int todayUnpaid = 0;
  int todayPaid = 0;
  int todayPending = 0;
  int todayConfirmed = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                "assets/images/person.png",
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: FutureBuilder(
                                  future: name,
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.done) {
                                      return Text(
                                        "Good ${greeting()}, ${snap.data}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      );
                                    }
                                    return Text(
                                      "Good ${greeting()}  ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      /*    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          NotificationPage()));
                            }),
                      )*/
                    ],
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Admin")
                            .document(presentDate())
                            .collection("Transactions")
                            .document("Pending")
                            .collection(MY_UID)
                            .orderBy("Timestamp", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                alignment: Alignment.center,
                                child: Container(
                                  child: item(
                                    " 0.00",
                                    "Today's Pending",
                                  ),
                                ),
                              );
                            default:
                              if (snapshot.data.documents.isNotEmpty) {
                                todayPending = 0;
                                snapshot.data.documents.map((document) {
                                  Investment item = Investment.map(document);

                                  if (item.date == presentDate()) {
                                    todayPending =
                                        todayPending + int.parse(item.amount);
                                  }
                                }).toList();
                              }
                              return snapshot.data.documents.isEmpty
                                  ? Container(
                                      child: item(
                                        " 0.00",
                                        "Today's Pending",
                                      ),
                                    )
                                  : Container(
                                      child: item(
                                          commaFormat.format(todayPending),
                                          "Today's Pending"));
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Admin")
                            .document(presentDate())
                            .collection("Transactions")
                            .document("Confirmed")
                            .collection(MY_UID)
                            .orderBy("Timestamp", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                alignment: Alignment.center,
                                child: item(
                                  " 0.00",
                                  "Today's Confirmed",
                                ),
                              );
                            default:
                              if (snapshot.data.documents.isNotEmpty) {
                                todayConfirmed = 0;
                                snapshot.data.documents.map((document) {
                                  Investment item = Investment.map(document);

                                  if (item.date == presentDate()) {
                                    todayConfirmed =
                                        todayConfirmed + int.parse(item.amount);
                                  }
                                }).toList();
                              }
                              return snapshot.data.documents.isEmpty
                                  ? Container(
                                      child: item(
                                        " 0.00",
                                        "Today's Confirmed",
                                      ),
                                    )
                                  : Container(
                                      child: item(
                                          commaFormat.format(todayConfirmed),
                                          "Today's Confirmed"));
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Admin")
                            .document(presentDate())
                            .collection("Transactions")
                            .document("Unpaid")
                            .collection(MY_UID)
                            .orderBy("Timestamp", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                alignment: Alignment.center,
                                child: item(
                                  " 0.00",
                                  "Today's Unpaid",
                                ),
                              );
                            default:
                              if (snapshot.data.documents.isNotEmpty) {
                                todayUnpaid = 0;
                                snapshot.data.documents.map((document) {
                                  Investment item = Investment.map(document);

                                  if (item.date == presentDate()) {
                                    todayUnpaid =
                                        todayUnpaid + int.parse(item.amount);
                                  }
                                }).toList();
                              }
                              return snapshot.data.documents.isEmpty
                                  ? Container(
                                      child: item(
                                        " 0.00",
                                        "Today's Unpaid",
                                      ),
                                    )
                                  : Container(
                                      child: item(
                                      commaFormat.format(todayUnpaid),
                                      "Today's Unpaid",
                                    ));
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Admin")
                            .document(presentDate())
                            .collection("Transactions")
                            .document("Paid")
                            .collection(MY_UID)
                            .orderBy("Timestamp", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                alignment: Alignment.center,
                                child: item(
                                  " 0.00",
                                  "Today's Paid",
                                ),
                              );
                            default:
                              if (snapshot.data.documents.isNotEmpty) {
                                todayPaid = 0;
                                snapshot.data.documents.map((document) {
                                  Investment item = Investment.map(document);

                                  if (item.date == presentDate()) {
                                    todayPaid =
                                        todayPaid + int.parse(item.amount);
                                  }
                                }).toList();
                              }
                              return snapshot.data.documents.isEmpty
                                  ? Container(
                                      child: item(
                                        " 0.00",
                                        "Today's Paid",
                                      ),
                                    )
                                  : Container(
                                      child: item(commaFormat.format(todayPaid),
                                          "Today's Paid"));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<String> types = [
  "Today's Total",
  "Today's Pending",
  "Today's Confirmed",
  "Paid",
  "Unpaid"
];

Widget item(String amount, String type) => Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent[100],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "₦" + amount,
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 15),
                Text(
                  type,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Styles.appPrimaryColor),
                ),
                SizedBox(height: 7),
              ],
            )
          ],
        ),
      ),
    );
