import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecgalpha/models/investment.dart';
import 'package:ecgalpha/models/user.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/user/orders/custom_order_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile({Key key, this.user}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController notifiMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User user = widget.user;

    int totalConfirmed = 0;
    int totalCancelled = 0;
    int totalPending = 0;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.notifications_active),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                              ),
                              child: AlertDialog(
                                title: Center(
                                  child: Text(
                                    "Notify ${widget.user.name}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                content: TextField(
                                  controller: notifiMessage,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                actions: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      String notiID = "NOT" +
                                          DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString();
                                      String message = notifiMessage.text;
                                      Map<String, Object> notiData = Map();
                                      notiData.putIfAbsent(
                                          "Message", () => message);
                                      notiData.putIfAbsent(
                                          "Date", () => presentDateTime());
                                      notiData.putIfAbsent(
                                          "userUid", () => widget.user.id);
                                      notiData.putIfAbsent(
                                          "Timestamp",
                                          () => DateTime.now()
                                              .millisecondsSinceEpoch);
                                      Firestore.instance
                                          .collection("Utils")
                                          .document("Notification")
                                          .collection(widget.user.id)
                                          .document(notiID)
                                          .setData(notiData);
                                      Navigator.pop(context);
                                      FocusScope.of(context).unfocus();
                                      showToast("Notification Sent", context);
                                      notifiMessage.clear();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "SEND MESSAGE",
                                        style: TextStyle(
                                            color: Styles.appPrimaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    })
              ],
            ),
            body: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.image == ""
                              ? "ef"
                              : widget.user.image,
                          height: 60,
                          width: 60,
                          placeholder: (context, url) => ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image(
                                image: AssetImage("assets/images/person.png"),
                                height: 60,
                                width: 60,
                                fit: BoxFit.contain),
                          ),
                          errorWidget: (context, url, error) => ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image(
                                image: AssetImage("assets/images/person.png"),
                                height: 60,
                                width: 60,
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ),
                    Text(user.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    Text(user.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("Transactions")
                              .document("Confirmed")
                              .collection(user.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                  height: 100,
                                  width: 100,
                                );
                              default:
                                if (snapshot.data.documents.isNotEmpty) {
                                  totalConfirmed = 0;
                                  snapshot.data.documents.map((document) {
                                    Investment item = Investment.map(document);

                                    totalConfirmed =
                                        totalConfirmed + int.parse(item.amount);
                                  }).toList();
                                }
                                return snapshot.data.documents.isEmpty
                                    ? Container(
                                        child: item("Total Confirmed", "0"),
                                      )
                                    : Container(
                                        child: item(
                                            "Total Confirmed",
                                            commaFormat
                                                .format(totalConfirmed)));
                            }
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("Transactions")
                              .document("Pending")
                              .collection(user.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                  height: 100,
                                  width: 100,
                                );
                              default:
                                if (snapshot.data.documents.isNotEmpty) {
                                  totalPending = 0;
                                  snapshot.data.documents.map((document) {
                                    Investment item = Investment.map(document);

                                    totalPending =
                                        totalPending + int.parse(item.amount);
                                  }).toList();
                                }
                                return snapshot.data.documents.isEmpty
                                    ? Container(
                                        child: item("Total Pending", "0"))
                                    : Container(
                                        child: item("Total Pending",
                                            commaFormat.format(totalPending)));
                            }
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("Transactions")
                              .document("Cancelled")
                              .collection(user.id)
                              .orderBy("Timestamp", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                  height: 100,
                                  width: 100,
                                );
                              default:
                                if (snapshot.data.documents.isNotEmpty) {
                                  totalCancelled = 0;
                                  snapshot.data.documents.map((document) {
                                    Investment item = Investment.map(document);

                                    totalCancelled =
                                        totalCancelled + int.parse(item.amount);
                                  }).toList();
                                }
                                return snapshot.data.documents.isEmpty
                                    ? Container(
                                        child: item("Total Cancelled", "0"),
                                      )
                                    : Container(
                                        child: item("Total Cancelled",
                                            commaFormat.format(totalCancelled)),
                                      );
                            }
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        child: Scaffold(
                          appBar: AppBar(
                            leading: Container(),
                            flexibleSpace: SafeArea(
                              child: TabBar(
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
                                        child: Text(
                                          "Confirmed",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text("Pending",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text("Cancelled",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ]),
                            ),
                            iconTheme: IconThemeData(color: Colors.white),
                            backgroundColor: Colors.white,
                            elevation: 1.0,
                            centerTitle: true,
                          ),
                          body: Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: TabBarView(children: [
                              CustomOrderPage(
                                  from: "Admin",
                                  type: "Confirmed",
                                  color: Colors.green,
                                  theUID: user.id),
                              CustomOrderPage(
                                  from: "Admin",
                                  type: "Pending",
                                  color: Styles.appPrimaryColor,
                                  theUID: user.id),
                              CustomOrderPage(
                                  from: "Admin",
                                  type: "Cancelled",
                                  color: Colors.red,
                                  theUID: user.id)
                            ]),
                          ),
                        ),
                      ),
                    )
                  ],
                ))));
  }
}

Widget item(String type, String amount) => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          type,
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        Text(
          "₦ $amount",
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ],
    );
