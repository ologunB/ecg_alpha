import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecgalpha/utils/constants.dart';
import 'package:ecgalpha/utils/styles.dart';
import 'package:ecgalpha/views/partials/custom_loading_button.dart';
import 'package:ecgalpha/views/partials/show_exception_alert_dialog.dart';
import 'package:ecgalpha/views/user/auth/auth_page.dart';
import 'package:ecgalpha/views/user/auth/register_complete_page.dart';
import 'package:ecgalpha/views/user/profile/update_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthPage extends StatefulWidget {
  @override
  _AdminAuthPageState createState() => _AdminAuthPageState();
}

String validateEmail(value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter Valid Email';
  } else if (value.isEmpty) {
    return 'Please enter your email!';
  } else
    return null;
}

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

bool isLogin = true;
TabController controller;

class _AdminAuthPageState extends State<AdminAuthPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  String text1 = "Welcome! ";
  String text2 = "Login to continue ";
  String text3 = "Hello! ";
  String text4 = "Signup in a minute ";

  Widget presentWidget = LoginWidget();
  int adminLock = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Styles.appPrimaryColor,
                      Colors.blue,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                //   color: Styles.appPrimaryColor,
                height: size.height / 2.5,
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[],
                ),
              )
            ],
          ),
          Container(
              height: size.height,
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      if (adminLock > 5) {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AuthPage()));
                      } else {
                        adminLock++;
                      }
                    },
                    child: Text(
                      // isLogin ? text1 : text3,
                      "ADMIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    isLogin ? text2 : text4,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey[200], blurRadius: 5)
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if (presentWidget != LoginWidget()) {
                                        setState(() {
                                          presentWidget = LoginWidget();
                                          isLogin = true;
                                        });
                                      }
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Login",
                                          style: TextStyle(
                                              color: isLogin
                                                  ? Styles.appPrimaryColor
                                                  : Colors.grey,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                              color: isLogin
                                                  ? Styles.appPrimaryColor
                                                  : Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft:
                                                      Radius.circular(10))),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  InkWell(
                                    onTap: () {
                                      if (presentWidget != SignupWidget()) {
                                        setState(() {
                                          presentWidget = SignupWidget();
                                          isLogin = false;
                                        });
                                      }
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Signup",
                                          style: TextStyle(
                                              color: isLogin
                                                  ? Colors.grey
                                                  : Styles.appPrimaryColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: 80,
                                          height: 5,
                                          decoration: BoxDecoration(
                                              color: !isLogin
                                                  ? Styles.appPrimaryColor
                                                  : Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft:
                                                      Radius.circular(10))),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              isLogin ? SizedBox(height: 70) : Container(),
                              presentWidget,
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController inEmail = TextEditingController();
  TextEditingController inPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool _autoValidate = false;

  bool isLoading = false;
  bool forgotPassIsLoading = false;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future signIn(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseUser user = value.user;

      if (value.user != null) {
        if (!value.user.isEmailVerified) {
          setState(() {
            isLoading = false;
          });
          showToast("Email not verified", context);
          _firebaseAuth.signOut();
          return;
        }

        Firestore.instance
            .collection("Admin Collection")
            .document(user.uid)
            .get()
            .then((document) {
          var dATA = document.data;

          String rememEmail = rememberMe ? email : "";
          String rememPass = rememberMe ? password : "";

          putInDB(
              type: dATA["Type"],
              uid: dATA["Uid"],
              name: dATA["Full Name"],
              email: dATA["Email"],
              image: dATA["Avatar"],
              bName: dATA["Bank Name"],
              aName: dATA["Account Name"],
              aNum: dATA["Bank Number"],
              rememPass: rememPass,
              rememMail: rememEmail);

          /*    Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (context) => AdminLayoutTemplate(),
            ),
          );
*/

          if (dATA["Bank Name"].toString().trim().isEmpty) {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (context) => UpdateBankDetails(
                  whereFrom: "login",
                  uuid: user.uid,
                  type: dATA["Type"],
                ),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (context) =>
                    RegisterCompleteScreen(type: dATA["Type"]),
              ),
            );
          }
        }).catchError((e) {
          showExceptionAlertDialog(
              context: context, exception: e, title: "Error");
          setState(() {
            isLoading = false;
          });
          setState(() {
            isLoading = false;
          });
          showToast("Details not found! Login as User.", context);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showToast("User doesn't exist", context);
      }
      return;
    }).catchError((e) {
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
      setState(() {
        isLoading = false;
      });
      return;
    });
  }

  Future putInDB(
      {String type,
      String uid,
      String email,
      String rememMail,
      String rememPass,
      String name,
      String aName,
      String aNum,
      String bName,
      String image}) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setBool("isLoggedIn", true);
      prefs.setString("REMEMBER_EMAIL", rememMail);
      prefs.setString("REMEMBER_PASS", rememPass);
      prefs.setString("uid", uid);
      prefs.setString("email", email);
      prefs.setString("name", name);
      prefs.setString("type", type);
      prefs.setString("image", image);
      prefs.setString("Bank Name", bName);
      prefs.setString("Account Number", aNum);
      prefs.setString("Account Name", aName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Theme(
                    data: ThemeData(
                        primaryColor: Colors.grey, hintColor: Colors.grey),
                    child: TextFormField(
                      controller: inEmail,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.mail, color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Theme(
                    data: ThemeData(
                        primaryColor: Colors.grey, hintColor: Colors.grey),
                    child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password!';
                        } else if (value.length < 6) {
                          return 'Password must be greater than 6 characters!';
                        }
                        return null;
                      },
                      controller: inPassword,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.vpn_key, color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                Checkbox(
                  value: rememberMe,
                  onChanged: (newValue) {
                    setState(() {
                      rememberMe = !rememberMe;
                    });
                  },
                  activeColor: Colors.deepOrange,
                  checkColor: Colors.white,
                ),
                Text("Remember me",
                    style: TextStyle(fontSize: 15, color: Colors.black)),
              ]),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Styles.appPrimaryColor, fontSize: 15),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomLoadingButton(
              title: isLoading ? "" : "LOGIN",
              onPress: isLoading
                  ? null
                  : () {
                      _formKey.currentState.save();
                      _formKey.currentState.validate();

                      setState(() {
                        _autoValidate = true;
                      });

                      if (_formKey.currentState.validate()) {
                        signIn(inEmail.text, inPassword.text);
                        /*        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    RegisterCompleteScreen()));*/
                      }
                    },
              icon: isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
              iconLeft: false,
            ),
          )
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}

