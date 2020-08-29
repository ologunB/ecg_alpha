import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecgalpha/models/investment.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/user/orders/each_order_item.dart';
import 'package:ecgalpha/views/user/partials/create_investment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'expecting_page.dart';
import 'notification_page.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class Expect {
  final String amount;
  final String date;

  Expect(this.amount, this.date);
}

List<Expect> expectingList = [];

Widget middleItem(String type, String amount, String time, context) => Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent[100],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(25),
          ),
        ),
        child: FlatButton(
          onPressed: type == "Expecting"
              ? expectingList == []
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ExpectingPage(
                                    items: expectingList,
                                  )));
                    }
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                type,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
              SizedBox(height: 15),
              Text(
                "₦ $amount",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.green),
              ),
              SizedBox(height: 7),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(5),
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    time,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

class _HomeViewState extends State<HomeView> {
  int totalExpecting = 0;
  String expectingTime = "";
  int todayPending = 0;
  String todayPendingTime = "";
  int todayConfirmed = 0;
  String todayConfirmedTime = "";
  int totalPending = 0;
  String totalPendingTime = "";
  int totalConfirmed = 0;
  int noOfNotifi = 0;
  String totalConfirmedTime = "";
  Future<String> uid, email, name, type, bName, aName, bNum, image;

  String adUnitId = "ca-app-pub-1874161073042155/7737888327";
  // live  String adUnitId = "ca-app-pub-3940256099942544/6300978111";

  AdmobBannerSize bannerSize;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;

      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  @override
  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: CachedNetworkImage(
                            imageUrl: MY_IMAGE.isEmpty ? "ma" : MY_IMAGE,
                            height: 50,
                            width: 50,
                            placeholder: (context, url) => ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Image(
                                  image: AssetImage("assets/images/person.png"),
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.contain),
                            ),
                            errorWidget: (context, url, error) => ClipRRect(
                              borderRadius: BorderRadius.circular(40.0),
                              child: Image(
                                  image: AssetImage("assets/images/person.png"),
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "Good ${greeting()}, $MY_NAME",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /* StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("Utils")
                        .document("Notification")
                        .collection(MY_UID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        default:
                          noOfNotifi = 0;
                          snapshot.data.documents.map((document) {
                            noOfNotifi++;
                          }).toList();
                          noOfNotifi = noOfNotifi - NO_OF_NOTI;
                          return snapshot.data.documents.isEmpty
                              ? IconButton(
                                  icon: Icon(Icons.notifications),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                NotificationPage()));
                                  })
                              : Stack(
                                  children: <Widget>[
                                    new IconButton(
                                        icon: Icon(Icons.notifications),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      NotificationPage()));
                                        }),
                                    noOfNotifi != 0
                                        ? new Positioned(
                                            right: 11,
                                            top: 11,
                                            child: new Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              constraints: BoxConstraints(
                                                minWidth: 14,
                                                minHeight: 14,
                                              ),
                                              child: Text(
                                                noOfNotifi.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : new Container()
                                  ],
                                );
                      }
                    },
                  ),*/
                  IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => NotificationPage()));
                      })
                ],
              ),
