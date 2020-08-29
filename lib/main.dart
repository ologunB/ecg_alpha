import 'package:admob_flutter/admob_flutter.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/admin/admin_layout_template.dart';
import 'package:ecgalpha/views/user/auth/auth_page.dart';
import 'package:ecgalpha/views/user/partials/layout_template.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize("ca-app-pub-1874161073042155~8883997771");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primaryColor: Styles.appPrimaryColor,
      ),
      home: MyWrapper(),
    );
  }
}

class MyWrapper extends StatefulWidget {
  @override
  _MyWrapperState createState() => _MyWrapperState();
}

class _MyWrapperState extends State<MyWrapper> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> uid,
      email,
      name,
      bName,
      aName,
      bNum,
      image,
      remememail,
      remempass,
      type;
  Future<int> noOfNotifi;

  @override
  void initState() {
    super.initState();

    type = _prefs.then((prefs) {
      return (prefs.getString('type') ?? "null");
    });
    remememail = _prefs.then((prefs) {
      return (prefs.getString('REMEMBER_EMAIL') ?? "");
    });
    remempass = _prefs.then((prefs) {
      return (prefs.getString('REMEMBER_pass') ?? "");
    });

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
    noOfNotifi = _prefs.then((prefs) {
      return (prefs.getInt('Notifications') ?? 0);
    });

    doAssign();
  }

  void doAssign() async {
    REMEMBER_EMAIL = await remememail;
    REMEMBER_PASS = await remempass;
    MY_NAME = await name;
    MY_UID = await uid;
    MY_EMAIL = await email;
    MY_ACCOUNT_NUMBER = await bNum;
    MY_BANK_ACCOUNT_NAME = await aName;
    MY_BANK_NAME = await bName;
    MY_IMAGE = await image;
    NO_OF_NOTI = await noOfNotifi;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: type,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String loggedIn = snapshot.data;
            if (loggedIn == "User") {
              return LayoutTemplate(
                pageSelectedIndex: 0,
                fromWhere: "Main",
              );
            } else if (loggedIn == "Admin") {
              return AdminLayoutTemplate();
            } else {
              return AuthPage();
            }
          }
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  /*    image: DecorationImage(
                image: AssetImage(
                      "assets/images/app_back.jpg",
                    ),
                    fit: BoxFit.fill),*/
                  ),
            ),
          );
        });
  }
}
