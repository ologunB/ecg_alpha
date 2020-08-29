class MyNotification {
  String _message, _date, _uid;
  int _timestamp;
  String get message => _message;
  String get date => _date;
  String get uid => _uid;
  int get timestamp => _timestamp;
  MyNotification(this._message, this._date, this._timestamp, this._uid);

  MyNotification.map(dynamic obj) {
    this._uid = obj["userUid"];
    this._message = obj['Message'];
    this._timestamp = obj['Timestamp'];
    this._date = obj['Date'];
  }
}
