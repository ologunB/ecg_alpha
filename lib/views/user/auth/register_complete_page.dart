import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/admin/admin_layout_template.dart';
import 'package:ecgalpha/views/user/partials/layout_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterCompleteScreen extends StatefulWidget {
  final String type;

  RegisterCompleteScreen({Key key, @required this.type}) : super(key: key);
  @override
  _RegisterCompleteScreenState createState() => _RegisterCompleteScreenState();
}

class _RegisterCompleteScreenState extends State<RegisterCompleteScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> uid, email, name, type, bName, aName, bNum, image;
  Future<int> noOfNoti;

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

    noOfNoti = _prefs.then((prefs) {
      return (prefs.getInt('Notifications') ?? 0);
    });

    if (widget.type == "User") {
      Future.delayed(Duration(milliseconds: 5000)).then((c) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (context) => LayoutTemplate(pageSelectedIndex: 0)));
      });
    } else if (widget.type == "Admin") {
      Future.delayed(Duration(milliseconds: 5000)).then((c) {
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => AdminLayoutTemplate()));
      });
    }

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
    NO_OF_NOTI = await noOfNoti;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          if (widget.type == "User") {
            Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => LayoutTemplate()));
          } else if (widget.type == "Admin") {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: (context) => AdminLayoutTemplate()));
          }
        },
        child: Container(
          padding: EdgeInsets.all(20),
          color: Styles.appPrimaryColor,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    "You are all set. You can now invest in us and get your cashback in days",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Center(
                  child: Text(
                    "TAP ANYWHERE TO CONTINUE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
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