class SignupWidget extends StatefulWidget {
  @override
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  TextEditingController upFName = TextEditingController();
  TextEditingController upEmail = TextEditingController();
  TextEditingController upPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool _autoValidate = false;
  bool isLoading = false;

  Future userSignUp(String fullName, String email, String password) async {
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseUser user = value.user;

      if (value.user != null) {
        user.sendEmailVerification().then((v) {
          Map<String, Object> mData = Map();
          mData.putIfAbsent("Full Name", () => upFName.text);
          mData.putIfAbsent("Email", () => upEmail.text);
          mData.putIfAbsent("Confirmed", () => "0");
          mData.putIfAbsent("Pending", () => "0");
          mData.putIfAbsent("Type", () => "Admin");
          mData.putIfAbsent("Bank Name", () => " ");
          mData.putIfAbsent("Bank Number", () => " ");
          mData.putIfAbsent("Account Name", () => " ");
          mData.putIfAbsent("Uid", () => user.uid);
          mData.putIfAbsent("Avatar", () => "");
          mData.putIfAbsent(
              "Timestamp", () => DateTime.now().millisecondsSinceEpoch);

          Firestore.instance
              .collection("Admin Collection")
              .document(user.uid)
              .setData(mData)
              .then((val) {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    content: Text(
                      "Admin created, Check email for verification.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                });
            upEmail.clear();
            upPassword.clear();
            upFName.clear();
            // showToast("Admin created, Check email for verification!", context);
            setState(() {
              _autoValidate = false;
              isLoading = false;
              isLogin = true;
            });
            FocusScope.of(context).unfocus();
          }).catchError((e) {
            showExceptionAlertDialog(
                context: context, exception: e, title: "Error");
            setState(() {
              isLoading = false;
            });
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showToast("Admin doesn't exist", context);
      }
      return;
    }).catchError((e) {
      showExceptionAlertDialog(context: context, exception: e, title: "Error");
      setState(() {
        isLoading = false;
      });
      showToast("$e", context);
      setState(() {
        isLoading = false;
      });
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Theme(
                    data: ThemeData(
                        primaryColor: Colors.grey, hintColor: Colors.grey),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Admin name!';
                        } else if (value.length < 6) {
                          return 'Characters must be greater than 6 characters!';
                        }
                        return null;
                      },
                      controller: upFName,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Admin Name',
                        hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Theme(
                    data: ThemeData(
                        primaryColor: Colors.grey, hintColor: Colors.grey),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      controller: upEmail,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.mail, color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Theme(
                    data: ThemeData(
                        primaryColor: Colors.grey, hintColor: Colors.grey),
                    child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password!';
                        } else if (value.length < 6) {
                          return 'Password must be greater than 6 characters!';
                        }
                        return null;
                      },
                      controller: upPassword,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.vpn_key, color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              //  mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "By signing up you, I agree to my ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Terms and Condition',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Styles.appPrimaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to desired screen
                              }),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Styles.appPrimaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to desired screen
                              }),
                      ]),
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomLoadingButton(
              title: isLoading ? "" : "SIGNUP",
              onPress: isLoading
                  ? null
                  : () {
                      _formKey.currentState.save();
                      _formKey.currentState.validate();

                      setState(() {
                        _autoValidate = true;
                      });

                      if (_formKey.currentState.validate()) {
                        userSignUp(upFName.text, upEmail.text, upPassword.text);
                      }
                    },
              icon: isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
              iconLeft: false,
            ),
          )
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