/*
              CarouselSlider(
                height: MediaQuery.of(context).size.height / 4,
                autoPlay: true,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                pauseAutoPlayOnTouch: Duration(seconds: 5),
                items: [
                  " ",
                  " ",
                ].map((i) {
                  return Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 4,
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: AdmobBanner(
                      adUnitId: adUnitId,
                      adSize: bannerSize,
                      listener:
                          (AdmobAdEvent event, Map<String, dynamic> args) {
                        handleEvent(event, args, 'Banner');
                      },
                    ),
                  );
                }).toList(),
              ),
*/
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 4,
                margin: EdgeInsets.only(bottom: 20.0),
                child: AdmobBanner(
                  adUnitId: adUnitId,
                  adSize: bannerSize,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                    handleEvent(event, args, 'Banner');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                child: Text(
                  "Transactions Details",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 155,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("Transactions")
                          .document("Expecting")
                          .collection(MY_UID)
                          .orderBy("Timestamp", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              alignment: Alignment.center,
                              child:
                                  middleItem("Expecting", "0", "--", context),
                            );
                          default:
                            int i = 0;
                            if (snapshot.data.documents.isNotEmpty) {
                              totalExpecting = 0;
                              expectingList.clear();
                              snapshot.data.documents.map((document) {
                                Investment item = Investment.map(document);
                                expectingList.add(
                                    Expect(item.amount, document.documentID));
                                if (i == 0) {
                                  expectingTime = timeAgo(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          item.timeStamp));
                                }
                                i++;

                                totalExpecting =
                                    totalExpecting + int.parse(item.amount);
                              }).toList();
                            }
                            return snapshot.data.documents.isEmpty
                                ? Container(
                                    child: middleItem(
                                        "Expecting", "0", "--", context),
                                  )
                                : Container(
                                    child: middleItem(
                                        "Expecting",
                                        commaFormat.format(totalExpecting),
                                        expectingTime,
                                        context),
                                  );
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("Transactions")
                          .document("Pending")
                          .collection(MY_UID)
                          .limit(20)
                          .orderBy("Timestamp", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              alignment: Alignment.center,
                              child: middleItem(
                                  "Today's Pending", "0", "--", context),
                            );
                          default:
                            int i = 0;
                            if (snapshot.data.documents.isNotEmpty) {
                              todayPending = 0;
                              snapshot.data.documents.map((document) {
                                Investment item = Investment.map(document);
                                if (i == 0) {
                                  todayPendingTime = timeAgo(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          item.timeStamp));
                                }
                                i++;

                                if (item.date == presentDate()) {
                                  todayPending =
                                      todayPending + int.parse(item.amount);
                                }
                              }).toList();
                            }
                            return snapshot.data.documents.isEmpty
                                ? Container(
                                    child: middleItem(
                                        "Today's Pending", "0", "--", context),
                                  )
                                : Container(
                                    child: middleItem(
                                        "Today's Pending",
                                        commaFormat.format(todayPending),
                                        todayPendingTime,
                                        context),
                                  );
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("Transactions")
                          .document("Confirmed")
                          .collection(MY_UID)
                          .limit(20)
                          .orderBy("Timestamp", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              alignment: Alignment.center,
                              child: middleItem(
                                  "Today's Confirmed", "0", "--", context),
                            );
                          default:
                            int i = 0;
                            if (snapshot.data.documents.isNotEmpty) {
                              todayConfirmed = 0;
                              snapshot.data.documents.map((document) {
                                Investment item = Investment.map(document);
                                if (i == 0) {
                                  todayConfirmedTime = timeAgo(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          item.timeStamp));
                                }
                                i++;

                                if (item.date == presentDate()) {
                                  todayConfirmed =
                                      todayConfirmed + int.parse(item.amount);
                                }
                              }).toList();
                            }
                            return snapshot.data.documents.isEmpty
                                ? Container(
                                    child: middleItem("Today's Confirmed", "0",
                                        "--", context),
                                  )
                                : Container(
                                    child: middleItem(
                                        "Today's Confirmed",
                                        commaFormat.format(todayConfirmed),
                                        todayConfirmedTime,
                                        context),
                                  );
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
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
                              child: middleItem(
                                  "Total Pending", "0", "--", context),
                            );
                          default:
                            int i = 0;
                            if (snapshot.data.documents.isNotEmpty) {
                              totalPending = 0;
                              snapshot.data.documents.map((document) {
                                Investment item = Investment.map(document);
                                if (i == 0) {
                                  totalPendingTime = timeAgo(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          item.timeStamp));
                                }
                                i++;

                                totalPending =
                                    totalPending + int.parse(item.amount);
                              }).toList();
                            }
                            return snapshot.data.documents.isEmpty
                                ? Container(
                                    child: middleItem(
                                        "Total Pending", "0", "--", context),
                                  )
                                : Container(
                                    child: middleItem(
                                        "Total Pending",
                                        commaFormat.format(totalPending),
                                        totalPendingTime,
                                        context),
                                  );
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
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
                              child: middleItem(
                                  "Total Confirmed", "0", "--", context),
                            );
                          default:
                            int i = 0;
                            if (snapshot.data.documents.isNotEmpty) {
                              totalConfirmed = 0;
                              snapshot.data.documents.map((document) {
                                Investment item = Investment.map(document);
                                if (i == 0) {
                                  totalConfirmedTime = timeAgo(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          item.timeStamp));
                                }
                                i++;

                                totalConfirmed =
                                    totalConfirmed + int.parse(item.amount);
                              }).toList();
                            }
                            return snapshot.data.documents.isEmpty
                                ? Container(
                                    child: middleItem(
                                        "Total Confirmed", "0", "--", context),
                                  )
                                : Container(
                                    child: middleItem(
                                        "Total Confirmed",
                                        commaFormat.format(totalConfirmed),
                                        totalConfirmedTime,
                                        context),
                                  );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                child: Text(
                  "Recent Transactions",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("Transactions")
                    .document("Pending")
                    .collection(MY_UID)
                    .orderBy("Timestamp", descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Text(
                              "Getting Data",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        height: 100,
                        width: 100,
                      );
                    default:
                      Investment item;
                      if (snapshot.data.documents.isNotEmpty) {
                        snapshot.data.documents.map((document) {
                          item = Investment.map(document);
                        }).toList();
                      }
                      return snapshot.data.documents.isEmpty
                          ? Container()
                          : Container(
                              child: EachOrderItem(
                                investment: item,
                                color: Styles.appPrimaryColor,
                                type: "Pending",
                              ),
                            );
                  }
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("Transactions")
                    .document("Confirmed")
                    .collection(MY_UID)
                    .orderBy("Timestamp", descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Text(
                              "Getting Data",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        height: 100,
                        width: 100,
                      );
                    default:
                      Investment item;
                      if (snapshot.data.documents.isNotEmpty) {
                        snapshot.data.documents.map((document) {
                          item = Investment.map(document);
                        }).toList();
                      }
                      return snapshot.data.documents.isEmpty
                          ? Container()
                          : Container(
                              child: EachOrderItem(
                                investment: item,
                                color: Colors.green,
                                type: "Confirmed",
                              ),
                            );
                  }
                },
              ),
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.appPrimaryColor,
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => CreateInvestment()));
        },
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}
