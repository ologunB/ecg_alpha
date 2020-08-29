import 'dart:io';
import 'dart:math';

import 'package:ecgalpha/utils/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Constants {
  static String shortLoremText =
      "Lorem ipsum dolor sit amet, mod tempor incididunt ut labore et dolore magna aliqua.  ";
  static String longLoremText =
      "Lorem ipsum dolor sit amet,  tempor incididu gna aliqua. Ut enim ad minim veniam, quis nostrud exercitation";
}

String MY_NAME,
    MY_UID,
    MY_EMAIL,
    MY_BANK_ACCOUNT_NAME,
    MY_ACCOUNT_NUMBER,
    MY_BANK_NAME,
    MY_IMAGE,
    REMEMBER_PASS,
    REMEMBER_EMAIL;
int NO_OF_NOTI;

showToast(String msg, BuildContext context) {
  Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
}

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

String randomString() {
  Random rnd = Random(DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < 12; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}

String presentDate() {
  return DateFormat("EEE MMM d").format(DateTime.now());
}

String next7Date() {
  return DateFormat("EEE MMM d")
      .format(DateTime.now().add(new Duration(days: 7)));
}

String presentDateTime() {
  return DateFormat("EEE MMM d, yyyy HH:mm a").format(DateTime.now());
}

//  return DateFormat("EEE MMM d, yyyy HH:mm a").format(DateTime.now());

final commaFormat = new NumberFormat("#,##0", "en_US");

Future<String> uploadImage(File file) async {
  String url = "";
  if (file != null) {
    StorageReference reference =
        FirebaseStorage.instance.ref().child("images/${randomString()}");

    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    url = (await downloadUrl.ref.getDownloadURL());
  }
  return url;
}

List<String> supportCategories = [
  "Non Payment of confirmed funds",
  "Cancelled Orders",
  "Problem with Confirmation",
  "App lags or gives inaccurate data",
  "Mistake in transaction",
  "Others"
];

List<String> dateList() {
  List<String> last30Days = [];
  for (int i = 0; i < 30; i++) {
    DateTime dayAgo = DateTime.now().subtract(new Duration(days: i));
    last30Days.add(DateFormat("EEE MMM d").format(dayAgo));
  }
  return last30Days;
}

List<String> date7List() {
  List<String> last30Days = [];
  DateTime next7days = DateTime.now().add(new Duration(days: 7));
  for (int i = 0; i < 30; i++) {
    DateTime dayAgo = next7days.subtract(new Duration(days: i));
    last30Days.add(DateFormat("EEE MMM d").format(dayAgo));
  }
  return last30Days;
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  if (diff.inDays > 0)
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  return "just now";
}
