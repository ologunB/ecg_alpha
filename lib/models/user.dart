class User {
  String _id;
  String _name;
  String _email;
  String _image;
  int _timeStamp;

  String get name => _name;
  String get id => _id;
  String get image => _image;
  String get email => _email;
  int get timeStamp => _timeStamp;

  User(this._id, this._email, this._name, this._timeStamp, this._image);

  User.map(dynamic obj) {
    this._id = obj["Uid"];
    this._name = obj['Full Name'];
    this._email = obj['Email'];
    this._timeStamp = obj['Timestamp'];
    this._image = obj['Avatar'];
  }
}
