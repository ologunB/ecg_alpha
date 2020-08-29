class Investment {
  String _id;
  String _adminUid;
  String _userUid;
  String _amount;
  String _name;
  String _date;
  String _pop;
  String _confirmedBy;
  int _timeStamp;

  String get name => _name;
  String get date => _date;
  String get confirmedBy => _confirmedBy;
  String get id => _id;
  String get pop => _pop;
  String get userUid => _userUid;
  String get adminUid => _adminUid;
  String get amount => _amount;
  int get timeStamp => _timeStamp;

  Investment(this._id, this._date, this._amount, this._timeStamp,
      this._confirmedBy, this._name, this._adminUid, this._userUid, this._pop);

  Investment.map(dynamic obj) {
    this._name = obj["Name"];
    this._id = obj["id"];
    this._pop = obj["pop"];
    this._userUid = obj["userUid"];
    this._adminUid = obj["adminUid"];
    this._amount = obj['Amount'];
    this._date = obj['Date'];
    this._confirmedBy = obj['Confirmed By'];
    this._timeStamp = obj['Timestamp'];
  }
}
