import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecgalpha/models/help_support.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/partials/custom_button.dart';
import 'package:ecgalpha/views/user/profile/create_ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _ListViewNoteState createState() => _ListViewNoteState();
}

class _ListViewNoteState extends State<HelpPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Tickets List",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomButton(
                title: "  Create Ticket  ",
                onPress: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) {
                        return CreateTicketPage();
                      },
                    ),
                  );
                },
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        leading: Container(),
                        flexibleSpace: SafeArea(
                          child: Center(
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
                                        "Unresolved",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("Resolved",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        iconTheme: IconThemeData(color: Colors.white),
                        backgroundColor: Colors.white,
                        elevation: 1.0,
                      ),
                      body: Container(
                        child: TabBarView(children: [
                          CustomHelpPage(type: "Unresolved"),
                          CustomHelpPage(type: "Resolved"),
                        ]),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomHelpPage extends StatefulWidget {
  final String type;

  const CustomHelpPage({Key key, this.type}) : super(key: key);
  @override
  _CustomHelpPageState createState() => _CustomHelpPageState();
}

class _CustomHelpPageState extends State<CustomHelpPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference ref = Firestore.instance
        .collection("Help Collection")
        .document(widget.type)
        .collection(MY_UID);
    return StreamBuilder<QuerySnapshot>(
      stream: ref.orderBy("Timestamp", descending: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 30),
                  Text(
                    "Getting Data",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 22),
                  ),
                  SizedBox(height: 30),
                ],
              ),
              height: 300,
              width: 300,
            );
          default:
            return snapshot.data.documents.isEmpty
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //  Image.asset("assets/images/confirmed.png"),
                        // SizedBox(height: 30),
                        Text(
                          "No Ticket yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 22),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  )
                : ListView(
                    children: snapshot.data.documents.map((document) {
                      Support item = Support.map(document);
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(
                                    item.category + " - " + item.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        item.desc,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        item.date,
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("CONTINUE",
                                              style: TextStyle(
                                                  color:
                                                      Styles.appPrimaryColor)),
                                        ))
                                  ],
                                );
                              });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black54)],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: item.pop,
                                      height: 50,
                                      width: 50,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 50,
                                        width: 50,
                                        decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/placeholder.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                              text: item.category + "- ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: item.title,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Styles
                                                            .appPrimaryColor),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
// navigate to desired screen
                                                          }),
                                              ]),
                                        ),
                                        Text(
                                          item.date,
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              content: Text(
                                                "Are you sure you want to delete the ticket?",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              actions: <Widget>[
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "NO",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    )),
                                                InkWell(
                                                    onTap: () {
                                                      ref
                                                          .document(item.id)
                                                          .delete()
                                                          .then((a) {
                                                        Firestore.instance
                                                            .collection(
                                                                "Admin Help Collection")
                                                            .document(item.id)
                                                            .delete()
                                                            .then((a) {
                                                          Navigator.pop(
                                                              context);
                                                          showToast(
                                                              "Ticket deleted",
                                                              context);
                                                        });
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "YES",
                                                        style: TextStyle(
                                                            color: Styles
                                                                .appPrimaryColor),
                                                      ),
                                                    ))
                                              ],
                                            );
                                          });
                                    })
                              ],
                            )),
                          ),
                        ),
                      );
                    }).toList(),
                  );
        }
      },
    );
  }
}
