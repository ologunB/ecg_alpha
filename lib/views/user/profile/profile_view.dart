import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/utils/toast.dart';
import 'package:ecgalpha/views/user/auth/auth_page.dart';
import 'package:ecgalpha/views/user/partials/create_investment.dart';
import 'package:ecgalpha/views/user/profile/change_password.dart';
import 'package:ecgalpha/views/user/profile/update_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'help_page.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File image;
  Future getImageGallery() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = img;
    });
    processImage(img);
  }

  Future getImageCamera() async {
    var img = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      image = img;
    });
    processImage(img);
  }

  void processImage(File file) async {
    if (file != null) {
      String url = await uploadImage(file);

      Firestore.instance
          .collection("User Collection")
          .document(MY_UID)
          .updateData({"Avatar": url});

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("image", url);
      MY_IMAGE = url;

      Toast.show("Image Uploaded", context,
          gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: image == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: CachedNetworkImage(
                              imageUrl: MY_IMAGE.isEmpty ? "r" : MY_IMAGE,
                              height: 80,
                              width: 80,
                              placeholder: (context, url) => ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: Image(
                                    image:
                                        AssetImage("assets/images/person.png"),
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.contain),
                              ),
                              errorWidget: (context, url, error) => ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: Image(
                                    image:
                                        AssetImage("assets/images/person.png"),
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.contain),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.file(image,
                                height: 80, width: 80, fit: BoxFit.contain),
                          ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  getImageGallery();
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Choose Avatar from Gallery"),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  getImageCamera();
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Take image from Camera"),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Text("Change Avatar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(MY_NAME,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Text(MY_EMAIL,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => UpdateBankDetails(
                        whereFrom: "profile",
                        type: "User",
                        uuid: MY_UID,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.edit, color: Colors.deepPurple),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Update Bank Details",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  LaunchReview.launch(
                    androidAppId: "com.ologundaniel.fabat",
                    iOSAppId: "585027354",
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.star, color: Colors.yellow),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Rate our App",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => HelpPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.help, color: Colors.blue),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Help and Support",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.fingerprint, color: Colors.green),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
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
                                "Confirmation!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: Container(
                              child: Text(
                                "Are you sure you want to logout?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  FirebaseAuth.instance
                                      .signOut()
                                      .then((val) async {
                                    Future<SharedPreferences> _prefs =
                                        SharedPreferences.getInstance();

                                    final SharedPreferences prefs =
                                        await _prefs;

                                    setState(() {
                                      prefs.setBool("isLoggedIn", false);
                                      prefs.remove("type");
                                      prefs.remove("uid");
                                      prefs.remove("email");
                                      prefs.remove("name");
                                      prefs.remove("Notifications");
                                    });
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => AuthPage(),
                                      ),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "CONFIRM",
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
                      });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.reply, color: Colors.red),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Log Out",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.appPrimaryColor,
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => CreateInvestment()));
        },
        child: Icon(Icons.add, size: 30),
      ),
    ));
  }
}
