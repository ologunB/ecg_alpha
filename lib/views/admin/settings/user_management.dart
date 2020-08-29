import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecgalpha/models/user.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'each_user.dart';

class UserManagementPage extends StatefulWidget {
  UserManagementPage({Key key}) : super(key: key);

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: !isSearching,
        title: !isSearching
            ? Text(
                "All Users",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )
            : CupertinoTextField(
                placeholder: "Find User...",
                placeholderStyle: TextStyle(fontSize: 20, color: Colors.grey),
                //onChanged: onSearchMechanic,
                padding: EdgeInsets.all(10),

                clearButtonMode: OverlayVisibilityMode.editing,
              ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("User Collection")
            .orderBy("Timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width);
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
                            "No Users",
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
                  : Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: snapshot.data.documents.map((document) {
                          User user = User.map(document);
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => UserProfile(
                                            user: user,
                                          )));
                            },
                            child: Card(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: CachedNetworkImage(
                                        imageUrl: user.image,
                                        height: 60,
                                        width: 60,
                                        placeholder: (context, url) =>
                                            ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          child: Image(
                                              image: AssetImage(
                                                  "assets/images/person.png"),
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.contain),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          child: Image(
                                              image: AssetImage(
                                                  "assets/images/person.png"),
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.contain),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        user.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "created " +
                                            timeAgo(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    user.timeStamp)),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
          }
        },
      ),
    );
  }
}
